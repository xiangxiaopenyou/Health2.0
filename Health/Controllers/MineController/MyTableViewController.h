//
//  MyTableViewController.h
//  Health
//
//  Created by 王杰 on 15/1/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface MyTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) NSArray *infoArray;
@property (nonatomic,strong) NSArray *imageArray;

@end
