//
//  CourseInfomationViewController.h
//  Health
//
//  Created by realtech on 15/5/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseInfomationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *infoTableView;
}

@property (nonatomic, strong) Course *course_info;

@end
