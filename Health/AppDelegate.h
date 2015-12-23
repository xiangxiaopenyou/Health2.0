//
//  AppDelegate.h
//  Health
//
//  Created by cheng on 15/1/23.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "RTTabbarViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate, WeiboSDKDelegate,RCIMUserInfoFetcherDelegagte,RCIMReceiveMessageDelegate>{
    NSMutableArray *userInfoArray;
    NSMutableArray *groupInfoArray;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) NSString *updateUrl;
@property (nonatomic,retain) UINavigationController *rootNavigationController;
@property (nonatomic, retain) RTTabbarViewController *tabbarController;

-(void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion;
-(void)getGroupInfoWithGroupId:(NSString*)groupId completion:(void (^)(RCGroup *group))completion;
- (void) sendLinkContentTimeLine:(NSString*)title Description:(NSString*)description Url:(NSString*)urlString Photo:(NSString*)photoUrl;
- (void) sendLinkContent:(NSString*)title Description:(NSString*)description Url:(NSString*)urlString Photo:(NSString*)photoUrl;

@end

