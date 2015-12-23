//
//  MyHomeViewController.h
//  Health
//
//  Created by realtech on 15/4/8.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    UIView *viewForTable;
    UITableView *myTableView;
    UITableView *dairyTableView;
    
    UILabel *clockinDaysLabel;
    UILabel *nowWeightLabel;
    UILabel *targetWeightLabel;
    UILabel *reducedWeightLabel;
    UILabel *consumeEnergyLabel;
    UILabel *englobeEnergyLabel;
    UIImageView *consumeImage;
    UIImageView *englobeImage;
    UITextField *_heightText;
    UITextField *causetext1;
    UITextField *causetext2;
    UserInfo *userinfo;
    UIView *causeView;
    UIView *nowView;
    
    
}
@property (nonatomic, strong) UIButton *chooseDairyButton;
@property (nonatomic, strong) UIButton *chooseMineButton;

@end
