//
//  UsersListTableViewCell.h
//  Health
//
//  Created by realtech on 15/5/27.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersListTableViewCell : UITableViewCell{
    UserInfo *userInfo;
    NSInteger friendship;
}

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UIButton *attentionButton;
@property (nonatomic, strong) NSDictionary *dictionary;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier wihtDic:(NSDictionary*)dic;


@end
