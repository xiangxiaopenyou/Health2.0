//
//  CourseImageTableViewCell.m
//  Health
//
//  Created by cheng on 15/1/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseImageTableViewCell.h"

@implementation CourseImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
//    self.course_image.frame = CGRectMake(self.course_image.frame.origin.x, self.course_image.frame.origin.y, self.course_image.frame.size.width, self.course_image.frame.size.width*9/16);
//    NSLog(@"%f %f",self.course_image.frame.size.width,self.course_image.frame.size.height);
    self.course_image.frame = CGRectMake(self.course_image.frame.origin.x, self.course_image.frame.origin.y, self.course_image.frame.size.width, self.course_image.frame.size.width*9/16);
}
- (float)getHight{
    return self.course_image.frame.size.height+40;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
