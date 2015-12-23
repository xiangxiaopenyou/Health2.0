//
//  MessageFavoriteCell.h
//  Health
//
//  Created by cheng on 15/2/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageFavoriteCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *fromLabel;
@property (nonatomic,strong) UIImageView *portraitImage;
@property (nonatomic,strong) UIImageView *photoimage;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
