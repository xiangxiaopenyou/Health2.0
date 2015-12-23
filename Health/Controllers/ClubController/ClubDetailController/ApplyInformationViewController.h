//
//  ApplyInformationViewController.h
//  Health
//
//  Created by realtech on 15/5/25.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyInformationViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, strong) UITextView *infoTextView;
@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) NSString *club_id;

@end
