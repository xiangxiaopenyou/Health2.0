//
//  CourseQAController.h
//  Health
//
//  Created by cheng on 15/3/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseQAController : UIViewController

@property (nonatomic,strong) Course *course;
@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UIButton *commentButton;

- (void)questionSend:(id)sender;


@end
