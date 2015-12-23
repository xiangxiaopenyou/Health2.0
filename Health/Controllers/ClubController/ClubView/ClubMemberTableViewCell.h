//
//  ClubMemberTableViewCell.h
//  Health
//
//  Created by realtech on 15/3/12.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubMemberTableviewCellDelegate <NSObject>
@optional
- (void)clickManage:(NSDictionary*)dic withType:(NSString*)typeString withUserType:(NSString*)userType;

@end

@interface ClubMemberTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *clubUserTypeLabel;
@property (nonatomic, strong) UIButton *manageButton;

@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *usertype;

@property (nonatomic, strong) id<ClubMemberTableviewCellDelegate>delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDic:(NSDictionary*)dic withType:(NSString*)typeString withUserType:(NSString*)userType;

@end
