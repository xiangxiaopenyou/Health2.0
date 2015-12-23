//
//  PersonFansCell.h
//  Health
//
//  Created by cheng on 15/3/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickAttention)(NSInteger);

@interface PersonFansCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imagePortrait;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *imageSex;
@property (nonatomic,strong) UILabel *ageLabel;
@property (nonatomic,strong) UIButton *btnFocus;
@property (nonatomic,strong) NSString *fansid;

@property (nonatomic,strong) ClickAttention click;

- (void)clickAttention:(ClickAttention)clickItem;

@end
