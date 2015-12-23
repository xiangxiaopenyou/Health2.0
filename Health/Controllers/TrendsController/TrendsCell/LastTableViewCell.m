//
//  LastTableViewCell.m
//  Health
//
//  Created by 项小盆友 on 15/2/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "LastTableViewCell.h"

@implementation LastTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //self.backgroundColor = [UIColor clearColor];
        self.indicatorView = [[UIActivityIndicatorView alloc]init];
        self.indicatorView.frame = CGRectMake(SCREEN_WIDTH/2 + 40, 12, 20, 20);
        self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [self addSubview:self.indicatorView];
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH, 20)];
        self.label.text = @"加载中...";
        self.label.font = [UIFont systemFontOfSize:12.0];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        [self addSubview:self.label];
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
