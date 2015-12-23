//
//  CourseImageTableViewCell.h
//  Health
//
//  Created by cheng on 15/1/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseImageTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIImageView *course_image;
@property (nonatomic,strong) IBOutlet UILabel *course_date;
@property (nonatomic,strong) IBOutlet UILabel *course_oldPrice;
@property (nonatomic,strong) IBOutlet UILabel *course_price;

@property (nonatomic,strong) IBOutlet UILabel *course_title;
@property (nonatomic,strong) IBOutlet UILabel *course_count;

@property (nonatomic,strong) IBOutlet UIImageView *course_state;
- (float)getHight;
@end
