//
//  GroupChatViewController.m
//  Health
//
//  Created by realtech on 15/4/20.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "GroupChatViewController.h"
#import "MessagePictureViewController.h"
#import "CourseMessageSettingViewController.h"

@interface GroupChatViewController (){
    AppDelegate *appDelegate;
}

@end

@implementation GroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //appDelegate.rootNavigationController.navigationBar.backgroundColor = [UIColor blackColor];
    [appDelegate.rootNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"] forBarMetrics:UIBarMetricsDefault];
    appDelegate.rootNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    //appDelegate.rootNavigationController.interactivePopGestureRecognizer.enabled = NO;
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] init];
    leftButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = leftButtonItem;
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    //    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"拉黑" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonItemPressed:)];
    //    [rightButton setTintColor:[UIColor whiteColor]];
    //    self.navigationItem.rightBarButtonItem = rightButton;
    
    //    //自定义导航左右按钮
    //    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(leftBarButtonItemPressed:)];
    //    [leftButton setTintColor:[UIColor whiteColor]];
    //    self.navigationItem.leftBarButtonItem = leftButton;
    
    //    if (!self.enableSettings) {
    //        self.navigationItem.rightBarButtonItem = nil;
    //    }else{
    //自定义导航左右按钮
    self.enablePOI = NO;
}
- (void)viewDidDisappear:(BOOL)animated {
    appDelegate.rootNavigationController.navigationBarHidden = YES;
}
- (void)viewDidAppear:(BOOL)animated{
    appDelegate.rootNavigationController.navigationBarHidden = NO;
}



-(void)leftBarButtonItemPressed:(id)sender
{
    [super leftBarButtonItemPressed:sender];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHAT object:@YES];
    appDelegate.rootNavigationController.navigationBarHidden = YES;
}

-(void)rightBarButtonItemPressed:(id)sender{
    //[super rightBarButtonItemPressed:sender];
    appDelegate.rootNavigationController.navigationBarHidden = YES;
    CourseMessageSettingViewController *controller = [[CourseMessageSettingViewController alloc] init];
    controller.isMessage = YES;
    controller.courseid = self.currentTarget;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)showPreviewPictureController:(RCMessage*)rcMessage{
    MessagePictureViewController *temp=[[MessagePictureViewController alloc]init];
    temp.rcMessage = rcMessage;
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:temp];
    
    //导航和原有的配色保持一直
    UIImage *image= [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    
    [nav.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
