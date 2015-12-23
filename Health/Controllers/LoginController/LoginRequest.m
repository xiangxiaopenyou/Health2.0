//
//  LoginRequest.m
//  Health
//
//  Created by cheng on 15/1/28.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "LoginRequest.h"

@implementation LoginRequest

+ (void)loginWithParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_LOGIN];
    [NetWorking post:url params:parameter success:^(id response) {
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取userid和usertoken
            NSString *userid = [NSString stringWithFormat:@"%@",[[response objectForKey:@"data"] objectForKey:@"userid"]];
            NSString *userToken = [[response objectForKey:@"data"] objectForKey:@"usertoken"];
            if (![Util isEmpty:userid] && ![Util isEmpty:userToken]) {
                UserInfo *userInfo = [UserInfo MR_findFirstByAttribute:@"userid" withValue:userid];
                if (userInfo == nil) {
                    userInfo = [UserInfo MR_createEntity];
                }
                userInfo.userid = userid;
                userInfo.usertoken = userToken;
                userInfo.rongyunid = [NSString stringWithFormat:@"%@",[[response objectForKey:@"data"] objectForKey:@"rongtoken"]];
                userInfo.type = [NSString stringWithFormat:@"%@",[[response objectForKey:@"data"] objectForKey:@"type"]];
                userInfo.isnewuser = [NSString stringWithFormat:@"%@", [[response objectForKey:@"data"]  objectForKey:@"isNewUser"]];
                [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
                
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userid"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"usertoken"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"rongyunid"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isnewuser"];
                [[NSUserDefaults standardUserDefaults]setObject:userid forKey:@"userid"];
                [[NSUserDefaults standardUserDefaults]setObject:userToken forKey:@"usertoken"];
                [[NSUserDefaults standardUserDefaults]setObject:userInfo.rongyunid forKey:@"rongyunid"];
                [[NSUserDefaults standardUserDefaults] setObject:[[response objectForKey:@"data"] objectForKey:@"isNewUser"] forKey:@"isnewuser"];
            }
        }
        success(response);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


+ (void)getRongyunToken:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_RONGYUN_TOKEN];
    [NetWorking post:url params:parameter success:^(id response) {
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取userid和usertoken
            NSString *rongyunid = [NSString stringWithFormat:@"%@",[response objectForKey:@"data"]];
            
            UserData *userdata = [UserData shared];
            UserInfo *userinfo = userdata.userInfo;
            userdata.userrongyunid = rongyunid;
            userinfo.rongyunid = [NSString stringWithFormat:@"%@",[response objectForKey:@"data"]];
            [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"rongyunid"];
            [[NSUserDefaults standardUserDefaults]setObject:rongyunid forKey:@"rongyunid"];
        }
        success(response);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)getUserInfo:(NSString*)userid success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    NSDictionary*parameter = [NSDictionary dictionaryWithObjectsAndKeys:userid,@"userid", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_RONGYUN_USERINFO];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)getGroupInfo:(NSString*)groupid success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSDictionary*parameter = [NSDictionary dictionaryWithObjectsAndKeys:groupid,@"courseid",userinfo.userid,@"userid",userinfo.usertoken,@"usertoken", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_RONGYUN_GROUP];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}


+ (void)checkUpdateSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_CHECK_UPDATE];
    NSLog(@"url %@",url);
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setObject:AppVersion forKey:@"version"];
    if (isappstore == 1) {
        
        [parameter setObject:@"1" forKey:@"isappstore"];//1是appstore版本
    }
    if (isappstore == 2) {
        
        [parameter setObject:@"2" forKey:@"isappstore"];//2是企业包版本
    }
    
    [NetWorking post:url params:parameter success:^(NSDictionary *response){
        if (success) {
            //返回controller，然后在UI线程上进行更新
            //解析返回的数据
            @try {
                if ([[response objectForKey:@"state"]integerValue] == 1000) {
                    //存储数据
                    
                }else{
                    //错误信息
                }
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            success(response);
        }
    }failure:^(NSError *error){
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)loginWithUserNameParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_LOGIN_USERACCOUNT];
    [NetWorking post:url params:parameter success:^(id response) {
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取userid和usertoken
            NSString *userid = [NSString stringWithFormat:@"%@",[[response objectForKey:@"data"] objectForKey:@"userid"]];
            NSString *userToken = [[response objectForKey:@"data"] objectForKey:@"usertoken"];
            if (![Util isEmpty:userid] && ![Util isEmpty:userToken]) {
                UserInfo *userInfo = [UserInfo MR_findFirstByAttribute:@"userid" withValue:userid];
                if (userInfo == nil) {
                    userInfo = [UserInfo MR_createEntity];
                }
                userInfo.userid = userid;
                userInfo.usertoken = userToken;
                userInfo.rongyunid = [NSString stringWithFormat:@"%@",[[response objectForKey:@"data"] objectForKey:@"rongtoken"]];
                userInfo.type = [NSString stringWithFormat:@"%@",[[response objectForKey:@"data"] objectForKey:@"type"]];
                [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
                
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userid"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"usertoken"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"rongyunid"];
                [[NSUserDefaults standardUserDefaults]setObject:userid forKey:@"userid"];
                [[NSUserDefaults standardUserDefaults]setObject:userToken forKey:@"usertoken"];
                [[NSUserDefaults standardUserDefaults]setObject:userInfo.rongyunid forKey:@"rongyunid"];
            }
            
        }
        success(response);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)registerWithUserNameParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_REGISTER_USERACCOUNT];
    [NetWorking post:url params:parameter success:^(id response) {
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
        }
        success(response);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)isAppstoreSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_ISON_APPSTROE];
    [NetWorking post:url params:nil success:^(id response) {
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
        }
        success(response);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)sendDeviceToken:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_SEND_DEVICETOKEN];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
