//
//  ClubInformationViewController.h
//  Health
//
//  Created by realtech on 15/5/20.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubInformationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    UITableView *infoTableView;
    
}
@property (nonatomic, strong) UIButton *applyButton;
@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, strong) NSString *usertype;
@property (nonatomic, strong) NSString *clubID;
@property (nonatomic, strong) NSString *isJoin;
@property (nonatomic, strong) NSString *applyState;
@property (nonatomic, strong) NSString *introUrl;

@end
