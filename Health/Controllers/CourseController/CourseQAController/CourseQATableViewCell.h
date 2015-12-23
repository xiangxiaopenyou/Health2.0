//
//  CourseQATableViewCell.h
//  Health
//
//  Created by cheng on 15/2/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseQAEntity.h"

@interface CourseQATableViewCell : UITableViewCell{
    CourseQAEntity *courseQAEntity;
    UILabel *questionLabel;
    UILabel *answerContent;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Data:(CourseQAEntity*)entity;
- (float)getHeight;
@end
