//
//  LikeMemberTableViewCell.m
//  Health
//
//  Created by 项小盆友 on 15/1/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "LikeMemberTableViewCell.h"

@implementation LikeMemberTableViewCell

@synthesize headImage, nicknameLabel, sexImage, ageLabel, attentionButton;
@synthesize dictionary;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(NSDictionary *)dic{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UserData *userData = [UserData shared];
        userInfo = userData.userInfo;
        dictionary = dic;
        //头像
        headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 40, 40)];
        [headImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[dic objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
        headImage.layer.masksToBounds = YES;
        headImage.layer.cornerRadius = 20;
        [headImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick:)]];
        headImage.userInteractionEnabled = YES;
        [self addSubview:headImage];
        
        //昵称
        NSString *nickString = [dic objectForKey:@"nickname"];
        CGSize nicknameSize = [nickString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SMALLFONT_14, NSFontAttributeName, nil]];
        nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, nicknameSize.width, nicknameSize.height)];
        nicknameLabel.text = nickString;
        nicknameLabel.font = SMALLFONT_14;
        nicknameLabel.textColor = WHITE_CLOCLOR;
        [self addSubview:nicknameLabel];
        
        //性别
        sexImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, 20 + nicknameSize.height, 12, 12)];
        if ([[dic objectForKey:@"sex"] integerValue] == 0) {
            sexImage.image = [UIImage imageNamed:@"sex_girl.png"];
        }
        else{
            sexImage.image = [UIImage imageNamed:@"sex_boy.png"];
        }
        [self addSubview:sexImage];
        
        //年龄
        if (![Util isEmpty:[dic objectForKey:@"birthday"]]) {
            NSString *birthdayString = [dic objectForKey:@"birthday"];
            NSInteger birthyear = [[birthdayString substringWithRange:NSMakeRange(0, 4)] integerValue];
            NSDate *now = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSUInteger unitFlags = NSYearCalendarUnit;
            NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
            NSInteger nowYear = [dateComponent year];
            ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 18+nicknameSize.height, 50, 15)];
            ageLabel.text = [NSString stringWithFormat:@"%ld", nowYear - birthyear];
            ageLabel.font = SMALLFONT_12;
            ageLabel.textColor = TIME_COLOR_GARG;
            ageLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:ageLabel];
        }
        
        friendship = [[dic objectForKey:@"isattention"] integerValue];
        //关注按钮
        if (![[dic objectForKey:@"id"] isEqualToString:userInfo.userid]) {
            attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if (friendship == 2) {
                [attentionButton setImage:[UIImage imageNamed:@"attention_each.png"] forState:UIControlStateNormal];
                attentionButton.frame = CGRectMake(SCREEN_WIDTH - 94, 14, 84, 30);
            }
            else if(friendship == 4){
                [attentionButton setImage:[UIImage imageNamed:@"isattention.png"] forState:UIControlStateNormal];
                attentionButton.frame = CGRectMake(SCREEN_WIDTH - 82, 14, 72, 30);
            }
            else{
                [attentionButton setImage:[UIImage imageNamed:@"attention.png"] forState:UIControlStateNormal];
                attentionButton.frame = CGRectMake(SCREEN_WIDTH - 70, 14, 60, 30);
            }
            [attentionButton addTarget:self action:@selector(attentionButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:attentionButton];
        }
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 57.5, SCREEN_WIDTH - 10, 0.5)];
        line.backgroundColor = LINE_COLOR_GARG;
        [self addSubview:line];
        
        
    }
    return self;
}
- (void)headClick:(UITapGestureRecognizer*)gesture{
    NSLog(@"点击了头像");
    [self.delegate clickHead:[dictionary objectForKey:@"id"]];
}
- (void)attentionButtonClick{
    NSLog(@"点击关注按钮");
    if (friendship == 2 || friendship == 4) {
        if (friendship == 2) {
            friendship = 3;
            [attentionButton setImage:[UIImage imageNamed:@"attention.png"] forState:UIControlStateNormal];
        }
        else{
            friendship = 1;
            [attentionButton setImage:[UIImage imageNamed:@"attention.png"] forState:UIControlStateNormal];
        }
        attentionButton.frame = CGRectMake(SCREEN_WIDTH - 70, 14, 60, 30);
        //取消关注
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", [dictionary objectForKey:@"id"], @"fansid", nil];
        [TrendRequest cancelAttentionWith:dic success:^(id response) {
            if ([[response objectForKey:@"state"] integerValue] == 1000) {
                NSLog(@"取消关注成功");
                //[self.delegate clickAttention];
            }
            else{
                NSLog(@"取消关注失败");
                //[JDStatusBarNotification showWithStatus:@"取消关注失败" dismissAfter:1.4];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消关注失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        } failure:^(NSError *error) {
            NSLog(@"检查网络");
            //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.4];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消关注失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
    else{
        if (friendship == 1) {
            friendship = 4;
            [attentionButton setImage:[UIImage imageNamed:@"isattention.png"] forState:UIControlStateNormal];
            attentionButton.frame = CGRectMake(SCREEN_WIDTH - 82, 14, 72, 30);
        }
        else{
            friendship = 2;
            [attentionButton setImage:[UIImage imageNamed:@"attention_each.png"] forState:UIControlStateNormal];
            attentionButton.frame = CGRectMake(SCREEN_WIDTH - 94, 14, 84, 30);
        }
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", [dictionary objectForKey:@"id"], @"fansid", nil];
        [TrendRequest payAttentionWith:dic success:^(id response) {
            if ([[response objectForKey:@"state"] integerValue] == 1000) {
                NSLog(@"关注成功");
                //[self.delegate clickAttention];
            }
            else{
                NSLog(@"关注失败");
                //[JDStatusBarNotification showWithStatus:@"关注失败" dismissAfter:1.4];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关注失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        } failure:^(NSError *error) {
            NSLog(@"检查网络");
            //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.4];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关注失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
