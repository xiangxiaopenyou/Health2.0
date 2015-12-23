//
//  SquareHomeViewController.h
//  Health
//
//  Created by realtech on 15/4/14.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareHomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    UITableView *courseTableView;
    UITableView *clubTableView;
    
    Course *selectedCourse;
}
@property (nonatomic, strong)UIButton *courseItemButton;
@property (nonatomic, strong)UIButton *clubItemButton;

@end
