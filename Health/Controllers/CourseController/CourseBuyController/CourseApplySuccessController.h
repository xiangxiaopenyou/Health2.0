//
//  CourseApplySuccessController.h
//  Health
//
//  Created by cheng on 15/3/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseApplySuccessController : UIViewController

@property (nonatomic,strong) Course *course;

@property (nonatomic,strong) IBOutlet UILabel *courseTitleLabel;

- (IBAction)gobackMineCourse:(id)sender;

@end
