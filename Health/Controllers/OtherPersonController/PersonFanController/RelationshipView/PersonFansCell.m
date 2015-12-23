//
//  PersonFansCell.m
//  Health
//
//  Created by cheng on 15/3/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PersonFansCell.h"

@implementation PersonFansCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imagePortrait = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.imagePortrait.image = [UIImage imageNamed:@"training"];
        [self.imagePortrait.layer setCornerRadius:CGRectGetHeight([self.imagePortrait bounds]) / 2];
        self.imagePortrait.layer.masksToBounds = YES;
        [self addSubview:self.imagePortrait];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 12, SCREEN_WIDTH-60-100, 21)];
        self.nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.nameLabel];
        
        self.imageSex = [[UIImageView alloc]initWithFrame:CGRectMake(60, 40, 13, 13)];
        self.imageSex.image = [UIImage imageNamed:@"msex1"];
        [self addSubview:self.imageSex];
        
        self.ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 38, 80, 21)];
        self.ageLabel.font = SMALLFONT_14;
        self.ageLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.ageLabel];
        
        self.btnFocus = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 15, 80, 30)];
        [self.btnFocus setBackgroundImage:[UIImage imageNamed:@"addfocus"] forState:UIControlStateNormal];
        [self.btnFocus addTarget:self action:@selector(setFocus:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnFocus];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 59.5, SCREEN_WIDTH - 10, 0.5)];
        line.backgroundColor = LINE_COLOR_GARG;
        [self addSubview:line];
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

- (void)setFocus:(id)sender{
    if (self.click != nil) {
        self.click(1);
    }
}

- (void)clickAttention:(ClickAttention)clickItem{
    self.click = clickItem;
}

@end
