//
//  MyInfoRequest.h
//  Health
//
//  Created by 王杰 on 15/2/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyInfoRequest : NSObject

+ (void)myInfoWithParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

+ (void)myPicWithParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

@end
