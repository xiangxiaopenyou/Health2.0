//
//  PersonFansViewController.h
//  Health
//
//  Created by cheng on 15/3/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonFansViewController : UIViewController

@property (nonatomic,assign) NSInteger flagIndex;//1表示我的粉丝 2表示他人的粉丝
@property (nonatomic,strong) NSString *personid;

@property (nonatomic,strong) UITableView *tableview;

@end
