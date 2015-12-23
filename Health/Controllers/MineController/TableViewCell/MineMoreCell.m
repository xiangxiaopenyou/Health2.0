//
//  MineMoreCell.m
//  Health
//
//  Created by 王杰 on 15/2/5.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MineMoreCell.h"

@implementation MineMoreCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
                
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

@end
