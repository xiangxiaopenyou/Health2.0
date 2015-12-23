//
//  PersonPhotoCell.m
//  Health
//
//  Created by cheng on 15/3/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PersonPhotoCell.h"

@implementation PersonPhotoCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLeft:)];
        self.leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, (SCREEN_WIDTH-30)/2, (SCREEN_WIDTH-30)*150/(2*145))];
        [self.leftImage addGestureRecognizer:tap];
        self.leftImage.userInteractionEnabled = YES;
        [self addSubview:self.leftImage];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickRight)];
        self.rightImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/2+20, 8, (SCREEN_WIDTH-30)/2, (SCREEN_WIDTH-30)*150/(2*145))];
        [self.rightImage addGestureRecognizer:tap1];
        self.rightImage.userInteractionEnabled = YES;
        [self addSubview:self.rightImage];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)clickLeft:(UIGestureRecognizer*)gesture{
    if (self.clickItem != nil) {
        self.clickItem(1);
    }
}

- (void)clickRight{
    if (self.clickItem != nil) {
        self.clickItem(2);
    }
}

- (void)clickImage:(ClickPhoto)click{
    self.clickItem = click;
}

@end
