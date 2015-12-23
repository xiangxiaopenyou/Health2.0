//
//  ChooseLabelViewController.m
//  Health
//
//  Created by realtech on 15/4/16.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ChooseLabelViewController.h"
#import "TrendRequest.h"

@interface ChooseLabelViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>{
    NSArray *labelArray;
    
    UserInfo *userInfo;
}

@end

@implementation ChooseLabelViewController
@synthesize writeLabelTextField, cancelOrSubmitButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    
    writeLabelTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 25, SCREEN_WIDTH - 70, 35)];
    writeLabelTextField.delegate = self;
    writeLabelTextField.returnKeyType = UIReturnKeyDone;
    writeLabelTextField.backgroundColor = [UIColor whiteColor];
    writeLabelTextField.placeholder = @"自定义标签(不超过5个字)";
    [self.view addSubview:writeLabelTextField];
    
    cancelOrSubmitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelOrSubmitButton.frame = CGRectMake(SCREEN_WIDTH - 50, 20, 45, 40);
    [cancelOrSubmitButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelOrSubmitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelOrSubmitButton addTarget:self action:@selector(cancelOrSubmitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelOrSubmitButton];
    
    labelTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    labelTableView.delegate =self;
    labelTableView.dataSource = self;
    labelTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:labelTableView];
    
    [self getTagList];
}
- (void)getTagList{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", nil];
    [TrendRequest tagListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            labelArray = [response objectForKey:@"data"];
            [labelTableView reloadData];
        }
        else {
        }
    } failure:^(NSError *error) {
        NSLog(@"网络问题");
    }];
}

- (void)cancelOrSubmitButtonClick{
    if ([Util isEmpty:writeLabelTextField.text]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        if (writeLabelTextField.text.length > 5) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"标签不要超过5个字哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
        
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", writeLabelTextField.text, @"name", nil];
        [TrendRequest tagCreateWith:dic success:^(id response) {
            if ([[response objectForKey:@"state"] integerValue] == 1000) {
                NSLog(@"自定义标签成功");
            }
            else{
                NSLog(@"自定义标签失败");
            }
        } failure:^(NSError *error) {
        }];
        [self.navigationController popViewControllerAnimated:YES];
        
        [self.delegate clickFinish:writeLabelTextField.text];
        }
    }
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
    [cancelOrSubmitButton setTitle:@"完成" forState:UIControlStateNormal];
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return labelArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    NSDictionary *tempDic = [labelArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.textLabel.text = [tempDic objectForKey:@"name"];
    UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, 17.5, 15, 15)];
    rightImage.image = [UIImage imageNamed:@"club_member_right"];
    [cell addSubview:rightImage];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *tempDic = [labelArray objectAtIndex:indexPath.row];
    [self.delegate clickFinish:[tempDic objectForKey:@"name"]];
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
