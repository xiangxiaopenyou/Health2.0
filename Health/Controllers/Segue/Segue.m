//
//  Segue.m
//  Health
//
//  Created by cheng on 15/1/23.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "Segue.h"

@implementation Segue

- (void)perform {
    UIViewController *srcVC = self.sourceViewController;
    UIViewController *destVC = self.destinationViewController;
    
    [srcVC addChildViewController:destVC];
    [srcVC.view addSubview:destVC.view];
    destVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(srcVC.view.frame), CGRectGetHeight(srcVC.view.frame));
    [destVC didMoveToParentViewController:srcVC];
}

@end
