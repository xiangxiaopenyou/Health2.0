//
//  DairyTableViewCell.h
//  Health
//
//  Created by realtech on 15/4/28.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DairyTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *weightLabel;
@property (nonatomic, strong) UILabel *sportsLabel;
@property (nonatomic, strong) UILabel *sportsEnergyLabel;
@property (nonatomic, strong) UILabel *foodLabel;
@property (nonatomic, strong) UILabel *foodEnergyLabel;
@property (nonatomic, strong) UIImageView *dairyImage;
@property (nonatomic, assign) NSInteger height;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDic:(NSDictionary*)dic;

@end
