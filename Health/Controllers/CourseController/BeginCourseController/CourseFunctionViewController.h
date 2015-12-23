//
//  CourseFunctionViewController.h
//  Health
//
//  Created by cheng on 15/3/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseFunctionViewController : UIViewController{
    NSMutableArray *actionCourseSub;
    NSNumber *actionofDay;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) Course *course;
@property (nonatomic,strong) NSString *courseid;

@property (nonatomic, assign) BOOL isChatIn;


@end
