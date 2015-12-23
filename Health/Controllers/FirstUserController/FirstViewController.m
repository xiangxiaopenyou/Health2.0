//
//  FirstViewController.m
//  Health
//
//  Created by realtech on 15/6/1.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "FirstViewController.h"
#import "MyInfoRequest.h"
#import "SecondViewController.h"

@interface FirstViewController () {
    UIDatePicker *datePicker;
}

@end

@implementation FirstViewController
@synthesize manButton, womanButton, nextButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:TABLEVIEW_BACKGROUNDCOLOR];
    
    
    UserData *userdata = [UserData shared];
    UserInfo *userInfo = userdata.userInfo;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", nil];
    [MyInfoRequest myDetailInfoWithParam:dic success:^(id response) {
    } failure:^(NSError *error) {
    }];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH, 20)];
    title.text = @"请选择性别和生日";
    title.font = [UIFont systemFontOfSize:17];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = WHITE_CLOCLOR;
    [self.view addSubview:title];
    
    manButton = [UIButton buttonWithType:UIButtonTypeCustom];
    manButton.frame = CGRectMake(SCREEN_WIDTH/4 - 38, 142, 76, 117);
    [manButton setBackgroundImage:[UIImage imageNamed:@"man_selected"] forState:UIControlStateNormal];
    [manButton addTarget:self action:@selector(manClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:manButton];
    
    womanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    womanButton.frame = CGRectMake(3*SCREEN_WIDTH/4 - 38, 142, 76, 117);
    [womanButton setBackgroundImage:[UIImage imageNamed:@"female_not_selected"] forState:UIControlStateNormal];
    [womanButton addTarget:self action:@selector(womanClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:womanButton];
    
    userInfo.usersex = @"1";
    
    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 280, SCREEN_WIDTH, 280)];
    [self.view addSubview:dateView];
    
    datePicker = [[UIDatePicker alloc] init];
    //UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 162)];
    datePicker.backgroundColor = [UIColor colorWithRed:238/255.0 green:244/255.0 blue:251/255.0 alpha:1.0];
    [dateView addSubview:datePicker];
    [datePicker setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    NSString *datestring = @"1990-01-01";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    datePicker.date = [formatter dateFromString:datestring];
    
    dateView.frame = CGRectMake(0, SCREEN_HEIGHT - datePicker.frame.size.height - 44, SCREEN_WIDTH, datePicker.frame.size.height + 44);
    
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0, datePicker.frame.size.height, SCREEN_WIDTH, 44);
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor colorWithRed:29/255.0 green:28/255.0 blue:36/255.0 alpha:1.0] forState:UIControlStateNormal];
    nextButton.backgroundColor = MAIN_COLOR_YELLOW;
    nextButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:nextButton];
    
}

- (void)manClick{
    UserData *userdata = [UserData shared];
    UserInfo *userInfo = userdata.userInfo;
    userInfo.usersex = @"1";
    [manButton setBackgroundImage:[UIImage imageNamed:@"man_selected"] forState:UIControlStateNormal];
    [womanButton setBackgroundImage:[UIImage imageNamed:@"female_not_selected"] forState:UIControlStateNormal];
}
- (void)womanClick{
    UserData *userdata = [UserData shared];
    UserInfo *userInfo = userdata.userInfo;
    userInfo.usersex = @"2";
    [manButton setBackgroundImage:[UIImage imageNamed:@"man_not_selected"] forState:UIControlStateNormal];
    [womanButton setBackgroundImage:[UIImage imageNamed:@"female_selected"] forState:UIControlStateNormal];
}
- (void)nextClick{
    UserData *userdata = [UserData shared];
    UserInfo *userInfo = userdata.userInfo;
    NSDate *selectDate = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:selectDate];
    userInfo.userbirthday = dateString;
    
    SecondViewController *controller = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    
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
