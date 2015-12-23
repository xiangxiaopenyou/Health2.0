//
//  CourseGroupChatViewController.m
//  Health
//
//  Created by realtech on 15/6/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseGroupChatViewController.h"
#import "CourseFunctionViewController.h"
#import "CourseInfomationViewController.h"
#import "CourseClockinListViewController.h"

@interface CourseGroupChatViewController (){
    AppDelegate *appDelegate;
}

@end

@implementation CourseGroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMessageSuccess) name:@"clearmessage" object:nil];
    
    UIImageView *settingImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.navigationItem.titleView.frame.size.width/2 + 30, self.navigationItem.titleView.frame.size.height - 10, 12, 7)];
    settingImage.image = [UIImage imageNamed:@"course_message"];
    [self.navigationItem.titleView addSubview:settingImage];
    
    self.navigationItem.titleView.userInteractionEnabled = YES;
    [self.navigationItem.titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleViewPress)]];
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"学员打卡" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonItemPressed:)];
    [rightButton setTintColor:MAIN_COLOR_YELLOW];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIButton *courseDetailsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    courseDetailsButton.frame = CGRectMake(SCREEN_WIDTH - 80, 5, 70, 30);
    [courseDetailsButton setImage:[UIImage imageNamed:@"course_details"] forState:UIControlStateNormal];
    [courseDetailsButton addTarget:self action:@selector(detailClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:courseDetailsButton];
    
    if (self.course == nil) {
        [self getCourseData];
    }
    
}
- (void)viewDidDisappear:(BOOL)animated {
    appDelegate.rootNavigationController.navigationBarHidden = YES;
}
- (void)viewDidAppear:(BOOL)animated{
    appDelegate.rootNavigationController.navigationBarHidden = NO;
}

- (void)detailClick{
    if (self.course != nil) {
        CourseFunctionViewController *courseController = [[CourseFunctionViewController alloc] init];
        courseController.course = self.course;
        courseController.isChatIn = YES;
        appDelegate.rootNavigationController.navigationBarHidden = YES;
        [appDelegate.rootNavigationController pushViewController:courseController animated:YES];
    }
   
}
- (void)titleViewPress{
    if (self.course != nil) {
        CourseInfomationViewController *controller = [[CourseInfomationViewController alloc] init];
        controller.course_info = self.course;
        [self.navigationController pushViewController:controller animated:YES];
        appDelegate.rootNavigationController.navigationBarHidden = YES;
    }
}

- (void)clearMessageSuccess{
    [self viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)leftBarButtonItemPressed:(id)sender
{
    [super leftBarButtonItemPressed:sender];
    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHAT object:@YES];
    appDelegate.rootNavigationController.navigationBarHidden = YES;
}
- (void)rightBarButtonItemPressed:(id)sender{
    CourseClockinListViewController *controller = [[CourseClockinListViewController alloc] init];
    controller.courseid = self.course.courseid;
    [self.navigationController pushViewController:controller animated:YES];
    appDelegate.rootNavigationController.navigationBarHidden = YES;
}

- (void)getCourseData{
    self.course = [Course MR_findFirstByAttribute:@"courseid" withValue:self.courseid];
    if (self.course == nil) {
        self.course = [Course MR_createEntity];
        self.course.courseid = self.courseid;
    }
    [CourseRequest courseDetailMineWith:self.course success:^(id response) {
        //[self receiveMessage];
    } failure:^(NSError *error) {
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
