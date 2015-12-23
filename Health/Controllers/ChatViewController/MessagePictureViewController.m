//
//  MessagePictureViewController.m
//  Health
//
//  Created by xlp on 15/6/16.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MessagePictureViewController.h"

@interface MessagePictureViewController ()

@end

@implementation MessagePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftBarButtonItemPressed:(id)sender{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.rootNavigationController setNavigationBarHidden:NO];
    [super leftBarButtonItemPressed:sender];
}
- (void)rightBarButtonItemPressed:(id)sender{
    [super rightBarButtonItemPressed:sender];
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
