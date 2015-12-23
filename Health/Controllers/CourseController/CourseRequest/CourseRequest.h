//
//  CourseRequest.h
//  Health
//
//  Created by cheng on 15/2/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudentEntity.h"
#import "CourseQAEntity.h"

@interface CourseRequest : NSObject
/*
 首页我的课程和推荐课程
 参数： userid  usertoken
 返回：
 方法：POST
 */
+ (void)courseListWithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
/**
*我参与的训练营：course/courseInvolved
* @param  userid  用户ID(必须有)
* @param  usertoken  校验token(必须有)
* @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
*
*/
+ (void)myCourseListWithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
/**
*全部的训练营：course/courseRecommend
* @param  userid  用户ID(必须有)
* @param  usertoken  校验token(必须有)
* @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
*
*/
+ (void)allCourseListWithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 参与课程
 参数： userid  usertoken  courseid
 返回：
 方法：POST
 */
+ (void)applyCourseWith:(NSString*)courseid success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
+ (void)applyCourse:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 课程详情
 */
+ (void)courseDetailMineWith:(Course*)course success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 参与课程
 参数： userid  usertoken  courseid  coursesubid
 返回：
 方法：POST
 */
+ (void)finishCourseSubWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 参与课程的课程
 参数： userid  usertoken  courseid
 地址：
 方法：POST
 */
+ (void)studentCourseWith:(NSString*)courseid success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 发表课程互动帖子
 参数： userid  usertoken  courseid courseownerid discussiontitle discussioncontent
 地址：
 方法：POST
 */
+ (void)createCourseInteractionWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 课程互动帖子列表
 参数： userid  usertoken  courseid
 地址：
 方法：POST
 */
+ (void)courseInteractionListWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 删除课程互动帖子
 参数： userid  usertoken  courseid discussionid
 地址：
 方法：POST
 */
+ (void)deleteCourseInteractionWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 课程互动帖子详情
 参数： userid  usertoken  courseidiscussionid
 地址：
 方法：POST
 */
+ (void)courseInteractionDetailWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 课程互动评论
 参数： userid  usertoken  discussionid discussionuserid commentcontent
 地址：
 方法：POST
 */
+ (void)courseInteractionCommentWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 课程互动评论
 参数： userid  usertoken  discussionid commentid commentreplyid discussionuserid commentcontent
 地址：
 方法：POST
 */
+ (void)courseInteractionReplyWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 我的课程互动时间轴
 参数： userid  usertoken  discussionid commentid commentreplyid discussionuserid commentcontent
 地址：
 方法：POST
 */
+ (void)myCourseInteractionsWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 课程的问答
 参数： userid  usertoken  courseid
 地址：
 方法：POST
 */
+ (void)courseQAListWith:(NSString*)courseid success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 课程的提问
 参数： userid  usertoken  courseid questioncontent
 地址：
 方法：POST
 */
+ (void)courseQuestionWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 课程提问回答
 参数：userid usertoken courseid courseuserid answerid answercontent
 地址：
 方法：post
 */
+ (void)courseAnswerWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
@end
