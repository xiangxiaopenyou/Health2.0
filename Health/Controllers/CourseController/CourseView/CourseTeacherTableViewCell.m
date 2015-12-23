//
//  CourseTeacherTableViewCell.m
//  Health
//
//  Created by cheng on 15/1/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseTeacherTableViewCell.h"

@implementation CourseTeacherTableViewCell

@synthesize course_intrduceview, course_nameLabel, course_ageLabel, course_intrduceLabel, course_teacherPhoto, course_pointStudent, course_pointSystem, course_teachersex, teacher_button;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *teacher = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        teacher.text = @"教练简介";
        teacher.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:teacher];
        
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 161)];
        mainView.backgroundColor = [UIColor clearColor];
        [self addSubview:mainView];
        
        course_teacherPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 44, 44)];
        course_teacherPhoto.layer.cornerRadius = self.course_teacherPhoto.frame.size.width/2;
        course_teacherPhoto.layer.masksToBounds = YES;
        [mainView addSubview:course_teacherPhoto];
        
        course_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 8, 200, 21)];
        course_nameLabel.font = [UIFont boldSystemFontOfSize:16];
        [mainView addSubview:course_nameLabel];
        
        course_teachersex = [[UIImageView alloc] initWithFrame:CGRectMake(60, 34, 15, 15)];
        [mainView addSubview:course_teachersex];
        
        course_ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(83, 31, 50, 21)];
        course_ageLabel.font = SMALLFONT_14;
        [mainView addSubview:course_ageLabel];
        
        teacher_button = [UIButton buttonWithType:UIButtonTypeCustom];
        teacher_button.frame = CGRectMake(SCREEN_WIDTH - 98, 8, 90, 30);
        [teacher_button setBackgroundImage:[UIImage imageNamed:@"course_teacher_image.png"] forState:UIControlStateNormal];
        [teacher_button addTarget:self action:@selector(clickTeacher:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:teacher_button];
        
        //course_intrduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)];
        
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    
    
    
}

- (void)clickTeacher:(id)sender{
    if (self.click != nil) {
        self.click();
    }
}

- (void)clickBlockTeacher:(ClickTeacher)clickItem{
    self.click = clickItem;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
