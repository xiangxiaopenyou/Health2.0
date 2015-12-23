//
//  CourseActionItemViewController.m
//  Health
//
//  Created by cheng on 15/3/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseActionItemViewController.h"
#import "VideoView.h"
#import "RTCountView.h"
#import "ActionItemView.h"
#import "CourseRequest.h"
#import "CourseInteractionViewController.h"
#import "ActitionDoneViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#define URL_TEST @"http://7u2h8u.com1.z0.glb.clouddn.com/colgate[*啦].mp4"
#define RIGHTVIEW_Y 64
#define RIGHTVIEW_WIDTH 250

@interface CourseActionItemViewController ()<VideoViewDelegate,RTCountViewDelegate>{
    ActionItemView *rightView;
    NSInteger currentIndex;
    UIButton *helpButton;
    MPMoviePlayerViewController *playerViewController;
}

@property (nonatomic,strong) VideoView *videoView;
@property (nonatomic,strong) RTCountView *timerView;

@end

@implementation CourseActionItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] init];
    //leftButtonItem.title = @"";
    //self.navigationItem.backBarButtonItem = leftButtonItem;
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"course_action_menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButton:)];
    
    
    //self.view.backgroundColor = [UIColor colorWithRed:31/255.0 green:31/255.0 blue:20/255.0 alpha:1.0];
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:[NSString stringWithFormat:@"第%d天",[self.actionOfDay intValue]]];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(SCREEN_WIDTH - 40, 27, 30, 30);
    [menuButton setImage:[UIImage imageNamed:@"course_action_menu.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(SCREEN_WIDTH/2 - 87, SCREEN_HEIGHT - 74, 174, 40);
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setTitleColor:TABLEVIEW_BACKGROUNDCOLOR forState:UIControlStateNormal];
    [finishButton setBackgroundColor:MAIN_COLOR_YELLOW];
    finishButton.layer.masksToBounds = YES;
    finishButton.layer.cornerRadius = 6;
    [finishButton addTarget:self action:@selector(clickFinish:) forControlEvents:UIControlEventTouchUpInside];
    finishButton.titleLabel.font = [UIFont systemFontOfSize:19];
    [self.view addSubview:finishButton];
    
    
//    NSString *placeUrl;
//    if (self.courseSubArray.count == 0 || self.courseSubArray == nil ) {
//        placeUrl = URL_TEST;
//    }else{
//        CourseSub *courseSubTemp = [self.courseSubArray objectAtIndex:0];
//        placeUrl = [Util urlForVideo:courseSubTemp.coursesubcontent];
//    }
    self.videoView = [[VideoView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH*9/16) Url:URL_TEST];
    [self.videoView initVideoUrl:URL_TEST];
    self.videoView.delegate = self;
    
    self.timerView = [[RTCountView alloc]initWithFrame:CGRectMake(0, self.videoView.frame.size.height + self.videoView.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - self.videoView.frame.size.height - self.videoView.frame.origin.y - 124) time:10*1000*2];
    self.timerView.delegate = self;
    [self.view addSubview:self.timerView];
    [self.view addSubview:self.videoView];
    
//    helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    helpButton.frame = CGRectMake(SCREEN_WIDTH-8-32, 8, 32, 32);
//    [helpButton setBackgroundImage:[UIImage imageNamed:@"course_action_help.png"] forState:UIControlStateNormal];
//    [helpButton addTarget:self action:@selector(helpClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.timerView addSubview:helpButton];
    
    //self.view.backgroundColor = [UIColor blackColor];
    
    NSInteger index = [CustomDate getDayToDate:[CustomDate getBirthdayDate:self.course.coursestarttime]]+1;
    
    rightView = [[ActionItemView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, RIGHTVIEW_Y, RIGHTVIEW_WIDTH, SCREEN_HEIGHT-RIGHTVIEW_Y) CourseSub:self.courseSubArray];
    if (self.actionOfDay.integerValue>index) {
        rightView.isStart = NO;
    }else{
        rightView.isStart = YES;
    }
    
    [rightView selectActionItem:^(NSString *itemid) {
        if ([itemid intValue] != 0) {
            CourseSub *courseSelectFront = [self.courseSubArray objectAtIndex:[itemid intValue]-1];
            if ([courseSelectFront.coursesubflag intValue] == 1) {
                
                [self changeAction:[itemid intValue]];
                [self setupRightView];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"选择项目" message:@"必须按顺序进行课程" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
        }else{
            [self changeAction:[itemid intValue]];
            [self setupRightView];
        }
    }];
    [self.view addSubview:rightView];
    
    if (self.courseSubArray.count == 0 || self.courseSubArray == nil ) {
        
    }else{
        [self changeAction:0];
    }
    
    
}
- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)helpClick{
    NSLog(@"123");
    CourseSub *courseSub = [self.courseSubArray objectAtIndex:currentIndex];
    CourseInteractionViewController *interactionController = [[CourseInteractionViewController alloc] init];
    interactionController.courseSub = courseSub;
    interactionController.courseSubDay = self.actionOfDay;
    interactionController.course = self.course;
    [self.navigationController pushViewController:interactionController animated:YES];
}

