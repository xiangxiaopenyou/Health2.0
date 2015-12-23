//
//  ClockinDetailTableViewCell.m
//  Health
//
//  Created by realtech on 15/5/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClockinDetailTableViewCell.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@implementation ClockinDetailTableViewCell
@synthesize headImage, nicknameLabel, timeLabel, deleteButton, reportButton, contentLabel, courseLabel, positionLabel, clockinDaysLabel, commentButton, commentNumberLabel, likeButton, likeNumberLabel, pictureView, privateView, weightLabel, sportsEnergyLabel, sportsLabel, foodEnergyLabel, foodLabel, likeMemberButton, likeMemberLabel, likeImage;
@synthesize height;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDic:(NSDictionary *)dic{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clockinDic = dic;
        UserData *userData = [UserData shared];
        userInfo = userData.userInfo;
        
        height = 0;
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *mainView = [[UIView alloc] init];
        mainView.backgroundColor = TABLEVIEWCELL_COLOR;
        //头像
        headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, height + 14, 40, 40)];
        [headImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[dic objectForKey:@"userheadportrait"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
        headImage.layer.masksToBounds = YES;
        headImage.layer.cornerRadius = 20;
        headImage.layer.borderWidth = 1;
        headImage.layer.borderColor = [UIColor whiteColor].CGColor;
        UITapGestureRecognizer *clickHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicked:)];
        [headImage addGestureRecognizer:clickHead];
        headImage.userInteractionEnabled = YES;
        [mainView addSubview:headImage];
        
        //昵称
        NSString *nick = [dic objectForKey:@"usernickname"];
        CGSize nicknameSize = [nick sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SMALLFONT_14, NSFontAttributeName, nil]];
        nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 18, nicknameSize.width, nicknameSize.height)];
        nicknameLabel.text = nick;
        nicknameLabel.textAlignment = NSTextAlignmentLeft;
        nicknameLabel.font = SMALLFONT_14;
        nicknameLabel.textColor = WHITE_CLOCLOR;
        [mainView addSubview:nicknameLabel];
        
        UIButton *nicknameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nicknameButton.frame = nicknameLabel.frame;
        [nicknameButton addTarget:self action:@selector(nicknameClick) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:nicknameButton];
        
        //时间
        UIImageView *timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, 28 + nicknameSize.height, 12, 12)];
        timeImage.image = [UIImage imageNamed:@"trend_time.png"];
        [mainView addSubview:timeImage];
        
        NSString *timeString;
        NSDate *date = [CustomDate getTimeDate:[dic objectForKey:@"time"]];
        if ([[CustomDate compareDate:date] isEqualToString:@"今天"]) {
            timeString = [[dic objectForKey:@"time"] substringWithRange:NSMakeRange(11, 5)];
        }
        else if ([[CustomDate compareDate:date] isEqualToString:@"昨天"]){
            timeString = @"昨天";
            //timeString = [timeString stringByAppendingString:@" "];
            timeString = [timeString stringByAppendingString:[[dic objectForKey:@"time"] substringWithRange:NSMakeRange(11, 5)]];
        }
        else{
            timeString = [[dic objectForKey:@"time"] substringWithRange:NSMakeRange(5, 11)];
        }
        CGSize timeSize = [timeString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SMALLFONT_12, NSFontAttributeName, nil]];
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(77, 27 + nicknameSize.height, timeSize.width, timeSize.height)];
        timeLabel.text = timeString;
        timeLabel.textColor = TIME_COLOR_GARG;
        timeLabel.font = SMALLFONT_12;
        [mainView addSubview:timeLabel];
        
        //隐私图标
        if ([[dic objectForKey:@"ispublic"] integerValue] != 1) {
            UIImageView *privateImage = [[UIImageView alloc] initWithFrame:CGRectMake(85 + timeSize.width, 27 + nicknameSize.height, 15, 15)];
            privateImage.image = [UIImage imageNamed:@"private.png"];
            [mainView addSubview:privateImage];
        }
        //删除按钮
        if ([[dic objectForKey:@"userid"] isEqualToString:userInfo.userid]) {
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
        height += 64;
        
        //文字内容
        if (![Util isEmpty:[dic objectForKey:@"trendcontent"]]) {
            NSString *content = [dic objectForKey:@"trendcontent"];
            CGSize contentSize = [content sizeWithFont:SMALLFONT_14 constrainedToSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, height, SCREEN_WIDTH - 20, contentSize.height)];
            contentLabel.numberOfLines = 0;
            contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
            contentLabel.text = content;
            contentLabel.font = SMALLFONT_14;
            contentLabel.textColor = WHITE_CLOCLOR;
            [mainView addSubview:contentLabel];
            
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
            CGSize sportsSize = [sportsString sizeWithFont:SMALLFONT_12 constrainedToSize:CGSizeMake(SCREEN_WIDTH - 94, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            sportsLabel.text = sportsString;
            sportsLabel.numberOfLines = 0;
            sportsLabel.lineBreakMode = NSLineBreakByCharWrapping;
            sportsLabel.font = SMALLFONT_12;
            sportsLabel.frame = CGRectMake(68, clockinHeight + 11, SCREEN_WIDTH - 94, sportsSize.height);
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
            CGSize foodSize = [foodString sizeWithFont:SMALLFONT_12 constrainedToSize:CGSizeMake(SCREEN_WIDTH - 94, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            foodLabel.text = foodString;
            foodLabel.font = SMALLFONT_12;
            foodLabel.numberOfLines = 0;
            foodLabel.lineBreakMode = NSLineBreakByCharWrapping;
            foodLabel.frame = CGRectMake(68, clockinHeight + 11, SCREEN_WIDTH - 94, foodSize.height);
            foodLabel.textColor = WHITE_CLOCLOR;
            [clockinView addSubview:foodLabel];
            
            //            foodEnergyLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, clockinHeight + 10 + foodSize.height, 150, 20)];
            //            foodEnergyLabel.text = [NSString stringWithFormat:@"共摄入%@大卡", [dic objectForKey:@"food_num"]];
            //            foodEnergyLabel.textColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
            //            foodEnergyLabel.font = SMALLFONT_10;
            //            [clockinView addSubview:foodEnergyLabel];
            
            clockinHeight += foodSize.height + 10;
        }
        
        clockinView.frame = CGRectMake(10, height, SCREEN_WIDTH - 20, clockinHeight + 10);
        [mainView addSubview:clockinView];
        
        height += clockinView.frame.size.height + 14;
        
        //图片
        if (![Util isEmpty:[dic objectForKey:@"trendpicture"]]) {
            pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(10, height, 120, 120)];
            [pictureView sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:[dic objectForKey:@"trendpicture"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
            pictureView.userInteractionEnabled = YES;
            [pictureView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picturePress:)]];
            [mainView addSubview:pictureView];
            
            height += 130;
        }
        //位置信息
        if (![Util isEmpty:[dic objectForKey:@"trendaddress"]]) {
            //位置
            UIImageView *positionImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, height + 3, 12, 12)];
            positionImage.image = [UIImage imageNamed:@"trend_position.png"];
            [mainView addSubview:positionImage];
            
            positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, height, SCREEN_WIDTH - 34, 19)];
            positionLabel.text = [dic objectForKey:@"trendaddress"];
            positionLabel.font = SMALLFONT_12;
            positionLabel.textColor = TIME_COLOR_GARG;
            positionLabel.textAlignment = NSTextAlignmentLeft;
            [mainView addSubview:positionLabel];
            
            height += 30;
            
            UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(10, height, SCREEN_WIDTH - 20, 0.5)];
            line1.backgroundColor = LINE_COLOR_GARG;
            [mainView addSubview:line1];
            
            height += 10;
        }
        
        if (![Util isEmpty:[dic objectForKey:@"coursetitle"]]){
            UIImageView *courseImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, height + 2.5, 15, 15)];
            courseImage.image =[UIImage imageNamed:@"show_course"];
            [mainView addSubview:courseImage];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(27, height, 30, 20)];
            label.text = @"来自";
            label.textColor = TIME_COLOR_GARG;
            label.font = SMALLFONT_12;
            [mainView addSubview:label];
            
            NSArray *course = [[dic objectForKey:@"coursetitle"] componentsSeparatedByString:@";"];
            NSString *courseString = [course objectAtIndex:0];
            courseArray = [courseString componentsSeparatedByString:@":"];
            CGSize courseSize = [[courseArray objectAtIndex:0] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SMALLFONT_12, NSFontAttributeName, nil]];
            courseLabel = [UIButton buttonWithType:UIButtonTypeCustom];
            courseLabel.frame = CGRectMake(55, height, courseSize.width, 20);
            [courseLabel setTitle:[courseArray objectAtIndex:0] forState:UIControlStateNormal];
            [courseLabel setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
            courseLabel.titleLabel.font = SMALLFONT_12;
            [courseLabel addTarget:self action:@selector(courseClick) forControlEvents:UIControlEventTouchUpInside];
            [mainView addSubview:courseLabel];
        }
        
        UIImageView *clockinImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, height + 3, 15, 15)];
        clockinImage.image = [UIImage imageNamed:@""];
        [mainView addSubview:clockinImage];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 17, height, 70, 20)];
        label1.text = @"连续打卡第";
        label1.textColor = TIME_COLOR_GARG;
        label1.font = SMALLFONT_12;
        label1.textAlignment = NSTextAlignmentRight;
        [mainView addSubview:label1];
        
        clockinDaysLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 87, height, 40, 20)];
        clockinDaysLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"countday"]];
        clockinDaysLabel.textColor = MAIN_COLOR_YELLOW;
        clockinDaysLabel.font = SMALLFONT_14;
        clockinDaysLabel.textAlignment = NSTextAlignmentCenter;
        [mainView addSubview:clockinDaysLabel];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 127, height, 20, 20)];
        label2.text = @"天";
        label2.font = SMALLFONT_12;
        label2.textColor = TIME_COLOR_GARG;
        [mainView addSubview:label2];
        
        height += 30;
        
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(10, height, SCREEN_WIDTH - 20, 0.5)];
        line2.backgroundColor = LINE_COLOR_GARG;
        [mainView addSubview:line2];
        
        height += 10;
        
        commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        commentButton.frame = CGRectMake(10, height, SCREEN_WIDTH/3 - 16, 30);
        commentButton.backgroundColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:101/255.0 alpha:1.0];
        commentButton.layer.masksToBounds = YES;
        commentButton.layer.cornerRadius = 2;
        [commentButton addTarget:self action:@selector(commentButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:commentButton];
        
        UIImageView *commentImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 7.5, 15, 15)];
        commentImage.image = [UIImage imageNamed:@"trend_comment.png"];
        [commentButton addSubview:commentImage];
        
        commentNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 45, 20)];
        commentNumberLabel.text = @"评论";
        commentNumberLabel.font = SMALLFONT_12;
        commentNumberLabel.textColor = WHITE_CLOCLOR;
        commentNumberLabel.textAlignment = NSTextAlignmentCenter;
        [commentButton addSubview:commentNumberLabel];
        
        likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        likeButton.frame = CGRectMake(SCREEN_WIDTH/2 - SCREEN_WIDTH/6 + 8, height, SCREEN_WIDTH/3 - 16, 30);
        likeButton.backgroundColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:101/255.0 alpha:1.0];
        likeButton.layer.masksToBounds = YES;
        likeButton.layer.cornerRadius = 2;
        [likeButton addTarget:self action:@selector(likeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:likeButton];
        
        likeImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 7.5, 15, 15)];
        [likeButton addSubview:likeImage];
        
        likeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 45, 20)];
        
        likeNumberLabel.font = SMALLFONT_12;
        likeNumberLabel.textColor = WHITE_CLOCLOR;
        likeNumberLabel.textAlignment = NSTextAlignmentCenter;
        [likeButton addSubview:likeNumberLabel];
        
        if ([[dic objectForKey:@"isfavorite"] integerValue] == 2) {
            likeImage.image = [UIImage imageNamed:@"trend_like.png"];
            likeNumberLabel.text = @"点赞";
            isLiked = NO;
        }
        else {
            likeImage.image = [UIImage imageNamed:@"trend_like_pressed.png"];
            likeNumberLabel.text = @"已赞";
            isLiked = YES;
        }
        
        height += 40;
        
        //点赞的人
        NSArray *memberArray = [dic objectForKey:@"favorite"];
        
        if ([memberArray count] > 0) {
            //            NSArray *memberArray = [trend.trendlikemember componentsSeparatedByString:@";"];
            if ([memberArray count] <= 8) {
                for(int i = 0; i < memberArray.count; i++){
                    NSDictionary *tempDic = [memberArray objectAtIndex:i];
                    UIImageView *likeMemberImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 + i*(27+5), height, 27, 27)];
                    [likeMemberImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[tempDic objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                    
                    likeMemberImage.layer.masksToBounds = YES;
                    likeMemberImage.layer.cornerRadius = 13.5;
                    [mainView addSubview:likeMemberImage];
                    
                }
            }
            else{
                for(int i = 0; i < 8; i++){
                    NSDictionary *tempDic = [memberArray objectAtIndex:i];
                    UIImageView *likeMemberImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 + i*(27+5), height, 27, 27)];
                    [likeMemberImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[tempDic objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                    likeMemberImage.layer.masksToBounds = YES;
                    likeMemberImage.layer.cornerRadius = 13.5;
                    [mainView addSubview:likeMemberImage];
                }
            }
            
            likeNumber = memberArray.count;
            
            likeMemberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, height, 70, 27)];
            likeMemberLabel.text = [NSString stringWithFormat:@"%ld赞", (long)memberArray.count];
            likeMemberLabel.textColor = MAIN_COLOR_YELLOW;
            likeMemberLabel.font = SMALLFONT_14;
            likeMemberLabel.textAlignment = NSTextAlignmentCenter;
            [mainView addSubview:likeMemberLabel];
            
            likeMemberButton = [UIButton buttonWithType:UIButtonTypeCustom];
            likeMemberButton.frame = CGRectMake(10, height, SCREEN_WIDTH - 20, 32);
            [likeMemberButton addTarget:self action:@selector(likeMemberClick) forControlEvents:UIControlEventTouchUpInside];
            [mainView addSubview:likeMemberButton];
            
            height += 41;
        }

        
        mainView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        [self addSubview:mainView];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, 10)];
        bottomView.backgroundColor = [UIColor clearColor];
        [self addSubview:bottomView];
        
        height += 10;
        
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
    //[self.delegate clickDelete:singleTrend.trendid];
    [self.delegate clickDelete];
}
- (void)reportClick{
    NSLog(@"点击了投诉");
    //[self.delegate clickReport:singleTrend.trendid];
    [self.delegate clickReport];
}
- (void)picturePress:(UITapGestureRecognizer*)gesture{
    NSLog(@"点击了图片");
    NSInteger imageCount = 1;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:imageCount];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:[Util urlPhoto:[self.clockinDic objectForKey:@"trendpicture"]]];
    photo.srcImageView = pictureView;
    [photos addObject:photo];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0;
    browser.photos = photos;
    browser.tagString = [self.clockinDic objectForKey:@"picTag"];
    [browser show];
}
- (void)courseClick{
    NSLog(@"点击了训练营");
    [self.delegate clickCourse];
}
- (void)commentButtonClick{
    [self.delegate clickComment:[self.clockinDic objectForKey:@"usernickname"]];
}
- (void)likeButtonClick{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", [self.clockinDic objectForKey:@"id"], @"trendid", nil];
    if (!isLiked) {
        likeNumber += 1;
        likeImage.image = [UIImage imageNamed:@"trend_like_pressed.png"];
        likeNumberLabel.text = [NSString stringWithFormat:@"%ld赞", (long)likeNumber];
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
    else {
        likeNumber -= 1;
        likeImage.image = [UIImage imageNamed:@"trend_like.png"];
        likeNumberLabel.text = [NSString stringWithFormat:@"%ld赞", (long)likeNumber];
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
- (void)likeMemberClick{
    NSLog(@"点击了点赞的人");
    [self.delegate clickLikeMember];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
