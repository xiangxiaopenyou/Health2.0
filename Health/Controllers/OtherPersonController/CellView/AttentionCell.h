//
//  AttentionCell.h
//  Health
//
//  Created by cheng on 15/3/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AttentionClick)(NSInteger index);

@interface AttentionCell : UITableViewCell

@property (nonatomic,strong) UIButton *attentionBtn;

@property (nonatomic,strong) AttentionClick click;

- (IBAction)clickMessage:(id)sender;
//- (IBAction)clickAttention:(id)sender;

- (void)attention:(AttentionClick)clickItem;

@end
