//
//  CourseDetailsViewController.m
//  Health
//
//  Created by realtech on 15/4/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseDetailsViewController.h"
#import "CourseDetailHeaderView.h"
#import "CourseIntroductionCell.h"
#import "CoachIntroductionTableViewCell.h"
#import "CoachAppraiseTableViewCell.h"
#import "AppraiseListTableViewCell.h"
#import "CourseBuyViewController.h"
#import "ChatViewController.h"

@interface CourseDetailsViewController (){
    CourseIntroductionCell *courseIntroductionCell;
    CoachIntroductionTableViewCell *coachIntroductionCell;
    CoachAppraiseTableViewCell *coachAppraiseCell;
    AppraiseListTableViewCell *appraiseCell;
    
    UIButton *applyButton;
}

@end

@implementation CourseDetailsViewController
@synthesize course;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"课程详情"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    if (self.course == nil) {
        [self getCourseData];
    }
    
    detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    detailTableView.showsVerticalScrollIndicator = NO;
    detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    detailTableView.backgroundColor = CLEAR_COLOR;
    [self.view addSubview:detailTableView];
    [self setupHeaderView];
    
}

- (void)getCourseData{
    self.course = [Course MR_findFirstByAttribute:@"courseid" withValue:self.courseid];
    if (self.course == nil) {
        self.course = [Course MR_createEntity];
        self.course.courseid = self.courseid;
    }
    [CourseRequest courseDetailMineWith:self.course success:^(id response) {
        //[self receiveMessage];
        [self setupHeaderView];
        [detailTableView reloadData];
    } failure:^(NSError *error) {
    }];
}
- (void)setupHeaderView{
    
    UIButton *questionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    questionButton.frame = CGRectMake(SCREEN_WIDTH - 80, 22, 70, 40);
    [questionButton setTitle:@"疑问咨询" forState:UIControlStateNormal];
    [questionButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    questionButton.titleLabel.font = SMALLFONT_14;
    [questionButton addTarget:self action:@selector(questionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:questionButton];
    
    CourseDetailHeaderView *headerView = [[CourseDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 3*SCREEN_WIDTH/4) withData:self.course];
    headerView.backgroundColor = CLEAR_COLOR;
    detailTableView.tableHeaderView = headerView;
    
    applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    applyButton.frame = CGRectMake(SCREEN_WIDTH/2 - 120, SCREEN_WIDTH/4 * 3 - 56, 240, 40);
    applyButton.backgroundColor = MAIN_COLOR_YELLOW;
    //[applyButton setTitle:@"立即申请" forState:UIControlStateNormal];
    [applyButton setTitleColor:TABLEVIEW_BACKGROUNDCOLOR forState:UIControlStateNormal];
    applyButton.titleLabel.font = SMALLFONT_16;
    applyButton.layer.masksToBounds = YES;
    applyButton.layer.cornerRadius = 2;
    [applyButton addTarget:self action:@selector(applyClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:applyButton];
    
    if ([self.course.coursesign integerValue] == 3) {
        [applyButton setTitle:@"立即申请" forState:UIControlStateNormal];
    }
    else {
        [applyButton setTitle:@"请等待审核..." forState:UIControlStateNormal];
        applyButton.userInteractionEnabled = NO;
    }
}

- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)questionButtonClick{
    ChatViewController *controller = [[ChatViewController alloc] init];
    controller.portraitStyle = RCUserAvatarCycle;
    controller.currentTarget = self.course.teacher.friendid;
    controller.currentTargetName = self.course.teacher.friendname;
    controller.conversationType = ConversationType_PRIVATE;
    [self.navigationController pushViewController:controller animated:YES];
    self.navigationController.navigationBarHidden = NO;
}
- (void)applyClick{
    FriendInfo *teacher = self.course.teacher;
    UserData *userData = [UserData shared];
    UserInfo *userInfo = userData.userInfo;
    if ([userInfo.userid integerValue] == [teacher.friendid integerValue]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"这是你自己的训练营哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    CourseBuyViewController *controller = [[CourseBuyViewController alloc] init];
    controller.course = self.course;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    courseIntroductionCell = (CourseIntroductionCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    coachIntroductionCell = (CoachIntroductionTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    coachAppraiseCell = (CoachAppraiseTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if ([Util isEmpty:self.course.coursedetailimgage]) {
            return 28 + courseIntroductionCell.introLabel.frame.size.height;
        }
        else {
            return 110 + courseIntroductionCell.introLabel.frame.size.height;
        }
    }
    else if (indexPath.section == 1){
        return 88 + coachIntroductionCell.introLabel.frame.size.height;
    }
    else {
//        if (indexPath.row == 0) {
            return 80;
//        }
//        else {
//            return 100;
//        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CourseIntro = @"CourseIntroduction";
    static NSString *CoachIntro = @"CoachIntroduction";
    static NSString *CoachAppraise = @"Coachappraise";
    //static NSString *AppraiseCell = @"AppraiseCell";
    switch (indexPath.section) {
        case 0:{
            courseIntroductionCell = [tableView dequeueReusableCellWithIdentifier:CourseIntro];
            if (courseIntroductionCell == nil) {
                courseIntroductionCell = [[CourseIntroductionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CourseIntro withIntro:self.course.courseintrduce withIntroImage:self.course.coursedetailimgage];
            }
            courseIntroductionCell.backgroundColor = CLEAR_COLOR;
            courseIntroductionCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return courseIntroductionCell;
        }
            
            break;
        case 1:{
            FriendInfo *friendInfo = self.course.teacher;
            coachIntroductionCell = [tableView dequeueReusableCellWithIdentifier:CoachIntro];
            if (coachIntroductionCell == nil) {
                coachIntroductionCell = [[CoachIntroductionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CoachIntro withCourse:friendInfo];
            }
            coachIntroductionCell.backgroundColor = CLEAR_COLOR;
            coachIntroductionCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [coachIntroductionCell clickBlockCoach:^{
                [self jumpPersonController:friendInfo.friendid];
            }];
            return coachIntroductionCell;
        }
            break;
        case 2:{
//            if (indexPath.row == 0) {
                FriendInfo *friendInfo = self.course.teacher;
                coachAppraiseCell = [tableView dequeueReusableCellWithIdentifier:CoachAppraise];
                if (coachAppraiseCell == nil) {
                    coachAppraiseCell = [[CoachAppraiseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CoachAppraise];
                }
                coachAppraiseCell.scoreImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"appraise_%@", friendInfo.friendoverallappraisal]];
                coachAppraiseCell.attitudeScoreLabel.text = [NSString stringWithFormat:@"%@分", friendInfo.friendattitudescore];
                coachAppraiseCell.skillScoreLabel.text = [NSString stringWithFormat:@"%@分", friendInfo.friendskillscore];
                coachAppraiseCell.backgroundColor = CLEAR_COLOR;
                coachAppraiseCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return coachAppraiseCell;
//            }
//            else {
//                appraiseCell = [tableView dequeueReusableCellWithIdentifier:AppraiseCell];
//                if (appraiseCell == nil) {
//                    appraiseCell = [[AppraiseListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AppraiseCell];
//                }
//                appraiseCell.backgroundColor = TABLEVIEWCELL_COLOR;
//                appraiseCell.selectionStyle = UITableViewCellSelectionStyleNone;
//                return appraiseCell;
//            }
        }
            
        default:
            return nil;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
    headerview.backgroundColor = TABLEVIEWCELL_COLOR;
    
    UILabel *headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
    headerTitleLabel.textColor = WHITE_CLOCLOR;
    headerTitleLabel.font = SMALLFONT_16;
    headerTitleLabel.textAlignment = NSTextAlignmentCenter;
    if (section == 0) {
        headerTitleLabel.text = @"课程简介";
    }
    else if (section == 1){
        headerTitleLabel.text = @"教练简介";
    }
    else {
        headerTitleLabel.text = @"教练评价";
    }
    [headerview addSubview:headerTitleLabel];
    return headerview;
}

- (void)jumpPersonController:(NSString*)friendid{
    UserData *userdata = [UserData shared];
    UserInfo *userInfo = userdata.userInfo;
    if ([friendid intValue] == [userInfo.userid intValue]) {
        OwnInfoViewController *ownInfoController = [[OwnInfoViewController alloc]init];
        ownInfoController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ownInfoController animated:YES];
    }else{
        PersonalViewController *personController = [[PersonalViewController alloc]init];
        personController.personID = friendid;
        [self.navigationController pushViewController:personController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
