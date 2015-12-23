//
//  PresentSegue.m
//  Health
//
//  Created by cheng on 15/1/28.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PresentSegue.h"

@implementation PresentSegue

- (void)perform {
    UIViewController *srcVC = self.sourceViewController;
    UIViewController *destVC = self.destinationViewController;
    [srcVC presentViewController:destVC animated:YES completion:^{
        
    }];
}
@end
