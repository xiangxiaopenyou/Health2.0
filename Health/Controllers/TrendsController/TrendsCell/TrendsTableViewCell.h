//
//  TrendsTableViewCell.h
//  Health
//
//  Created by 项小盆友 on 15/1/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXActivity.h"
@protocol TrendsTableViewCellDelegate<NSObject>
@optional
- (void)clickCommentsList:(NSString*)trendid;
- (void)clickHead:(NSString*)userid;
- (void)clickNickname:(NSString*)userid;
- (void)clickDelete:(NSString*)trendid;
- (void)clickcomment:(NSString*)trendid;
- (void)clickLike:(NSString*)trendid;
- (void)clickShare:(NSString*)trendid;
- (void)clickLikeMember:(NSString*)trendid;
- (void)clickReport:(NSString*)trendid;

@end

@interface TrendsTableViewCell : UITableViewCell<LXActivityDelegate>{
    UserInfo *userinfo;
    BOOL isShowTag;
}

@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UIButton *nicknameButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UIImageView *privateView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *reportButton;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UILabel *likeLabel;
@property (nonatomic, strong) UIImageView *likeImage;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UILabel *likeNumber;
@property (nonatomic, strong) UIButton *likeMemberButton;
@property (nonatomic, strong) UIButton *readCommentsButton;
@property (nonatomic, strong) Trend *singleTrend;

@property (nonatomic, assign) int iHeight;

@property (nonatomic, strong) id<TrendsTableViewCellDelegate>delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(Trend*)trend;

@end
