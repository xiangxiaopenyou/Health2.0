//
//  RTUploadImageNetWork.h
//  RTHealth
//
//  Created by cheng on 14/11/21.
//  Copyright (c) 2014年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTUploadImageNetWork : NSObject


/*
 * 发送一个post请求,上传图片
 *
 *
 * @param  url     请求路径
 * @param  params  请求参数
 * @param  success 请求成功返回
 * @param  failure 请求失败返回
 */
+ (void)postMulti:(NSString*)url imageparams:(UIImage*)imageparams success:(void(^)(id response))success failure:(void(^)(NSError *error))failure Progress:(void(^)(NSString *key,float percent))progress Cancel:(BOOL(^)(void))cancel;

@end
