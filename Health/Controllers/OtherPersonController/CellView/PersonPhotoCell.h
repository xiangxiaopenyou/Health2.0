//
//  PersonPhotoCell.h
//  Health
//
//  Created by cheng on 15/3/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickPhoto)(NSInteger index);

@interface PersonPhotoCell : UITableViewCell

@property (nonatomic,strong) UIImageView *leftImage;
@property (nonatomic,strong) UIImageView *rightImage;

@property (nonatomic,strong) ClickPhoto clickItem;

- (void)clickImage:(ClickPhoto)click;

@end
