//
//  FourthViewController.m
//  Health
//
//  Created by realtech on 15/6/1.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "FourthViewController.h"
#import "MyInfoRequest.h"

@interface FourthViewController (){
    UIScrollView *scrollView;
    NSMutableArray *imageArray;
    
    UIButton *nextButton;
    
    UserInfo *userInfo;
}

@end

@implementation FourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 44- NAVIGATIONBAR_HEIGHT)];
    scrollView.backgroundColor = CLEAR_COLOR;
    [self.view addSubview:scrollView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    title.text = @"你感兴趣的";
    title.font = [UIFont systemFontOfSize:17];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = WHITE_CLOCLOR;
    [scrollView addSubview:title];
    
    for (int i = 0; i < 5; i ++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 100, 48 + i *68, 200, 62)];
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"like_not_selected_%d", i]];
        image.tag = i + 10;
        image.userInteractionEnabled = YES;
        [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePress:)]];
        [scrollView addSubview:image];
    }
    imageArray = [[NSMutableArray alloc] init];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44);
    [nextButton setTitle:@"完成" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor colorWithRed:29/255.0 green:28/255.0 blue:36/255.0 alpha:1.0] forState:UIControlStateNormal];
    nextButton.backgroundColor = MAIN_COLOR_YELLOW;
    nextButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
}

- (void)imagePress:(UITapGestureRecognizer*)gesture {
    UIImageView *image = (UIImageView*)gesture.view;
    NSString *tagString = [NSString stringWithFormat:@"%ld", (long)image.tag];
    if ([imageArray containsObject:tagString]) {
        [imageArray removeObject:tagString];
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"like_not_selected_%ld", image.tag - 10]];
    }
    else {
        [imageArray addObject:tagString];
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"like_selected_%ld", image.tag - 10]];
    }
}
- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextClick{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:userInfo.usersex forKey:@"usersex"];
    [dic setObject:userInfo.userbirthday forKey:@"userbirthday"];
    [dic setObject:userInfo.userheight forKey:@"userheight"];
    [dic setObject:userInfo.userweight forKey:@"userweight"];
    [dic setObject:userInfo.usertargetweight forKey:@"weight"];
    [dic setObject:userInfo.usersycle forKey:@"duration"];
    NSArray *array = [NSArray arrayWithArray:imageArray];
    if (array.count != 0) {
        NSString *likeString = @"";
        for (int i = 0; i < array.count; i ++) {
            NSString *string = [array objectAtIndex:i];
            likeString =  [likeString stringByAppendingString:string];
            likeString = [likeString stringByAppendingString:@";"];
        }
        likeString = [likeString substringWithRange:NSMakeRange(0, likeString.length - 1)];
        [dic setObject:likeString forKey:@"points"];
    }
    [MyInfoRequest modifyMyInfoWithParam:dic success:^(id response) {
        
    } failure:^(NSError *error) {
    }];
    UserInfo *user = [UserInfo MR_findFirstByAttribute:@"userid" withValue:userInfo.userid];
    user.isnewuser = @"1";
    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isnewuser"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:@YES];
    
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
