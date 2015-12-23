//
//  WriteIntrduceViewController.h
//  Health
//
//  Created by cheng on 15/3/5.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnTextBlock)(NSString *showText);

@interface WriteIntrduceViewController : UIViewController

@property (nonatomic,strong) NSString *content;

@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

-(void)returnText:(ReturnTextBlock)block;
@end
