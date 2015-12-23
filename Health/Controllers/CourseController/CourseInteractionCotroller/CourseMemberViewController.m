//
//  CourseMemberViewController.m
//  Health
//
//  Created by realtech on 15/3/16.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseMemberViewController.h"
#import "CourseRequest.h"

@interface CourseMemberViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *studentArray;
    
    UITableView *memberTableView;
}

@end

@implementation CourseMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_LABEL_X, TITLE_LABEL_Y, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"成员选择"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    memberTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    memberTableView.delegate = self;
    memberTableView.dataSource = self;
    [memberTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [memberTableView setBackgroundView:nil];
    [memberTableView setBackgroundColor:[UIColor colorWithRed:30/255.0 green:30/255.0 blue:32/255.0 alpha:1.0]];
    memberTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:memberTableView];
    [self getStudent];
}

- (void)getStudent{
    [CourseRequest studentCourseWith:self.courseID success:^(id response) {
        studentArray = response;
        [memberTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return studentArray.count + 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 0) {
        UILabel *selfLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, 60)];
        selfLabel.text = @"我";
        selfLabel.font = [UIFont boldSystemFontOfSize:18];
        selfLabel.textColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
        [cell addSubview:selfLabel];
    }
    else{
        StudentEntity *studentInfo = [studentArray objectAtIndex:indexPath.row - 1];
        //头像
        UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [headImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:studentInfo.studentphoto]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
        headImage.layer.masksToBounds = YES;
        headImage.layer.cornerRadius = 20;
        [cell addSubview:headImage];
        //昵称
        UILabel *nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 150, 60)];
        nicknameLabel.text = studentInfo.studentname;
        nicknameLabel.font = SMALLFONT_16;
        nicknameLabel.textColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
        [cell addSubview:nicknameLabel];
    }
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:18/255.0 green:18/255.0 blue:19/255.0 alpha:1.0];
    }
    else{
        cell.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:32/255.0 alpha:1.0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self.delegate clickMember:nil];
    }
    else{
        StudentEntity *studentInfo = [studentArray objectAtIndex:indexPath.row - 1];
        [self.delegate clickMember:studentInfo.studentid];
    }
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
