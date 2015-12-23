//
//  CourseIntroductionCell.h
//  Health
//
//  Created by realtech on 15/5/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseIntroductionCell : UITableViewCell

@property (nonatomic, strong) UILabel *introLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIntro:(NSString*)introString withIntroImage:(NSString*)imageString;

@end
