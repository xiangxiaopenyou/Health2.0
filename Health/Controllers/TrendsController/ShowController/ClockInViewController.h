//
//  ClockInViewController.h
//  Health
//
//  Created by realtech on 15/4/15.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClockInViewController : UIViewController{
}
@property (nonatomic, strong) UILabel *clockinTimeLabel;
@property (nonatomic, strong) UILabel *clockinWeightLabel;
@property (nonatomic, strong) UILabel *sportsEnergyLabel;
@property (nonatomic, strong) UILabel *foodEnergyLabel;

@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UIButton *positionButton;
@property (nonatomic, strong) UIButton *privateButton;

@property (nonatomic, strong) UIImageView *addLabelImageView;
@property (nonatomic, strong) UIButton *addLabelButton;
@property (nonatomic, strong) UILabel *addTipLabel;

@end
