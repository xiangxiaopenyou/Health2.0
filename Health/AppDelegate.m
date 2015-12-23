//
//  AppDelegate.m
//  Health
//
//  Created by cheng on 15/1/23.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "AppDelegate.h"
#import <TuSDK/TuSDK.h>
#import "LoginRequest.h"
#import "MessageRequest.h"
#import "LoginMainViewController.h"
#import "FirstViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong)NSString* code;
@property (nonatomic, strong)NSString* accessToken;
@property (nonatomic, strong)NSString* openID;
@property (nonatomic, strong)NSString* nickName;
@property (nonatomic, strong)NSString* image;
@property (nonatomic, strong)NSString* sex;
@property (nonatomic, strong)NSString* unionid;
@property (nonatomic, strong)NSTimer *timer;

@end

@implementation AppDelegate
@synthesize timer;
@synthesize rootNavigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedLoginToken) name:@"receiveLoginToken" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginStatusChanged) name:@"Login" object:nil];
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Model.sqlite"];
    //向微信注册
    [WXApi registerApp:wxAppKey];
    [TuSDK initSdkWithAppKey:tuSecret];
    [RCIM initWithAppKey:RYAPPKEY deviceToken:nil];
    [RCIM setUserInfoFetcherWithDelegate:self isCacheUserInfo:NO];
    [[RCIM sharedRCIM]setReceiveMessageDelegate:self];
    userInfoArray = [[NSMutableArray alloc]init];
    groupInfoArray = [[NSMutableArray alloc]init];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    [self checkUpdate];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self loginStatusChanged];
    
    [MobClick startWithAppkey:UMengKey];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(timerSchedule) userInfo:nil repeats:YES];
    
    return YES;
}
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString* dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    UserData *userData = [UserData shared];
    userData.deviceToken = dt;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveLoginToken" object:nil];
    [[RCIM sharedRCIM] setDeviceToken:deviceToken];
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[RCIM sharedRCIM] getTotalUnreadCount];
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
//    if ([[notification.userInfo objectForKey:@"key1"] intValue] == 9999) {
//        MessageViewController *messageController = [[MessageViewController alloc]init];
//        if (!self.rootNavigationController) {
//            [self.rootNavigationController pushViewController:messageController animated:YES];
//        }
//    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHAT object:@YES];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
}
//微信回调
- (void) onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode == 0) {
            _code = aresp.code;
            [self getAccess_token];
        }
    }

}
//REQUEST
-(void) onReq:(BaseReq*)req
{
    
}
- (void)receivedLoginToken{
    UserData *userdata = [UserData shared];
    if ([Util isEmpty:userdata.userid] || [Util isEmpty:userdata.deviceToken]) {
        return;
    }
    else{
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userdata.userid, @"userid", userdata.userToken, @"usertoken", userdata.deviceToken, @"devicetoken", nil];
        [LoginRequest sendDeviceToken:dic success:^(id response) {
            if ([[response objectForKey:@"state"] integerValue] == 1000) {
                NSLog(@"上传devicetoken成功");
            }
            else{
                NSLog(@"上传失败");
            }
        } failure:^(NSError *error) {
            NSLog(@"检查网络");
        }];
    }
}

- (void)getAccess_token
{
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:wxAppKey,@"appid",wxAppSecretkey,@"secret",self.code, @"code", @"authorization_code", @"grant_type", nil];
    [NetWorking get:url params:dic success:^(id response) {
        self.openID = [response objectForKey:@"openid"];
        self.accessToken = [response objectForKey:@"access_token"];
        [self getUserInfo];

    } failure:^(NSError *error) {
        NSLog(@"failure");
    }];

}

- (void)getUserInfo
{
    
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.accessToken,@"access_token",self.openID,@"openid", nil];
    [NetWorking get:url params:dic success:^(id response) {
        self.nickName = [response objectForKey:@"nickname"];
        self.image = [response objectForKey:@"headimgurl"];
        self.unionid = [response objectForKey:@"unionid"];
        [self upload];
    } failure:^(NSError *error) {
        
    }];
}

