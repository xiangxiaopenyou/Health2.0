//
//  ClockinDetailViewController.h
//  Health
//
//  Created by realtech on 15/5/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClockinDetailViewController : UIViewController

@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, assign) BOOL isCommentsShow;
@property (nonatomic, assign) BOOL isCommentIn;
@property (nonatomic, strong) NSString *trendid;

@end
