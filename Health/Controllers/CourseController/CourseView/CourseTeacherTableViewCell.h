//
//  CourseTeacherTableViewCell.h
//  Health
//
//  Created by cheng on 15/1/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickTeacher)(void);

@interface CourseTeacherTableViewCell : UITableViewCell

@property (nonatomic,strong) UIView *course_intrduceview;
@property (nonatomic,strong) UILabel *course_nameLabel;
@property (nonatomic,strong) UILabel *course_ageLabel;
@property (nonatomic,strong) UILabel *course_intrduceLabel;
@property (nonatomic,strong) UIImageView *course_teacherPhoto;
@property (nonatomic,strong) UIImageView *course_teachersex;
@property (nonatomic,strong) UIImageView *course_pointStudent;
@property (nonatomic,strong) UIImageView *course_pointSystem;
@property (nonatomic,strong) UIButton *teacher_button;

@property (nonatomic,strong) ClickTeacher click;

- (IBAction)clickTeacher:(id)sender;

- (void)clickBlockTeacher:(ClickTeacher)clickItem;

@end
