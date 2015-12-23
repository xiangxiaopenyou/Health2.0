//
//  CoachIntroductionTableViewCell.h
//  Health
//
//  Created by realtech on 15/5/13.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickCoach)(void);

@interface CoachIntroductionTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UIButton *coachButton;
@property (nonatomic, strong) UILabel *introLabel;

@property (nonatomic, strong) ClickCoach click;

- (void)clickBlockCoach:(ClickCoach)clickItem;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCourse:(FriendInfo*)info;


@end
