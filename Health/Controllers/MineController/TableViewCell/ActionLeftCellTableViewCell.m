//
//  ActionLeftCellTableViewCell.m
//  Health
//
//  Created by 王杰 on 15/2/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ActionLeftCellTableViewCell.h"

@implementation ActionLeftCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:252/255.0 green:84/255.0 blue:13/255.0 alpha:1.0];
    }else{
        self.backgroundColor = [UIColor clearColor];
    }

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 24.5, 70, 21)];
        self.infoLabel.textColor = [UIColor whiteColor];
        self.infoLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [self addSubview:self.infoLabel];
    
        self.infoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(250-50, 10, 40, 45)];
        [self addSubview:self.infoImageView];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithRed:252/255.0 green:84/255.0 blue:13/255.0 alpha:1.0];
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
