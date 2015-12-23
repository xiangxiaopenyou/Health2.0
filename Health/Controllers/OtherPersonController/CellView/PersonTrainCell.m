//
//  PersonTrainCell.m
//  Health
//
//  Created by cheng on 15/3/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PersonTrainCell.h"

@implementation PersonTrainCell

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage)];
    self.trainImage.userInteractionEnabled = YES;
    [self.trainImage addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)clickImage{
    if (self.click != nil) {
        self.click();
    }
}

- (void)clickImage:(ClickImage)clickItem{
    self.click = clickItem;
}

@end
