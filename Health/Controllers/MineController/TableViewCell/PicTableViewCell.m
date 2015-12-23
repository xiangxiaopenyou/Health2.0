//
//  PicTableViewCell.m
//  Health
//
//  Created by 王杰 on 15/2/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PicTableViewCell.h"

@implementation PicTableViewCell

- (void)awakeFromNib {
    // Initialization code
   
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:32/255.0 alpha:1.0];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.img1 = [[UIImageView alloc] initWithFrame: CGRectMake(8, 6, SCREEN_WIDTH/2-12, SCREEN_WIDTH/2-12)];
        [self.img1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageleftPress:)]];
        self.img1.userInteractionEnabled = YES;
        [self.contentView addSubview:self.img1];
        self.img2 = [[UIImageView alloc] initWithFrame: CGRectMake(SCREEN_WIDTH/2+4, 6, SCREEN_WIDTH/2-12, SCREEN_WIDTH/2-12)];
        [self.img2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagerightPress:)]];
        self.img2.userInteractionEnabled = YES;
        [self.contentView addSubview:self.img2];
        
      
    }
    return self;
}
- (void)imageleftPress:(UITapGestureRecognizer *)tap {
    if (self.selectImage != nil) {
        self.selectImage(@"1");
    }
}
- (void)selectImageItem:(SelectImage)block{
    self.selectImage = block;
}

- (void)imagerightPress:(UITapGestureRecognizer *)tap {
    if (self.selectImage != nil) {
        self.selectImage(@"2");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
