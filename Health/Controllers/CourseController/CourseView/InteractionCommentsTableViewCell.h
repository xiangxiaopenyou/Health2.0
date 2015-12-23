//
//  InteractionCommentsTableViewCell.h
//  Health
//
//  Created by 项小盆友 on 15/1/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InteractionCommentsTableViewCellDelegate<NSObject>
@optional
- (void)clickCommentHead:(NSString*)userid;
- (void)clickReplyNickname:(NSString*)userid;
@end

@interface InteractionCommentsTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, strong) UIButton *replyNicknameButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, assign) int height;
@property (nonatomic, strong) id<InteractionCommentsTableViewCellDelegate>delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(NSDictionary*)dic;

@end
