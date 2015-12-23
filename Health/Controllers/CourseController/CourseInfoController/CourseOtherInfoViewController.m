//
//  CourseOtherInfoViewController.m
//  Health
//
//  Created by cheng on 15/3/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseOtherInfoViewController.h"

@interface CourseOtherInfoViewController ()

@end

@implementation CourseOtherInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = self.course.coursetitle;
    self.contentLabel.text = self.course.courseintrduce;
    self.fatImage.image = [Util levelImage:self.course.coursefat];
    self.shapingImage.image = [Util levelImage:self.course.courseshaping];
    self.strengthImage.image = [Util levelImage:self.course.coursestrength];
    self.powerImage.image = [Util levelImage:self.course.coursepowerdifficulty];
    self.difficultyImage.image = [Util levelImage:self.course.coursedifficultty];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissController:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
