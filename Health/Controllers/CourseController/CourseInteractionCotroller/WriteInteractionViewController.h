//
//  WriteInteractionViewController.h
//  Health
//
//  Created by 项小盆友 on 15/1/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteInteractionViewController : UIViewController

@property (nonatomic, strong)UITextField *titleTextField;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIImageView *trendImage;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) Course *course;
@property (nonatomic, strong) CourseSub *courseSub;
@property (nonatomic, strong) NSNumber *coursesubDay;
@property (nonatomic, strong) NSString *courseUserType;
@property (nonatomic, strong) NSString *discutionType;

@end
