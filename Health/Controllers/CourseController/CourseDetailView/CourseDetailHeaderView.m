//
//  CourseDetailHeaderView.m
//  Health
//
//  Created by realtech on 15/5/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseDetailHeaderView.h"

@implementation CourseDetailHeaderView

@synthesize backgroundImage, coursenameLabel, bodyLabel, daysLabel, difficultyImage, difficultyLabel, priceLabel, oldPriceLabel, starttimeLabel, joinMemberLabel;

- (id)initWithFrame:(CGRect)frame withData:(Course *)course{
    self = [super initWithFrame:frame];
    if (self) {
        backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/4*3)];
        backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        [backgroundImage sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:course.coursephoto]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
        [self addSubview:backgroundImage];
        
        coursenameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 260, 29, 250, 30)];
        coursenameLabel.backgroundColor = [UIColor clearColor];
        coursenameLabel.font = [UIFont boldSystemFontOfSize:20];
        coursenameLabel.textColor = [UIColor whiteColor];
        coursenameLabel.textAlignment = NSTextAlignmentRight;
        coursenameLabel.text = course.coursetitle;
        [self addSubview:coursenameLabel];
        
        bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 38, 69, 28, 16)];
        //bodyLabel.text = @"全身";
        bodyLabel.textColor = WHITE_CLOCLOR;
        bodyLabel.font = SMALLFONT_12;
        bodyLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:bodyLabel];
        
        switch ([course.coursebody integerValue]) {
            case 10:
                bodyLabel.text = @"增肌";
                break;
            case 11:
                bodyLabel.text = @"减肥";
                break;
            case 12:
                bodyLabel.text = @"塑性";
                break;
            case 13:
                bodyLabel.text = @"康复";
                break;
            case 14:
                bodyLabel.text = @"健美";
                break;
            default:
                bodyLabel.text = @"其他";
                break;
        }
        
        daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 83, 69, 35, 16)];
        daysLabel.textColor = WHITE_CLOCLOR;
        daysLabel.font = SMALLFONT_12;
        daysLabel.textAlignment = NSTextAlignmentRight;
        daysLabel.text = [NSString stringWithFormat:@"%@天", course.courseday];
        [self addSubview:daysLabel];
        
        difficultyImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 131, 70, 38, 14)];
        //difficultyImage.image = [UIImage imageNamed:@"difficulty_easy"];
        [self addSubview:difficultyImage];
        
        difficultyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 161, 69, 29, 16)];
        //difficultyLabel.text = @"简单";
        difficultyLabel.textColor = WHITE_CLOCLOR;
        difficultyLabel.font =SMALLFONT_12;
        difficultyLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:difficultyLabel];
        
        if ([course.coursedifficultty integerValue] <= 2) {
            difficultyImage.image = [UIImage imageNamed:@"difficulty_easy"];
            difficultyLabel.text = @"简单";
            
        }
        else if ([course.coursedifficultty integerValue] <= 4){
            difficultyImage.image = [UIImage imageNamed:@"difficulty_normal"];
            difficultyLabel.text = @"普通";
        }
        else {
            difficultyImage.image = [UIImage imageNamed:@"difficulty_diffcult"];
            difficultyLabel.text = @"困难";
        }
        
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 50, 15)];
        price.font = SMALLFONT_12;
        price.text = @"课程价格";
        price.textColor = WHITE_CLOCLOR;
        [self addSubview:price];
        
        oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 50, 20)];
        oldPriceLabel.text = course.courseoldprice;
        oldPriceLabel.textColor = WHITE_CLOCLOR;
        oldPriceLabel.font = [UIFont boldSystemFontOfSize:19];
        [self addSubview:oldPriceLabel];
        
        UILabel *deleteLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 50, 1)];
        deleteLine.backgroundColor = WHITE_CLOCLOR;
        [oldPriceLabel addSubview:deleteLine];
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 150, 50, 20)];
        priceLabel.text = course.courseprice;
        priceLabel.font = BOLDFONT_19;
        priceLabel.textColor = MAIN_COLOR_YELLOW;
        [self addSubview:priceLabel];
        
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 25, 130, 50, 15)];
        date.text = @"开课时间";
        date.textColor = WHITE_CLOCLOR;
        date.font = SMALLFONT_12;
        date.textAlignment = NSTextAlignmentCenter;
        [self addSubview:date];
        
        starttimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 30, 150, 60, 20)];
        starttimeLabel.text = [course.coursestarttime substringWithRange:NSMakeRange(5, 5)];
        starttimeLabel.font = BOLDFONT_19;
        starttimeLabel.textColor = WHITE_CLOCLOR;
        starttimeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:starttimeLabel];
        
        UILabel *member = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 130, 50, 15)];
        member.text = @"参加人数";
        member.textColor = WHITE_CLOCLOR;
        member.font = SMALLFONT_12;
        member.textAlignment = NSTextAlignmentRight;
        [self addSubview:member];
        
        joinMemberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 150, 50, 20)];
        joinMemberLabel.text = [NSString stringWithFormat:@"%@/%@", course.courseapplynum, course.coursecount];
        joinMemberLabel.textColor = WHITE_CLOCLOR;
        joinMemberLabel.font = BOLDFONT_19;
        joinMemberLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:joinMemberLabel];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
