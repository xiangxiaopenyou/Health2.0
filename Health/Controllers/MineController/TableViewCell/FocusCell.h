//
//  FocusCell.h
//  Health
//
//  Created by 王杰 on 15/2/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FocusCellDelegate <NSObject>

@optional

- (void)focusCreate:(NSString *)fansid;
- (void)focusDele:(NSString *)fansid;

@end

@interface FocusCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imagePortrait;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *imageSex;
@property (nonatomic,strong) UILabel *ageLabel;
@property (nonatomic,strong) UIButton *btnFocus;
@property (nonatomic,strong) NSString *fansid;

@property (nonatomic,strong) id<FocusCellDelegate>delegate;

- (void) setFocus: (UIButton *)sender;

@property (nonatomic, assign) Boolean isFocused;

@end
