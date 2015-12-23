//
//  CreateActivityViewController.m
//  Health
//
//  Created by realtech on 15/5/20.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CreateActivityViewController.h"

@interface CreateActivityViewController ()<UITextFieldDelegate>{
    UserInfo *userInfo;
}

@end

@implementation CreateActivityViewController

@synthesize titleTextField, linkTextField, sendButton, tipImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    if ([self.type integerValue] == 1) {
        [customLab setText:@"添加精选"];
    }
    else if ([self.type integerValue] == 3){
        [customLab setText:@"创建活动"];
    }
    else {
        [customLab setText:@"创建课表"];
    }
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
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    scroll.contentSize = CGSizeMake(SCREEN_WIDTH, 520);
    scroll.showsVerticalScrollIndicator = NO;
    scroll.backgroundColor = CLEAR_COLOR;
    [self.view addSubview:scroll];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 22, 60, 16)];
    label1.textColor = [UIColor blackColor];
    label1.font = SMALLFONT_14;
    if ([self.type integerValue] == 1) {
        label1.text = @"文章标题";
    }
    else if ([self.type integerValue] == 3) {
        label1.text = @"活动标题";
    }
    else {
        label1.text = @"课表标题";
    }
    [scroll addSubview:label1];
    
    titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 48, SCREEN_WIDTH - 30, 44)];
    titleTextField.textColor = [UIColor blackColor];
    titleTextField.font = SMALLFONT_14;
    titleTextField.returnKeyType = UIReturnKeyDone;
    titleTextField.layer.masksToBounds = YES;
    titleTextField.layer.cornerRadius = 2;
    titleTextField.layer.borderWidth = 0.5;
    titleTextField.layer.borderColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0].CGColor;
    titleTextField.delegate =self;
    titleTextField.backgroundColor = WHITE_CLOCLOR;
    if ([self.type integerValue] == 1) {
        titleTextField.placeholder = @"请输入文章标题,不超过30字";
    }
    else if ([self.type integerValue] == 3) {
        titleTextField.placeholder = @"请输入活动标题,不超过30字";
    }
    else {
        titleTextField.placeholder = @"请输入课表标题,不超过30字";
    }
    [scroll addSubview:titleTextField];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 104, 60, 16)];
    label2.textColor = [UIColor blackColor];
    label2.font = SMALLFONT_14;
    if ([self.type integerValue] == 1) {
        label2.text = @"文章链接";
    }
    else if ([self.type integerValue] == 3) {
        label2.text = @"活动链接";
    }
    else {
        label2.text = @"课表链接";
    }
    [scroll addSubview:label2];
    
    linkTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 130, SCREEN_WIDTH - 30, 44)];
    linkTextField.textColor = [UIColor blackColor];
    linkTextField.font = SMALLFONT_14;
    linkTextField.returnKeyType = UIReturnKeyDone;
    linkTextField.layer.masksToBounds = YES;
    linkTextField.layer.cornerRadius = 2;
    linkTextField.layer.borderWidth = 0.5;
    linkTextField.layer.borderColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0].CGColor;
    linkTextField.delegate =self;
    linkTextField.backgroundColor = WHITE_CLOCLOR;
    if ([self.type integerValue] == 1) {
        linkTextField.placeholder = @"请输入文章链接";
    }
    else if ([self.type integerValue] == 3) {
        linkTextField.placeholder = @"请输入活动链接";
    }
    else {
        linkTextField.placeholder = @"请输入课表链接";
    }
    [scroll addSubview:linkTextField];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(15, 194, SCREEN_WIDTH - 30, 40);
    sendButton.backgroundColor = MAIN_COLOR_YELLOW;
    [sendButton setTitle:@"发布" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendButton.layer.masksToBounds = YES;
    sendButton.layer.cornerRadius = 2;
    [sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:sendButton];
    
    tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 132.5, 254, 265, 256.5)];
    tipImageView.image = [UIImage imageNamed:@"getlink_tip"];
    [scroll addSubview:tipImageView];
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([@"\n" isEqualToString:string]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)sendClick{
    if ([Util isEmpty:titleTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"先输入文章标题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        if (titleTextField.text.length > 30) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"标题大于30字了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            if ([Util isEmpty:linkTextField.text]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入链接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:userInfo.userid forKey:@"userid"];
                [dic setObject:userInfo.usertoken forKey:@"usertoken"];
                [dic setObject:self.type forKey:@"type"];
                [dic setObject:self.club_id forKey:@"clubid"];
                [dic setObject:titleTextField.text forKey:@"title"];
                [dic setObject:linkTextField.text forKey:@"url"];
                if ([self.type integerValue] == 1) {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }
                else if ([self.type integerValue] == 3) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                }
                
                [ClubRequest clubCreamCreateWith:dic success:^(id response) {
                    if ([[response objectForKey:@"state"] integerValue] == 1000) {
                        NSLog(@"发布成功");
                        if ([self.type integerValue] == 1) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"createcreamsuccess" object:@YES];
                        }
                        else if ([self.type integerValue] == 2){
                        }
                        else {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"createactivitysuccess" object:@YES];
                        }
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
