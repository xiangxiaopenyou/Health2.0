//
//  UrlConstan.h
//  Health
//
//  Created by cheng on 15/1/28.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#ifndef Health_UrlConstan_h
#define Health_UrlConstan_h


//#define URL_BASE @"http://192.168.1.112:9090/jianshen/Admin"//陈世江本地
#define URL_BASE @"http://jianshen.so/Admin" //发布服务器
//#define URL_BASE @"http://115.29.170.235/Admin"//正式服务器地址
//#define URL_BASE @"http://test.jianshen.so/Admin"

//#define URL_FOCUSMAP @"http://felix-chenc.qiniudn.com/"//测试库图片地址
#define URL_FOCUSMAP @"http://7u2h8u.com1.z0.glb.clouddn.com/" //正式库图片地址

#define URL_TRENDS_SHARE_BASE @"http://jianshen.so/Health/Trends/detail" //正式
//#define URL_TRENDS_SHARE_BASE @"http://test.jianshen.so/Health/Trends/detail"//测试服务器

#define URL_COURSE_SHARE_BASE @"http://jianshen.so/Health/Course/appCourse" //正式
//#define URL_COURSE_SHARE_BASE @"http://test.jianshen.so/Health/Course/appCourse"//测试服务器

/*
 自动更新
 */
#define URL_CHECK_UPDATE @"/config/version"
/*
 AppStore是否上线
 */
#define URL_ISON_APPSTROE @"/config/shfind"
/*
 图片上传地址
 */
#define URL_UPLOADIMAGE @"http://up.qiniu.com/"

/*
 图片上传的Token获取
 */
#define URL_GETTOKEN @"/QiNiuToken/setToken2"

/*
 *login 
 *参数openid  nickname  headimgurl sex introduce
 *POST
 *返回 userid  usertoken usertype
 */
#define URL_LOGIN @"/own/thirdRegister"

/*
 *login
 *参数username userpassword
 *POST
 *返回 userid  usertoken usertype
 */
#define URL_LOGIN_USERACCOUNT @"/own/login"
/*
 *register
 *参数username userpassword
 *POST
 *返回 userid  usertoken usertype
 */
#define URL_REGISTER_USERACCOUNT @"/own/register"
/*
 *获取融云token
 *参数 userid usertoken
 *POST
 *返回token
 */
#define URL_RONGYUN_TOKEN @"/own/setrytoken"

/*
 *提供用户信息给融云
 */
#define URL_RONGYUN_USERINFO @"/own/userportrait"

/*
 *提供群组信息给容云
 */
#define URL_RONGYUN_GROUP @"/course/onlyCourse"
/*
 *deviceToken传到服务器
 */
#define URL_SEND_DEVICETOKEN @"/own/setdDeviceToken"

/*
 *course list
 *参数 userid usertoken
 *POST
 *返回 课程信息
 */
#define URL_COURSE_COURSE_LIST @"/course/courselist"

/*
 *mycourse list
 *参数 userid usertoken
 *POST
 *返回 课程信息
 */
#define URL_COURSE_MYCOURSE_LIST @"/course/courseInvolved"

/*
 *allcourse list
 *参数 userid usertoken
 *POST
 *返回 课程信息
 */
#define URL_COURSE_ALLCOURSE_LIST @"/course/courseRecommend"


/*
 *course 详情
 *参数 userid usertoken courseid
 *POST
 *返回 课程信息
 */
#define URL_COURSE_COURSE_DETAILMINE @"/course/courseDetail"

/*
 *apply course
 *参数 userid usertoken courseid
 *POST
 *返回 成功失败
 */
#define URL_COURSE_COURSE_APPLY_REAL @"/course/coursetakeCreate"  //真实支付过程
#define URL_COURSE_COURSE_APPLY @"/course/courseCreate"

/*
 *完成 coursesub
 *参数 userid usertoken courseid coursesubid
 *POST
 *返回 成功失败
 */
#define URL_COURSE_COURSESUB_FINISH @"/course/finish"

/*
 *课程同学
 *参数 userid usertoken courseid
 *POST
 *返回 成功失败
 */
