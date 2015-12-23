//
//  FocusImageViewController.m
//  Health
//
//  Created by realtech on 15/5/27.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "FocusImageViewController.h"
#import "ShowTrendsViewController.h"

@interface FocusImageViewController (){
    UIActivityIndicatorView *indicatorView;
}

@end

@implementation FocusImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    web = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    if ([self.type  integerValue] == 1) {
        web.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT);
        UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        joinButton.frame = CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT, SCREEN_WIDTH, TABBAR_HEIGHT);
        joinButton.backgroundColor = MAIN_COLOR_YELLOW;
        [joinButton setTitle:@"立即参与" forState:UIControlStateNormal];
        [joinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [joinButton addTarget:self action:@selector(joinClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:joinButton];
    }
    web.delegate = self;
    [self.view addSubview:web];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 25, SCREEN_HEIGHT/2 - 100, 50, 50)];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:indicatorView];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    [web loadRequest:request];
    
}
- (void)joinClick{
    ShowTrendsViewController *controller = [[ShowTrendsViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
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
