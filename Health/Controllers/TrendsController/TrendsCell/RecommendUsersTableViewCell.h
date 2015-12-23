//
//  RecommendUsersTableViewCell.h
//  Health
//
//  Created by realtech on 15/5/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickPhoto)(NSInteger index);

@interface RecommendUsersTableViewCell : UITableViewCell{
    NSInteger friendship;
}

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UIImageView *centerImage;
@property (nonatomic, strong) UIImageView *rightImage;
@property (nonatomic, strong) UIButton *attentionButton;
@property (nonatomic, strong) NSDictionary *dictionary;

@property (nonatomic, strong) ClickPhoto clickItem;
- (void)clickImage:(ClickPhoto)click;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDic:(NSDictionary*)dic;

@end
