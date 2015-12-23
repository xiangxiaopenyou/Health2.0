//
//  StudentInfoTableViewCell.h
//  Health
//
//  Created by cheng on 15/3/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentInfoTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *student_nameLabel;
@property (nonatomic,strong) IBOutlet UILabel *student_ageLabel;
@property (nonatomic,strong) IBOutlet UILabel *student_intrduceLabel;
@property (nonatomic,strong) IBOutlet UIImageView *student_teacherPhoto;
@property (nonatomic,strong) IBOutlet UIImageView *student_teachersex;

@end
