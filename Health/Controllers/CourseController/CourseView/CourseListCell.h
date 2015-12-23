//
//  CourseListCell.h
//  Health
//
//  Created by cheng on 15/1/24.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseListCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) UIImageView *image_view;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *oldpriceLabel;
@property (nonatomic,strong) UIImageView *stateImageView;
@property (nonatomic, strong) UILabel *difficultyLabel;
@property (nonatomic, strong) UIImageView *difficultyImage;
@property (nonatomic, strong) UILabel *daysLabel;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UILabel *clubLabel;

@end
