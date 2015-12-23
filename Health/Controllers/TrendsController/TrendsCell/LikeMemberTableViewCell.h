//
//  LikeMemberTableViewCell.h
//  Health
//
//  Created by 项小盆友 on 15/1/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LikeMemberTableViewCellDelegate<NSObject>
@optional
- (void)clickAttention;
- (void)clickHead:(NSString*)userid;
@end

@interface LikeMemberTableViewCell : UITableViewCell{
    UserInfo *userInfo;
    NSInteger friendship;
}

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UIImageView *sexImage;
@property (nonatomic, strong) UIButton *attentionButton;
@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) id<LikeMemberTableViewCellDelegate>delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(NSDictionary*)dic;

@end
