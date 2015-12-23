//
//  ClockinTableViewCell.h
//  Health
//
//  Created by realtech on 15/4/24.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClockinCellDelete <NSObject>
@optional
- (void)clickPicture:(NSString*)pictureString withTag:(NSString*)tagString;
- (void)clickClockinUserHead:(NSString*)userid;
- (void)clickClockinUserNickname:(NSString*)userid;
- (void)clickClockinDelete:(NSString*)trendid;
- (void)clickClockinComment:(NSString*)trendid;
- (void)clickClockinReport:(NSString*)trendid;
- (void)clickClockinCourse:(NSString*)courseid withTitle:(NSString *)title;
@end

@interface ClockinTableViewCell : UITableViewCell{
    UserInfo *userInfo;
    NSArray *courseArray;
    NSInteger likeNmuber;
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
@property (nonatomic, strong) UIImageView *likeImage;
@property (nonatomic, strong) UILabel *likeNumberLabel;
@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UIImageView *privateView;
@property (nonatomic, strong) UILabel *sportsLabel;
@property (nonatomic, strong) UILabel *sportsEnergyLabel;
@property (nonatomic, strong) UILabel *foodLabel;
@property (nonatomic, strong) UILabel *foodEnergyLabel;
@property (nonatomic, strong) UILabel *weightLabel;

@property (nonatomic, assign) NSInteger height;

@property (nonatomic, strong) NSDictionary *clockinDic;

@property (nonatomic, strong) id<ClockinCellDelete>delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDic:(NSDictionary*)dic;

@end
