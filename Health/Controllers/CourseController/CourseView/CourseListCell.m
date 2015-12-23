//
//  CourseListCell.m
//  Health
//
//  Created by cheng on 15/1/24.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseListCell.h"

@implementation CourseListCell

@synthesize titleLabel, dateLabel, countLabel, image_view, priceLabel, oldpriceLabel, stateImageView, difficultyImage, difficultyLabel, daysLabel, clubLabel, bodyLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6)];
        label1.backgroundColor = CLEAR_COLOR;
        [self addSubview:label1];
        
        image_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, SCREEN_WIDTH, SCREEN_WIDTH/2)];
        image_view.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:image_view];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 260, 29, 250, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:titleLabel];
        
        stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 40, 40)];
        stateImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:stateImageView];
        
        bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 69, 30, 16)];
        //bodyLabel.text = @"全身";
        bodyLabel.textColor = WHITE_CLOCLOR;
        bodyLabel.font = SMALLFONT_12;
        bodyLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:bodyLabel];
        
        daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 69, 35, 16)];
        daysLabel.textColor = WHITE_CLOCLOR;
        daysLabel.font = SMALLFONT_12;
        daysLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:daysLabel];
        
        difficultyImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 116, 70, 38, 14)];
        difficultyImage.image = [UIImage imageNamed:@"difficulty_easy"];
        [self addSubview:difficultyImage];
        
        difficultyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 146, 69, 29, 16)];
        //difficultyLabel.text = @"简单";
        difficultyLabel.textColor = WHITE_CLOCLOR;
        difficultyLabel.font =SMALLFONT_12;
        difficultyLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:difficultyLabel];
        
        clubLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 200, 95, 190, 20)];
        //clubLabel.text = @"918官方俱乐部";
        clubLabel.font = SMALLFONT_12;
        clubLabel.textColor = WHITE_CLOCLOR;
        clubLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:clubLabel];
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, SCREEN_WIDTH/2 - 30, 60, 25)];
        priceLabel.font = [UIFont boldSystemFontOfSize:19];
        priceLabel.textColor = [UIColor colorWithRed:240/255.0 green:131/255.0 blue:0 alpha:1.0];
        [self addSubview:priceLabel];
        
        oldpriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, SCREEN_WIDTH/2 - 30, 70, 25)];
        //oldpriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, SCREEN_WIDTH/2, 30, 50, 25)];
        oldpriceLabel.font = [UIFont boldSystemFontOfSize:19];
        oldpriceLabel.textColor = WHITE_CLOCLOR;
        [self addSubview:oldpriceLabel];
        
        UILabel *deletePrice = [[UILabel alloc] initWithFrame:CGRectMake(27, SCREEN_WIDTH/2 - 17, 44, 1)];
        deletePrice.backgroundColor = WHITE_CLOCLOR;
        [self addSubview:deletePrice];
        
        UIImageView *countImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 67, SCREEN_WIDTH/2 - 24, 12, 12)];
        countImage.image = [UIImage imageNamed:@"home_count_image.png"];
        [self addSubview:countImage];
        
        countLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 55, SCREEN_WIDTH/2 - 26, 45, 16)];
        countLabel.font = SMALLFONT_12;
        countLabel.textColor = WHITE_CLOCLOR;
        countLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:countLabel];
        
        UIImageView *dateImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 165, SCREEN_WIDTH/2 - 24, 12, 12)];
        dateImage.image = [UIImage imageNamed:@"home_date_image.png"];
        [self addSubview:dateImage];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 148, SCREEN_WIDTH/2 - 26, 76, 16)];
        dateLabel.font = SMALLFONT_14;
        dateLabel.textColor = WHITE_CLOCLOR;
        dateLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:dateLabel];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
