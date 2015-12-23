//
//  ClubTableViewCell.h
//  Health
//
//  Created by jason on 15/3/5.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *clubImageView;
@property (nonatomic, strong) UILabel *clubNameLabel;
@property (nonatomic, strong) UILabel *clubMemberNumberLabel;
@property (nonatomic, strong) UILabel *clubPositionLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDic:(NSDictionary*)dic;

@end