- (void)clickRightButton:(id)sender{
    [self setupRightView];
}

- (void)setupRightView{
    if (!rightView.isShow) {
        rightView.isShow = YES;
        [UIView animateWithDuration:0.3 animations:^{
            rightView.frame = CGRectMake(SCREEN_WIDTH-RIGHTVIEW_WIDTH, RIGHTVIEW_Y, RIGHTVIEW_WIDTH, SCREEN_HEIGHT-RIGHTVIEW_Y);
        }];
    }else if (rightView.isShow) {
        rightView.isShow = NO;
        [UIView animateWithDuration:0.3 animations:^{
            rightView.frame = CGRectMake(SCREEN_WIDTH, RIGHTVIEW_Y, RIGHTVIEW_WIDTH, SCREEN_HEIGHT-RIGHTVIEW_Y);
        }];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (rightView.isShow) {
        rightView.isShow = NO;
        [UIView animateWithDuration:0.3 animations:^{
            rightView.frame = CGRectMake(SCREEN_WIDTH, RIGHTVIEW_Y, RIGHTVIEW_WIDTH, SCREEN_HEIGHT-RIGHTVIEW_Y);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    //dealloc的时候必须对计时器进行释放
    [self.timerView stop];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.timerView stop];
    [self.videoView stopVideo];
}

- (void)clickFullScreen:(NSString*)url{
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
//    self.navigationController.navigationBarHidden = YES;
//    
//    self.videoView.transform = CGAffineTransformMakeRotation(M_PI/2);
//    [UIView animateWithDuration:0.2 animations:^{
//        rightView.hidden = YES;
//        self.videoView.frame = CGRectMake(0, 0, 568 , 320);
//        self.videoView.backgroundColor = [UIColor redColor];
//    }];
    [self.videoView stopVideo];
    playerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:[Util urlForVideo:url]]];
    MPMoviePlayerController*player=[playerViewController moviePlayer];
//    player.scalingMode=MPMovieScalingModeFill;
    [player play];
    [self.navigationController presentViewController:playerViewController animated:YES completion:nil];
}

- (void)changeAction:(NSInteger)index{
    currentIndex = index;
    CourseSub *courseSubTemp = [self.courseSubArray objectAtIndex:index];
    [self.videoView initVideoUrl:courseSubTemp.coursesubcontent];
    self.videoView.contentLabel.text = courseSubTemp.coursesubtitle;
    self.videoView.videoLabel.text = courseSubTemp.coursesubintrduce;
    
    [self.timerView stop];
    [self.timerView removeFromSuperview];
    self.timerView = [[RTCountView alloc]initWithFrame:CGRectMake(0, self.videoView.frame.size.height + self.videoView.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - self.videoView.frame.size.height - self.videoView.frame.origin.y - 124) time:[courseSubTemp.coursesubtime intValue]*1000];
    //    [self.view addSubview:self.timerView];
    [self.timerView addSubview:helpButton];
    [self.view insertSubview:self.timerView belowSubview:rightView];
}

#pragma mark - Navigation

- (void)timerDidEnd{
    if ([self.course.coursehastake intValue] == 1) {
        [self finishCourseSub];
    }
    [self setupNextAction];
}

- (void)clickFinish:(id)sender{
    
    if ([self.course.coursehastake intValue] == 1) {
        [self finishCourseSub];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"完成课程" message:@"您没有报名参加此课程" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
//        return;
    }
    [self setupNextAction];
}

- (void)finishCourseSub{
    
    CourseSub *courseSub = [self.courseSubArray objectAtIndex:currentIndex];
    courseSub.coursesubflag = @"1";
    //按顺序进行，进行的天数<=当前页面所在天数  子课程的上一个子课程必须已完成
    //网络请求
    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
    
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken",self.course.courseid,@"courseid",courseSub.coursesubid,@"coursesubid", nil];
    
    [CourseRequest finishCourseSubWith:parameter success:^(id response) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)setupNextAction{
    [rightView reloadTable];
    currentIndex = currentIndex+1;
    
    if (currentIndex>=self.courseSubArray.count) {
        if ([self.course.coursehastake intValue] == 1) {
            currentIndex = currentIndex - 1;
            ActitionDoneViewController *actionDone = [[ActitionDoneViewController alloc]init];
            actionDone.course = self.course;
            actionDone.courseSubArray = self.courseSubArray;
            actionDone.actionOfDay = self.actionOfDay;
            //        [self.navigationController pushViewController:actionDone animated:YES];
            [self presentViewController:actionDone animated:YES completion:^{
            }];
        } else {
        }
        return;
    }
    [self changeAction:currentIndex];
}

@end
