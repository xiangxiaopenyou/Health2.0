//
//  AttentionCell.m
//  Health
//
//  Created by cheng on 15/3/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "AttentionCell.h"

@implementation AttentionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.attentionBtn.frame = CGRectMake(SCREEN_WIDTH/2 - 42, 5, 84, 30);
        [self.attentionBtn addTarget:self action:@selector(clickAttention:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.attentionBtn];
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

- (IBAction)clickMessage:(id)sender{
    if (self.click !=nil) {
        self.click(1);
    }
}
- (void)clickAttention:(id)sender{
    if (self.click != nil) {
        self.click(2);
    }
}

- (void)attention:(AttentionClick)clickItem{
    self.click = clickItem;
}
@end
