//
//  TrendDetailTableViewCell.m
//  Health
//
//  Created by 项小盆友 on 15/1/27.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "TrendDetailTableViewCell.h"
//#import "TrendLikeMemberViewController.h"
#import "AppDelegate.h"

@implementation TrendDetailTableViewCell

@synthesize headView, nicknameButton, nicknameLabel, timeLabel, pictureView, privateView, deleteButton, reportButton, contentLabel, addressLabel, commentButton, likeLabel, likeButton, likeImage, shareButton, likeNumber, likeMemberButton;
@synthesize iHeight;
@synthesize dictionary;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(NSDictionary*)dic{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UserData *userData = [UserData shared];
        userInfo  = userData.userInfo;
        dictionary = dic;
        
        iHeight = 0;
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *mainView = [[UIView alloc] init];
        mainView.backgroundColor = TABLEVIEWCELL_COLOR;
        
        //头像
        headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, iHeight + 14, 40, 40)];
        [headView sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[dic objectForKey:@"userheadportrait"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
        headView.layer.masksToBounds = YES;
        headView.layer.cornerRadius = 20;
        headView.layer.borderWidth = 1;
        headView.layer.borderColor = [UIColor whiteColor].CGColor;
        UITapGestureRecognizer *clickHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicked:)];
        [headView addGestureRecognizer:clickHead];
        headView.userInteractionEnabled = YES;
        [mainView addSubview:headView];
        
        //昵称
        NSString *nick = [dic objectForKey:@"usernickname"];
        CGSize nicknameSize = [nick sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SMALLFONT_14, NSFontAttributeName, nil]];
        nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 18, nicknameSize.width, nicknameSize.height)];
        nicknameLabel.text = nick;
        nicknameLabel.textAlignment = NSTextAlignmentLeft;
        nicknameLabel.font = SMALLFONT_14;
        nicknameLabel.textColor = [UIColor whiteColor];
        [mainView addSubview:nicknameLabel];
        
        nicknameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nicknameButton.frame = nicknameLabel.frame;
        [nicknameButton addTarget:self action:@selector(nicknameClick) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:nicknameButton];
        
        //时间
        UIImageView *timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, 28 + nicknameSize.height, 12, 12)];
        timeImage.image = [UIImage imageNamed:@"trend_time.png"];
        [mainView addSubview:timeImage];
        
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
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(77, 27 + nicknameSize.height, timeSize.width, timeSize.height)];
        timeLabel.text = timeString;
        timeLabel.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.font = SMALLFONT_12;
        [mainView addSubview:timeLabel];
        
        if ([[dic objectForKey:@"ispublic"] integerValue] != 1) {
            //隐私图标
            UIImageView *privateImage = [[UIImageView alloc] initWithFrame:CGRectMake(87 + timeSize.width, 15 + nicknameSize.height, 10, 10)];
            privateImage.image = [UIImage imageNamed:@"private.png"];
            [mainView addSubview:privateImage];
        }
        
        if([[dic objectForKey:@"userid"] isEqualToString:userInfo.userid]){
            //删除按钮
            UIImageView *deleteView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 28, 14, 14, 14)];
            deleteView.image = [UIImage imageNamed:@"trend_delete.png"];
            [mainView addSubview:deleteView];
            deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteButton.frame = CGRectMake(SCREEN_WIDTH - 40, 10, 40, 25);
            [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
            deleteButton.titleLabel.font = SMALLFONT_12;
            [mainView addSubview:deleteButton];
        }
        else{
            UIImageView *deleteView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 28, 14, 14, 14)];
            deleteView.image = [UIImage imageNamed:@"report.png"];
            [mainView addSubview:deleteView];
            
            reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
            reportButton.frame = CGRectMake(SCREEN_WIDTH - 40, 10, 40, 25);
            [reportButton addTarget:self action:@selector(reportClick) forControlEvents:UIControlEventTouchUpInside];
            reportButton.titleLabel.font = SMALLFONT_12;
            [mainView addSubview:reportButton];
        }
       
        
        iHeight += 64;
        
        //图片内容
        pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, iHeight, SCREEN_WIDTH, SCREEN_WIDTH)];
        [pictureView sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:[dic objectForKey:@"trendpicture"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
        pictureView.contentMode = UIViewContentModeScaleAspectFit;
        pictureView.userInteractionEnabled = YES;
        [pictureView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picturePress:)]];
        [mainView addSubview:pictureView];
        
        [self showPicTag];
        isShowTag = YES;
        
        iHeight += SCREEN_WIDTH + 15;
        //文字内容
        if (![Util isEmpty:[dic objectForKey:@"trendcontent"]]) {
            NSString *content = [dic objectForKey:@"trendcontent"];
            CGSize contentSize = [content sizeWithFont:SMALLFONT_14 constrainedToSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, iHeight, SCREEN_WIDTH - 20, contentSize.height)];
            contentLabel.numberOfLines = 0;
            contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
            contentLabel.text = content;
            contentLabel.font = SMALLFONT_14;
            contentLabel.textColor = [UIColor whiteColor];
            [mainView addSubview:contentLabel];
            
            iHeight += contentSize.height + 18;
        }
        
        
        //位置
        if (![Util isEmpty:[dic objectForKey:@"trendaddress"]]) {
            UIImageView *positionImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, iHeight + 3, 12, 12 )];
            positionImage.image = [UIImage imageNamed:@"trend_position.png"];
            [mainView addSubview:positionImage];
            addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, iHeight, SCREEN_WIDTH - 33, 19)];
            addressLabel.text = [dic objectForKey:@"trendaddress"];
            addressLabel.font = SMALLFONT_12;
            addressLabel.textColor = [UIColor colorWithRed:86/255.0 green:187/255.0 blue:234/255.0 alpha:1.0];
            addressLabel.textAlignment = NSTextAlignmentLeft;
            [mainView addSubview:addressLabel];
            
            iHeight += 30;
            
            UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(10, iHeight, SCREEN_WIDTH - 20, 0.5)];
            line1.backgroundColor = LINE_COLOR_GARG;
            [mainView addSubview:line1];
            
            iHeight += 12;
        }
        
        
        //评论、点赞、分享
        commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        commentButton.frame = CGRectMake(10, iHeight, SCREEN_WIDTH/3 - 16, 30);
        [commentButton addTarget:self action:@selector(commentButtonClick) forControlEvents:UIControlEventTouchUpInside];
        commentButton.backgroundColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:101/255.0 alpha:1.0];
        commentButton.layer.masksToBounds = YES;
        commentButton.layer.cornerRadius = 2;
        [mainView addSubview:commentButton];
        
        UIImageView *commentImage = [[UIImageView alloc] initWithFrame:CGRectMake(commentButton.frame.size.width/2 - 20, 7.5, 15, 15)];
        commentImage.image = [UIImage imageNamed:@"trend_comment.png"];
        [commentButton addSubview:commentImage];
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(commentButton.frame.size.width/2, 5, 30, 20)];
        commentLabel.font = SMALLFONT_12;
        commentLabel.text = @"评论";
        commentLabel.textColor = [UIColor whiteColor];
        commentLabel.textAlignment = NSTextAlignmentLeft;
        [commentButton addSubview:commentLabel];
        
        likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        likeButton.frame = CGRectMake(SCREEN_WIDTH/3 + 6, iHeight, SCREEN_WIDTH/3 - 16, 30);
        likeButton.layer.masksToBounds = YES;
        likeButton.layer.cornerRadius = 2;
        likeButton.backgroundColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:101/255.0 alpha:1.0];
        [likeButton addTarget:self action:@selector(likeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:likeButton];
        
        likeImage = [[UIImageView alloc] initWithFrame:CGRectMake(likeButton.frame.size.width/2 - 20, 7.5, 15, 15)];
        [likeButton addSubview:likeImage];
        likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(likeButton.frame.size.width/2, 5, 30, 20)];
        likeLabel.font = SMALLFONT_12;
        if ([[dic objectForKey:@"isfavorite"] integerValue] == 2) {
            likeLabel.text = @"点赞";
            likeImage.image = [UIImage imageNamed:@"trend_like.png"];
            isLiked = NO;
        }
        else{
            likeLabel.text = @"已赞";
            likeImage.image = [UIImage imageNamed:@"trend_like_pressed.png"];
            isLiked = YES;
        }
        likeLabel.textColor = [UIColor whiteColor];
        likeLabel.textAlignment = NSTextAlignmentLeft;
        [likeButton addSubview:likeLabel];
        
        
        shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.frame = CGRectMake(2*SCREEN_WIDTH/3 + 6, iHeight, SCREEN_WIDTH/3 - 16, 30);
        shareButton.layer.masksToBounds = YES;
        shareButton.layer.cornerRadius = 2;
        shareButton.backgroundColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:101/255.0 alpha:1.0];
        [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:shareButton];
        UIImageView *shareImage = [[UIImageView alloc] initWithFrame:CGRectMake(shareButton.frame.size.width/2 - 20, 7.5, 15, 15)];
        shareImage.image = [UIImage imageNamed:@"trend_share.png"];
        [shareButton addSubview:shareImage];
        UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(shareButton.frame.size.width/2, 5, 30, 20)];
        shareLabel.font = SMALLFONT_12;
        shareLabel.text = @"分享";
        shareLabel.textColor = [UIColor whiteColor];
        shareLabel.textAlignment = NSTextAlignmentLeft;
        [shareButton addSubview:shareLabel];
        
        iHeight += 38;
        
        //点赞的人
        if ([[dic objectForKey:@"likenumber"] integerValue] > 0) {
            NSArray *memberArray = [dic objectForKey:@"favorite"];
            if ([[dic objectForKey:@"likenumber"] integerValue] <= 8) {
                for(int i = 0; i < memberArray.count; i++){
                    UIImageView *likeMemberImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 + i*(27+5), iHeight, 27, 27)];
                    NSDictionary *tempDic = [memberArray objectAtIndex:i];
                    [likeMemberImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[tempDic objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                    likeMemberImage.layer.masksToBounds = YES;
                    likeMemberImage.layer.cornerRadius = 13.5;
                    [mainView addSubview:likeMemberImage];
                }
            }
            else{
                for(int i = 0; i < 8; i++){
                    UIImageView *likeMemberImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 + i*(27+5), iHeight, 27, 27)];
                    NSDictionary *tempDic = [memberArray objectAtIndex:i];
                    [likeMemberImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[tempDic objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                    likeMemberImage.layer.masksToBounds = YES;
                    likeMemberImage.layer.cornerRadius = 13.5;
                    [mainView addSubview:likeMemberImage];
                }
            }
            
            likeNumber = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, iHeight, 70, 27)];
            likeNumber.text = [NSString stringWithFormat:@"%ld赞", (long)[[dic objectForKey:@"likenumber"] integerValue]];
            likeNumber.textColor = MAIN_COLOR_YELLOW;
            likeNumber.font = SMALLFONT_14;
            likeNumber.textAlignment = NSTextAlignmentCenter;
            [mainView addSubview:likeNumber];
            
            likeMemberButton = [UIButton buttonWithType:UIButtonTypeCustom];
            likeMemberButton.frame = CGRectMake(10, iHeight, SCREEN_WIDTH - 20, 32);
            [likeMemberButton addTarget:self action:@selector(likeMemberClick) forControlEvents:UIControlEventTouchUpInside];
            [mainView addSubview:likeMemberButton];
            
            iHeight += 41;
        }
        
        mainView.frame = CGRectMake(0, 0, SCREEN_WIDTH, iHeight);
        [self addSubview:mainView];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, iHeight, SCREEN_WIDTH, 10)];
        bottomView.backgroundColor = [UIColor clearColor];
        [self addSubview:bottomView];
        iHeight += 10;
    }
    return self;
}

