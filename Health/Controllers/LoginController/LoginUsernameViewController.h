//
//  LoginUsernameViewController.h
//  Health
//
//  Created by cheng on 15/3/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginUsernameViewController : UIViewController

@property (nonatomic,strong) IBOutlet UITextField *usernameTextField;
@property (nonatomic,strong) IBOutlet UITextField *passwordTextField;

- (IBAction)clickLogin:(id)sender;
- (IBAction)clickRegister:(id)sender;
- (IBAction)back:(id)sender;
@end
