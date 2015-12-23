//
//  CourseMemberViewController.h
//  Health
//
//  Created by realtech on 15/3/16.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CourseMemberControllerDelegate <NSObject>

- (void)clickMember:(NSString*)studentid;

@end

@interface CourseMemberViewController : UIViewController

@property (nonatomic, strong) NSString *courseID;

@property (nonatomic, strong) id<CourseMemberControllerDelegate>delegate;

@end
