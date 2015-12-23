//
//  PersonTrainCell.h
//  Health
//
//  Created by cheng on 15/3/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickImage)(void);

@interface PersonTrainCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIImageView *trainImage;
@property (nonatomic,strong) IBOutlet UIImageView *levelImage;
@property (nonatomic,strong) IBOutlet UIImageView *stateImage;
@property (nonatomic,strong) IBOutlet UILabel *pointLabel;
@property (nonatomic,strong) IBOutlet UILabel *commentLabel;

@property (nonatomic,strong) ClickImage click;

- (void)clickImage:(ClickImage)clickItem;

@end
