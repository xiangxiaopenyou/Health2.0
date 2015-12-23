//
//  PhysicalStatusViewController.h
//  Health
//
//  Created by realtech on 15/6/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhysicalStatusViewController : UIViewController{
    UITextField *heightText;
    UITextField *weightText;
    UITextField *bustText;
    UITextField *waistlineText;
    UITextField *buttocksText;
    UITextField *armText;
    UITextField *thighText;
    UITextField *shankText;
    UITextField *pushupText;
    UITextField *abdominalVolumeText;
    UITextField *upwardLegText;
}

@property (nonatomic, assign) BOOL isCoachIn;
@property (nonatomic, strong) NSString *friendid;

@end
