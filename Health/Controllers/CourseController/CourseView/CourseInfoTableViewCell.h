//
//  CourseInfoTableViewCell.h
//  Health
//
//  Created by cheng on 15/1/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseInfoTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIView *course_backView;
@property (nonatomic,strong) IBOutlet UILabel *course_contentLabel;
@property (nonatomic,strong) IBOutlet UIImageView *course_fatcost;
@property (nonatomic,strong) IBOutlet UIImageView *course_tough;
@property (nonatomic,strong) IBOutlet UIImageView *course_power;
@property (nonatomic,strong) IBOutlet UIImageView *course_muscle;
@property (nonatomic,strong) IBOutlet UIImageView *course_difficult;

@end
