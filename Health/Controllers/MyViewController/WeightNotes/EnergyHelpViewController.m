//
//  EnergyHelpViewController.m
//  Health
//
//  Created by realtech on 15/6/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "EnergyHelpViewController.h"

@interface EnergyHelpViewController ()

@end

@implementation EnergyHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor= TABLEVIEW_BACKGROUNDCOLOR;
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@""];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    scroll.backgroundColor = CLEAR_COLOR;
    scroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/320*758);
    [self.view addSubview:scroll];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/320*758)];
    image.image = [UIImage imageNamed:@"energy_help"];
    [scroll addSubview:image];
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
