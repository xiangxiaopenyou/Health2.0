//
//  CreateActivityViewController.h
//  Health
//
//  Created by realtech on 15/5/20.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateActivityViewController : UIViewController

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UITextField *linkTextField;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) NSString *club_id;

@end
