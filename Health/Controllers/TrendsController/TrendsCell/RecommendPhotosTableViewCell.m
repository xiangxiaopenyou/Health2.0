//
//  RecommendPhotosTableViewCell.m
//  Health
//
//  Created by realtech on 15/5/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RecommendPhotosTableViewCell.h"

@implementation RecommendPhotosTableViewCell
@synthesize leftPhoto, centerPhoto, rightPhoto;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        leftPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(12, 6, (SCREEN_WIDTH - 36)/3, (SCREEN_WIDTH - 36)/3)];
        leftPhoto.contentMode = UIViewContentModeScaleAspectFill;
        leftPhoto.clipsToBounds = YES;
        [leftPhoto addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeft)]];
        leftPhoto.userInteractionEnabled = YES;
        [self addSubview:leftPhoto];
        
        centerPhoto = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 36)/3 + 18, 6, (SCREEN_WIDTH - 36)/3, (SCREEN_WIDTH - 36)/3)];
        centerPhoto.contentMode = UIViewContentModeScaleAspectFill;
        centerPhoto.clipsToBounds = YES;
        [centerPhoto addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCenter)]];
        centerPhoto.userInteractionEnabled = YES;
        [self addSubview:centerPhoto];
        
        rightPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(2*(SCREEN_WIDTH - 36)/3 + 24, 6, (SCREEN_WIDTH - 36)/3, (SCREEN_WIDTH - 36)/3)];
        rightPhoto.contentMode = UIViewContentModeScaleAspectFill;
        rightPhoto.clipsToBounds = YES;
        [rightPhoto addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRight)]];
        rightPhoto.userInteractionEnabled = YES;
        [self addSubview:rightPhoto];
    }
    return self;
}
- (void)clickLeft {
    if (self.clickItem != nil) {
        self.clickItem(1);
    }
}
- (void)clickCenter {
    if (self.clickItem != nil) {
        self.clickItem(2);
    }
}
- (void)clickRight {
    if (self.clickItem != nil) {
        self.clickItem(3);
    }
}
- (void)clickImage:(ClickPhoto)click{
    self.clickItem = click;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