- (void)headClicked:(UITapGestureRecognizer*)gesture{
    NSLog(@"点击了头像");
    [self.delegate clickHead];
}

- (void)nicknameClick{
    NSLog(@"点击了昵称");
    [self.delegate clickNickname];
}

- (void)deleteClick{
    NSLog(@"点击了删除");
    [self.delegate clickDelete];
}

- (void)commentButtonClick{
    NSLog(@"点击了评论");
    [self.delegate clickComment:[dictionary objectForKey:@"usernickname"]];
}
- (void)picturePress:(UITapGestureRecognizer*)gesture{
    if (!isShowTag) {
        [self showPicTag];
    }
    else{
        [self hidePicTag];
    }
}
- (void)showPicTag{
    if (![Util isEmpty:[dictionary objectForKey:@"picTag"]]) {
        UIImage *tagImageRight = [UIImage imageNamed:@"tag_right"];
        UIImage *tagImageLeft = [UIImage imageNamed:@"tag_left"];
        UIEdgeInsets insets_right = UIEdgeInsetsMake(0, 52, 0, 10);
        UIEdgeInsets insets_left = UIEdgeInsetsMake(0, 10, 0, 52);
        tagImageRight = [tagImageRight resizableImageWithCapInsets:insets_right resizingMode:UIImageResizingModeStretch];
        tagImageLeft = [tagImageLeft resizableImageWithCapInsets:insets_left resizingMode:UIImageResizingModeStretch];
        NSArray *tagArray = [Util toArray:[dictionary objectForKey:@"picTag"]];
        for (NSDictionary *tempDic in tagArray){
            NSString *tagString = [tempDic objectForKey:@"tagText"];
            CGSize tagSize = [tagString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SMALLFONT_14, NSFontAttributeName, nil]];
            CGSize twoWordsSize = [@"标签" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SMALLFONT_14, NSFontAttributeName, nil]];
            NSInteger x = [[tempDic objectForKey:@"tagX"] floatValue] *SCREEN_WIDTH;
            if (x + tagSize.width + 90 - twoWordsSize.width > SCREEN_WIDTH) {
                x = SCREEN_WIDTH - tagSize.width - 91 + twoWordsSize.width;
            }
            NSInteger y = [[tempDic objectForKey:@"tagY"] floatValue] * SCREEN_WIDTH;
            if (y + 28 > SCREEN_WIDTH) {
                y = SCREEN_WIDTH - 29;
            }
            UIButton *tag = [UIButton buttonWithType:UIButtonTypeCustom];
            tag.frame = CGRectMake(x, y, tagSize.width + 90 - twoWordsSize.width, 28);
            if (x + (tagSize.width + 90 - twoWordsSize.width)/2 > SCREEN_WIDTH/2) {
                [tag setBackgroundImage:tagImageRight forState:UIControlStateNormal];
            }
            else{
                [tag setBackgroundImage:tagImageLeft forState:UIControlStateNormal];
            }
            [tag setTitle:tagString forState:UIControlStateNormal];
            [tag setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
            tag.titleLabel.font = SMALLFONT_14;
            [pictureView addSubview:tag];
        }
    }
    isShowTag = YES;
}
- (void)hidePicTag{
    for (UIView *view in pictureView.subviews){
        [view removeFromSuperview];
    }
    isShowTag = NO;
}
- (void)likeButtonClick{
    NSLog(@"点击了点赞");
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", [dictionary objectForKey:@"id"], @"trendid", nil];
    if (!isLiked) {
        likeLabel.text = @"已赞";
        likeImage.image = [UIImage imageNamed:@"trend_like_pressed.png"];
        isLiked = YES;
        [TrendRequest likeTrendWith:dic success:^(id response) {
            if ([[response objectForKey:@"state"] integerValue] == 1000) {
                NSLog(@"点赞成功");
            }
            else{
                NSLog(@"点赞失败");
            }
        } failure:^(NSError *error) {
            NSLog(@"网络问题");
        }];
        
    }
    else{

        likeLabel.text = @"点赞";
        likeImage.image = [UIImage imageNamed:@"trend_like.png"];
        isLiked = NO;
        [TrendRequest cancelLikeTrendWith:dic success:^(id response) {
            if ([[response objectForKey:@"state"] integerValue] == 1000) {
                NSLog(@"取消点赞成功");
            }
            else{
                NSLog(@"取消点赞失败");
            }
        } failure:^(NSError *error) {
            NSLog(@"网络问题");
        }];
    }
    [self.delegate clickLike];
}
- (void)shareButtonClick{
    NSLog(@"点击了分享");
    //[self.delegate clickShare:nil];
    NSArray *shareButtonTitleArray = @[@"微信好友",@"微信朋友圈"];
    NSArray *shareButtonImageNameArray = @[@"sns_icon_22",@"sns_icon_23"];
    
    LXActivity *lxActivity = [[LXActivity alloc] initWithTitle:@"分享到" delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    [lxActivity showInView:self];
}
#pragma mark - LXActivityDelegate
- (void)didClickOnImageIndex:(NSInteger *)imageIndex{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (imageIndex == 0) {
        [appDelegate sendLinkContent:@"健身坊分享" Description:[Util isEmpty:[dictionary objectForKey:@"trendcontent"]]?@" ":[dictionary objectForKey:@"trendcontent"] Url:[NSString stringWithFormat:@"%@?userid=%@&token=%@&trendid=%@", URL_TRENDS_SHARE_BASE, userInfo.userid, userInfo.usertoken, [dictionary objectForKey:@"id"]] Photo:[Util urlWeixinPhoto:[dictionary objectForKey:@"trendpicture"]]];
    }
    else{
        [appDelegate sendLinkContentTimeLine:@"健身坊分享" Description:[Util isEmpty:[dictionary objectForKey:@"trendcontent"]]?@" ":[dictionary objectForKey:@"trendcontent"] Url:[NSString stringWithFormat:@"%@?userid=%@&token=%@&trendid=%@", URL_TRENDS_SHARE_BASE, userInfo.userid, userInfo.usertoken, [dictionary objectForKey:@"id"]] Photo:[Util urlWeixinPhoto:[dictionary objectForKey:@"trendpicture"]]];
    }
}
- (void)likeMemberClick{
    NSLog(@"点击了点赞的人");
    [self.delegate clickLikeMember];
}
- (void)reportClick{
    NSLog(@"点击了投诉");
    [self.delegate clickReport];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
