//
//  TrendDetailTableViewCell.h
//  Health
//
//  Created by 项小盆友 on 15/1/27.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXActivity.h"
@protocol TrendDetailTableViewCellDelegate<NSObject>
@optional
- (void)clickHead;
- (void)clickNickname;
- (void)clickDelete;
- (void)clickReport;
- (void)clickComment:(NSString*)usernickname;
- (void)clickLike;
- (void)clickShare;
- (void)clickLikeMember;
@end

@interface TrendDetailTableViewCell : UITableViewCell<LXActivityDelegate>{
    UserInfo *userInfo;
    
    BOOL isLiked;
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
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIImageView *likeImage;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UILabel *likeNumber;
@property (nonatomic, strong) UIButton *likeMemberButton;

@property (nonatomic, strong) NSDictionary *dictionary;

@property (nonatomic, assign) int iHeight;

@property (nonatomic, strong) id<TrendDetailTableViewCellDelegate>delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(NSDictionary*)dic;

@end
