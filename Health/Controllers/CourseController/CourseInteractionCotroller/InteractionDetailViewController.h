//
//  InteractionDetailViewController.h
//  Health
//
//  Created by 项小盆友 on 15/1/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractionDetailViewController : UIViewController {
    UIButton *reportButton;
}

@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) NSString *interactionId;
@property (nonatomic, strong) NSDictionary *interactionDic;

@end
