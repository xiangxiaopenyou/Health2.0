//
//  CourseDetailsViewController.h
//  Health
//
//  Created by realtech on 15/4/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    UITableView *detailTableView;
}

@property (nonatomic, strong) Course *course;
@property (nonatomic, strong) NSString *courseid;


@end
