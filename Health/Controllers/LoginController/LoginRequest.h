//
//  LoginRequest.h
//  Health
//
//  Created by cheng on 15/1/28.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginRequest : NSObject

+ (void)loginWithParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

+ (void)getRongyunToken:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

+ (void)getUserInfo:(NSString*)userid success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
+ (void)getGroupInfo:(NSString*)groupid success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
/*
 检查更新
 */
+ (void)checkUpdateSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

+ (void)loginWithUserNameParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

+ (void)registerWithUserNameParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

+ (void)isAppstoreSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *IOS获取推送token：owntdDeviceToken
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  devicetoken  IOS获取推送token(必须有)
 *
 * @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
 */
+ (void)sendDeviceToken:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

@end
