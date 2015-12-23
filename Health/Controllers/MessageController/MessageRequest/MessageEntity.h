//
//  MessageEntity.h
//  Health
//
//  Created by cheng on 15/2/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageEntity : NSObject

@property (nonatomic,strong) NSString *userid;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *userPortrait;
@property (nonatomic,strong) NSString *trendid;
@property (nonatomic,strong) NSString *courseid;
@property (nonatomic,strong) NSString *courseTitle;
@property (nonatomic,strong) NSString *replyPhoto;

@end

@interface MessageReplyEntity : MessageEntity

@property (nonatomic,strong) NSString *replyType;
@property (nonatomic, strong) NSString *replyTrendType;
@property (nonatomic,strong) NSString *replyContent;
@property (nonatomic,strong) NSString *replyTime;
@property (nonatomic,strong) NSString *replyid;
@property (nonatomic,strong) NSString *replyTitle;

@end

@interface MessageFavoriteEntity : MessageEntity

@property (nonatomic,strong) NSString *favoriteType;
@property (nonatomic, strong) NSString *favoriteTrendsType;
@property (nonatomic,strong) NSString *favoriteTime;
@property (nonatomic,strong) NSString *favoriteid;

@end