//
//  ClubDiscussionDetailView.h
//  Health
//
//  Created by realtech on 15/6/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"
@protocol ClubDiscussionDetailViewDelegate<NSObject>
@optional
- (void)clickComment;
- (void)clickDetailHead:(NSString*)userid;
- (void)clickDetailNickname:(NSString*)userid;
- (void)clickLink:(NSString*)linkString;
@end

@interface ClubDiscussionDetailView : UIView<MLEmojiLabelDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UIButton *nicknameButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) MLEmojiLabel *contentLabel;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, assign) int iHeight;

@property (nonatomic, strong) id<ClubDiscussionDetailViewDelegate>delegate;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
