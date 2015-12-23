//
//  CourseWebViewController.h
//  Health
//
//  Created by realtech on 15/4/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseWebViewController : UIViewController{
    UIWebView *courseWeb;
}

@property (nonatomic, strong) NSString *urlString;

@end
