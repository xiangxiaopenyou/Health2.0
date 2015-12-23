//
//  PersonDetailInfoViewController.h
//  Health
//
//  Created by cheng on 15/3/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonEntity.h"

@interface PersonDetailInfoViewController : UIViewController

@property (nonatomic,strong) PersonEntity *personInfo;

@property (nonatomic,strong) UITableView *tableview;

@end