#define URL_COURSE_STUDENT_LIST @"/course/studentlist"

#define URL_CREATEINTERACTION @"/course/courseDiscussionCreate"
#define URL_COURSEINTERACTIONLIST @"/course/courseDiscussionList"
#define URL_DELETECOURSEINTERACTION @"/course/courseDiscussiondele"
#define URL_COURSEINTERACTIONDETAIL @"/course/courseCommentList"
#define URL_COURSEINTERACTIONCOMMENT @"/course/courseCommentCreate"
#define URL_COURSEINTERACTIONREPLY @"/course/courseCpartakCreate"
#define URL_MYCOURSEINTERACTIONS @"/course/allDiscussionList"

#define URL_UPLOADIMAGE @"http://up.qiniu.com/"
#define URL_GETTOKEN @"/QiNiuToken/setToken2"
/*
 问答咨询列表
 参数 userid usertoken courseid
 POST
 返回 列表
 */
#define URL_COURSE_QA_LIST @"/consult/consultlist"

/*
 课程提问接口
 参数 userid，usertoken，courseid，questioncontent
 POST
 返回 成功失败
 */
#define URL_COURSE_QA_QUESTION @"/consult/consultCreate"

/*
 课程提问回答
 */
#define URL_COURSE_QA_ANSWER @"/consult/consultCpartakCreate"

/*
 消息列表：replylist
 参数：userid  usertoken  time
 POST 
 返回
 */
#define URL_MESSAGE_REPLYLIST @"/own/replylist"
/*
 赞列表
 参数：userid  usertoken  time
 POST
 返回
 */
#define URL_MESSAGE_FAVORITELIST @"/own/favoritelist"

#define URL_SYSTEM_MESSAGE @"/own/systemList"

/*
 未读消息数量
 参数：userid  usertoken
 POST
 返回
 */
#define URL_MESSAGE_NOTREADNUM @"/own/notreadnum"

/*
 friend info
 */
#define URL_FRIEND_INFO @"/friend/info"

/*
 friendCourse
 */
#define URL_FRIEND_COURSE @"/course/friendCourse"

/*
 trendfriendpicture
 */
#define URL_FRIEND_PICTURE @"/trends/trendfriendpicture"

/*
 别人的粉丝
 */
#define URL_FRIEND_FANS @"/fans/friendfans"

/*
 别人的关注
 */
#define URL_FRIEND_ATTENTION @"/fans/friendattention"

/*
 别人的详细信息
 */
#define URL_FRIEND_DETAILINFO @"/own/frienddetail"

/*
 *trend
 *
 */
#define URL_WRITETRENDS @"/trends/trendCreate"
#define URL_GETTRENDLIST @"/trends/trendsList"
#define URL_GETATTENTIONTRENDLIST @"/trends/fansTrendsList"
#define URL_TRENDDETAIL @"/trends/detail"
#define URL_TRENDCOMMENT @"/trends/commentCreate"
#define URL_TRENDREPLY @"/trends/cpartakCreate"
#define URL_LIKETREND @"/trends/favoriteCreate"
#define URL_DISLIKETREND @"/trends/delefavorite"
#define URL_LIKEMEMBERLIST @"/trends/favoriteList"
#define URL_DELETETREND @"/trends/trendDelete"

#define URL_CLOCKIN_LIST @"/trends/trendsSignList"

#define URL_RECOMMENDUSERS @"/trends/recommend"
#define URL_RECOMMENDUSERLIST @"/trends/recommendList"
#define URL_RECOMMENDPHOTOSLIST @"/trends/trendsChoice"
#define URL_FOCUSIMAGE @"/config/topicList"

/*
 关注
 */
#define URL_PAYATTENTION @"/fans/fansCreate"
#define URL_CANCELATTENTION @"/fans/delefans"

/*
 Club
 */
