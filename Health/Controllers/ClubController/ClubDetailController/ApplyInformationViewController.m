//
//  ApplyInformationViewController.m
//  Health
//
//  Created by realtech on 15/5/25.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ApplyInformationViewController.h"

@interface ApplyInformationViewController (){
    UserInfo *userInfo;
}

@end

@implementation ApplyInformationViewController
@synthesize tipLabel, infoTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"验证信息"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(SCREEN_WIDTH - 50, 22, 40, 40);
    [submitButton setTitle:@"发送" forState:UIControlStateNormal];
    [submitButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    submitButton.titleLabel.font = SMALLFONT_14;
    [submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    infoTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 110)];
    infoTextView.backgroundColor = WHITE_CLOCLOR;
    infoTextView.delegate = self;
    infoTextView.textColor = [UIColor colorWithRed:91/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    infoTextView.font = SMALLFONT_14;
    infoTextView.showsVerticalScrollIndicator = NO;
    infoTextView.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:infoTextView];
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 7.5, 200, 16)];
    tipLabel.font = SMALLFONT_14;
    tipLabel.text = @"输入验证信息，不超过30字";
    tipLabel.textColor = TIME_COLOR_GARG;
    [infoTextView addSubview:tipLabel];
    
    [infoTextView becomeFirstResponder];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [infoTextView resignFirstResponder];
}

#pragma mark - UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([@"\n" isEqualToString:text]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    [tipLabel setHidden:YES];
}

- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)submitClick{
    if ([Util isEmpty:infoTextView.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"先输入验证信息哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        if (infoTextView.text.length > 30) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证信息不要超过30字哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", self.club_id, @"clubid", infoTextView.text, @"content", nil];
            [self.navigationController popViewControllerAnimated:YES];
            [ClubRequest clubApplyWith:dic success:^(id response) {
                if ([[response objectForKey:@"state"]  integerValue] == 1000) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"applyclubsuccess" object:@YES];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            } failure:^(NSError *error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }];
        }
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
