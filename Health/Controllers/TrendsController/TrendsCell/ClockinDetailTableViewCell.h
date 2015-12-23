//
//  ClockinDetailTableViewCell.h
//  Health
//
//  Created by realtech on 15/5/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ClockinDetailCellDelegate <NSObject>
@optional
- (void)clickHead;
- (void)clickNickname;
- (void)clickDelete;
- (void)clickReport;
- (void)clickComment:(NSString*)usernickname;
- (void)clickLike;
- (void)clickLikeMember;
- (void)clickCourse;
@end

@interface ClockinDetailTableViewCell : UITableViewCell{
    UserInfo *userInfo;
    NSArray *courseArray;
    NSInteger likeNumber;
    BOOL isLiked;
}

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *reportButton;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UIButton *courseLabel;
@property (nonatomic, strong) UILabel *clockinDaysLabel;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UILabel *commentNumberLabel;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UILabel *likeNumberLabel;
@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UIImageView *privateView;
@property (nonatomic, strong) UILabel *sportsLabel;
@property (nonatomic, strong) UILabel *sportsEnergyLabel;
@property (nonatomic, strong) UILabel *foodLabel;
@property (nonatomic, strong) UILabel *foodEnergyLabel;
@property (nonatomic, strong) UILabel *weightLabel;
@property (nonatomic, strong) UIButton *likeMemberButton;
@property (nonatomic, strong) UILabel *likeMemberLabel;
@property (nonatomic, strong) UIImageView *likeImage;

@property (nonatomic, assign) NSInteger height;

@property (nonatomic, strong) NSDictionary *clockinDic;

@property (nonatomic, strong) id<ClockinDetailCellDelegate>delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDic:(NSDictionary*)dic;

@end
