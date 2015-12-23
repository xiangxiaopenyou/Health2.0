//
//  CourseDaySelectView.m
//  Health
//
//  Created by cheng on 15/1/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseDaySelectView.h"

#define left_button_height 64
#define left_button_width 33

#define right_button_height 64
#define right_button_width 33

#define info_button_height 30
#define info_button_width 30

#define left_button_image @"course_action_leftday.png"
#define left_button_lock_image @"course_unaction_leftday.png"
#define right_button_image @"course_action_right.png"
#define right_button_lock_image @"course_unaction_right.png"

@implementation CourseDaySelectView
@synthesize current_index ;

- (id)initWithFrame:(CGRect)frame Course:(Course*)course{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI:course];
    }
    return self;
}

- (void)setupUI:(Course*)course{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    courseInfo = course;
    self.backgroundColor = CLEAR_COLOR;
    count_index = [courseInfo.courseday integerValue];
    today_index = [CustomDate getDayToDate:[CustomDate getBirthdayDate:courseInfo.coursestarttime]] + 1;
    if (today_index <= 0 || today_index >= count_index) {
        current_index = 1;
    }else{
        current_index = today_index;
    }
    [self setupScrollView];
    [self setupState];
    [self setupText];
}

- (void)setupText{
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @1.0;
    animation.toValue = @3.0;
    animation.duration = .5;
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation1.fromValue = @1.0;
    animation1.toValue = @0.0;
    animation1.duration = .5;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.removedOnCompletion = YES;
    group.duration             = .5;
    group.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.repeatCount         = 1;//FLT_MAX;  //"forever";
    group.fillMode             = kCAFillModeForwards;
    group.animations = [NSArray arrayWithObjects:animation,animation1, nil];
    
    [current_label.layer addAnimation:group forKey:@"scale"];
    
}

- (void)setupState{
    if (current_index==1) {
        [left_button setBackgroundImage:[UIImage imageNamed:left_button_lock_image] forState:UIControlStateNormal];
        left_button.userInteractionEnabled = NO;
    } else {
        [left_button setBackgroundImage:[UIImage imageNamed:left_button_image] forState:UIControlStateNormal];
        left_button.userInteractionEnabled = YES;
    }
    if (current_index == count_index){
        [right_button setBackgroundImage:[UIImage imageNamed:right_button_lock_image] forState:UIControlStateNormal];
        right_button.userInteractionEnabled = NO;
    } else {
        [right_button setBackgroundImage:[UIImage imageNamed:right_button_image] forState:UIControlStateNormal];
        right_button.userInteractionEnabled = YES;
    }
    
    
    
    NSInteger index = [CustomDate getDayToDate:[CustomDate getBirthdayDate:courseInfo.coursestarttime]]+1;//根据时间进行判断是否开始结束
    if ( index > [courseInfo.courseday intValue]) {//过期
        [imageview sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:courseInfo.coursephoto]] placeholderImage:[UIImage imageNamed:@""]];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"course_start_image.png"] forState:UIControlStateNormal];
        dateLabel.text = @"课程已结课";
    }else if (index <= 0) {//未开课
        imageview.image = [UIImage imageNamed:@"course_function_notstart.png"];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"course_notstart_image.png"] forState:UIControlStateNormal];
        dateLabel.text = [NSString stringWithFormat:@"课程开始于%@",courseInfo.coursestarttime];
    }else if ( index>0 && index<= [courseInfo.courseday intValue]) {//开课
        if (current_index>today_index) {
            imageview.image = [UIImage imageNamed:@"course_function_notstart.png"];
            [startBtn setBackgroundImage:[UIImage imageNamed:@"course_notstart_image.png"] forState:UIControlStateNormal];
            dateLabel.text = @"该日课程尚未开始";
        }else{
            if (current_index == today_index) {
                dateLabel.text = @"今日任务";
            }else{
                dateLabel.text = @"";
            }
            [imageview sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:courseInfo.coursephoto]] placeholderImage:[UIImage imageNamed:@""]];
            [startBtn setBackgroundImage:[UIImage imageNamed:@"course_start_image.png"] forState:UIControlStateNormal];
        }
    }
}

