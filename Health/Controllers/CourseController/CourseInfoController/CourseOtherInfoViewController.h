//
//  CourseOtherInfoViewController.h
//  Health
//
//  Created by cheng on 15/3/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseOtherInfoViewController : UIViewController

@property (nonatomic,strong) Course *course;

@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UILabel *contentLabel;
@property (nonatomic,strong) IBOutlet UIImageView *fatImage;
@property (nonatomic,strong) IBOutlet UIImageView *shapingImage;
@property (nonatomic,strong) IBOutlet UIImageView *strengthImage;
@property (nonatomic,strong) IBOutlet UIImageView *powerImage;
@property (nonatomic,strong) IBOutlet UIImageView *difficultyImage;

- (IBAction)dismissController:(id)sender;

@end
