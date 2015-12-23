//
//  FansCell.m
//  Health
//
//  Created by 王杰 on 15/1/31.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "FansCell.h"

@implementation FansCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imagePortrait = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.imagePortrait.image = [UIImage imageNamed:@"training"];
        [self.imagePortrait.layer setCornerRadius:CGRectGetHeight([self.imagePortrait bounds]) / 2];
        self.imagePortrait.layer.masksToBounds = YES;
        [self addSubview:self.imagePortrait];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 12, 60, 21)];
        self.nameLabel.text = @"鬼见愁";
        self.nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.nameLabel];
        
        self.imageSex = [[UIImageView alloc]initWithFrame:CGRectMake(80, 40, 13, 13)];
        self.imageSex.image = [UIImage imageNamed:@"msex1"];
        [self addSubview:self.imageSex];
        
        NSString *string = @"22岁";
        CGSize size = [string sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SMALLFONT_14, NSFontAttributeName, nil]];
        self.ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 38, 40, size.height)];
        self.ageLabel.text = string;
        self.ageLabel.font = SMALLFONT_14;
        self.ageLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.ageLabel];
        
        self.btnFocus = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 15, 80, 30)];
        [self.btnFocus setBackgroundImage:[UIImage imageNamed:@"addfocus"] forState:UIControlStateNormal];
        [self.btnFocus addTarget:self action:@selector(setFocus:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnFocus];
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

- (void) setFocus:(UIButton *)sender{
    if (self.isFocused) {
        [self.delegate fanDele:self.fansid];
    } else {
        [self.delegate fanCreate:self.fansid];

    }
}

@end
