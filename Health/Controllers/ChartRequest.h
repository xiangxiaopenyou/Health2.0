//
//  ChartRequest.h
//  Health
//
//  Created by 陈 on 15/6/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartRequest : NSObject
+(void)success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
@end
