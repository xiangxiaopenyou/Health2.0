//
//  ChatListCell.h
//  Health
//
//  Created by cheng on 15/3/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatListCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIImageView *photoImageView;
@property (nonatomic,strong) UILabel *notReadLabel;

@end
