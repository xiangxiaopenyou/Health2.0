//
//  ChooseThemeViewController.h
//  Health
//
//  Created by 项小盆友 on 15/3/1.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChooseThemeDelegate <NSObject>
@optional
- (void)clickFinish:(NSString*)themeString;
@end

@interface ChooseThemeViewController : UIViewController

@property (nonatomic, strong)UITextField *createThemeTextField;
@property (nonatomic, strong)UIButton *cancelOrSubmitButton;
@property (nonatomic, strong) UITableView *themeTableView;

@property (nonatomic, strong) NSString *discussionType;
@property (nonatomic, strong) NSString *discussionTheme;

@property (nonatomic, strong) id<ChooseThemeDelegate>delegate;

@end
