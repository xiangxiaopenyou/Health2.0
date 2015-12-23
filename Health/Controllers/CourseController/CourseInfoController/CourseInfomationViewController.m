//
//  CourseInfomationViewController.m
//  Health
//
//  Created by realtech on 15/5/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseInfomationViewController.h"
#import "CourseStudentViewController.h"
#import "CourseMessageSettingViewController.h"

@interface CourseInfomationViewController () {
    NSMutableArray *memberArray;
}

@end

@implementation CourseInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [back setTitle:@"" forState:UIControlStateNormal];
    [back setFrame:CGRectMake(5, 2, 52, 30)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = barButton;
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"营资料"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    memberArray = [[NSMutableArray alloc] init];
    
    infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    infoTableView.delegate = self;
    infoTableView.dataSource = self;
    infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    infoTableView.showsVerticalScrollIndicator = NO;
    infoTableView.backgroundColor = CLEAR_COLOR;
    [self.view addSubview:infoTableView];
    
    [self getStudent];
    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.frame = CGRectMake(0, SCREEN_HEIGHT - 45, SCREEN_WIDTH, 45);
    [settingButton setBackgroundColor:TABLEVIEWCELL_COLOR];
    [settingButton addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingButton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 10, 0, 100, 45)];
    label.text = @"营设置";
    label.font = SMALLFONT_16;
    label.textColor = MAIN_COLOR_YELLOW;
    [settingButton addSubview:label];
    
    UIImageView *settingImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 34, 13.5, 18, 18)];
    settingImage.image = [UIImage imageNamed:@"message_setting"];
    [settingButton addSubview:settingImage];
}
- (void)bClick{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.rootNavigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)settingClick{
    CourseMessageSettingViewController *controller = [[CourseMessageSettingViewController alloc] init];
    controller.courseid = self.course_info.courseid;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)getStudent{
    [CourseRequest studentCourseWith:self.course_info.courseid success:^(id response) {
        memberArray = response;
        [infoTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:SMALLFONT_14, NSFontAttributeName, nil];
        CGSize size = [self.course_info.courseintrduce boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        return size.height + 30;
    }
    else {
        return 48;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row == 0) {
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 65, 48)];
        label1.text = @"营成员";
        label1.font = SMALLFONT_14;
        label1.textColor = WHITE_CLOCLOR;
        [cell addSubview:label1];
        
        if (memberArray.count <= 6) {
            for (int i = 0; i < memberArray.count; i++){
                StudentEntity *studentInfo = [memberArray objectAtIndex:i];
                UIImageView *head = [[UIImageView alloc] initWithFrame:CGRectMake(80 + i*34, 10, 28, 28)];
                [head sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:studentInfo.studentphoto]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                head.layer.masksToBounds = YES;
                head.layer.cornerRadius = 14;
                [cell addSubview:head];
            }
        }
        else {
            for (int i = 0; i < 6; i++){
                StudentEntity *studentInfo = [memberArray objectAtIndex:i];
                UIImageView *head = [[UIImageView alloc] initWithFrame:CGRectMake(80 + i*34, 10, 28, 28)];
                [head sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:studentInfo.studentphoto]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                head.layer.masksToBounds = YES;
                head.layer.cornerRadius = 14;
                [cell addSubview:head];
            }
        }
        UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, 16.5, 15, 15)];
        right.image = [UIImage imageNamed:@"club_member_right"];
        [cell addSubview:right];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 47.5, SCREEN_WIDTH - 10, 0.5)];
        line.backgroundColor = LINE_COLOR_GARG;
        [cell addSubview:line];
    }
    else if (indexPath.row == 1) {
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 65, 48)];
        label1.text = @"主教练";
        label1.font = SMALLFONT_14;
        label1.textColor = WHITE_CLOCLOR;
        [cell addSubview:label1];
        
        FriendInfo *teacher = self.course_info.teacher;
        UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(80, 10, 28, 28)];
        [headImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:teacher.friendphoto]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
        headImage.layer.masksToBounds = YES;
        headImage.layer.cornerRadius = 14;
        [cell addSubview:headImage];
        
        UILabel *nickname = [[UILabel alloc] initWithFrame:CGRectMake(115, 0, 180, 48)];
        nickname.text = teacher.friendname;
        nickname.textColor = WHITE_CLOCLOR;
        nickname.font = SMALLFONT_14;
        [cell addSubview:nickname];
        
        UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, 16.5, 15, 15)];
        right.image = [UIImage imageNamed:@"club_member_right"];
        [cell addSubview:right];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 47.5, SCREEN_WIDTH - 10, 0.5)];
        line.backgroundColor = LINE_COLOR_GARG;
        [cell addSubview:line];
        
    }
    else if (indexPath.row == 2){
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:SMALLFONT_14, NSFontAttributeName, nil];
        CGSize size = [self.course_info.courseintrduce boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 65, size.height + 30)];
        label1.text = @"营介绍";
        label1.font = SMALLFONT_14;
        label1.textColor = WHITE_CLOCLOR;
        [cell addSubview:label1];
        
        UILabel *introLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH - 100, size.height + 30)];
        introLabel.text = self.course_info.courseintrduce;
        introLabel.font = SMALLFONT_14;
        introLabel.textColor = WHITE_CLOCLOR;
        introLabel.numberOfLines = 0;
        introLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [cell addSubview:introLabel];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, size.height + 29.5, SCREEN_WIDTH - 10, 0.5)];
        line.backgroundColor = LINE_COLOR_GARG;
        [cell addSubview:line];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 65, 48)];
        label1.text = @"创建日期";
        label1.font = SMALLFONT_14;
        label1.textColor = WHITE_CLOCLOR;
        [cell addSubview:label1];
        
        UILabel *createtime = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 100, 48)];
        if (![Util isEmpty:self.course_info.coursecreatedtime]) {
            createtime.text = [self.course_info.coursecreatedtime substringWithRange:NSMakeRange(0, 10)];
        }
        createtime.textColor = WHITE_CLOCLOR;
        createtime.font = SMALLFONT_14;
        [cell addSubview:createtime];
        cell.backgroundColor = TABLEVIEWCELL_COLOR;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 47.5, SCREEN_WIDTH - 10, 0.5)];
        line.backgroundColor = LINE_COLOR_GARG;
        [cell addSubview:line];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = TABLEVIEWCELL_COLOR;
    
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.row == 0) {
            CourseStudentViewController *controller = [[CourseStudentViewController alloc] init];
            controller.course = self.course_info;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else {
            FriendInfo *teacher = self.course_info.teacher;
            [self jumpPersonController:teacher.friendid];
        }
    }
}

//转到个人主页
- (void)jumpPersonController:(NSString*)friendid{
    UserData *userData = [UserData shared];
    UserInfo *userInfo = userData.userInfo;
    if ([friendid intValue] == [userInfo.userid intValue]) {
        OwnInfoViewController *ownInfoController = [[OwnInfoViewController alloc]init];
        ownInfoController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ownInfoController animated:YES];
    }else{
        PersonalViewController *personController = [[PersonalViewController alloc]init];
        personController.personID = friendid;
        personController.hidesBottomBarWhenPushed = YES;
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
