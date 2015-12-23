//
//  CourseDetailHeaderView.h
//  Health
//
//  Created by realtech on 15/5/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailHeaderView : UIView

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UILabel *coursenameLabel;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UILabel *daysLabel;
@property (nonatomic, strong) UIImageView *difficultyImage;
@property (nonatomic, strong) UILabel *difficultyLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *oldPriceLabel;
@property (nonatomic, strong) UILabel *starttimeLabel;
@property (nonatomic, strong) UILabel *joinMemberLabel;

- (id)initWithFrame:(CGRect)frame withData:(Course*)course;

@end
