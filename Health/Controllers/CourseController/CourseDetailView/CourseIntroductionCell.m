//
//  CourseIntroductionCell.m
//  Health
//
//  Created by realtech on 15/5/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseIntroductionCell.h"

@implementation CourseIntroductionCell
@synthesize introLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIntro:(NSString *)introString withIntroImage:(NSString *)imageString{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        introLabel = [[UILabel alloc] init];
        introLabel.text = introString;
        introLabel.font = SMALLFONT_12;
        introLabel.textColor = WHITE_CLOCLOR;
        introLabel.numberOfLines = 0;
        introLabel.lineBreakMode = NSLineBreakByCharWrapping;
        CGSize introSize = [introString sizeWithFont:SMALLFONT_12 constrainedToSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        introLabel.frame = CGRectMake(10, 14, SCREEN_WIDTH - 20, introSize.height);
        [self addSubview:introLabel];
        
        if (![Util isEmpty:imageString]) {
            NSArray *imageArray = [imageString componentsSeparatedByString:@";"];
            for (int i = 0; i < imageArray.count; i ++){
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10 + i * ((SCREEN_WIDTH - 38)/3 + 9), 26 + introSize.height, (SCREEN_WIDTH - 38)/3, 66)];
                [image sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[imageArray objectAtIndex:i]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                [self addSubview:image];
            }
        }
        
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
