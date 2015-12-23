//
//  MessageRequest.h
//  Health
//
//  Created by cheng on 15/2/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageRequest : NSObject

+ (void)replyListWith:(NSMutableArray*)array success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
+ (void)replyListRefreshWith:(NSMutableArray*)array success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

+ (void)favoriteListWith:(NSMutableArray*)array success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
+ (void)favoriteListRefreshWith:(NSMutableArray*)array success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

+ (void)notReadWithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *系统消息查询：own/systemList
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
 *
 */
+ (void) getSystemMessage:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

@end
