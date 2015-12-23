//
//  ClubTrainingCampViewController.h
//  Health
//
//  Created by realtech on 15/5/22.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubTrainingCampViewController : UIViewController{
    UITableView *campTableView;
}

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *club_id;

@end
