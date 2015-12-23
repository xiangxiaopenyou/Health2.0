//
//  PersonalViewController.h
//  Health
//
//  Created by cheng on 15/3/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>{
    UIView *viewForTable;
    UITableView *dairyTableView;
    
    UILabel *clockinDaysLabel;
    UILabel *nowWeightLabel;
    UILabel *targetWeightLabel;
    UILabel *reducedWeightLabel;
    UILabel *consumeEnergyLabel;
    UILabel *englobeEnergyLabel;
    UIImageView *consumeImage;
    UIImageView *englobeImage;
    
    UserInfo *userinfo;
}

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSString *personID;
@property (nonatomic, assign) NSInteger isChat;

@property (nonatomic, strong) UIButton *chooseDairyButton;
@property (nonatomic, strong) UIButton *chooseMineButton;

@end
