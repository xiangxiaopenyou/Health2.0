//
//  NetWorking.h
//  Health
//
//  Created by cheng on 15/1/23.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorking : NSObject

/*
 * 发送一个get请求
 *
 * @param  url     请求路径
 * @param  params  请求参数
 * @param  success 请求成功返回
 * @param  failure 请求失败返回
 */

+ (void)get:(NSString*)url params:(NSDictionary*)params success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
/*
 * 发送一个post请求
 *
 * @param  url     请求路径
 * @param  params  请求参数
 * @param  success 请求成功返回
 * @param  failure 请求失败返回
 */
+ (void)post:(NSString*)url params:(NSDictionary*)params success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 * 发送一个post请求,上传图片
 * eg. 上传图片[formData appendPartWithFileData :imageData name:@"1"fileName:@"1.png"mimeType:@"image/jpeg"]
 *
 *
 * @param  url     请求路径
 * @param  params  请求参数
 * @param  success 请求成功返回
 * @param  failure 请求失败返回
 */
+ (void)postMulti:(NSString*)url params:(NSDictionary*)params imageparams:(UIImage*)imageparams success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
@end
