//
//  MineInfoCell.m
//  Health
//
//  Created by 王杰 on 15/1/31.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MineInfoCell.h"

@implementation MineInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
        self.background.image = [UIImage imageNamed:@"background1"];
        [self.contentView addSubview:self.background];
        
        self.focusNum = [[UIButton alloc]initWithFrame: CGRectMake(SCREEN_WIDTH /2-70, 120, 70, 20)];
        [self.focusNum setTitle:@"关注 11" forState:UIControlStateNormal];
        [self.focusNum setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
        [self.focusNum addTarget:self action:@selector(focusBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.focusNum.titleLabel.font = SMALLFONT_14;
        [self.contentView addSubview:self.focusNum];
        
        self.fansNum = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH /2, 120, 70, 20)];
        [self.fansNum setTitle:@"粉丝 99" forState:UIControlStateNormal];
        [self.fansNum setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
        self.fansNum.titleLabel.font = SMALLFONT_14;
        [self.fansNum addTarget:self action:@selector(fansBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.fansNum];
        
        self.line = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH /2 , 122, 1, 16)];
        self.line.image  = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:self.line];
        
        self.name = [[UILabel alloc]initWithFrame: CGRectMake(SCREEN_WIDTH /2 - 50 , 86, 100, 21)];
        self.name.text = @"自己啊";
        self.name.font = SMALLFONT_14;
        self.name.textAlignment = NSTextAlignmentCenter;
        self.name.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.name];
        
        self.sex = [[UIImageView alloc]initWithFrame: CGRectMake(SCREEN_WIDTH/2 + 52 , 87, 15, 15)];
        self.sex.image = [UIImage imageNamed:@"msex"];
        [self.contentView addSubview:self.sex];
        
        self.imageviewPortrait = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, 16, 60, 60)];
        self.imageviewPortrait.image = [UIImage imageNamed:@"training"];
        self.imageviewPortrait.layer.cornerRadius = 30.0;
        self.imageviewPortrait.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageviewPortrait];
        [self.imageviewPortrait addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickportrait:)]];
        self.imageviewPortrait.userInteractionEnabled = YES;
        
        self.blackView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH/3*2-46, SCREEN_WIDTH, 46)];
        [self.blackView setBackgroundColor:[UIColor blackColor]];
        
        self.message = [[UIButton alloc]initWithFrame: CGRectMake(20, 8, SCREEN_WIDTH/2-40, 30)];
        [self.message setBackgroundImage:[UIImage imageNamed:@"personalmessage"] forState:UIControlStateNormal];
        
        self.focus = [[UIButton alloc]initWithFrame: CGRectMake(SCREEN_WIDTH/2+20, 8, SCREEN_WIDTH/2-40, 30)];
        [self.focus setBackgroundImage:[UIImage imageNamed:@"addfocus1"] forState:UIControlStateNormal];

    
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fansBtn:(UIButton *)sender {
  
    [self.delegate pushTOMyFun];
}

- (void)focusBtn:(UIButton *)sender{
    [self.delegate pushtoMyFocus];
}

- (void)addFocusBtn:(UIButton *)sender{
    
}

- (void)writeMessage:(UIButton *)sender {
    
}

- (void)clickportrait:(UIImageView *)tap {
    [self.delegate pushtoMyDetailInfo];
}

@end
