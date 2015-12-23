//
//  ChooseLabelViewController.h
//  Health
//
//  Created by realtech on 15/4/16.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol chooseLabelDelegete <NSObject>

- (void)clickFinish:(NSString*)labelString;

@end

@interface ChooseLabelViewController : UIViewController{
    UITableView *labelTableView;
}

@property (nonatomic, strong) UITextField *writeLabelTextField;
@property (nonatomic, strong) UIButton *cancelOrSubmitButton;

@property (nonatomic, strong) id<chooseLabelDelegete>delegate;

@end
