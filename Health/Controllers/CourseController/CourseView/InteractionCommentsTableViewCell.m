//
//  InteractionCommentsTableViewCell.m
//  Health
//
//  Created by 项小盆友 on 15/1/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "InteractionCommentsTableViewCell.h"


@implementation InteractionCommentsTableViewCell

@synthesize dictionary, headImage, nicknameLabel, timeLabel,replyLabel, replyNicknameButton, contentLabel, height;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(NSDictionary *)dic{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        dictionary = dic;
        height = 0;
        
        self.backgroundColor = TABLEVIEWCELL_COLOR;
        
        //头像
        headImage = [[UIImageView alloc] initWithFrame:CGRectMake(11, height + 12, 40, 40)];
        [headImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[dic objectForKey:@"userheadportrait"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
        headImage.layer.masksToBounds = YES;
        headImage.layer.cornerRadius = 20;
        headImage.layer.borderWidth = 1;
        headImage.layer.borderColor = [UIColor whiteColor].CGColor;
        UITapGestureRecognizer *clickHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicked:)];
        [headImage addGestureRecognizer:clickHead];
        headImage.userInteractionEnabled = YES;
        [self addSubview:headImage];
        
        //昵称
        nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(61, 16, 200, 20)];
        nicknameLabel.text = [dic objectForKey:@"commentusernickname"];
        nicknameLabel.font = [UIFont systemFontOfSize:16];
        nicknameLabel.textColor = WHITE_CLOCLOR;
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
            timeString = [timeString stringByAppendingString:[[dic objectForKey:@"created_time"] substringWithRange:NSMakeRange(11, 5)]];
        }
        else{
            timeString = [[dic objectForKey:@"created_time"] substringWithRange:NSMakeRange(5, 11)];
        }
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 94, 16, 80, 20)];
        timeLabel.text = timeString;
        timeLabel.font = SMALLFONT_10;
        timeLabel.textColor = TIME_COLOR_GARG;
        timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:timeLabel];
        
        if ([[dic objectForKey:@"type"] integerValue] == 2) {
            //回复
            NSString *reString = @"回复";
            CGSize reSize = [reString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SMALLFONT_13, NSFontAttributeName, nil]];
            
            NSString *nicknameString = [dic objectForKey:@"commentreplyusernickname"];
            CGSize nicknameSize = [nicknameString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SMALLFONT_14, NSFontAttributeName, nil]];
            replyNicknameButton = [UIButton buttonWithType:UIButtonTypeCustom];
            replyNicknameButton.frame = CGRectMake(61 + reSize.width, 46, nicknameSize.width, nicknameSize.height);
            [replyNicknameButton addTarget:self action:@selector(replyNicknameClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:replyNicknameButton];
            //回复内容
            NSString *contentString = [NSString stringWithFormat:@"回复%@:%@", [dic objectForKey:@"commentreplyusernickname"], [dic objectForKey:@"replycontent"]];
            CGSize contentSize = [contentString sizeWithFont:SMALLFONT_14 constrainedToSize:CGSizeMake(SCREEN_WIDTH - 61 - 14, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(61, 45, contentSize.width, contentSize.height)];
            contentLabel.textColor = WHITE_CLOCLOR;
            contentLabel.font = SMALLFONT_14;
            contentLabel.textAlignment = NSTextAlignmentLeft;
            contentLabel.numberOfLines = 0;
            contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
            [self addSubview:contentLabel];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentString];
            [str addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR_YELLOW range:NSMakeRange(2, [[dic objectForKey:@"commentreplyusernickname"] length])];
            contentLabel.attributedText = str;
            
            height += 55 + contentSize.height;
            
        }
        else{
            NSString *contentString = [dic objectForKey:@"commentcontent"];
            CGSize contentSize = [contentString sizeWithFont:SMALLFONT_14 constrainedToSize:CGSizeMake(SCREEN_WIDTH - 61 - 14, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(61, 45, contentSize.width, contentSize.height)];
            contentLabel.text = contentString;
            contentLabel.textColor = WHITE_CLOCLOR;
            contentLabel.font = SMALLFONT_14;
            contentLabel.textAlignment = NSTextAlignmentLeft;
            contentLabel.numberOfLines = 0;
            contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
            [self addSubview:contentLabel];
            
            height += 55 + contentSize.height;
        }

        
        //分割线
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, height - 0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = LINE_COLOR_GARG;
        [self addSubview:line];
        
    }
    return self;
}

- (void)headClicked:(UITapGestureRecognizer*)gesture{
    NSLog(@"点击了头像");
    [self.delegate clickCommentHead:[dictionary objectForKey:@"commentuserid"]];
}
- (void)replyNicknameClick{
    NSLog(@"点击了回复对象的昵称");
    [self.delegate clickReplyNickname:[dictionary objectForKey:@"commentreplyuserid"]];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
