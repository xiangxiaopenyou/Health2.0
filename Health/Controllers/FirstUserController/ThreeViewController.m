//
//  ThreeViewController.m
//  Health
//
//  Created by realtech on 15/6/1.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ThreeViewController.h"
#import "FourthViewController.h"

@interface ThreeViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>{
    UserInfo *userInfo;
    UIPickerView *picker;
}

@end

@implementation ThreeViewController
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
    title.text = @"请选择目标体重和目标周期";
    title.font = [UIFont systemFontOfSize:17];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = WHITE_CLOCLOR;
    [self.view addSubview:title];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 41, 114, 82, 180)];
    if ([userInfo.usersex integerValue] == 1) {
        image.image = [UIImage imageNamed:@"male_target_weight"];
        
    }
    else {
        image.image = [UIImage imageNamed:@"female_target_weight"];
    }
    [self.view addSubview:image];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 206, SCREEN_WIDTH, 162)];
    picker.delegate = self;
    picker.backgroundColor = [UIColor colorWithRed:238/255.0 green:244/255.0 blue:251/255.0 alpha:1.0];
    [self.view addSubview:picker];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44);
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor colorWithRed:29/255.0 green:28/255.0 blue:36/255.0 alpha:1.0] forState:UIControlStateNormal];
    nextButton.backgroundColor = MAIN_COLOR_YELLOW;
    nextButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake( SCREEN_WIDTH/4 - 10, 65, 30, 30)];
    pointLabel.text = @".";
    pointLabel.font = [UIFont systemFontOfSize:18];
    pointLabel.textAlignment = NSTextAlignmentCenter;
    [picker addSubview:pointLabel];
    
    UILabel *kgLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 15, 65, 30, 30)];
    kgLabel.text = @"kg";
    kgLabel.font = [UIFont systemFontOfSize:18];
    [picker addSubview:kgLabel];
    
    [picker selectRow:50 inComponent:0 animated:YES];
    
    UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 65, 30, 30)];
    weekLabel.text = @"周";
    weekLabel.font = [UIFont systemFontOfSize:18];
    [picker addSubview:weekLabel];
    
}
- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)nextClick{
    NSInteger weightRow1 = [picker selectedRowInComponent:0];
    NSInteger weightRow2 = [picker selectedRowInComponent:1];
    NSInteger weightRow3 = [picker selectedRowInComponent:2];
    userInfo.usertargetweight = [NSString stringWithFormat:@"%ld.%ld", weightRow1 + 20, (long)weightRow2];
    userInfo.usersycle = [NSString stringWithFormat:@"%ld", weightRow3 + 1];
    FourthViewController *controller = [[FourthViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == 2) {
        return picker.frame.size.width/2;
    }
    else {
        return picker.frame.size.width/4;
    }
}
- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 130;
    }
    else if (component == 1){
        return 10;
    }
    else {
        return 20;
    }
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [NSString stringWithFormat:@"%ld", row + 20];
    }
    else if (component == 1){
        return [NSString stringWithFormat:@"%ld", row];
    }
    else {
        return [NSString stringWithFormat:@"%ld", row + 1];
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
