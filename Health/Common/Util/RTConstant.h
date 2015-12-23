//
//  RTConstant.h
//  RTHealth
//
//  Created by cheng on 14/10/22.
//  Copyright (c) 2014年 realtech. All rights reserved.
//

#ifndef RTHealth_RTConstant_h
#define RTHealth_RTConstant_h

#pragma mark 是否是appsotre

//#define isappstore 1 //appstore
#define isappstore 2 //no

#pragma mark 某些字段的表示
//总计划的几个状态 1 开始 2 未开始 3 已完成 4 未导入 state
//子计划的几个状态 1 完成 2 未完成 3 正在进行4 未进行 flag
//朋友的标记 1表示单方关注 2表示双方关注
//计划公开 1 公开  else 不公开
//体重公开 1 公开  else 不公开
//性别    1 男    else 女  默认0 女
#define MAN_FLAG 1
#define WOMAN_FLAG 0
//coursesubtype 1为线上健身  2为线下活动

#define FRIENDS_SIGNAL 1
#define FRIENDS_EACHOTHER 2
#define FRIENDS_IATTENTION 3
#define FRIENDS_HEATTENTION 4

//1表示评论 2表示回复
#pragma mark 三方的key和secret

//融云sdk
#define RYAPPKEY @"ik1qhw091dt3p"
#define RYSecret @"CExMIWwUBca"
#define RYAPPKEY_TEST @"3argexb6rnowe"
#define RYSecret_TEST @"xwATcK8Upt"

//微博
#define kAppKey         @"3858892611"
#define kAppSecret      @"0caca9888a2725f1157cbed51dc98568"
#define kRedirectURI    @"https://api.weibo.com/oauth2/default.html"
#define kAppUserInfo    @"https://api.weibo.com/2/users/show.json"

//微信
#define wxAppKey        @"wxf2e603a835fbb324"
#define wxAppSecretkey  @"ef3e5025c2a0a2e4b21c63f20ba6a54c"
#define wxDescribe      @"health"
#define wxUserInfoAccess  @"https://api.weixin.qq.com/sns/oauth2/access_token"
#define wxUserInfo      @"https://api.weixin.qq.com/sns/userinfo"
//QQ
#define qqAppid         @"1104061498"
#define qqSecret        @"jpF5A4CAtgGhG26v"

//TuSKD
//#define tuSecret        @"a91fcb6a3c955ecc-00"  //企业包
#define tuSecret        @"747df7438f8b2fe1-00-oimln1"  //企业包升级
//#define tuSecret        @"c5ad1fddd10e9d25-00"  //appstore正式包
//#define tuSecret        @"1ac9c7143e737182-00-oimln1"  //appstore正式包升级。

//友盟key
#define UMengKey        @"5508e883fd98c590ae0013ca"

#define AlipayPartner   @"2088011517502464"

#pragma mark 本地消息通知
//本地消息通知

//获取到消息条数
#define GETALLMESSAGE @"getallmessage"
//发送成功
#define SENDSUCCESS @"sendsuccess"
//我的课程有变化
#define MINECOURSECHANGE @"MINECOURSECHANGE"
//devicetoken
#define NOTIFICATION_DEVICETOKEN @"devicetoken"
//点击推送消息进入app
#define NOTIFICATION_OPENAPP @"Notification"
//有新的聊天信息
#define NOTIFICATION_CHAT @"notificationchat"

#define NOTIFICATION_MESSAGE @"PushMessageController"

#pragma mark 全局的字体或颜色定义

#define SMALLFONT_10 [UIFont systemFontOfSize:10.0]
#define SMALLFONT_12 [UIFont systemFontOfSize:12.0]
#define SMALLFONT_13 [UIFont systemFontOfSize:13.0]
#define SMALLFONT_14 [UIFont systemFontOfSize:14.0]
#define SMALLFONT_16 [UIFont systemFontOfSize:16.0]


#define BOLDFONT_17 [UIFont boldSystemFontOfSize:17.0]
#define BOLDFONT_16 [UIFont boldSystemFontOfSize:16.0]
#define BOLDFONT_18 [UIFont boldSystemFontOfSize:18.0]
#define BOLDFONT_19 [UIFont boldSystemFontOfSize:19.0]
#define BOLDFONT_20 [UIFont boldSystemFontOfSize:20.0]
#define BOLDFONT_14 [UIFont boldSystemFontOfSize:14.0]

#define VERDANA_FONT_16 [UIFont fontWithName:@"Verdana" size:16.0]
#define VERDANA_FONT_14 [UIFont fontWithName:@"Verdana" size:14.0]
#define VERDANA_FONT_12 [UIFont fontWithName:@"Verdana" size:12.0]
#define VERDANA_FONT_11 [UIFont fontWithName:@"Verdana" size:11.0]
#define VERDANA_FONT_10 [UIFont fontWithName:@"Verdana" size:10.0]

#define MAIN_COLOR_YELLOW [UIColor colorWithRed:230/255.0 green:187/255.0 blue:13/255.0 alpha:1.0]
#define TIME_COLOR_GARG [UIColor colorWithRed:88/255.0 green:88/255.0 blue:101/255.0 alpha:1.0]
#define LINE_COLOR_GARG [UIColor colorWithRed:63/255.0 green:62/255.0 blue:69/255.0 alpha:1.0]
#define TABLEVIEW_BACKGROUNDCOLOR [UIColor colorWithRed:21/255.0 green:20/255.0 blue:26/255.0 alpha:1.0]
#define TABLEVIEWCELL_COLOR [UIColor colorWithRed:27/255.0 green:26/255.0 blue:35/255.0 alpha:1.0]
#define line_color [UIColor colorWithRed:63/255.0 green:62/255.0 blue:69/255.0 alpha:1.0]
#define WHITE_CLOCLOR [UIColor whiteColor]
#define CLEAR_COLOR [UIColor clearColor]
#define PICKER_COLOR [UIColor colorWithRed:238/255.0 green:244/255.0 blue:251/255.0 alpha:1.0]

#pragma mark App全局某些代码片段
#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define AppShared @"健身坊分享"

#endif
