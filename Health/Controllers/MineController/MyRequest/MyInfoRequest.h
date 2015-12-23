//
//  MyInfoRequest.h
//  Health
//
//  Created by 王杰 on 15/2/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyTrend.h"
#import "MyCourse.h"
#import "MyFuns.h"

@interface MyInfoRequest : NSObject

//我的信息
+ (void)myInfoWithParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

//我的照片
+ (void)myPicWithParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

//我的课程
+ (void)myCourseWithParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

//我的粉丝
+ (void)myFansWithParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

//我的关注
+ (void)myAttentionWithParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

//关注
+ (void)fanCreateWithParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

//取消关注
+ (void)fanDelesWithParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

//我的个人信息
+ (void)myDetailInfoWithParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

//修改我的个人信息
+ (void)modifyMyInfoWithParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

//修改体重信息
+ (void)modifyWeightInfoWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

//修改我的头像
+ (void)modifyMyPortraitWithParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

//我的照片,刷新
+ (void)pictureListWith:(NSMutableArray*)array success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

//我的照片,加载更多
+ (void)pictureMoreListWith:(NSMutableArray *)array success:(void(^)(id))success failure:(void(^)(NSError *))failure;

//我的训练营,刷新
+ (void)courseListWith:(NSMutableArray*)array success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

//我的训练营,加载更多
+ (void)courseMoreListWith:(NSMutableArray *)array success:(void(^)(id))success failure:(void(^)(NSError *))failure;

/*
 我的体重信息
 */
+ (void)myWeightInfo:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
/*
 打卡日记信息列表
 */
+ (void)dairyInfoList:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *查询身体状况：own/otherBodyList
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 *
 *
 * @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
 *
 */
+ (void)bodyInfo:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *身体状况记录：own/otherBody
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  height 身高（可选）
 * @param  weight 体重（可选）
 * @param  chest 胸围（可选）
 * @param  waist 腰围（可选）
 * @param  hip 臀围（可选）
 * @param  arm 手臂（可选）
 * @param  thigh 大腿围（可选）
 * @param  calf 小腿围（可选）
 * @param  pushups 俯卧撑（可选）
 * @param  volume 卷腹（可选）
 * @param  taitui 高抬腿（可选）
 *
 *
 * @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
 *
 */
+ (void)bodyInfoEdit:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
@end
