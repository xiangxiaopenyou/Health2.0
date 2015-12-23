//
//  RelationRequest.h
//  Health
//
//  Created by cheng on 15/3/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelationRequest : NSObject

+ (void)fansListWith:(NSMutableArray*)array parameter:(NSDictionary*)parameter URL:(NSString*)url success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

+ (void)fansMoreListWith:(NSMutableArray*)array parameter:(NSDictionary*)parameter URL:(NSString*)url success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

@end
