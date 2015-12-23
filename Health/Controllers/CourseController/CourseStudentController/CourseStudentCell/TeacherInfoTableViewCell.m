//
//  TeacherInfoTableViewCell.m
//  Health
//
//  Created by cheng on 15/3/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "TeacherInfoTableViewCell.h"

@implementation TeacherInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.course_teacherPhoto.layer.cornerRadius = self.course_teacherPhoto.frame.size.width/2;
    self.course_teacherPhoto.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
