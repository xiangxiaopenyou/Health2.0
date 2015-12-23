//
//  ClubCurriculumViewController.h
//  Health
//
//  Created by realtech on 15/5/21.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubCurriculumViewController : UIViewController<UIWebViewDelegate>{
    UIWebView *web;
}

@property (nonatomic, strong) NSString *club_id;
@property (nonatomic, strong) NSString *user_type;

@end
