//
//  TrendRequest.h
//  Health
//
//  Created by 项小盆友 on 15/2/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrendRequest : NSObject
/*
 * 写动态 接口
 *
 * @params parameter userid usertoken content image ispublic address
 * @params success 成功返回信息
 * @params failture 失败返回信息
 */
+ (void)writeTrendsWith:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 * 获取最新动态列表 接口
 *
 * @params parameter userid usertoken time
 * @params success 成功返回信息
 * @params failture 失败返回信息
 */
+ (void)getTrendsListWith:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 * 获取最新动态列表 接口
 *
 * @params parameter userid usertoken time
 * @params success 成功返回信息
 * @params failture 失败返回信息
 */
+ (void)getAttentionTrendsListWith:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 * 获取动态详情 接口
 *
 * @params parameter userid usertoken trendid
 * @params success 成功返回信息
 * @params failture 失败返回信息
 */
+ (void)trendDetailWtih:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 * 评论动态 接口
 *
 * @params parameter userid usertoken trendid commentcontent
 * @params success 成功返回信息
 * @params failture 失败返回信息
 */
+ (void)commentTrendWith:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 * 回复动态 接口
 *
 * @params parameter userid usertoken trendid commentid commentuserid cpartakcontent
 * @params success 成功返回信息
 * @params failture 失败返回信息
 */
+ (void)replyTrendWith:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 * 点赞 接口
 *
 * @params parameter userid usertoken trendid
 * @params success 成功返回信息
 * @params failture 失败返回信息
 */
+ (void)likeTrendWith:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 * 取消点赞 接口
 *
 * @params parameter userid usertoken trendid
 * @params success 成功返回信息
 * @params failture 失败返回信息
 */
+ (void)cancelLikeTrendWith:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 * 获取点赞的人 接口
 *
 * @params parameter userid usertoken trendid
 * @params success 成功返回信息
 * @params failture 失败返回信息
 */
+ (void)likeMemberWith:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 * 删除动态 接口
 *
 * @params parameter userid usertoken trendid
 * @params success 成功返回信息
 * @params failture 失败返回信息
 */
+ (void)deleteTrendWith:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 * 关注 接口
 *
 * @params parameter userid usertoken fansid
 * @params success 成功返回信息
 * @params failture 失败返回信息
 */
+ (void)payAttentionWith:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 * 取消关注 接口
 *
 * @params parameter userid usertoken fansid
 * @params success 成功返回信息
 * @params failture 失败返回信息
 */
+ (void)cancelAttentionWith:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *用户投诉接口：/complaints/complaintsCreate
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  complaintstargetid  投诉的对象ID(可选)
 * @param  type  投诉的类型 show、club、course(可选)
 *
 * @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
 *
 */
+ (void)reportWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *标签列表：sign/tagList
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  like  模糊查询(可有)
 *
 * @return  data返回的数据  state 返回的状态1000 message返回状态解释
 *
 */
+ (void)tagListWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *用户自定义标签：sign/tagCreate
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  name  标签名(必须有)
 *
 * @return  data返回的数据  state 返回的状态1000 message返回状态解释
 *
 */
+ (void)tagCreateWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *食物列表：sign/foodsList
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  like  模糊查询(可有)
 *
 * @return  data返回的数据  state 返回的状态1000 message返回状态解释
 *
 */
+ (void)foodListWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *运动列表：sign/sportList
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  like  模糊查询(可有)
 *
 * @return  data返回的数据  state 返回的状态1000 message返回状态解释
 *
 */
+ (void)sportsListWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *获取打卡列表：trends/trendsSignList
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 *
 * @return  data返回的数据  state 返回的状态1000 message返回状态解释
 *
 */
+ (void)clockinListWith:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *两个推荐用户：trends/recommend
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 *
 * @return  data返回的数据  state 返回的状态1000 message返回状态解释
 */
+ (void)recommendUsersWith:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *推荐用户列表查询：trends/recommendList
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  limt  分页时间（分页条数20），(可选)
 *
 * @return  data返回的数据  state 返回的状态1000 message返回状态解释
 */
+ (void)recommendUserListWith:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *推荐精选图片列表查询：trends/trendsChoice
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  limt  分页时间（分页条数20），(可选)
 *
 * @return  data返回的数据  state 返回的状态1000 message返回状态解释
 */
+ (void)recommendPhotosListWith:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *推荐焦点图接口：config/topicList
 *
 *
 * @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
 *
 */
+ (void)focusImageWith:(NSDictionary *)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

@end
