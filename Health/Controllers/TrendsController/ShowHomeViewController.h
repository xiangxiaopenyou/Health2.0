//
//  ShowHomeViewController.h
//  Health
//
//  Created by realtech on 15/4/23.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowHomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    
    UIView *viewForTable;
    UITableView *recentTableView;
    UITableView *clockinTableView;
    UITableView *recommendTableView;
    
    BOOL _reloading;
}

@property (nonatomic, strong) UIButton *recentButton;
@property (nonatomic, strong) UIButton *clockinButton;
@property (nonatomic, strong) UIButton *recommendButton;

@end
