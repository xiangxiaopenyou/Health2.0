//
//  ClubMemberTableViewCell.m
//  Health
//
//  Created by realtech on 15/3/12.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClubMemberTableViewCell.h"

@implementation ClubMemberTableViewCell
@synthesize headImage, nicknameLabel, clubUserTypeLabel, manageButton, usertype, type, dictionary;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDic:(NSDictionary *)dic withType:(NSString *)typeString withUserType:(NSString *)userType{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        dictionary = dic;
        type = typeString;
        usertype = userType;
        //头像
        headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [headImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[dic objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
        headImage.layer.masksToBounds = YES;
        headImage.layer.cornerRadius = 20;
        [self addSubview:headImage];
        
        if ([userType integerValue] == 0 || [userType integerValue] == 2) {
            if ([[dic objectForKey:@"gag"] integerValue] == 1) {
                UIImageView *gagImage = [[UIImageView alloc] initWithFrame:CGRectMake(45, 45, 9, 9)];
                gagImage.image = [UIImage imageNamed:@"club_gag"];
                [self addSubview:gagImage];
            }
        }
        
        //昵称
        nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 150, 60)];
        nicknameLabel.text = [Util isEmpty:[dic objectForKey:@"nickname"]]?@"":[dic objectForKey:@"nickname"];
        nicknameLabel.font = SMALLFONT_14;
        nicknameLabel.textColor = WHITE_CLOCLOR;
        [self addSubview:nicknameLabel];
        
        //用户类型
        clubUserTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 58, 60)];
        clubUserTypeLabel.textColor = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:90/255.0 alpha:1.0];
        clubUserTypeLabel.font = SMALLFONT_14;
        clubUserTypeLabel.textAlignment = NSTextAlignmentRight;
        
        UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, 22.5, 15, 15)];
        rightImageView.image = [UIImage imageNamed:@"club_member_right"];
        
        //管理按钮
        manageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        manageButton.frame = CGRectMake(SCREEN_WIDTH - 39, 15.5, 29, 29);
        [manageButton setImage:[UIImage imageNamed:@"club_member_manage"] forState:UIControlStateNormal];
        [manageButton addTarget:self action:@selector(manageButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        switch ([typeString integerValue]) {
            case 0:{
                if ([userType integerValue] == 0) {
                    [self addSubview:rightImageView];
                }
                else if ([userType integerValue] == 1){
                    [self addSubview:rightImageView];
                    clubUserTypeLabel.text = @"创建者";
                    [self addSubview:clubUserTypeLabel];
                }
                else{
                    [self addSubview:rightImageView];
                    clubUserTypeLabel.text = @"管理员";
                    [self addSubview:clubUserTypeLabel];
                }
            }
                break;
            case 1:{
                if ([userType integerValue] == 0) {
                    [self addSubview:manageButton];
                }
                else if ([userType integerValue] == 1){
                    [self addSubview:rightImageView];
                    clubUserTypeLabel.text = @"创建者";
                    [self addSubview:clubUserTypeLabel];
                }
                else{
                    [self addSubview:manageButton];
                    clubUserTypeLabel.text = @"管理员";
                    [self addSubview:clubUserTypeLabel];
                }
            }
                break;
                
            case 2:{
                if ([userType integerValue] == 0) {
                    [self addSubview:manageButton];
                }
                else if ([userType integerValue] == 1){
                    [self addSubview:rightImageView];
                    clubUserTypeLabel.text = @"创建者";
                    [self addSubview:clubUserTypeLabel];
                }
                else{
                    [self addSubview:rightImageView];
                    clubUserTypeLabel.text = @"管理员";
                    [self addSubview:clubUserTypeLabel];
                }
            }
                break;
            default:
                break;
        }
    }
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 59.5, SCREEN_WIDTH - 10, 0.5)];
    line.backgroundColor = LINE_COLOR_GARG;
    [self addSubview:line];
    return self;
}

- (void)manageButtonClick{
    NSLog(@"点击了管理按钮");
    [self.delegate clickManage:dictionary withType:type withUserType:usertype];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
