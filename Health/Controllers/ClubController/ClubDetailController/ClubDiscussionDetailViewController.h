//
//  ClubDiscussionDetailViewController.h
//  Health
//
//  Created by jason on 15/3/9.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubDiscussionDetailViewController : UIViewController

@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UIButton *commentButton;

@property (nonatomic, strong) NSString *discussionId;
@property (nonatomic, strong) NSString *clubUSerType;

@end
