//
//  MineDetailInfoViewCell.m
//  Health
//
//  Created by 王杰 on 15/2/8.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MineDetailInfoViewCell.h"

@implementation MineDetailInfoViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.portrait = [[UIImageView alloc] initWithFrame: CGRectMake(SCREEN_WIDTH - 75, 15, 50, 50)];
        [self.portrait.layer setCornerRadius:CGRectGetHeight([self.portrait bounds]) / 2];
        self.portrait.layer.masksToBounds = YES;
        [self.contentView addSubview:self.portrait];
        self.item = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 80, 20)];
        self.item.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.item];
        self.itemValue = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, SCREEN_WIDTH -120, 20)];
        self.itemValue.textColor = [UIColor whiteColor];
        self.itemValue.textAlignment = NSTextAlignmentRight;
        self.itemValue.numberOfLines = 0;
        [self.contentView addSubview:self.itemValue];
    }
    return self;
}

@end