//微博回调
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        if (!response.statusCode) {
            self.accessToken = [(WBAuthorizeResponse *)response accessToken];
            self.openID = [(WBAuthorizeResponse *)response userID];
            self.nickName = [[response.userInfo objectForKey:@"app"] objectForKey:@"name"];
            NSLog(@"%@",self.nickName);
        }
        [self upload];
    }
}

- (void)upload
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.unionid,@"openid",self.nickName,@"nickname",self.image,@"headimgurl",@"sex",@"1", nil];
    [LoginRequest loginWithParam:dic success:^(id response) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Login" object:nil];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - RCIMUserInfoFetcherDelegagte method
/*
 获取用户信息
 */
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    RCUserInfo *user  = nil;
    user.userId = userId;
    
    for(RCUserInfo *u in userInfoArray)
    {
        if([u.userId isEqualToString:userId])
        {
            user = u;
            return completion(user);
            break;
        }
    }
    [LoginRequest getUserInfo:userId success:^(id response) {
        if ([[response objectForKey:@"state"] intValue]==1000) {
            if (![Util isEmpty:[response objectForKey:@"data"]]) {
                RCUserInfo *userInfo = [RCUserInfo new];
                userInfo.userId = userId;
                userInfo.portraitUri = [Util urlZoomPhoto:[[response objectForKey:@"data"] objectForKey:@"portrait"]];
                userInfo.name = [[response objectForKey:@"data"] objectForKey:@"nickname"];
                [userInfoArray addObject:userInfo];
                return completion(userInfo);
            }else{
                return completion(user);
            }
        }else{
            return completion(user);
        }
    } failure:^(NSError *error) {
        return completion(nil);
    }];
}
// 获取群组信息的方法。
-(void)getGroupInfoWithGroupId:(NSString*)groupId completion:(void (^)(RCGroup *group))completion
{
    // 此处最终代码逻辑实现需要您从本地缓存或服务器端获取群组信息。
    
    RCGroup *group  = nil;
    group.groupId = groupId;
    
    for(RCGroup *u in groupInfoArray)
    {
        if([u.groupId isEqualToString:groupId])
        {
            group = u;
            return completion(group);
            break;
        }
    }
    [LoginRequest getGroupInfo:groupId success:^(id response) {
        if ([[response objectForKey:@"state"] intValue]==1000) {
            if (![Util isEmpty:[response objectForKey:@"data"]]) {
                RCGroup *groupInfo = [RCGroup new];
                groupInfo.groupId = groupId;
                groupInfo.portraitUri = [Util urlZoomPhoto:[[response objectForKey:@"data"] objectForKey:@"coursephoto"]];
                groupInfo.groupName = [[response objectForKey:@"data"] objectForKey:@"coursetitle"];
                [groupInfoArray addObject:groupInfo];
                return completion(groupInfo);
            }else{
                return completion(group);
            }
        }else{
            return completion(group);
        }
    } failure:^(NSError *error) {
        return completion(nil);
    }];
    
    
    return completion(group);
}

/**
 接收消息到消息后执行。
 
 @param message 接收到的消息。
 @param left    剩余消息数.
 */
-(void)didReceivedMessage:(RCMessage*)message left:(int)left{
    
    if (0 == left) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
        });
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHAT object:@YES];
    [[RCIM sharedRCIM] invokeVoIPCall:self.window.rootViewController message:message];
}


#pragma mark - 自动更新


