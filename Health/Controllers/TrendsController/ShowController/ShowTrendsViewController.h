//
//  ShowTrendsViewController.h
//  Health
//
//  Created by 项小盆友 on 15/1/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowTrendsViewController : UIViewController

@property (nonatomic, strong) UIImageView *trendImage;
@property (nonatomic, strong) UITextView *trendContent;
@property (nonatomic, strong) UIButton *privateButton;
@property (nonatomic, strong) UIButton *positionButton;
@property (nonatomic, strong) UIImageView *positionImage;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UIImageView *addLabelImageView;
@property (nonatomic, strong) UIButton *addLabelButton;
@property (nonatomic, strong) UILabel *addTipLabel;

@property (nonatomic, assign) BOOL isCourseTrend;
@property (nonatomic, strong) NSString *courseid;

@end
