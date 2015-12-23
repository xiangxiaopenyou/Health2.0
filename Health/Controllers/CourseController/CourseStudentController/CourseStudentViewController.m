//
//  CourseStudentViewController.m
//  Health
//
//  Created by cheng on 15/3/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseStudentViewController.h"
#import "CourseRequest.h"
#import "StudentInfoTableViewCell.h"
#import "TeacherInfoTableViewCell.h"

@interface CourseStudentViewController ()<UITableViewDataSource,UITableViewDelegate>{
    FriendInfo *teacherInfo;
    NSMutableArray *studentArray;
}

@end

@implementation CourseStudentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"训练营学员"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    studentArray = [[NSMutableArray alloc]init];
    teacherInfo = self.course.teacher;
    [self getStudent];
}
- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }else{
        return studentArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *indentifier = @"CourseTeacherInfo";
        TeacherInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TeacherInfoTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        cell.course_intrduceLabel.text = teacherInfo.friendintrduce;
        [cell.course_intrduceLabel sizeToFit];
        cell.course_ageLabel.text = [NSString stringWithFormat:@"%ld",(long)[CustomDate getAgeToDate:teacherInfo.friendbirthday]];
        cell.course_nameLabel.text = [NSString stringWithFormat:@"%@",teacherInfo.friendname];
        [cell.course_teacherPhoto sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:teacherInfo.friendphoto]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
        if ([teacherInfo.friendsex intValue] == MAN_FLAG) {
            cell.course_teachersex.image = [UIImage imageNamed:@"sex_man.png"];
        }else{
            cell.course_teachersex.image = [UIImage imageNamed:@"sex_woman.png"];
        }
        cell.course_pointStudent.image = [Util levelImage:teacherInfo.friendpointstudent];
        cell.course_pointSystem.image = [Util levelImage:teacherInfo.friendpointsystem];
        
        return cell;
    }else{
        StudentEntity *studentInfo = [studentArray objectAtIndex:indexPath.row];
        static NSString *indentifier = @"CourseStudentInfo";
        StudentInfoTableViewCell *cell = (StudentInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"StudentInfoTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        if (![Util isEmpty:studentInfo.studentintrduce]) {
            cell.student_intrduceLabel.text = studentInfo.studentintrduce;
        }
        else{
            cell.student_intrduceLabel.text = @"这个人很懒什么都没写";
        }
        [cell.student_intrduceLabel sizeToFit];
        if ([Util isEmpty: studentInfo.studentbirthday]) {
            cell.student_ageLabel.text = [NSString stringWithFormat:@"0岁"];
        }else{
            cell.student_ageLabel.text = [NSString stringWithFormat:@"%ld岁",(long)[CustomDate getAgeToDate:studentInfo.studentbirthday]];
        }
        cell.student_nameLabel.text = [NSString stringWithFormat:@"%@",studentInfo.studentname];
        [cell.student_teacherPhoto sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:studentInfo.studentphoto]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
        if ([studentInfo.studentsex intValue] == MAN_FLAG) {
            cell.student_teachersex.image = [UIImage imageNamed:@"sex_man.png"];
        }else{
            cell.student_teachersex.image = [UIImage imageNamed:@"sex_woman.png"];
        }
        //cell.backgroundColor = TABLEVIEWCELL_COLOR;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 59.5, SCREEN_WIDTH - 10, 0.5)];
        line.backgroundColor = LINE_COLOR_GARG;
        [cell addSubview:line];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //教练
        [self jumpPersonController:teacherInfo.friendid];
    }else{
        StudentEntity *studentInfo = [studentArray objectAtIndex:indexPath.row];
        [self jumpPersonController:studentInfo.studentid];
    }
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

-  (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier1 = @"CourseTeacherInfo";
    if (indexPath.section == 0) {
        TeacherInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TeacherInfoTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            //[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        cell.course_intrduceLabel.text = teacherInfo.friendintrduce;
        [cell.course_intrduceLabel sizeToFit];
        //cell里面的教练的介绍高度
        return 140+cell.course_intrduceLabel.frame.size.height;
    }else{
        return 60;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH-16*2, 40)];
    if (section == 0) {
        label.text = @"教练简介";
    }else{
        label.text = @"学员信息";
    }
    label.backgroundColor = [UIColor clearColor];
    label.font = SMALLFONT_16;
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    view.backgroundColor = CLEAR_COLOR;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:1.0];
    return view;
}

- (void)getStudent{
    [CourseRequest studentCourseWith:self.course.courseid success:^(id response) {
        studentArray = response;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}


@end
