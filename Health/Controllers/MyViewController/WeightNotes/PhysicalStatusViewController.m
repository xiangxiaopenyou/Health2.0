//
//  PhysicalStatusViewController.m
//  Health
//
//  Created by realtech on 15/6/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PhysicalStatusViewController.h"
#import "MyInfoRequest.h"

@interface PhysicalStatusViewController ()<UITableViewDataSource, UITableViewDelegate>{
    UIButton *saveButton;
    UITableView *mainTableView;
    UserInfo *userInfo;
}

@end

@implementation PhysicalStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    self.view.backgroundColor= TABLEVIEW_BACKGROUNDCOLOR;
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"身体数据"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT)];
    mainTableView.backgroundColor = CLEAR_COLOR;
    mainTableView.showsVerticalScrollIndicator = NO;
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(SCREEN_WIDTH - 50, 22, 40, 40);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    if (self.isCoachIn) {
        saveButton.hidden = YES;
    }
    
    [self getBodyInfo];
}

- (void)getBodyInfo{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", nil];
    if (self.isCoachIn) {
        [dic setObject:self.friendid forKey:@"friendid"];
    }
    [MyInfoRequest bodyInfo:dic success:^(id response) {
        if ([[response objectForKey:@"state"]  integerValue] == 1000) {
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveButtonClick{
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
