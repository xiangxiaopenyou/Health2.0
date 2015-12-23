//
//  MyCourseView.h
//  Health
//
//  Created by cheng on 15/1/24.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyCourseViewDelegate <NSObject>

@optional

- (void)pushToMyCourse:(Course*)course;

@end

@interface MyCourseView : UIView<UIScrollViewDelegate>{
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    NSMutableArray *arrayData;
}

@property (nonatomic,weak) id<MyCourseViewDelegate>delegate;

- (void)setupUI;

@end
