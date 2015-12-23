//
//  SegmentSelectCell.h
//  Health
//
//  Created by cheng on 15/3/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickSegment)(NSInteger index);

@interface SegmentSelectCell : UITableViewCell

@property (nonatomic,strong) UILabel *markLabel;
@property (nonatomic,strong) ClickSegment selectIndex;
@property (nonatomic,strong) UIButton *photoBtn;
@property (nonatomic,strong) UIButton *trainBtn;

- (void)clickPhoto:(id)sender;
- (void)clickTrain:(id)sender;
- (void)selectIndex:(ClickSegment)select;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Index:(NSInteger)index;

@end
