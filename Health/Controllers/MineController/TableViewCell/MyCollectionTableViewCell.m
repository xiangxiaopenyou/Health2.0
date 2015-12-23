//
//  MyCollectionTableViewCell.m
//  Health
//
//  Created by 王杰 on 15/2/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MyCollectionTableViewCell.h"

@implementation MyCollectionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imageCollection = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, SCREEN_WIDTH/3*2-20)];
    self.imageCollection.image = [UIImage imageNamed:@"training"];
    [self addSubview:self.imageCollection];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
