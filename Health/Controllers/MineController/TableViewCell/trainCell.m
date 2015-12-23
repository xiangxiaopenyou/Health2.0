//
//  PicCell.m
//  Health
//
//  Created by 王杰 on 15/1/31.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "trainCell.h"

@implementation TrainCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:32/255.0 alpha:1.0];
        self.pic1 = [[UIImageView alloc] initWithFrame: CGRectMake(10, 5, SCREEN_WIDTH - 20, SCREEN_WIDTH/2 -10)];
        self.pic1.userInteractionEnabled = YES;
        [self.contentView addSubview:self.pic1];
        self.pic2 = [[UIImageView alloc] initWithFrame: CGRectMake(10, 5, 80, 80)];
        [self.contentView addSubview:self.pic2];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
