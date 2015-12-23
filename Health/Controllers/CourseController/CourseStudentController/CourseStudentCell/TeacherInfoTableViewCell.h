//
//  TeacherInfoTableViewCell.h
//  Health
//
//  Created by cheng on 15/3/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherInfoTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *course_nameLabel;
@property (nonatomic,strong) IBOutlet UILabel *course_ageLabel;
@property (nonatomic,strong) IBOutlet UILabel *course_intrduceLabel;
@property (nonatomic,strong) IBOutlet UIImageView *course_teacherPhoto;
@property (nonatomic,strong) IBOutlet UIImageView *course_teachersex;
@property (nonatomic,strong) IBOutlet UIImageView *course_pointStudent;
@property (nonatomic,strong) IBOutlet UIImageView *course_pointSystem;
@property (nonatomic,strong) IBOutlet UIButton *teacher_button;

@end
