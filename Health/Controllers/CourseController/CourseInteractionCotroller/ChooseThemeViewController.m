//
//  ChooseThemeViewController.m
//  Health
//
//  Created by 项小盆友 on 15/3/1.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ChooseThemeViewController.h"

@interface ChooseThemeViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>{
    NSArray *themeArray;
    BOOL isCreateTheme;
    
}

@end

@implementation ChooseThemeViewController
@synthesize createThemeTextField, cancelOrSubmitButton, themeTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [navigationView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationbar"]]];
    [self.view addSubview:navigationView];
    
    if ([self.discussionType isEqualToString:@"food"]) {
        themeArray = [[NSArray alloc] initWithObjects:@"早餐", @"上午茶", @"午餐", @"下午茶", @"晚餐", @"夜宵", @"零食", nil];
    }
    else if ([self.discussionType isEqualToString:@"sports"]){
        themeArray = [[NSArray alloc] initWithObjects:@"举哑铃", @"俯卧撑",nil];
    }
    else{
        themeArray = nil;
    }
    
    //自定义话题
    createThemeTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 26, SCREEN_WIDTH - 80, 32)];
    createThemeTextField.delegate = self;
    createThemeTextField.backgroundColor = [UIColor grayColor];
    createThemeTextField.textColor = [UIColor whiteColor];
    createThemeTextField.returnKeyType = UIReturnKeyDone;
    createThemeTextField.layer.masksToBounds = YES;
    createThemeTextField.layer.cornerRadius = 2;
    createThemeTextField.placeholder = @"自定义话题";
    [navigationView addSubview:createThemeTextField];
    
    isCreateTheme = NO;
    
    //取消或者确定按钮
    cancelOrSubmitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelOrSubmitButton.frame = CGRectMake(SCREEN_WIDTH - 70, 26, 70, 32);
    [cancelOrSubmitButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelOrSubmitButton addTarget:self action:@selector(cancelOrSubmitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:cancelOrSubmitButton];
    
    themeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    themeTableView.delegate = self;
    themeTableView.dataSource = self;
    themeTableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    [themeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    themeTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:themeTableView];
    
}

- (void)cancelOrSubmitButtonClick{
    self.navigationController.navigationBarHidden = NO;
    if (![Util isEmpty:createThemeTextField.text]) {
        [self.delegate clickFinish:createThemeTextField.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([@"\n" isEqualToString:string]) {
        [textField resignFirstResponder];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [cancelOrSubmitButton setTitle:@"确定" forState:UIControlStateNormal];
    isCreateTheme = YES;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return themeArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UILabel *themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 50)];
    themeLabel.font = [UIFont boldSystemFontOfSize:16];
    themeLabel.textColor = [UIColor blackColor];
    themeLabel.textAlignment = NSTextAlignmentLeft;
    themeLabel.text = [themeArray objectAtIndex:indexPath.row];
    [cell addSubview:themeLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [cell addSubview:line];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.navigationController.navigationBarHidden = NO;
    [self.delegate clickFinish:[themeArray objectAtIndex:indexPath.row]];
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
