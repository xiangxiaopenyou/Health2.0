//
//  CoachAppraiseTableViewCell.m
//  Health
//
//  Created by realtech on 15/5/13.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CoachAppraiseTableViewCell.h"

@implementation CoachAppraiseTableViewCell
@synthesize scoreImage, attitudeScoreLabel, skillScoreLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 18, 30, 16)];
        label.text = @"总评:";
        label.textColor = WHITE_CLOCLOR;
        label.font = SMALLFONT_12;
        [self addSubview:label];
        
        scoreImage = [[UIImageView alloc]initWithFrame:CGRectMake(40, 18.5, 98, 15)];
        //scoreImage.image = [UIImage imageNamed:@"appraise_5"];
        [self addSubview:scoreImage];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 52, 60, 16)];
        label1.text = @"教学态度:";
        label1.textColor = WHITE_CLOCLOR;
        label1.font = SMALLFONT_12;
        [self addSubview:label1];
        
        attitudeScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 52, 30, 16)];
        attitudeScoreLabel.font = SMALLFONT_12;
        attitudeScoreLabel.text = @"4.9分";
        attitudeScoreLabel.textColor = MAIN_COLOR_YELLOW;
        [self addSubview:attitudeScoreLabel];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 52, 60, 16)];
        label2.text = @"专业技能:";
        label2.font = SMALLFONT_12;
        label2.textColor = WHITE_CLOCLOR;
        [self addSubview:label2];
        
        skillScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+60, 52, 30, 16)];
        skillScoreLabel.text = @"4.9分";
        skillScoreLabel.font = SMALLFONT_12;
        skillScoreLabel.textColor = MAIN_COLOR_YELLOW;
        [self addSubview:skillScoreLabel];
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
