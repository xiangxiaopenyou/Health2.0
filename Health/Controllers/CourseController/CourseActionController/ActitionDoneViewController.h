//
//  ActitionDoneViewController.h
//  Health
//
//  Created by cheng on 15/3/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActitionDoneViewController : UIViewController


@property (nonatomic,strong) Course *course;
@property (nonatomic,strong) NSArray *courseSubArray;
@property (nonatomic,strong) NSNumber *actionOfDay;

@property (nonatomic,strong) UILabel *markLabel;
@property (nonatomic,strong) IBOutlet UIImageView *imageview;
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UILabel *contentLabel;

- (IBAction)clickShared:(id)sender;

@end
