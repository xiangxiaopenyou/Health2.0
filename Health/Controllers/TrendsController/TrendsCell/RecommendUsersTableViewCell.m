//
//  RecommendUsersTableViewCell.m
//  Health
//
//  Created by realtech on 15/5/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RecommendUsersTableViewCell.h"

@implementation RecommendUsersTableViewCell
@synthesize headImage, nicknameLabel, leftImage, centerImage, rightImage, attentionButton;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDic:(NSDictionary *)dic{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSDictionary *tempDic = [dic objectForKey:@"terminal"];
        self.dictionary = tempDic;
        headImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 14, 30, 30)];
        headImage.layer.masksToBounds = YES;
        headImage.layer.cornerRadius = 15;
        [self addSubview:headImage];
        
        nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, 150, 30)];
        nicknameLabel.font = SMALLFONT_14;
        nicknameLabel.textColor = WHITE_CLOCLOR;
        [self addSubview:nicknameLabel];
        
        friendship = [[tempDic objectForKey:@"flag"] integerValue];
        //关注按钮
        if (friendship != 5) {
            attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if (friendship == 2) {
                [attentionButton setImage:[UIImage imageNamed:@"attention_each.png"] forState:UIControlStateNormal];
                attentionButton.frame = CGRectMake(SCREEN_WIDTH - 96, 14, 84, 30);
            }
            else if(friendship == 4){
                [attentionButton setImage:[UIImage imageNamed:@"isattention.png"] forState:UIControlStateNormal];
                attentionButton.frame = CGRectMake(SCREEN_WIDTH - 84, 14, 72, 30);
            }
            else{
                [attentionButton setImage:[UIImage imageNamed:@"attention.png"] forState:UIControlStateNormal];
                attentionButton.frame = CGRectMake(SCREEN_WIDTH - 72, 14, 60, 30);
            }
            [attentionButton addTarget:self action:@selector(attentionButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:attentionButton];
        }
        
        leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 52, (SCREEN_WIDTH - 36)/3, (SCREEN_WIDTH - 36)/3)];
        [leftImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeft)]];
        leftImage.userInteractionEnabled = YES;
        [self addSubview:leftImage];
        
        centerImage = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 36)/3 + 18, 52, (SCREEN_WIDTH - 36)/3, (SCREEN_WIDTH - 36)/3)];
        [centerImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCenter)]];
        centerImage.userInteractionEnabled = YES;
        [self addSubview:centerImage];
        
        rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(2*(SCREEN_WIDTH - 36)/3 + 24, 52, (SCREEN_WIDTH - 36)/3, (SCREEN_WIDTH - 36)/3)];
        [rightImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRight)]];
        rightImage.userInteractionEnabled = YES;
        [self addSubview:rightImage];
    }
    return self;
}
- (void)attentionButtonClick{
    UserData *userdata = [UserData shared];
    UserInfo *userInfo = userdata.userInfo;
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
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", [self.dictionary objectForKey:@"userid"], @"fansid", nil];
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
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", [self.dictionary objectForKey:@"userid"], @"fansid", nil];
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

- (void)clickLeft {
    if (self.clickItem != nil) {
        self.clickItem(1);
    }
}
- (void)clickCenter {
    if (self.clickItem != nil) {
        self.clickItem(2);
    }
}
- (void)clickRight {
    if (self.clickItem != nil) {
        self.clickItem(3);
    }
}
- (void)clickImage:(ClickPhoto)click{
    self.clickItem = click;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
