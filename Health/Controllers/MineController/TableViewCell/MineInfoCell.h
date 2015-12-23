//
//  MineInfoCell.h
//  Health
//
//  Created by 王杰 on 15/1/31.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineInfoCellDelegate <NSObject>

@optional

- (void)pushTOMyFun;
- (void)pushtoMyFocus;
- (void)pushtoMyDetailInfo;

@end

@interface MineInfoCell : UITableViewCell

@property (nonatomic,weak) id<MineInfoCellDelegate>delegate;

@property (nonatomic,strong) UIImageView *imageviewPortrait;
@property (nonatomic,strong) UIButton *focusNum;
@property (nonatomic,strong) UIButton *fansNum;
@property (nonatomic,strong) UIImageView *sex;
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UIImageView *line;
@property (nonatomic,strong) UIView *blackView;
@property (nonatomic,strong) UIButton *focus;
@property (nonatomic,strong) UIButton *message;
@property (nonatomic,strong) UIImageView *background;
@property (nonatomic,strong) UIImageView *coarch;
@property (nonatomic,strong) UIView *clearview;
@property (nonatomic,strong) UILabel *teachcondtion;
@property (nonatomic,strong) UILabel *goodAT;
@property (nonatomic,strong) UILabel *skillLabel;

- (void) fansBtn:(UIButton*)sender;
- (void) focusBtn:(UIButton*)sender;
- (void) addFocusBtn:(UIButton*)sender;
- (void) writeMessage:(UIButton*)sender;
- (void) clickportrait:(UIImageView *)tap;
@end
