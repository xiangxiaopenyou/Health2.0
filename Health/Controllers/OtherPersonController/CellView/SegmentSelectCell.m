//
//  SegmentSelectCell.m
//  Health
//
//  Created by cheng on 15/3/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "SegmentSelectCell.h"

@implementation SegmentSelectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Index:(NSInteger)index{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.photoBtn.frame = CGRectMake(16, 14, SCREEN_WIDTH/2-32, 30);
        [self.photoBtn addTarget:self action:@selector(clickPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [self.photoBtn setTitle:@"照片" forState:UIControlStateNormal];
        [self.photoBtn setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
        self.photoBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [self addSubview:self.photoBtn];
        
        self.trainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.trainBtn.frame = CGRectMake(SCREEN_WIDTH/2+16, 14, SCREEN_WIDTH/2-32, 30);
        [self.trainBtn addTarget:self action:@selector(clickTrain:) forControlEvents:UIControlEventTouchUpInside];
        [self.trainBtn setTitle:@"训练营" forState:UIControlStateNormal];
        [self.trainBtn setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
        self.trainBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [self addSubview:self.trainBtn];
        
        self.markLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4 - 16, 40, 32, 4)];
        self.markLabel.backgroundColor = MAIN_COLOR_YELLOW;
        if (index !=1) {
            self.markLabel.frame = CGRectMake(3*SCREEN_WIDTH/4 - 16, 40, 32, 4);
            [self.trainBtn setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
            [self.photoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [self addSubview:self.markLabel];
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
- (void)clickPhoto:(id)sender{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.markLabel.frame = CGRectMake(SCREEN_WIDTH/4 - 16, 40, 32, 4);
    }completion:^(BOOL finished) {
        self.markLabel.frame = CGRectMake(SCREEN_WIDTH/4 - 16, 40, 32, 4);
        [self.photoBtn setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
        [self.trainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (self.selectIndex !=nil) {
            self.selectIndex(1);
        }
    }];
}

- (void)clickTrain:(id)sender{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.markLabel.frame = CGRectMake(3*SCREEN_WIDTH/4 - 16, 40, 32, 4);
    }completion:^(BOOL finished) {
        self.markLabel.frame = CGRectMake(3*SCREEN_WIDTH/4 - 16, 40, 32, 4);
        [self.trainBtn setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
        [self.photoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (self.selectIndex !=nil) {
            self.selectIndex(2);
        }
    }];
}

- (void)selectIndex:(ClickSegment)select{
    self.selectIndex = select;
}

@end
