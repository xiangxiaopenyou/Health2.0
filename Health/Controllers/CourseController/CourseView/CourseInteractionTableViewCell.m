//
//  CourseInteractionTableViewCell.m
//  Health
//
//  Created by 项小盆友 on 15/1/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseInteractionTableViewCell.h"

@implementation CourseInteractionTableViewCell
@synthesize headImage, interactionTitle, nicknameLabel, timeLabel, numberLabel;
@synthesize cellHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDic:(NSDictionary *)dic{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([Util isEmpty:[dic objectForKey:@"discussoverhead"]]) {
            //头像
            headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 39, 39)];
            headImage.layer.masksToBounds = YES;
            headImage.layer.cornerRadius = 19.5;
            [headImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[dic objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
            [self addSubview:headImage];
            
           
            //内容
            interactionTitle = [[UILabel alloc] initWithFrame:CGRectMake(57, 12, SCREEN_WIDTH - 92, 20)];
            if([Util isEmpty:[dic objectForKey:@"discussiontitle"]]){
                interactionTitle.text = [dic objectForKey:@"discussioncontent"];
            }
            else{
                interactionTitle.text = [dic objectForKey:@"discussiontitle"];
            }
            interactionTitle.textColor = WHITE_CLOCLOR;
            interactionTitle.font = SMALLFONT_14;
            interactionTitle.textAlignment = NSTextAlignmentLeft;
            [self addSubview:interactionTitle];
            
            //类型
//            if (![Util isEmpty:[dic objectForKey:@"discussionType"]]) {
//                UIImageView *typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 32, 12, 20, 20)];
//                if ([[dic objectForKey:@"discussionType"] isEqualToString:@"food"]) {
//                    typeImageView.image = [UIImage imageNamed:@"food_discussion"];
//                }
//                else if ([[dic objectForKey:@"discussionType"] isEqualToString:@"sports"]){
//                    typeImageView.image = [UIImage imageNamed:@"sports_discussion"];
//                }
//                else if ([[dic objectForKey:@"discussionType"] isEqualToString:@"show"]){
//                    typeImageView.image = [UIImage imageNamed:@"show_discussion"];
//                }
//                else{
//                    typeImageView.image = [UIImage imageNamed:@"discussion_question"];
//                }
//                [self addSubview:typeImageView];
//            }
            
//            if ([[dic objectForKey:@"discussionpublic"] integerValue] != 1) {
//                //隐私图标
//                UIImageView *privateImage = [[UIImageView alloc] initWithFrame:CGRectMake(57, 37, 10, 10)];
//                privateImage.image = [UIImage imageNamed:@"private.png"];
//                [self addSubview:privateImage];
//                
//                //昵称
//                UIImageView *personalImage = [[UIImageView alloc] initWithFrame:CGRectMake(70, 36, 11, 11)];
//                personalImage.image = [UIImage imageNamed:@"interaction_owner.png"];
//                [self addSubview:personalImage];
//                
//                nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(83, 34, 120, 15)];
//                nicknameLabel.text = [dic objectForKey:@"nickname"];
//                nicknameLabel.textColor = [UIColor colorWithRed:191/255.0 green:191/255.0 blue:207/255.0 alpha:1.0];
//                nicknameLabel.font = SMALLFONT_10;
//                nicknameLabel.textAlignment = NSTextAlignmentLeft;
//                [self addSubview:nicknameLabel];
//            }
            
            //else{
                //昵称
            UIImageView *personalImage = [[UIImageView alloc] initWithFrame:CGRectMake(57, 36, 12, 12)];
            personalImage.image = [UIImage imageNamed:@"common_person"];
            [self addSubview:personalImage];
            
            nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 33, 120, 16)];
            nicknameLabel.text = [dic objectForKey:@"nickname"];
            nicknameLabel.textColor = TIME_COLOR_GARG;
            nicknameLabel.font = SMALLFONT_12;
            nicknameLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:nicknameLabel];
            //}
            
            //时间
            NSString *timeString;
            NSDate *date = [CustomDate getTimeDate:[dic objectForKey:@"created_time"]];
            if ([[CustomDate compareDate:date] isEqualToString:@"今天"]) {
                timeString = [[dic objectForKey:@"created_time"] substringWithRange:NSMakeRange(11, 5)];
            }
            else if ([[CustomDate compareDate:date] isEqualToString:@"昨天"]){
                timeString = @"昨天";
                //timeString = [timeString stringByAppendingString:@" "];
                timeString = [timeString stringByAppendingString:[[dic objectForKey:@"created_time"] substringWithRange:NSMakeRange(11, 5)]];
            }
            else{
                timeString = [[dic objectForKey:@"created_time"] substringWithRange:NSMakeRange(5, 11)];
            }
            timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 130, 34, 70, 14)];
            timeLabel.text = timeString;
            timeLabel.textColor = TIME_COLOR_GARG;
            timeLabel.font = SMALLFONT_12;
            timeLabel.textAlignment = NSTextAlignmentRight;
            [self addSubview:timeLabel];
            
            //讨论人数
            UIImageView *commentImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 33.5, 15, 15)];
            commentImage.image = [UIImage imageNamed:@"common_comment.png"];
            [self addSubview:commentImage];
            
            numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 34, 34, 24, 14)];
            numberLabel.text = [dic objectForKey:@"discussnumber"];
            numberLabel.textColor = TIME_COLOR_GARG;
            numberLabel.font = SMALLFONT_10;
            numberLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:numberLabel];
        }
        
        else{
            //置顶
            UIImageView *topImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 22, 32, 16)];
            topImage.image = [UIImage imageNamed:@"interaction_header"];
            [self addSubview:topImage];
            
            //标题
            interactionTitle = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, SCREEN_WIDTH - 55, 60)];
            if([Util isEmpty:[dic objectForKey:@"discussiontitle"]]){
                interactionTitle.text = [dic objectForKey:@"discussioncontent"];
            }
            else{
                interactionTitle.text = [dic objectForKey:@"discussiontitle"];
            }

            interactionTitle.textColor = WHITE_CLOCLOR;
            interactionTitle.font = SMALLFONT_14;
            interactionTitle.textAlignment = NSTextAlignmentLeft;
            [self addSubview:interactionTitle];
        }
        
    }
    return self;
}

- (void)headImagePress:(UITapGestureRecognizer*)gesture{
    NSLog(@"点击了头像");
}
- (void)themeClick{
    NSLog(@"点击了话题");
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
