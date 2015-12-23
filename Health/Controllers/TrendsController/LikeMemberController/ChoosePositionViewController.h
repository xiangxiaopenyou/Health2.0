//
//  ChoosePositionViewController.h
//  Health
//
//  Created by realtech on 15/5/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PositionViewDelegate <NSObject>
@optional
- (void)clickSubmit:(NSString*)positionString;
- (void)clickDeletePosition;
@end

@interface ChoosePositionViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    UITableView *positionTableView;
}
@property (nonatomic, strong) UITextField *positionTextField;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) NSString *defaultPositionString;

@property (nonatomic, strong) id<PositionViewDelegate>delegate;
@end