#define URL_CLUBLIST @"/club/mypartakeclublist"
#define URL_MYCLUBLIST @"/club/clubMyList"
#define URL_ALLCLUBLIST @"/club/clubRecommendList"
#define URL_CLUBDETAIL @"/club/clubpostsList"
#define URL_WRITECLUBDISCUSSION @"/club/clubpostsCreate"
#define URL_CLUBDISCUSSIONDETAIL @"/club/clubpostsDetail"
#define URL_CLUBMEMBERLIST @"/club/clubmemberlist"
#define URL_JOINCLUB @"/club/clubmemberCreate"
#define URL_EXITCLUB @"/club/clubmembermydele"
#define URL_CLUBDISCUSSIONCOMMENT @"/club/clubpostsCommentCreate"
#define URL_CLUBDISCUSSIONREPLY @"/club/clubpostsCpartakCreate"
#define URL_DELETECLUBDISCUSSION @"/club/clubpostsdele"
#define URL_CLUBADMINCREATE @"/club/clubadminCreate"
#define URL_CLUBADMINCANCEL @"/club/clubadmincancel"
#define URL_CLUBADMINDELETE @"/club/clubadmindele"
#define URL_CLUBMEMBERDELETE @"/club/clubmemberdele"
#define URL_CLUBMEMBERGAG @"/club/clubgag"
#define URL_CLUBMEMBERCANCELGAG @"/club/clubgagdele"
#define URL_CLUB_SIGN @"/club/clubSign"
#define URL_CLUB_APPLY @"/club/clubapplyAdd"
#define URL_CLUB_CREAM_CREATE @"/club/clubHtmlAdd"
#define URL_CLUB_CREAM_LIST @"/club/clubChoice"
#define URL_CLUB_STARS_LIST @"/club/clubStar"
#define URL_CLUB_CURRICULUM @"/club/clubChoiceCustom"
#define URL_CLUB_COURSE_LIST @"/club/clubCourse"

/*
 * myinfo
 * 参数 userid usertoken
 * post
 */
#define URL_MY_INFO @"/own/info"

#define URL_BODY_INFO @"/own/otherBodyList"
#define URL_BODY_INFO_EDIT @"/own/otherBody"


/*
 * mypic
 * 参数 userid usertoken
 * post
 */
#define URL_MY_PIC @"/trends/trendpicture"


/*
 * mycourse
 * 参数 userid usertoken
 * post
 */
#define URL_MY_COURESE @"/course/myCourse"

/*
 * myfans
 * 参数 userid usertoken
 * post
 */
#define URL_MY_FANS @"/fans/Fans"

/*
 * myattention
 * 参数 userid usertoken
 * post
 */
#define URL_MY_ATTENTION @"/fans/attention"

/*
 * delefans
 * 参数 userid usertoken fansid
 * post
 */
#define URL_MY_DELEFANS @"/fans/delefans"

/*
 * fansCreate
 * 参数 userid usertoken fansid
 * post
 */
#define URL_MY_FANSCREATE @"/fans/fansCreate"

/*
 * mydetailInfo
 * 参数 userid usertoken
 * post
 */
#define URL_MY_INFO_DETAIL @"/own/detail"

/*
 * 修改个人信息
 * 参数 所有个人信息
 * POST
 */
#define URL_MY_INFO_MODIFY @"/own/modifyinfo"

/*
 * 修改体重信息
 * 参数 体重信息
 * POST
 */
#define URL_WEIGHT_INFO_MODIFY @"/sign/updateWeight"

/*
 * 修改个人头像
 * 参数 所有个人头像
 * POST
 */
#define URL_MY_INFO_MODIFYPHOTO @"/own/upportrait"

/*
投诉
 */
#define URL_REPORT @"/complaints/complaintsCreate"

/*
 tag
 */
#define URL_TAG_LIST @"/sign/tagList"
#define URL_TAG_CREATE @"/sign/tagCreate"
#define URL_FOOD_LIST @"/sign/foodsList"
#define URL_SPORTS_LIST @"/sign/sportList"

//获取体重信息
#define URL_WEIGHTINFO @"/sign/journl"

//打卡日记
#define URL_DAIRY_LIST @"/sign/journalList"

/*
 折现图数据
 参数：：userid  usertoken  time
 POST
 返回
 */
#define URL_CHART_DATA @"/sign/weightList"


#endif
