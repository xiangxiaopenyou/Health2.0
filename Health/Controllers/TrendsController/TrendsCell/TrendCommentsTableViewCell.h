//
//  TrendCommentsTableViewCell.h
//  Health
//
//  Created by 项小盆友 on 15/1/27.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TrendCommentsCellDelegate <NSObject>
@optional
- (void)clickCommentHead:(NSString*)userid;
- (void)clickReplyNickname:(NSString*)userid;
@end

@interface TrendCommentsTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, strong) UIButton *replyNicknameButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;



@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, assign) int height;

@property (nonatomic, strong) id<TrendCommentsCellDelegate>delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(NSDictionary*)dic;

@end
