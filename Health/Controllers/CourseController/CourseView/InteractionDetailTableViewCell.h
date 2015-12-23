//
//  InteractionDetailTableViewCell.h
//  Health
//
//  Created by 项小盆友 on 15/1/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"
@protocol InteractionDetailTableViewCellDelegate<NSObject>
@optional
- (void)clickComment;
- (void)clickDetailHead;
- (void)clickDetailNickname;
- (void)clickLink:(NSString*)linkString;
@end

@interface InteractionDetailTableViewCell : UITableViewCell<MLEmojiLabelDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UIButton *nicknameButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) MLEmojiLabel *contentLabel;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) id<InteractionDetailTableViewCellDelegate>delegate;

@property (nonatomic, strong) NSDictionary *dictionary;

@property (nonatomic, assign) int iHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(NSDictionary*)dic;

@end
