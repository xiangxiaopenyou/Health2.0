//
//  WriteIntrduceViewController.m
//  Health
//
//  Created by cheng on 15/3/5.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "WriteIntrduceViewController.h"

@interface WriteIntrduceViewController ()<UITextViewDelegate>{
    UITextView *texview;
    UILabel *textnumber;
}

@end

@implementation WriteIntrduceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:self.title];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:titleLabel];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(SCREEN_WIDTH - 50, 20, 44, 44);
    [saveButton setImage:[UIImage imageNamed:@"save_myinfo_image.png"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];

    
    texview = [[UITextView alloc]initWithFrame:CGRectMake(10, NAVIGATIONBAR_HEIGHT+10, SCREEN_WIDTH - 20, SCREEN_HEIGHT- 0 - 20)];
    texview.text = self.content;
    texview.backgroundColor = CLEAR_COLOR;
    texview.font = VERDANA_FONT_14;
    texview.textColor = WHITE_CLOCLOR;
    texview.returnKeyType = UIReturnKeyDone;
    texview.delegate = self;
    [self.view addSubview:texview];
    
//    textnumber = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 10, 45, 20)];
//    textnumber.text = [NSString stringWithFormat:@"%lu/250",(unsigned long)[self.content length]];
//    textnumber.textColor = [UIColor blackColor];
//    textnumber.textAlignment = NSTextAlignmentCenter;
//    textnumber.font = VERDANA_FONT_10;
//    [self.view addSubview:textnumber];
}
- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [texview becomeFirstResponder];
}
//- (void)keyboardShow:(NSNotification *)notif {
//    
//    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat y = rect.origin.y;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.25];
//    texview.frame = CGRectMake(10, 0+10, SCREEN_WIDTH - 20, SCREEN_HEIGHT- 0 - 20-y);
//    [UIView commitAnimations];
//}

//- (void)keyboardHide:(NSNotification *)notif{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.25];
//    texview.frame = CGRectMake(10, 0+10, SCREEN_WIDTH - 20, SCREEN_HEIGHT- 0 - 20);
//    [UIView commitAnimations];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)backClick
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)saveClick
{
    NSLog(@"save");
    [texview resignFirstResponder];
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(texview.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}
-(void)viewWillDisappear:(BOOL)animated {
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([@"\n" isEqualToString:text]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
