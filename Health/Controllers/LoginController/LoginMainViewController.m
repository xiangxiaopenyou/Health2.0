//
//  LoginMainViewController.m
//  Health
//
//  Created by realtech on 15/4/22.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "LoginMainViewController.h"
#import "LoginRequest.h"
#import "LoginUsernameViewController.h"

@interface LoginMainViewController ()

@end

@implementation LoginMainViewController

@synthesize userLoginButton, weChatLoginButton, loginButton, backgroundImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (SCREEN_HEIGHT > 480) {
        backgroundImage.image = [UIImage imageNamed:@"login_background_big"];
    }
    else {
       backgroundImage.image = [UIImage imageNamed:@"login_background_small"];
    }
    [self.view addSubview:backgroundImage];
    
    userLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userLoginButton.frame = CGRectMake(SCREEN_WIDTH/2 - 107, SCREEN_HEIGHT - 60, 214, 53);
    [userLoginButton setImage:[UIImage imageNamed:@"login_username_image.png"] forState:UIControlStateNormal];
    [userLoginButton addTarget:self action:@selector(userLoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userLoginButton];
    
    weChatLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    weChatLoginButton.frame = CGRectMake(SCREEN_WIDTH/2 - 107, SCREEN_HEIGHT - 120, 214, 53);
    [weChatLoginButton setImage:[UIImage imageNamed:@"login_button_background.png"] forState:UIControlStateNormal];
    [weChatLoginButton addTarget:self action:@selector(weChatLoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weChatLoginButton];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(SCREEN_WIDTH - 100, 300, 80, 30);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    loginButton.hidden = YES;
    
    if (isappstore == 1) {//appstore 需要登录注册
        [LoginRequest isAppstoreSuccess:^(id response) {
            if (![Util isEmpty:[response objectForKey:@"data"]]&&[[response objectForKey:@"data"] intValue] == 2 ) {
                userLoginButton.hidden = YES;
                weChatLoginButton.hidden = NO;
            }else{
                userLoginButton.hidden = NO;
                weChatLoginButton.hidden = YES;
            }
        } failure:^(NSError *error) {
        }];
    } else {
        //企业包不需要登录注册
        weChatLoginButton.hidden = NO;
        userLoginButton.hidden = YES;
        //loginButton.hidden = NO;
    }
    
}
- (void)userLoginButtonClick{
    LoginUsernameViewController *controller = [[LoginUsernameViewController alloc]init];
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}
- (void)weChatLoginButtonClick{
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}
- (void)login{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"onKFit7ea0JbgWOgkTk6AVskAFeo",@"openid", nil];
    [LoginRequest loginWithParam:dic success:^(id response) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Login" object:nil];
    } failure:^(NSError *error) {
    }];
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
