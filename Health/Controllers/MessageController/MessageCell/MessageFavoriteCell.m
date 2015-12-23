//
//  MessageFavoriteCell.m
//  Health
//
//  Created by cheng on 15/2/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MessageFavoriteCell.h"

#define TIME_TEXT_COLOR [UIColor colorWithRed:11/255.0 green:11/255.0 blue:11/255.0 alpha:1.0]
#define FROM_TEXT_COLOR [UIColor colorWithRed:11/255.0 green:11/255.0 blue:11/255.0 alpha:1.0]
#define TEXT_COLOR [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]

@implementation MessageFavoriteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.photoimage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-60, 7.5, 60, 60)];
        [self addSubview:self.photoimage];
        self.portraitImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 45, 45)];
        self.portraitImage.layer.cornerRadius = 22.5;
        self.portraitImage.layer.masksToBounds = YES;
        [self addSubview:self.portraitImage];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.portraitImage.frame.origin.x+self.portraitImage.frame.size.width+10, 10, 110, 21)];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.nameLabel.textColor = TEXT_COLOR;
        [self addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y+self.nameLabel.frame.size.height, SCREEN_WIDTH - 140, 25)];
        self.timeLabel.font = [UIFont boldSystemFontOfSize:10.0];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.textColor = TIME_COLOR_GARG;
        [self addSubview:self.timeLabel];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90-60, 10, 60, 21)];
        self.contentLabel.font = [UIFont systemFontOfSize:12.0];
        self.contentLabel.textColor = TEXT_COLOR;
        [self addSubview:self.contentLabel];
        
        self.fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.frame.origin.x, self.timeLabel.frame.origin.y+self.timeLabel.frame.size.height, SCREEN_WIDTH - 140, 15)];
        self.fromLabel.textColor = TIME_COLOR_GARG;
        self.fromLabel.font = [UIFont systemFontOfSize:10.0];
        [self addSubview:self.fromLabel];
        
        self.photoimage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-60, 7.5, 60, 60)];
        [self addSubview:self.photoimage];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 74.5, SCREEN_WIDTH - 10, 0.5)];
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

    // Configure the view for the selected state
}

@end
