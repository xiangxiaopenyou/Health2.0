//
//  PeosonInfoCell.h
//  Health
//
//  Created by cheng on 15/3/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Click)(NSInteger);

@interface PeosonInfoCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIImageView *photoImage;
@property (nonatomic,strong) IBOutlet UIImageView *sexImage;
@property (nonatomic,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) IBOutlet UILabel *attentionLabel;
@property (nonatomic,strong) IBOutlet UILabel *fansLabel;
@property (nonatomic,strong) IBOutlet UILabel *teacherLabel;
@property (nonatomic,strong) IBOutlet UILabel *skillLabel;
@property (nonatomic,strong) IBOutlet UILabel *goodAtLabel;

@property (nonatomic,strong) IBOutlet UIView *backView;

@property (nonatomic,strong) Click click;

- (void)clickLabel:(Click)clickItem;

@end
