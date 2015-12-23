//
//  ClubCurriculumViewController.m
//  Health
//
//  Created by realtech on 15/5/21.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClubCurriculumViewController.h"
#import "CreateCurriculumViewController.h"

@interface ClubCurriculumViewController (){
    UserInfo *userInfo;
    
    NSString *urlString;
    
    UIActivityIndicatorView *indicatorView;
}

@end

@implementation ClubCurriculumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createCurriculumSuccess) name:@"createcurriculumsuccess" object:nil];
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"课程表"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    if ([self.user_type integerValue] != 0) {
        UIButton *curriculumCreateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        curriculumCreateButton.frame = CGRectMake(SCREEN_WIDTH - 65, 22, 60, 40);
        [curriculumCreateButton setTitle:@"创建课表" forState:UIControlStateNormal];
        [curriculumCreateButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
        curriculumCreateButton.titleLabel.font = SMALLFONT_14;
        [curriculumCreateButton addTarget:self action:@selector(curriculumCreateClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:curriculumCreateButton];
    }
    
    web = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    web.delegate = self;
    [self.view addSubview:web];
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 25, SCREEN_HEIGHT/2 - 100, 50, 50)];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:indicatorView];
    
    [self getCurriculum];
    

}
- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)curriculumCreateClick{
    CreateCurriculumViewController *controller = [[CreateCurriculumViewController alloc] init];
    controller.club_id = self.club_id;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)getCurriculum{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:self.club_id forKey:@"clubid"];
    [ClubRequest clubCurriculumWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSArray *tempArray = [response objectForKey:@"data"];
            if (tempArray.count > 0) {
                urlString = [[tempArray objectAtIndex:0] objectForKey:@"url"];
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
                [web loadRequest:request];
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)createCurriculumSuccess{
    [self getCurriculum];
}

#pragma mark - UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [indicatorView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [indicatorView stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"加载失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [indicatorView stopAnimating];
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
