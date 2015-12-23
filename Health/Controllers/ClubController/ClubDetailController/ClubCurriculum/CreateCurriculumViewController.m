//
//  CreateCurriculumViewController.m
//  Health
//
//  Created by realtech on 15/5/21.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CreateCurriculumViewController.h"

@interface CreateCurriculumViewController ()<UITextFieldDelegate>{
    UserInfo *userInfo;
}

@end

@implementation CreateCurriculumViewController
@synthesize linkTextField, sendButton, tipImageView;

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
    [customLab setText:@"创建课表"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    [self setupMainView];
}

- (void)setupMainView{
    

    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, NAVIGATIONBAR_HEIGHT + 22, 60, 16)];
    label2.textColor = [UIColor blackColor];
    label2.font = SMALLFONT_14;
    
    label2.text = @"课表链接";
    [self.view addSubview:label2];
    
    linkTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, NAVIGATIONBAR_HEIGHT + 50, SCREEN_WIDTH - 30, 44)];
    linkTextField.textColor = [UIColor blackColor];
    linkTextField.font = SMALLFONT_14;
    linkTextField.returnKeyType = UIReturnKeyDone;
    linkTextField.layer.masksToBounds = YES;
    linkTextField.layer.cornerRadius = 2;
    linkTextField.layer.borderWidth = 0.5;
    linkTextField.layer.borderColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0].CGColor;
    linkTextField.delegate =self;
    linkTextField.backgroundColor = WHITE_CLOCLOR;
    linkTextField.placeholder = @"请输入课表链接";
    [self.view addSubview:linkTextField];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(15, NAVIGATIONBAR_HEIGHT + 114, SCREEN_WIDTH - 30, 40);
    sendButton.backgroundColor = MAIN_COLOR_YELLOW;
    [sendButton setTitle:@"发布" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendButton.layer.masksToBounds = YES;
    sendButton.layer.cornerRadius = 2;
    [sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 132.5, NAVIGATIONBAR_HEIGHT + 174, 265, 256.5)];
    tipImageView.image = [UIImage imageNamed:@"getlink_tip"];
    [self.view addSubview:tipImageView];
}
#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([@"\n" isEqualToString:string]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)sendClick {
    if ([Util isEmpty:linkTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入链接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:userInfo.userid forKey:@"userid"];
        [dic setObject:userInfo.usertoken forKey:@"usertoken"];
        [dic setObject:@"2" forKey:@"type"];
        [dic setObject:self.club_id forKey:@"clubid"];
        [dic setObject:linkTextField.text forKey:@"url"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [ClubRequest clubCreamCreateWith:dic success:^(id response) {
            if ([[response objectForKey:@"state"] integerValue] == 1000) {
                NSLog(@"发布成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"createcurriculumsuccess" object:@YES];
            }
            else if([[response objectForKey:@"state"] integerValue] == 1007){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布失败，链接不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else{
                NSLog(@"发布失败");
            }
        } failure:^(NSError *error) {
            NSLog(@"网络问题");
        }];
    }
}


- (void)bClick{
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
