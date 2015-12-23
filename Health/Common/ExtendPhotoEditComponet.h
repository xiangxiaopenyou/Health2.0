//
//  ExtendPhotoEditComponet.h
//  Health
//
//  Created by 天池邵 on 15/6/19.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TuSDK/TuSDK.h>
#define RGB(r, g, b)            RGBA(r, g, b, 1)

@interface ExtendPhotoEditComponet : NSObject
- (void)showSimpleWithController:(UIViewController *)controller image:(UIImage *)image callback:(void(^)(UIImage *))block;
@end