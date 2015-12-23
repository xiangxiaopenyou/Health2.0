//
//  WriteClubDiscussionViewController.h
//  Health
//
//  Created by jason on 15/3/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteClubDiscussionViewController : UIViewController

@property (nonatomic, strong)UITextField *titleTextField;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIImageView *trendImage;
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) NSString *clubId;
@property (nonatomic, strong) NSString *clubOwnerId;
@property (nonatomic, strong) NSString *clubUserType;

@end
