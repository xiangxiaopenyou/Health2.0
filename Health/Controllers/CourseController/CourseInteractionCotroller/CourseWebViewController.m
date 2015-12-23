//
//  CourseWebViewController.m
//  Health
//
//  Created by realtech on 15/4/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseWebViewController.h"

@interface CourseWebViewController ()<UIWebViewDelegate>{
    UIActivityIndicatorView *indicatorView;
}

@end

@implementation CourseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    courseWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    courseWeb.delegate = self;
    [self.view addSubview:courseWeb];
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 25, SCREEN_HEIGHT/2 - 100, 50, 50)];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:indicatorView];
    NSArray *urlArray = [self.urlString componentsSeparatedByString:@"://"];
    NSString *requestString = nil;
    if (urlArray.count > 1) {
        requestString = self.urlString;
    }
    else{
        requestString = [NSString stringWithFormat:@"http://%@", self.urlString];
    }
    NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    [courseWeb loadRequest:webRequest];
    
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
