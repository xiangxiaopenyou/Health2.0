//
//  PicAndTrainCell.m
//  Health
//
//  Created by 王杰 on 15/1/31.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PicAndTrainCell.h"

#define MARKLABEL_COLOR [UIColor colorWithRed:32/255.0 green:120/255.0 blue:151/255.0 alpha:1.0]
#define NOTSELECT_COLOR [UIColor colorWithRed:92/255.0 green:92/255.0 blue:92/255.0 alpha:1.0]

@implementation PicAndTrainCell

- (void)awakeFromNib {
    // Initialization code
  
 
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.pictureLabel = [[UIButton alloc]initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH/2, 40)];
        [self.pictureLabel setTitle:@"照片" forState:UIControlStateNormal];
        [self.pictureLabel setTitleColor:MARKLABEL_COLOR forState:UIControlStateNormal];
        [self.pictureLabel addTarget:self action:@selector(btnPic:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.pictureLabel];
        
        self.trainLabel = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 40)];
        [self.trainLabel setTitleColor:NOTSELECT_COLOR forState:UIControlStateNormal];
        [self.trainLabel setTitle:@"训练营" forState:UIControlStateNormal];
        [self.trainLabel addTarget:self action:@selector(btnTrain:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.trainLabel];
        
        self.markLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 36, SCREEN_WIDTH/2-20, 4)];
        self.markLabel.backgroundColor = [UIColor colorWithRed:32/255.0 green:120/255.0 blue:151/255.0 alpha:1.0];
        [self addSubview:self.markLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)btnPic:(UIButton*)sender {
    [self.pictureLabel setTitleColor:MARKLABEL_COLOR forState:UIControlStateNormal];
    [self.trainLabel setTitleColor:NOTSELECT_COLOR forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        self.markLabel.frame = CGRectMake(10, 36, SCREEN_WIDTH/2-20, 4);
        
    }];
    [self.delegate clickChangePic:0];
    
}

- (void)btnTrain:(UIButton*)sender {
    [self.trainLabel setTitleColor:MARKLABEL_COLOR forState:UIControlStateNormal];
    [self.pictureLabel setTitleColor:NOTSELECT_COLOR forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        self.markLabel.frame = CGRectMake(SCREEN_WIDTH/2+10, 36, SCREEN_WIDTH/2-20, 4);
    }];
    [self.delegate clickChangePic:1];
}


@end
