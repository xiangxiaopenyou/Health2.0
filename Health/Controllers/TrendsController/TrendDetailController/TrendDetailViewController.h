//
//  TrendDetailViewController.h
//  Health
//
//  Created by 项小盆友 on 15/1/27.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendDetailViewController : UIViewController

@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, assign) BOOL isCommentsShow;
@property (nonatomic, assign) BOOL isCommentIn;
@property (nonatomic, strong) NSString *trendid;

@end
