//
//  PeosonInfoCell.m
//  Health
//
//  Created by cheng on 15/3/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PeosonInfoCell.h"

@implementation PeosonInfoCell

- (void)awakeFromNib {
    // Initialization code
    
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 3;
    
    self.photoImage.layer.masksToBounds = YES;
    self.photoImage.layer.cornerRadius = 30;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPhoto)];
    self.photoImage.userInteractionEnabled = YES;
    [self.photoImage addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPersonAttention)];
    self.attentionLabel.userInteractionEnabled = YES;
    [self.attentionLabel addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPersonFans)];
    self.fansLabel.userInteractionEnabled = YES;
    [self.fansLabel addGestureRecognizer:tap2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)clickPersonAttention{
    if (self.click != nil) {
        self.click(1);
    }
}

- (void)clickPersonFans{
    
    if (self.click != nil) {
        self.click(2);
    }
}

- (void)clickPhoto{
    if (self.click != nil) {
        self.click(3);
    }
}

- (void)clickLabel:(Click)clickItem{
    self.click = clickItem;
}

@end
