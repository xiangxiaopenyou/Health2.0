//
//  AppraiseListTableViewCell.m
//  Health
//
//  Created by realtech on 15/5/13.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "AppraiseListTableViewCell.h"

@implementation AppraiseListTableViewCell
@synthesize nicknameLabel, scoreImage, timeLabel, appraiseLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, SCREEN_WIDTH - 20, 16)];
        nicknameLabel.text = @"VC爱健身";
        nicknameLabel.font = SMALLFONT_14;
        nicknameLabel.textColor = WHITE_CLOCLOR;
        [self addSubview:nicknameLabel];
        
        scoreImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 42, 98, 15)];
        scoreImage.image = [UIImage imageNamed:@"appraise_5"];
        [self addSubview:scoreImage];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150, 42, 140, 15)];
        timeLabel.text = @"11-23 06:06";
        timeLabel.font = SMALLFONT_12;
        timeLabel.textColor = TIME_COLOR_GARG;
        timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:timeLabel];
        
        appraiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 68, SCREEN_WIDTH - 20, 20)];
        appraiseLabel.text = @"拉萨的恢复快速的减肥了双方";
        appraiseLabel.font = SMALLFONT_12;
        appraiseLabel.textColor = WHITE_CLOCLOR;
        appraiseLabel.numberOfLines = 0;
        appraiseLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:appraiseLabel];
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
