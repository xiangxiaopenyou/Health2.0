//
//  ClubTrainingCampViewController.m
//  Health
//
//  Created by realtech on 15/5/22.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClubTrainingCampViewController.h"
#import "CourseListCell.h"
#import "CourseDetailsViewController.h"
#import "CourseGroupChatViewController.h"

@interface ClubTrainingCampViewController ()<UITableViewDataSource, UITableViewDelegate>{
    UserInfo *userInfo;
    NSMutableArray *courseArray;
    NSString *limitString;
    NSString *totalString;
    Course *selectedCourse;
}

@end

@implementation ClubTrainingCampViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:[NSString stringWithFormat:@"%@隶属营", self.titleString]];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    campTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT -NAVIGATIONBAR_HEIGHT)];
    campTableView.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    campTableView.delegate = self;
    campTableView.dataSource = self;
    campTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:campTableView];

    [self refreshClubCourse];
}

- (void)refreshClubCourse{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:self.club_id forKey:@"clubid"];
    [ClubRequest clubCourseListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            limitString = [response objectForKey:@"limit"];
            totalString = [response objectForKey:@"total"];
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            tempArray = [response objectForKey:@"data"];
            if (![Util isEmpty:tempArray]) {
                //NSMutableArray *temp_a = [[NSMutableArray alloc] init];
                courseArray = [self getCurseArray:tempArray];
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"coursecreatedtime" ascending:NO];
                [courseArray sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
                [campTableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (NSMutableArray *)getCurseArray:(NSMutableArray*)temp_array{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *courseDiction in temp_array) {
        Course *course = [Course MR_createEntity];
        if (![Util isEmpty:[courseDiction objectForKey:@"course"]]) {
            NSDictionary *courseTemp = [courseDiction objectForKey:@"course"];
            course.courseapplynum = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseapplynum"]];
            course.coursecount = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursecount"]];
            course.courseday = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseday"]];
            course.coursedifficultty = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursedifficulty"]];
            course.coursefat = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursefat"]];
            course.courseid = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseid"]];
            course.courseintrduce = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseintroduce"]];
            course.courseoldprice = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseoldprice"]];
            course.coursephoto = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursephoto"]];
            course.coursepowerdifficulty = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursepowerdifficulty"]];
            course.courseprice = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseprice"]];
            course.courseshaping = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseshaping"]];
            course.coursestarttime = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursestarttime"]];
            course.coursecreatedtime = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"created_time"]];
            course.coursestate = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursestate"]];
            course.coursestrength = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursestrength"]];
            course.coursetarget = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursetarget"]];
            course.coursetitle = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursetitle"]];
            course.coursesign = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"coursepayment"]];
            course.courseisstart = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"flag"]];
            course.courseisappraise = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"seetype"]];
            course.coursebody = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"parts"]];
            course.coursedetailimgage = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"partsimg"]];
            if (![Util isEmpty:[courseTemp objectForKey:@"clubname"]]) {
                course.courseofclub = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"clubname"]];
            }
            else {
                course.courseofclub = @"";
            }
            
        }
        NSArray *tempArray = [courseDiction objectForKey:@"coursesub"];
        if (tempArray.count > 0) {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (NSDictionary *courseSub in [courseDiction objectForKey:@"coursesub"] ) {
                for (NSDictionary *courseSubTemp in [courseSub objectForKey:@"data"]){
                    CourseSub *courseSub = [CourseSub MR_createEntity];
                    courseSub.coursesubflag = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubflag"]];
                    courseSub.coursesubid = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubid"]];
                    courseSub.coursesubcontent = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubcontent"]];
                    courseSub.coursesubday = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubday"]];
                    courseSub.coursesubintrduce = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubintroduce"]];
                    courseSub.coursesubtime = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubtime"]];
                    courseSub.coursesubtitle = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubtitle"]];
                    courseSub.coursesuborder = [NSNumber numberWithInt:[[NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesuborder"]]intValue]];
                    courseSub.coursesubtype = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubtype"]];
                    [array addObject:courseSub];
                }
                
            }
            course.coursesub = [NSSet setWithArray:array];
        }
        if (![Util isEmpty:[courseDiction objectForKey:@"teacher"]]) {
            FriendInfo *teacher = [FriendInfo MR_createEntity];
            NSDictionary *teacherDic = [courseDiction objectForKey:@"teacher"];
            teacher.friendbirthday = [Util isEmpty:[teacherDic objectForKey:@"teacherbirthday"]]?nil:[teacherDic objectForKey:@"teacherbirthday"];
            teacher.friendpointstudent = [Util isEmpty:[teacherDic objectForKey:@"teacherpointstudent"]]?nil:[teacherDic objectForKey:@"teacherpointstudent"];
            teacher.friendpointsystem = [Util isEmpty:[teacherDic objectForKey:@"teacherpointsystem"]]?nil:[teacherDic objectForKey:@"teacherpointsystem"];
            teacher.friendid = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teacherid"]];
            teacher.friendintrduce = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teacherintrduce"]];
            teacher.friendphoto = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teacherphoto"]];
            teacher.friendsex = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teachersex"]];
            teacher.friendname = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teachernickname"]];
            teacher.friendoverallappraisal = [NSString stringWithFormat:@"%@", [teacherDic objectForKey:@"have"]];
            teacher.friendattitudescore = [NSString stringWithFormat:@"%@", [teacherDic objectForKey:@"teaching_attitude"]];
            teacher.friendskillscore = [NSString stringWithFormat:@"%@", [teacherDic objectForKey:@"expertise"]];
            course.teacher = teacher;
        }
        [array addObject:course];
    }
    return array;
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return courseArray.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_WIDTH/2 + 10;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CourseCell";
    Course *course = [courseArray objectAtIndex:indexPath.row];
    CourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CourseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.titleLabel.text = course.coursetitle;
    cell.dateLabel.text = [NSString stringWithFormat:@"%@开课", [course.coursestarttime substringWithRange:NSMakeRange(5, 5)]];
    cell.countLabel.text = [NSString stringWithFormat:@"%@人班", course.coursecount];
    cell.daysLabel.text = [NSString stringWithFormat:@"%@天", course.courseday];
    [cell.image_view sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:course.coursephoto]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@", course.courseprice];
    cell.oldpriceLabel.text = [NSString stringWithFormat:@"￥%@", course.courseoldprice];
    if (![Util isEmpty:course.courseofclub]) {
        cell.clubLabel.text = course.courseofclub;
    }
    if ([course.coursedifficultty integerValue] <= 2) {
        cell.difficultyImage.image = [UIImage imageNamed:@"difficulty_easy"];
        cell.difficultyLabel.text = @"简单";
        
    }
    else if ([course.coursedifficultty integerValue] <= 4){
        cell.difficultyImage.image = [UIImage imageNamed:@"difficulty_normal"];
        cell.difficultyLabel.text = @"普通";
    }
    else {
        cell.difficultyImage.image = [UIImage imageNamed:@"difficulty_diffcult"];
        cell.difficultyLabel.text = @"困难";
    }
    switch ([course.coursebody integerValue]) {
        case 10:
            cell.bodyLabel.text = @"增肌";
            break;
        case 11:
            cell.bodyLabel.text = @"减肥";
            break;
        case 12:
            cell.bodyLabel.text = @"塑性";
            break;
        case 13:
            cell.bodyLabel.text = @"康复";
            break;
        case 14:
            cell.bodyLabel.text = @"健美";
            break;
        default:
            cell.bodyLabel.text = @"其他";
            break;
    }
    if ([course.courseisstart integerValue] == 1) {
        cell.stateImageView.image = [UIImage imageNamed:@"course_state_start"];
    }
    else if ([course.courseisstart integerValue] == 2){
        cell.stateImageView.image = [UIImage imageNamed:@"course_state_finish"];
    }
    else {
        cell.stateImageView.image = [UIImage imageNamed:@"course_state_notstart"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = TABLEVIEWCELL_COLOR;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Course *tempCourse = [courseArray objectAtIndex:indexPath.row];
    selectedCourse = tempCourse;
    if ([tempCourse.coursesign  integerValue] == 1) {
        [[RCIM sharedRCIM] joinGroup:tempCourse.courseid groupName:tempCourse.coursetitle completion:^{
            [self performSelectorOnMainThread:@selector(turnToGoupChat) withObject:nil waitUntilDone:YES];
            
        } error:^(RCErrorCode status) {
            
        }];
    }
    else {
        CourseDetailsViewController *detailsController = [[CourseDetailsViewController alloc] init];
        detailsController.course = tempCourse;
        [self.navigationController pushViewController:detailsController animated:YES];
    }
}
- (void)turnToGoupChat{
    CourseGroupChatViewController *controller = [[CourseGroupChatViewController alloc]init];
    controller.course = selectedCourse;
    controller.currentTarget = selectedCourse.courseid;
    controller.currentTargetName = selectedCourse.coursetitle;
    controller.conversationType = ConversationType_GROUP;
    controller.enableUnreadBadge = NO;
    controller.enableVoIP = NO;
    controller.portraitStyle = RCUserAvatarCycle;
    
    [self.navigationController pushViewController:controller animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
}

- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
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
