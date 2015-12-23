//
//  MyCourseView.m
//  Health
//
//  Created by cheng on 15/1/24.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MyCourseView.h"

@implementation MyCourseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupData{
    
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    arrayData = [NSMutableArray arrayWithArray:[userinfo.minecourse allObjects]];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"coursestarttime" ascending:YES];//生序
    [arrayData sortUsingDescriptors:[NSArray arrayWithObjects:sort,nil]];
}
- (void)setupUI{
    [self setupData];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, self.frame.size.width-16*2, 33)];
    title.text = @"我的训练营";
    title.font = [UIFont boldSystemFontOfSize:16.0];
    title.textColor = [UIColor blackColor];
    [self addSubview:title];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 33, self.frame.size.width,self.frame.size.width*9/16)];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    if (arrayData.count == 0 || [arrayData isEqual: [NSNull null]]) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, scrollView.frame.size.height)];
        imageView.image = [UIImage imageNamed:@"havenot_course_image.png"];
        [scrollView addSubview:imageView];
        return;
    }
    
    for (int i = 0; i< arrayData.count ; i ++ ) {
        Course *course = [arrayData objectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, scrollView.frame.size.height);
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[Util urlPhoto:course.coursephoto]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
        btn.tag = i;
        [btn addTarget:self action:@selector(clickCourse:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        NSInteger index = [CustomDate getDayToDate:[CustomDate getBirthdayDate:course.coursestarttime]]+1;//根据时间进行判断是否开始结束
        if ( index>0 && index<= [course.courseday intValue]) {
            imageview.image = [UIImage imageNamed:@"course_state_start.png"];
        }else if (index <= 0) {
            imageview.image = [UIImage imageNamed:@"course_state_notstart.png"];
        }else if ( index > [course.courseday intValue]) {
            imageview.image = [UIImage imageNamed:@"course_state_finish.png"];
        }
        [btn addSubview:imageview];
        
        UIView *backgroound_View = [[UIView alloc]initWithFrame:CGRectMake(0, scrollView.frame.size.height-50, self.frame.size.width, 50)];
        backgroound_View.backgroundColor = backview_color;
        [btn addSubview:backgroound_View];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, scrollView.frame.size.height-50, self.frame.size.width, 30)];
        label.text = course.coursetitle;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Optima-ExtraBlack" size:20.0];
        [btn addSubview:label];
        scrollView.contentSize = CGSizeMake((i+1)*self.frame.size.width,scrollView.frame.size.height);
    }
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-100)/2, self.frame.size.height-22, 100, 20)];
    pageControl.numberOfPages = arrayData.count;
    pageControl.currentPage = 0;
    [self addSubview:pageControl];
}

- (void)clickCourse:(UIButton*)btn{
    [self.delegate pushToMyCourse:[arrayData objectAtIndex:btn.tag]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollview{
    pageControl.currentPage = floor(scrollview.contentOffset.x/scrollview.frame.size.width);
}
@end
