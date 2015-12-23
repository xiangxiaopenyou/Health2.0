//
//  PicAndTrainCell.h
//  Health
//
//  Created by 王杰 on 15/1/31.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PicAndTrainCellDelegate <NSObject>

@optional

- (void)clickChangePic:(NSInteger)index;

@end

@interface PicAndTrainCell : UITableViewCell

@property (nonatomic,weak) id<PicAndTrainCellDelegate>delegate;

@property (nonatomic, strong) UIButton* pictureLabel;
@property (nonatomic, strong) UIButton* trainLabel;
@property (nonatomic, strong) UILabel* markLabel;

- (void)btnPic:(UIButton*)sender;
- (void)btnTrain:(UIButton*)sender;

@end
