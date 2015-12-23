//
//  CourseMessageSettingViewController.m
//  Health
//
//  Created by realtech on 15/6/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseMessageSettingViewController.h"

@interface CourseMessageSettingViewController ()<UITableViewDataSource, UITableViewDelegate>{
    UISwitch *topSwitch;
    UISwitch *reportSwitch;
}

@end

@implementation CourseMessageSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"营设置"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    UITableView *settingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    settingTable.delegate = self;
    settingTable.dataSource = self;
    settingTable.showsVerticalScrollIndicator = NO;
    settingTable.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    settingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:settingTable];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    headerView.backgroundColor = CLEAR_COLOR;
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 48)];
    headerLabel.font = BOLDFONT_16;
    headerLabel.text = @"消息设置";
    headerLabel.textColor = WHITE_CLOCLOR;
    [headerView addSubview:headerLabel];
    settingTable.tableHeaderView = headerView;

}

- (void)bClick {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (self.isMessage) {
        appDelegate.rootNavigationController.navigationBarHidden = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = TABLEVIEWCELL_COLOR;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 60)];
    label1.textColor = WHITE_CLOCLOR;
    label1.font = SMALLFONT_14;
    if (indexPath.row == 0) {
        label1.text = @"置顶聊天";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        topSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 15, 55, 30)];
        [topSwitch setOn:NO];
        topSwitch.onTintColor = MAIN_COLOR_YELLOW;
        [topSwitch addTarget:self action:@selector(topSwitch) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:topSwitch];
    }
    else if (indexPath.row == 1) {
        label1.text = @"新消息通知";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        reportSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 15, 55, 30)];
        [reportSwitch setOn:YES];
        reportSwitch.onTintColor = MAIN_COLOR_YELLOW;
        [reportSwitch addTarget:self action:@selector(reportSwitch) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:reportSwitch];
    }
    else {
        label1.text = @"清空聊天记录";
    }
    [cell addSubview:label1];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 59.5, SCREEN_WIDTH - 10, 0.5)];
    line.backgroundColor = LINE_COLOR_GARG;
    [cell addSubview:line];
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if ([[RCIM sharedRCIM] clearMessages:ConversationType_GROUP targetId:self.courseid]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"clearmessage" object:@YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"清除成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            
        }
    }
}
- (void)topSwitch{
    if ([topSwitch isOn]) {
        [[RCIM sharedRCIM] setConversationToTop:ConversationType_GROUP targetId:self.courseid isTop:YES];
    }
    else {
        [[RCIM sharedRCIM] setConversationToTop:ConversationType_GROUP targetId:self.courseid isTop:NO];
    }
}
- (void)reportSwitch{
    if ([reportSwitch isOn]) {
        [[RCIM sharedRCIM] setConversationNotificationStatus:ConversationType_GROUP targetId:self.courseid isBlocked:YES completion:^(RCConversationNotificationStatus nStatus) {
            
        } error:^(RCErrorCode status) {
            
        }];
    }
    else {
        [[RCIM sharedRCIM] setConversationNotificationStatus:ConversationType_GROUP targetId:self.courseid isBlocked:NO completion:^(RCConversationNotificationStatus nStatus) {
            
        } error:^(RCErrorCode status) {
            
        }];
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
