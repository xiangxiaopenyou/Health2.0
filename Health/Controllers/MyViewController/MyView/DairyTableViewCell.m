//
//  DairyTableViewCell.m
//  Health
//
//  Created by realtech on 15/4/28.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "DairyTableViewCell.h"

@implementation DairyTableViewCell
@synthesize timeLabel, contentLabel, weightLabel, sportsEnergyLabel, sportsLabel, foodEnergyLabel, foodLabel, dairyImage, height;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDic:(NSDictionary *)dic{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        height = 20;
        
        timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = WHITE_CLOCLOR;
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.text = [[dic objectForKey:@"time"] substringWithRange:NSMakeRange(11, 5)];
        timeLabel.font = SMALLFONT_13;
        [self addSubview:timeLabel];
        
        if (![Util isEmpty:[dic objectForKey:@"trendcontent"]]){
            CGSize contentSize = [[dic objectForKey:@"trendcontent"] sizeWithFont:SMALLFONT_14 constrainedToSize:CGSizeMake(SCREEN_WIDTH - 90, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(77, height, SCREEN_WIDTH - 90, contentSize.height)];
            contentLabel.font = SMALLFONT_14;
            contentLabel.textColor = WHITE_CLOCLOR;
            contentLabel.text = [dic objectForKey:@"trendcontent"];
            [self addSubview:contentLabel];
            
            height += contentSize.height + 14;
        }
        
        UIView *clockinView = [[UIView alloc] init];
        clockinView.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
        
        NSInteger clockinHeight = 0;
        if (![Util isEmpty:[dic objectForKey:@"weight"]]) {
            UIImageView *weightImage = [[UIImageView alloc] initWithFrame:CGRectMake(6, 12, 16, 16)];
            weightImage.image = [UIImage imageNamed:@"show_weight"];
            [clockinView addSubview:weightImage];
            UILabel *weight =[[UILabel alloc] initWithFrame:CGRectMake(28, 12, 38, 16)];
            weight.text = @"体重:";
            weight.textColor = WHITE_CLOCLOR;
            weight.font = SMALLFONT_12;
            [clockinView addSubview:weight];
            
            weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 12, 100, 16)];
            weightLabel.text = [NSString stringWithFormat:@"%@kg", [dic objectForKey:@"weight"]];
            weightLabel.font = SMALLFONT_12;
            weightLabel.textColor = WHITE_CLOCLOR;
            [clockinView addSubview:weightLabel];
            
            clockinHeight += 28;
            
        }
        if (![Util isEmpty:[dic objectForKey:@"playcard_sport"]]) {
            UIImageView *sportImage = [[UIImageView alloc] initWithFrame:CGRectMake(6, clockinHeight + 10, 16, 16)];
            sportImage.image = [UIImage imageNamed:@"show_sports"];
            [clockinView addSubview:sportImage];
            
            UILabel *sports = [[UILabel alloc] initWithFrame:CGRectMake(28, clockinHeight + 10, 38, 16)];
            sports.text = @"运动:";
            sports.font = SMALLFONT_12;
            sports.textColor = WHITE_CLOCLOR;
            [clockinView addSubview:sports];
            
            NSString *sportsString = [NSString stringWithFormat:@"%@ 共消耗%@大卡", [dic objectForKey:@"playcard_sport"], [dic objectForKey:@"sport_num"]];
            sportsLabel = [[UILabel alloc] init];
            CGSize sportsSize = [sportsString sizeWithFont:SMALLFONT_12 constrainedToSize:CGSizeMake(SCREEN_WIDTH - 161, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            sportsLabel.text = sportsString;
            sportsLabel.numberOfLines = 0;
            sportsLabel.lineBreakMode = NSLineBreakByCharWrapping;
            sportsLabel.font = SMALLFONT_12;
            sportsLabel.frame = CGRectMake(68, clockinHeight + 11, SCREEN_WIDTH - 161, sportsSize.height);
            sportsLabel.textColor = WHITE_CLOCLOR;
            [clockinView addSubview:sportsLabel];
            
            //            sportsEnergyLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, clockinHeight + 10 + sportsSize.height, 150, 20)];
            //            sportsEnergyLabel.text = [NSString stringWithFormat:@"共消耗%@大卡", [dic objectForKey:@"sport_num"]];
            //            sportsEnergyLabel.textColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
            //            sportsEnergyLabel.font = SMALLFONT_10;
            //            [clockinView addSubview:sportsEnergyLabel];
            
            clockinHeight += sportsSize.height + 10;
        }
        if (![Util isEmpty:[dic objectForKey:@"playcard_food"]]) {
            UIImageView *foodImage = [[UIImageView alloc] initWithFrame:CGRectMake(6, clockinHeight + 10, 16, 16)];
            foodImage.image = [UIImage imageNamed:@"show_food"];
            [clockinView addSubview:foodImage];
            
            UILabel *food = [[UILabel alloc] initWithFrame:CGRectMake(28, clockinHeight + 10, 38, 16)];
            food.text = @"饮食:";
            food.font = SMALLFONT_12;
            food.textColor = WHITE_CLOCLOR;
            [clockinView addSubview:food];
            
            NSString *foodString = [NSString stringWithFormat:@"%@ 共摄入%@大卡", [dic objectForKey:@"playcard_food"], [dic objectForKey:@"food_num"]];
            foodLabel = [[UILabel alloc] init];
            CGSize foodSize = [foodString sizeWithFont:SMALLFONT_12 constrainedToSize:CGSizeMake(SCREEN_WIDTH - 161, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            foodLabel.text = foodString;
            foodLabel.font = SMALLFONT_12;
            foodLabel.numberOfLines = 0;
            foodLabel.lineBreakMode = NSLineBreakByCharWrapping;
            foodLabel.frame = CGRectMake(68, clockinHeight + 11, SCREEN_WIDTH - 161, foodSize.height);
            foodLabel.textColor = WHITE_CLOCLOR;
            [clockinView addSubview:foodLabel];
            
            //            foodEnergyLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, clockinHeight + 10 + foodSize.height, 150, 20)];
            //            foodEnergyLabel.text = [NSString stringWithFormat:@"共摄入%@大卡", [dic objectForKey:@"food_num"]];
            //            foodEnergyLabel.textColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
            //            foodEnergyLabel.font = SMALLFONT_10;
            //            [clockinView addSubview:foodEnergyLabel];
            
            clockinHeight += foodSize.height + 10;
        }
        
        clockinView.frame = CGRectMake(77, height, SCREEN_WIDTH - 89, clockinHeight + 10);
        [self addSubview:clockinView];
        
        height += clockinView.frame.size.height + 14;
        if (![Util isEmpty:[dic objectForKey:@"trendpicture"]]) {
            dairyImage = [[UIImageView alloc] initWithFrame:CGRectMake(77, height, 70, 70)];
            [dairyImage sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:[dic objectForKey:@"trendpicture"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
//            dairyImage.userInteractionEnabled = YES;
//            [dairyImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picturePress:)]];
            [self addSubview:dairyImage];
            
            height += 80;
        }
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height - 1, SCREEN_WIDTH, 1)];
        lineLabel.backgroundColor = [UIColor colorWithRed:63/255.0 green:62/255.0 blue:69/255.0 alpha:1.0];
        [self addSubview:lineLabel];
        
    }
    return  self;
}
//- (void)picturePress:(UITapGestureRecognizer*)gesture{
//}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
