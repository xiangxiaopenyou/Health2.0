//
//  ChoosePositionViewController.m
//  Health
//
//  Created by realtech on 15/5/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ChoosePositionViewController.h"

@interface ChoosePositionViewController (){
    UILabel *tipLabel;
}

@end

@implementation ChoosePositionViewController

@synthesize positionTextField, submitButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"地点"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 20, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    [self setupHeaderView];
    
    positionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT + 40, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 98)];
    positionTableView.delegate = self;
    positionTableView.dataSource = self;
    positionTableView.showsVerticalScrollIndicator = NO;
    positionTableView.backgroundColor = CLEAR_COLOR;
    positionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:positionTableView];
    
}

- (void)setupHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 40)];
    headerView.backgroundColor = CLEAR_COLOR;
    [self.view addSubview:headerView];
    
    positionTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, 7, SCREEN_WIDTH - 76, 26)];
    positionTextField.delegate = self;
    positionTextField.font = SMALLFONT_13;
    positionTextField.returnKeyType = UIReturnKeyDone;
    positionTextField.layer.masksToBounds = YES;
    positionTextField.layer.cornerRadius = 2;
    positionTextField.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [headerView addSubview:positionTextField];
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 26)];
    tipLabel.text = @"自定义位置";
    tipLabel.textColor = [UIColor colorWithRed:191/255.0 green:192/255.0 blue:192/255.0 alpha:1.0];
    tipLabel.font = SMALLFONT_13;
    [positionTextField addSubview:tipLabel];
    
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(SCREEN_WIDTH - 50, 5, 50, 30);
    [submitButton setTitle:@"确定" forState:UIControlStateNormal];
    [submitButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    submitButton.titleLabel.font = SMALLFONT_14;
    [submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:submitButton];
    
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([@"\n" isEqualToString:string]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    tipLabel.hidden = YES;
}


- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)submitButtonClick{
    if ([Util isEmpty:positionTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"先输入你的位置吧~" delegate:nil cancelButtonTitle:@"确定 " otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate clickSubmit:positionTextField.text];
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"不显示";
        cell.textLabel.textColor = WHITE_CLOCLOR;
    }
    else {
        UIImageView *positionImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 21, 18, 18)];
        positionImage.image = [UIImage imageNamed:@"choose_position"];
        [cell addSubview:positionImage];
        
        UILabel *positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 40, 60)];
        positionLabel.text = self.defaultPositionString;
        positionLabel.textColor = WHITE_CLOCLOR;
        positionLabel.font = SMALLFONT_14;
        [cell addSubview:positionLabel];
    }
    cell.backgroundColor = TABLEVIEWCELL_COLOR;
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 59.5, SCREEN_WIDTH - 10, 0.5)];
    line.backgroundColor = LINE_COLOR_GARG;
    [cell addSubview:line];
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate clickDeletePosition];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate clickSubmit:self.defaultPositionString];
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
