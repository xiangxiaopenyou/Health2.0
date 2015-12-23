//
//  CourseApplySuccessController.m
//  Health
//
//  Created by cheng on 15/3/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseApplySuccessController.h"

@interface CourseApplySuccessController ()

@end

@implementation CourseApplySuccessController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.course != nil) {
        self.courseTitleLabel.text = self.course.coursetitle;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gobackMineCourse:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
