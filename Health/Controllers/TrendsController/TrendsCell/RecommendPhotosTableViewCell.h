//
//  RecommendPhotosTableViewCell.h
//  Health
//
//  Created by realtech on 15/5/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickPhoto)(NSInteger index);

@interface RecommendPhotosTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftPhoto;
@property (nonatomic, strong) UIImageView *centerPhoto;
@property (nonatomic, strong) UIImageView *rightPhoto;

@property (nonatomic, strong) ClickPhoto clickItem;

- (void)clickImage:(ClickPhoto)click;

@end
