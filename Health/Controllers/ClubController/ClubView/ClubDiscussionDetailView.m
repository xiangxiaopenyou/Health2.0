//
//  ClubDiscussionDetailView.m
//  Health
//
//  Created by realtech on 15/6/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClubDiscussionDetailView.h"

@implementation ClubDiscussionDetailView
@synthesize titleLabel, headView, nicknameButton, timeLabel, pictureView, commentButton;
@synthesize iHeight;
@synthesize dictionary;

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        dictionary = dic;
        iHeight = 0;
        
        self.backgroundColor = TABLEVIEWCELL_COLOR;
        //标题
        NSString *titleString = [dic objectForKey:@"clubpoststitle"];
        if (![Util isEmpty:titleString]) {
            CGSize titleSize = [titleString sizeWithFont:SMALLFONT_16 constrainedToSize:CGSizeMake(SCREEN_WIDTH - 56, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, iHeight, SCREEN_WIDTH, titleSize.height + 58)];
            titleView.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
            [self addSubview:titleView];
            
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 30, SCREEN_WIDTH - 56, titleSize.height)];
            titleLabel.text = titleString;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.font = SMALLFONT_16;
            titleLabel.numberOfLines = 0;
            titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
            [titleView addSubview:titleLabel];
            iHeight += 58 + titleSize.height;
        }
        
        
        //头像
        headView = [[UIImageView alloc] initWithFrame:CGRectMake(12, iHeight + 5, 44, 44)];
        [headView sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[dic objectForKey:@"portrait"]]]placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
        headView.layer.masksToBounds = YES;
        headView.layer.cornerRadius = 22;
        headView.layer.borderWidth = 1;
        headView.layer.borderColor = [UIColor whiteColor].CGColor;
        UITapGestureRecognizer *clickHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicked:)];
        [headView addGestureRecognizer:clickHead];
        headView.userInteractionEnabled = YES;
        [self addSubview:headView];
        
        //昵称
        NSString *nick = [dic objectForKey:@"nickname"];
        CGSize nicknameSize = [nick sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SMALLFONT_14, NSFontAttributeName, nil]];
        nicknameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nicknameButton.frame = CGRectMake(66, iHeight + 12, nicknameSize.width, nicknameSize.height);
        [nicknameButton setTitle:nick forState:UIControlStateNormal];
        [nicknameButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
        nicknameButton.titleLabel.font = SMALLFONT_14;
        [nicknameButton addTarget:self action:@selector(nicknameClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nicknameButton];
        
        //时间
        UIImageView *timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(66, iHeight + 15.5 + nicknameSize.height, 12, 12)];
        timeImage.image = [UIImage imageNamed:@"trend_time.png"];
        [self addSubview:timeImage];
        
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
        CGSize timeSize = [timeString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SMALLFONT_12, NSFontAttributeName, nil]];
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 14 + nicknameSize.height + iHeight, timeSize.width, timeSize.height)];
        timeLabel.text = timeString;
        timeLabel.textColor = TIME_COLOR_GARG;
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.font = SMALLFONT_12;
        [self addSubview:timeLabel];
        
        //评论按钮
        commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        commentButton.frame = CGRectMake(SCREEN_WIDTH - 40, 6 + iHeight, 40, 25);
        [commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [commentButton addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
        commentButton.titleLabel.font = SMALLFONT_12;
        [self addSubview:commentButton];
        
        iHeight += 59;
        
        if (![Util isEmpty:[dic objectForKey:@"clubpostspicture"]]) {
            //图片内容
            pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, iHeight, SCREEN_WIDTH, SCREEN_WIDTH)];
            [pictureView sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:[dic objectForKey:@"clubpostspicture"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
            [self addSubview:pictureView];
            
            iHeight += SCREEN_WIDTH + 15;
        }
        
        
        //文字内容
        [self addSubview:self.contentLabel];
        self.contentLabel.frame = CGRectMake(12, iHeight, SCREEN_WIDTH - 24, 5);
        [self.contentLabel sizeToFit];
        iHeight += self.contentLabel.frame.size.height + 18;
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iHeight - 2, SCREEN_WIDTH, 2)];
        lineLabel.backgroundColor = LINE_COLOR_GARG;
        [self addSubview:lineLabel];

    }
    return self;
}

//文字内容
- (MLEmojiLabel*)contentLabel{
    if (!_contentLabel) {
//        _contentLabel = [[MLEmojiLabel alloc] init];
        _contentLabel = [MLEmojiLabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = SMALLFONT_14;
        _contentLabel.emojiDelegate = self;
        _contentLabel.backgroundColor = [UIColor clearColor];
        //_contentLabel.textColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
        _contentLabel.textColor = WHITE_CLOCLOR;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.isNeedAtAndPoundSign = YES;
        NSString *contentString = nil;
        
        contentString = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"clubposcontent"]];
        
        NSString *lineStr = @"\n";
        contentString = [contentString stringByReplacingOccurrencesOfString:@"\\n" withString:lineStr];
        
        // NSLog(@"%@", contentString);
        _contentLabel.emojiText = contentString;
        
    }
    
    return _contentLabel;
}


- (void)headClicked:(UITapGestureRecognizer*)gesture{
    NSLog(@"点击了头像");
    [self.delegate clickDetailHead:[dictionary objectForKey:@"clubpostsuserid"]];
}

- (void)nicknameClick{
    NSLog(@"点击了昵称");
    [self.delegate clickDetailNickname:[dictionary objectForKey:@"clubpostsuserid"]];
}
- (void)commentClick{
    NSLog(@"点击了评论");
    [self.delegate clickComment];
}

#pragma mark - MLEmojiLabel Delegate
- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接%@",link);
            [self.delegate clickLink:link];
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            //[self.delegate clickTrendsClassfy:link];
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