- (void)checkUpdate{
    
    [LoginRequest checkUpdateSuccess:^(id response){
        if ([[response objectForKey:@"version"] intValue] == 1) {
        }else if ([[response objectForKey:@"version"] intValue] == 2){
            self.updateUrl = [response objectForKey:@"updateurl"];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"有新版本更新" message:[response objectForKey:@"data"] delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"马上更新", nil];
            alertView.tag = 100;
            [alertView show];
        }
    }failure:^(NSError *error){
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if(buttonIndex == 1){
            NSURL *url = [NSURL URLWithString:self.updateUrl];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)dealloc{
    [timer invalidate];
}
- (void)timerSchedule{
    [MessageRequest notReadWithSuccess:^(id response) {
        if ([[response objectForKey:@"state"]integerValue] == 1000) {
            [[NSNotificationCenter defaultCenter]postNotificationName:GETALLMESSAGE object:@YES];
            //[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_CHAT object:@YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)loginStatusChanged{
    rootNavigationController = [[UINavigationController alloc] init];
    if ([self loginSuccess]) {
        
        NSString *isNewUser = [[NSUserDefaults standardUserDefaults]objectForKey:@"isnewuser"];
        if ([isNewUser integerValue] == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveLoginToken" object:nil];
            [timer fire];
            NSLog(@"login");
            //[self performSegueWithIdentifier:@"Tabbar" sender:self];
            self.tabbarController = [[RTTabbarViewController alloc]init];
            rootNavigationController = [[UINavigationController alloc]initWithRootViewController:self.tabbarController];
            
            UserData *userdata = [UserData shared];
            
            [RCIM connectWithToken:userdata.userrongyunid completion:^(NSString *userId) {
                NSLog(@"连接融云sdk成功");
            } error:^(RCConnectErrorCode status) {
                if(status == 0){
                }else{
                    UserData *userdata = [UserData shared];
                    UserInfo *userinfo = userdata.userInfo;
                    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken", nil];
                    [LoginRequest getRongyunToken:parameter success:^(id response) {
                        NSLog(@"重新获取融云token成功");
                        
                        UserData *userData = [UserData shared];
                        [RCIM connectWithToken:userData.userrongyunid completion:^(NSString *userId) {
                            NSLog(@"连接融云sdk成功");
                        } error:^(RCConnectErrorCode status) {
                            
                            NSLog(@"重新连接融云token失败");
                        }];
                    } failure:^(NSError *error) {
                        NSLog(@"重新获取融云token失败");
                    }];
                }
            }];
            
            
            [[RCIM sharedRCIM] setUserPortraitClickEvent:^(UIViewController *viewController, RCUserInfo *userInfo) {
                UserData *userdata = [UserData shared];
                UserInfo *userinfo = userdata.userInfo;
                if ([userInfo.userId intValue] == [userinfo.userid intValue]) {
                    OwnInfoViewController *ownInfoController = [[OwnInfoViewController alloc]init];
                    ownInfoController.hidesBottomBarWhenPushed = YES;
                    ownInfoController.isChat = 1;
                    [viewController.navigationController pushViewController:ownInfoController animated:YES];
                    viewController.navigationController.navigationBarHidden = YES;
                }else{
                    PersonalViewController *personController = [[PersonalViewController alloc]init];
                    personController.personID = userInfo.userId;
                    personController.hidesBottomBarWhenPushed = YES;
                    personController.isChat = 1;
                    [viewController.navigationController pushViewController:personController animated:YES];
                    viewController.navigationController.navigationBarHidden = YES;
                }
                
            }];
            
        }
        else {
            FirstViewController *controller = [[FirstViewController alloc] init];
            rootNavigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        }
        
        
    }else{
        [timer invalidate];
        NSLog(@"tabbar");
        LoginMainViewController *loginController = [[LoginMainViewController alloc]init];
        rootNavigationController = [[UINavigationController alloc]initWithRootViewController:loginController];
    }
    rootNavigationController.navigationBarHidden = YES;
    //rootNavigationController.interactivePopGestureRecognizer.enabled = NO;
    self.window.rootViewController = rootNavigationController;
}


- (BOOL)loginSuccess{
    if ([Util isLogin]) {
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSString *usertoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"];
        NSString *rongyunid = [[NSUserDefaults standardUserDefaults]objectForKey:@"rongyunid"];
        UserInfo *userinfo = [UserInfo MR_findFirstByAttribute:@"userid" withValue:userid];
        if (userinfo == nil) {
            return NO;
        }
        UserData *userdata = [UserData shared];
        userdata.userid = userid;
        userdata.userToken = usertoken;
        userdata.userrongyunid = rongyunid;
        userdata.userInfo = userinfo;
        return YES;
    }else{
        return NO;
    }
    
}

//分享给朋友
- (void) sendLinkContent:(NSString*)title Description:(NSString*)description Url:(NSString *)urlString Photo:(NSString *)photoUrl
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrl]]]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
    
    
}
//分享到朋友圈
- (void) sendLinkContentTimeLine:(NSString*)title Description:(NSString*)description Url:(NSString *)urlString Photo:(NSString *)photoUrl
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrl]]]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}



@end
