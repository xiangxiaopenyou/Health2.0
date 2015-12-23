//
//  SecondViewController.m
//  Health
//
//  Created by realtech on 15/6/1.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "SecondViewController.h"
#import "ThreeViewController.h"

@interface SecondViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>{
    UserInfo *userInfo;
    UIPickerView *picker;
}

@end

@implementation SecondViewController
@synthesize image, nextButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH, 20)];
    title.text = @"请选择身高和体重";
    title.font = [UIFont systemFontOfSize:17];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = WHITE_CLOCLOR;
    [self.view addSubview:title];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 84, 114, 168, 186)];
    if ([userInfo.usersex integerValue] == 1) {
        image.image = [UIImage imageNamed:@"male_height_weight"];

    }
    else {
        image.image = [UIImage imageNamed:@"female_height_weight"];
    }
    [self.view addSubview:image];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 206, SCREEN_WIDTH, 162)];
    picker.delegate = self;
    picker.backgroundColor = [UIColor colorWithRed:238/255.0 green:244/255.0 blue:251/255.0 alpha:1.0];
    [self.view addSubview:picker];
    
    [picker selectRow:70 inComponent:0 animated:YES];
    [picker selectRow:50 inComponent:1 animated:YES];
    
    UILabel *cmLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4 + 40, 65, 30, 30)];
    cmLabel.text = @"cm";
    cmLabel.font = [UIFont systemFontOfSize:18];
    [picker addSubview:cmLabel];
    
    UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(3* SCREEN_WIDTH/4, 65, 30, 30)];
    pointLabel.text = @".";
    pointLabel.font = [UIFont systemFontOfSize:18];
    [picker addSubview:pointLabel];
    
    UILabel *kgLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 65, 30, 30)];
    kgLabel.text = @"kg";
    kgLabel.font = [UIFont systemFontOfSize:18];
    [picker addSubview:kgLabel];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44);
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor colorWithRed:29/255.0 green:28/255.0 blue:36/255.0 alpha:1.0] forState:UIControlStateNormal];
    nextButton.backgroundColor = MAIN_COLOR_YELLOW;
    nextButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}
- (void)nextClick{
    NSInteger heightRow = [picker selectedRowInComponent:0];
    NSInteger weightRow1 = [picker selectedRowInComponent:1];
    NSInteger weightRow2 = [picker selectedRowInComponent:2];
    
    userInfo.userheight = [NSString stringWithFormat:@"%ld", heightRow + 100];
    userInfo.userweight = [NSString stringWithFormat:@"%ld.%ld", weightRow1 + 20, weightRow2];
    
    ThreeViewController *controller = [[ThreeViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    
}
- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == 0) {
        return picker.frame.size.width/2;
    }
    else if (component == 1) {
        return picker.frame.size.width/4 - 40;
    }
    else {
        return picker.frame.size.width/4 + 60;
    }
}
- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 100;
    }
    else if (component == 1) {
        return 130;
    }
    else {
        return 10;
    }
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [NSString stringWithFormat:@"%ld", row + 100];
    }
    else if (component == 1) {
        return [NSString stringWithFormat:@"%ld", row + 20];
    }
    else {
        return [NSString stringWithFormat:@"%ld", row];
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
