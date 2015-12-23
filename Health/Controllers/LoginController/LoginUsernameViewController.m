//
//  LoginUsernameViewController.m
//  Health
//
//  Created by cheng on 15/3/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "LoginUsernameViewController.h"
#import "RegisterViewController.h"
#import "LoginRequest.h"

@interface LoginUsernameViewController ()<UITextFieldDelegate>

@end

@implementation LoginUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)clickLogin:(id)sender{
    if ([Util isEmpty:self.usernameTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录" message:@"用户名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([Util isEmpty:self.passwordTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSDictionary *paramater = [NSDictionary dictionaryWithObjectsAndKeys:self.passwordTextField.text,@"userpassword",self.usernameTextField.text,@"username", nil];
    
    [LoginRequest loginWithUserNameParam:paramater success:^(id response) {
        
        if ([[response objectForKey:@"state"] intValue] == 1000) {
            [self dismissViewControllerAnimated:YES completion:^{
            }];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Login" object:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"请检查用户名和密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录" message:@"网络连接异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
}

- (void)clickRegister:(id)sender{
    RegisterViewController *controller = [[RegisterViewController alloc]init];
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