- (void)setupScrollView{
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width*9/16)];
    [imageview sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:courseInfo.coursephoto]] placeholderImage:[UIImage imageNamed:@""]];
    [self addSubview:imageview];
    
    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2 , 20, 200, 21)];
    dateLabel.font = [UIFont boldSystemFontOfSize:18.0];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textColor = [UIColor whiteColor];
    [self addSubview:dateLabel];
    
    startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake((imageview.frame.size.width-100)/2, (imageview.frame.size.height-100)/2, 100, 100);
    startBtn.layer.cornerRadius = 50;
    startBtn.layer.masksToBounds = YES;
    [startBtn setBackgroundImage:[UIImage imageNamed:@"course_start_image.png"] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(clickStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:startBtn];
    
    count_label = [[UILabel alloc]initWithFrame:CGRectMake(startBtn.frame.size.width/2, startBtn.frame.size.height/2+10, 40, 20)];
    count_label.font = [UIFont boldSystemFontOfSize:20.0];
    count_label.text = [NSString stringWithFormat:@"%ld",(long)count_index];
    count_label.textColor = [UIColor whiteColor];
    count_label.textAlignment = NSTextAlignmentCenter;
    [startBtn addSubview:count_label];
    
    current_label = [[UILabel alloc]initWithFrame:CGRectMake(startBtn.frame.size.width/2-40, startBtn.frame.size.height/2-30, 40, 30)];
    current_label.font = [UIFont boldSystemFontOfSize:30.0];
    current_label.text = [NSString stringWithFormat:@"%ld",(long)current_index];
    current_label.textColor = [UIColor whiteColor];
    current_label.textAlignment = NSTextAlignmentCenter;
    [startBtn addSubview:current_label];
    
    left_button = [UIButton buttonWithType:UIButtonTypeCustom];
    left_button.frame = CGRectMake(0, (imageview.frame.size.height-left_button_height)/2, left_button_width, left_button_height);
    [left_button setBackgroundImage:[UIImage imageNamed:left_button_image] forState:UIControlStateNormal];
    [left_button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:left_button];

    right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    right_button.frame = CGRectMake(imageview.frame.size.width-right_button_width, (imageview.frame.size.height-right_button_height)/2, right_button_width, right_button_height);
    [right_button addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [right_button setBackgroundImage:[UIImage imageNamed:right_button_image] forState:UIControlStateNormal];
    [self addSubview:right_button];
    
//    info_button = [UIButton buttonWithType:UIButtonTypeInfoLight];
//    info_button.frame = CGRectMake(self.frame.size.width - info_button_width - 10 , imageview.frame.size.height - info_button_height - 10, 30, 30 );
//    [info_button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [info_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    info_button.tintColor = [UIColor whiteColor];
//    info_button.layer.cornerRadius = 15;
//    info_button.layer.masksToBounds = YES;
//    [info_button addTarget:self action:@selector(infoClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:info_button];
}

- (void)clickStartBtn:(id)sender{
    [self.delegate clickStartCourseAction:current_index];
}
//- (void)infoClick:(id)sender{
//    [self.delegate clickCourseInfo];
//}

- (void)leftButtonClick{
    current_index = current_index-1;
    [self setupState];
    [self setupText];
    if (self.selectDay != nil) {
        self.selectDay([NSString stringWithFormat:@"%ld",(long)current_index]);
    }
}

- (void)rightButtonClick{
    current_index = current_index+1;
    [self setupState];
    [self setupText];
    if (self.selectDay != nil) {
        self.selectDay([NSString stringWithFormat:@"%ld",(long)current_index]);
    }
}

- (void)selectDayItem:(SelectDay)selectDay{
    self.selectDay = selectDay;
}
- (CGAffineTransform)transformForText{
    return CGAffineTransformIdentity;
}

//- (void)recentButtonClick{
//    [self.delegate clickRecentButton];
//}
//- (void)hottestButtonClick{
//    [self.delegate clickHottestButton];
//}

#pragma mark - animationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        
    }
    current_label.text = [NSString stringWithFormat:@"%ld",(long)current_index];
}

@end
