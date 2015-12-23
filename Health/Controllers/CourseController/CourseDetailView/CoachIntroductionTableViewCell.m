//
//  CoachIntroductionTableViewCell.m
//  Health
//
//  Created by realtech on 15/5/13.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CoachIntroductionTableViewCell.h"

@implementation CoachIntroductionTableViewCell
@synthesize headImage, nicknameLabel, ageLabel, coachButton, introLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCourse:(FriendInfo *)info{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [headImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:info.friendphoto]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
        headImage.layer.masksToBounds = YES;
        headImage.layer.cornerRadius = 20;
        [self addSubview:headImage];
        
        nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 12, 120, 16)];
        nicknameLabel.font = SMALLFONT_14;
        nicknameLabel.textColor = WHITE_CLOCLOR;
        nicknameLabel.text = info.friendname;
        [self addSubview:nicknameLabel];
        
        UIImageView *sexImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, 30, 12, 12)];
        if ([info.friendsex integerValue] == MAN_FLAG) {
            sexImage.image = [UIImage imageNamed:@"sex_boy"];
        }
        else{
            sexImage.image = [UIImage imageNamed:@"sex _girl"];
        }
        [self addSubview:sexImage];
        
        ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(74, 28, 30, 16)];
        ageLabel.font = SMALLFONT_12;
        ageLabel.text = [NSString stringWithFormat:@"%ld",(long)[CustomDate getAgeToDate:info.friendbirthday]];
        ageLabel.textColor = TIME_COLOR_GARG;
        [self addSubview:ageLabel];
        
        coachButton = [UIButton buttonWithType:UIButtonTypeCustom];
        coachButton.frame = CGRectMake(SCREEN_WIDTH - 100, 15, 90, 30);
        coachButton.backgroundColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:82/255.0 alpha:1.0];
        [coachButton setTitle:@"进入主页" forState:UIControlStateNormal];
        [coachButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
        coachButton.titleLabel.font = SMALLFONT_12;
        coachButton.layer.masksToBounds = YES;
        coachButton.layer.cornerRadius = 2;
        [coachButton addTarget:self action:@selector(coachClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:coachButton];
        
        introLabel = [[UILabel alloc] init];
        introLabel.text = info.friendintrduce;
        introLabel.textColor = WHITE_CLOCLOR;
        introLabel.font = SMALLFONT_12;
        introLabel.numberOfLines = 0;
        introLabel.lineBreakMode = NSLineBreakByCharWrapping;
        CGSize introSize = [info.friendintrduce sizeWithFont:SMALLFONT_12 constrainedToSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        introLabel.frame = CGRectMake(10, 74, SCREEN_WIDTH - 20, introSize.height);
        [self addSubview:introLabel];
    }
    return self;
}

- (void)coachClick{
    if (self.click != nil) {
        self.click();
    }
}
- (void)clickBlockCoach:(ClickCoach)clickItem{
    self.click = clickItem;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
