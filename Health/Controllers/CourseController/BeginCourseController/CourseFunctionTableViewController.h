//
//  CourseFunctionTableViewController.h
//  Health
//
//  Created by cheng on 15/1/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseFunctionTableViewController : UIViewController{
    NSMutableArray *actionCourseSub;
    NSNumber *actionofDay;
}

@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) Course *course;
@property (nonatomic,strong) NSString *courseid;

- (IBAction)clickStudent:(id)sender;

@end
