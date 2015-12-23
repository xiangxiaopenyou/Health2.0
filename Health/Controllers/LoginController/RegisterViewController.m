//
//  RegisterViewController.m
//  Health
//
//  Created by cheng on 15/3/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginRequest.h"

@interface RegisterViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)clickRegister:(id)sender{
    
    if ([Util isEmpty:self.usernameTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册" message:@"用户名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([Util isEmpty:self.passwordTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([Util isEmpty:self.repasswordTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册" message:@"重复密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (![self.repasswordTextField.text isEqualToString:self.passwordTextField.text]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册" message:@"两次密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSDictionary *paramater = [NSDictionary dictionaryWithObjectsAndKeys:self.passwordTextField.text,@"userpassword",self.usernameTextField.text,@"username", nil];
    
    [LoginRequest registerWithUserNameParam:paramater success:^(id response) {
        if ([[response objectForKey:@"state"] intValue] == 1000) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册失败" message:@"用户已存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册失败" message:@"网络连接错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
