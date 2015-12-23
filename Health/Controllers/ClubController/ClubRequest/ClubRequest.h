//
//  ClubRequest.h
//  Health
//
//  Created by jason on 15/3/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClubRequest : NSObject

/*
 我的俱乐部和推荐俱乐部
 接口 userid usertoken
 */
+ (void)clubListWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

 /*
 我的俱乐部
 接口 userid usertoken
 */
+ (void)myClubListWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
/*
 推荐的俱乐部
 接口 userid usertoken
 */
+ (void)allClubListWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 
 俱乐部详情
 接口 userid usertoken clubid
 */
+ (void)clubDetailWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 发布俱乐部帖子
 接口
 */
+ (void)writeClubDisussionWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/*
 帖子详情
 接口
 */
+ (void)clubDisussionDetailWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *删除某个俱乐部的帖子：club/clubpostsdele
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  clubpostsid  俱乐部帖子ID(必须有)
 * @param  clubid  俱乐部ID(必须有)
 *
 * @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
 *
 */
+ (void)deleteClubDisussionWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *俱乐部成员：club/clubmemberlist
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  clubid  俱乐部ID(必须有)
 * @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
 *
 */
+ (void)clubMemberListWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *成员加入俱乐部：club/clubmemberCreate
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  clubid  俱乐部ID(必须有)
 * @param  clubuserid  俱乐部创建者ID(必须有)
 * @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
 *
 */
+ (void)joinClubWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *成员退出俱乐部：club/clubmembermydele
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  clubid  俱乐部ID(必须有)
 * @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
 *
 */
+ (void)exitClubWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *创建俱乐部帖子评论
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  clubposid  俱乐部帖子ID(必须有)
 * @param  clubposuserid  俱乐部帖子创建人ID(必须有)
 * @param  commentcontent  评论的内容(必须有)
 *
 * @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
 *
 */
+ (void)clubDiscussionCommentWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *俱乐部的帖子的回复
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  clubposid  俱乐部帖子ID(必须有)
 * @param  clubposuserid  俱乐部帖子创建人ID(必须有)
 * @param  reply  回复的内容(必须有)
 * @param  commentid  回复的评论ID(必须有)
 * @param  commentreplyuserid  回复的评论创建人ID(必须有)
 *
 * @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
 *
 */
+ (void)clubDiscussionReplyWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *俱乐部设置管理员：club/clubadminCreate
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  clubid  俱乐部ID(必须有)
 * @param  adminid  管理员ID(必须有)
 *
 * @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
 *
 */
+ (void)clubAdminCreateWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *俱乐部取消管理员资格：club/clubadmindele
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  clubid  俱乐部ID(必须有)
 * @param  adminid  管理员ID(必须有)
 *
 * @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
 *
 */
+ (void)clubAdminCancelWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *俱乐部删除管理员：club/clubadmindele
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  clubid  俱乐部ID(必须有)
 * @param  adminid  管理员ID(必须有)
 *
 * @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
 *
 */
+ (void)clubAdminDeleteWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *俱乐部删除成员：club/clubmemberdele
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  clubid  俱乐部ID(必须有)
 * @param  clubmemberuserid  成员ID(必须有)
 *
 * @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
 *
 */
+ (void)clubMemberDeleteWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *俱乐部成员设置禁言：club/clubgag
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  gagid  俱乐部成员ID(必须有)
 *
 * @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
 *
 */
+ (void)clubMemberGagWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
 *俱乐部成员取消禁言：club/clubmembertype
 * @param  userid  用户ID(必须有)
 * @param  usertoken  校验token(必须有)
 * @param  clubmemberid  俱乐部成员ID(必须有)
 *
 * @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
 *
 */
+ (void)clubMemberCancelGagWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
*俱乐部签到：club/clubSign
* @param  userid  用户ID(必须有)
* @param  usertoken  校验token(必须有)
* @param  clubid  俱乐部ID(必须有)
*
* @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
*
*/
+ (void)clubSignWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
*俱乐部申请：club/clubapplyAdd
* @param  userid  用户ID(必须有)
* @param  usertoken  校验token(必须有)
* @param  clubid  俱乐部ID(必须有)
* @param content 验证信息
* @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
*
*/
+ (void)clubApplyWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
*俱乐部精选，活动，课程创建：club/clubHtmlAdd
* @param  userid  用户ID(必须有)
* @param  usertoken  校验token(必须有)
* @param  clubid  俱乐部ID(必须有)
* @param  type  俱乐部ID(必须有),type=1精选文章，2课程，3活动
* @param  url  链接地址(必须有)
*  @param  title  标题(必须有)
*
* @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
*
*/
+ (void)clubCreamCreateWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
*俱乐部精选或者活动内容：club/clubChoice
* @param  userid  用户ID(必须有)
* @param  usertoken  校验token(必须有)
* @param  clubid  俱乐部ID(必须有)
* @param  type  俱乐部ID(必须有),type=1精选文章,3活动
* @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
*
*/
+ (void)clubCreamListWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
*俱乐部明星：club/clubStar
* @param  userid  用户ID(必须有)
* @param  usertoken  校验token(必须有)
* @param  clubid  俱乐部ID(必须有)
* @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
*
*/
+ (void)clubStarsListWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
/**
*俱乐部课程表：club/clubChoiceCustom
* @param  userid  用户ID(必须有)
* @param  usertoken  校验token(必须有)
* @param  clubid  俱乐部ID(必须有)
* @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
*
*/

+ (void)clubCurriculumWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

/**
*俱乐部训练营：club/clubCourse
* @param  userid  用户ID(必须有)
* @param  usertoken  校验token(必须有)
* @param  clubid  俱乐部ID(必须有)
* @return  data返回的数据  ， state 返回的状态 ，message返回状态解释
*
*/
+ (void)clubCourseListWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;



@end
