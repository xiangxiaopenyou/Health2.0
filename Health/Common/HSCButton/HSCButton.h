//
//  HSCButton.h
//  AAAA
//
//  Created by zhangmh on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
/*
其实,
 */
#import <UIKit/UIKit.h>

@interface HSCButton : UIButton
{
    CGPoint beginPoint;
    UIImage *tagImageRight;
    UIImage *tagImageLeft;
}

@property (nonatomic) BOOL dragEnable;
@end
