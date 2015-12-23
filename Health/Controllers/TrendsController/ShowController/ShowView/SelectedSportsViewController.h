//
//  SelectedSportsViewController.h
//  Health
//
//  Created by realtech on 15/4/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedSportsViewController : UIViewController{
    UITableView *selectedTableview;
}

@property (nonatomic, strong) NSArray *sportsArray;
@property (nonatomic, assign) NSInteger energyCount;

@end
