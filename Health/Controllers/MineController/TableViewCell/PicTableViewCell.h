//
//  PicTableViewCell.h
//  Health
//
//  Created by 王杰 on 15/2/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  PicTableViewCellDelegate<NSObject>

@optional

- (void)pushToImag1;
- (void)pushToImag2;

@end

typedef void(^SelectImage)(NSString*item);

@interface PicTableViewCell : UITableViewCell

@property (nonatomic,weak) id<PicTableViewCellDelegate>delegate;

@property (nonatomic, strong)  UIImageView *img1;
@property (nonatomic, strong)  UIImageView *img2;

@property (nonatomic,strong)  SelectImage selectImage;

- (void)imageleftPress:(UITapGestureRecognizer*)tap;
-(void)imagerightPress:(UITapGestureRecognizer *)tap;

- (void)selectImageItem:(SelectImage)block;

@end
