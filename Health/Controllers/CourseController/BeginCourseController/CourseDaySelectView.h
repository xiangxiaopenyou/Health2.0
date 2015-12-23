//
//  CourseDaySelectView.h
//  Health
//
//  Created by cheng on 15/1/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CourseDaySelectViewDelegate <NSObject>

@optional

//- (void)clickCourseInfo;
- (void)clickStartCourseAction:(NSInteger)index;

@end

typedef void (^SelectDay)(NSString *days);

@interface CourseDaySelectView : UIView<UIScrollViewDelegate>{
    UIButton *startBtn;
    UILabel *count_label;
    UILabel *current_label;
    UIButton *left_button;
    UIButton *right_button;
    //UIButton *info_button;
    UIImageView *imageview;
    UILabel *dateLabel;
    
    NSInteger count_index;
    NSInteger today_index;
    
    Course *courseInfo;
}

@property (nonatomic,assign) NSInteger current_index;
@property (nonatomic,weak) id<CourseDaySelectViewDelegate>delegate;
@property (nonatomic,strong) SelectDay selectDay;
- (void)selectDayItem:(SelectDay)selectDay;

- (id)initWithFrame:(CGRect)frame Course:(Course*)course;
- (void)setupUI:(Course*)course;
@end
