//
//  ChatListCell.m
//  Health
//
//  Created by cheng on 15/3/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ChatListCell.h"

@implementation ChatListCell

@synthesize photoImageView, contentLabel, nameLabel, notReadLabel, timeLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        photoImageView.layer.masksToBounds = YES;
        photoImageView.layer.cornerRadius = 20;
        [self addSubview:photoImageView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 120, 16)];
        nameLabel.textColor = WHITE_CLOCLOR;
        nameLabel.font = BOLDFONT_14;
        [self addSubview:nameLabel];
        
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 10, 90, 16)];
        timeLabel.font = SMALLFONT_12;
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.textColor = TIME_COLOR_GARG;
        [self addSubview:timeLabel];
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, SCREEN_WIDTH - 140, 20)];
        self.contentLabel.font = SMALLFONT_12;
        self.contentLabel.textColor = WHITE_CLOCLOR;
        [self addSubview:self.contentLabel];
        
        notReadLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 34, 30, 24, 24)];
        notReadLabel.layer.masksToBounds = YES;
        notReadLabel.layer.cornerRadius = 12;
        notReadLabel.backgroundColor = [UIColor redColor];
        notReadLabel.textColor = WHITE_CLOCLOR;
        notReadLabel.font = SMALLFONT_12;
        notReadLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:notReadLabel];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 59.5, SCREEN_WIDTH - 10, 0.5)];
        line.backgroundColor = LINE_COLOR_GARG;
        [self addSubview:line];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    self.photoImageView.layer.masksToBounds = YES;
    self.photoImageView.layer.cornerRadius = 20;
    self.notReadLabel.layer.masksToBounds = YES;
    self.notReadLabel.layer.cornerRadius = 10;
    self.notReadLabel.backgroundColor = [UIColor redColor];
    self.notReadLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
