//
//  ClubDiscussionTableViewCell.m
//  Health
//
//  Created by jason on 15/3/5.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClubDiscussionTableViewCell.h"

@implementation ClubDiscussionTableViewCell
@synthesize headImageView, discussionTitleLabel, nicknameLabel, timeLabel, commentsNumberLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDic:(NSDictionary *)dic{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            //头像
            headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
            headImageView.layer.masksToBounds = YES;
            headImageView.layer.cornerRadius = 20;
            [headImageView sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[dic objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
            [self addSubview:headImageView];
            
            //帖子标题
            discussionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 12, SCREEN_WIDTH - 92, 16)];
            discussionTitleLabel.text = [dic objectForKey:@"clubpoststitle"];
            discussionTitleLabel.textColor = WHITE_CLOCLOR;
            discussionTitleLabel.font = SMALLFONT_14;
            discussionTitleLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:discussionTitleLabel];
            
            //昵称
            UIImageView *personalImage = [[UIImageView alloc] initWithFrame:CGRectMake(57, 35, 12, 12)];
            personalImage.image = [UIImage imageNamed:@"common_person"];
            [self addSubview:personalImage];
            
            nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 33, 150, 16)];
            nicknameLabel.text = [dic objectForKey:@"nickname"];
            nicknameLabel.textColor = TIME_COLOR_GARG;
            nicknameLabel.font = SMALLFONT_12;
            nicknameLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:nicknameLabel];
            
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
            
            commentsNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 34, 34, 24, 14)];
            commentsNumberLabel.text = [dic objectForKey:@"clubpostsnumber"];
            commentsNumberLabel.textColor = TIME_COLOR_GARG;
            commentsNumberLabel.font = SMALLFONT_12;
            commentsNumberLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:commentsNumberLabel];
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
