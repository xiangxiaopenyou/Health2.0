//
//  ClubTableViewCell.m
//  Health
//
//  Created by jason on 15/3/5.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClubTableViewCell.h"

@implementation ClubTableViewCell
@synthesize clubImageView,clubNameLabel, clubMemberNumberLabel, clubPositionLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDic:(NSDictionary *)dic{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        //俱乐部logo
        clubImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [clubImageView sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:[dic objectForKey:@"clublogo"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
        clubImageView.layer.masksToBounds = YES;
        clubImageView.layer.cornerRadius = 25;
        clubImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:clubImageView];
        
        NSString *nameString = [dic objectForKey:@"clubname"];
        CGSize nameSize = [nameString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SMALLFONT_14, NSFontAttributeName, nil]];
        //俱乐部名字
        clubNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 16, nameSize.width, nameSize.height)];
        clubNameLabel.text = [dic objectForKey:@"clubname"];
        clubNameLabel.textColor = [UIColor whiteColor];
        clubNameLabel.font = SMALLFONT_14;
        clubNameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:clubNameLabel];
        
        //俱乐部参加人数
        clubMemberNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 65, 70)];
        clubMemberNumberLabel.textAlignment = NSTextAlignmentRight;
        clubMemberNumberLabel.text = [NSString stringWithFormat:@"%ld人", [[dic objectForKey:@"clubnumber"] integerValue] + 1];
        clubMemberNumberLabel.textColor = MAIN_COLOR_YELLOW;
        clubMemberNumberLabel.font = SMALLFONT_12;
        [self addSubview:clubMemberNumberLabel];
        
        //俱乐部位置
        
        if (![Util isEmpty:[dic objectForKey:@"clubaddress"]]) {
            UIImageView *positionImage = [[UIImageView alloc] initWithFrame:CGRectMake(70, 32 + nameSize.height, 12, 12)];
            positionImage.image = [UIImage imageNamed:@"trend_position"];
            [self addSubview:positionImage];
            
            clubPositionLabel = [[UILabel alloc] initWithFrame:CGRectMake(84, 30 + nameSize.height, SCREEN_WIDTH - 110, 16)];
            clubPositionLabel.text = [NSString stringWithFormat:@"位于：%@", [dic objectForKey:@"clubaddress"]];
            clubPositionLabel.textAlignment = NSTextAlignmentLeft;
            clubPositionLabel.font = SMALLFONT_12;
            clubPositionLabel.textColor = TIME_COLOR_GARG;
            [self addSubview:clubPositionLabel];
        }
        
        UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 25, 20, 20)];
        rightView.image = [UIImage imageNamed:@"cell_right"];
        [self addSubview:rightView];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 69, SCREEN_WIDTH - 10, 1)];
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
