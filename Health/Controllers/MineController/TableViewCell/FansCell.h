//
//  FansCell.h
//  Health
//
//  Created by 王杰 on 15/1/31.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FansCellDelegate <NSObject>

@optional

- (void)fanCreate:(NSString *)fansid;
- (void)fanDele:(NSString *)fansid;

@end

@interface FansCell : UITableViewCell

@property (nonatomic,weak) id<FansCellDelegate>delegate;

@property (nonatomic,strong) UIImageView *imagePortrait;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *imageSex;
@property (nonatomic,strong) UILabel *ageLabel;
@property (nonatomic,strong) UIButton *btnFocus;
@property (nonatomic,strong) NSString *fansid;
@property (nonatomic, assign) Boolean isFocused;

- (void) setFocus: (UIButton *)sender;



@end
