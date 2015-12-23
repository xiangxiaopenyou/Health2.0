//
//  ActionRightViewCell.m
//  Health
//
//  Created by cheng on 15/1/31.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ActionRightViewCell.h"

@implementation ActionRightViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 200, 21)];
        self.title.textColor = [UIColor whiteColor];
        self.title.font = [UIFont systemFontOfSize:18];
        [self addSubview:self.title];
        
        self.intrduce = [[UILabel alloc]initWithFrame:CGRectMake(8, 38, 200, 15)];
        self.intrduce.textColor = TIME_COLOR_GARG;
        self.intrduce.font = SMALLFONT_12;
        [self addSubview:self.intrduce];
        
        self.lockImage = [[UIImageView alloc]initWithFrame:CGRectMake(250-32, 19, 22, 22)];
        [self addSubview:self.lockImage];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59.5, 250, 0.5)];
        line.backgroundColor = LINE_COLOR_GARG;
        [self addSubview:line];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.backgroundColor = MAIN_COLOR_YELLOW;
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundColor = MAIN_COLOR_YELLOW;
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}
@end
