//
//  FocusImageViewController.h
//  Health
//
//  Created by realtech on 15/5/27.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FocusImageViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView *web;
}

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *type;

@end
