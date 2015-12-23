//
//  RTTabbarViewController.h
//  RTHealth
//
//  Created by cheng on 14-10-15.
//  Copyright (c) 2014年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTTabbarItem.h"

typedef enum
{
    // Home page
    RT_TABITEM_PERSONAL = 0,
    // Local Page
    RT_TABITEM_TOPIC = 1,
    // Search Page
    RT_TABITEM_SEARCH =2,
    // Mine
    RT_TABITEM_MINE = 3,
    // Setting
    RT_TABITEM_SETTING =4
} RTTabItemType;


#define SELECTED_VIEW_CONTROLLER_TAG 98456345

@interface RTTabbarViewController : UIViewController<RTTabbarItemDelegate>{
    RTTabbarItem *tabBar;
    NSArray *tabBarItems;
    RTTabItemType curItemType;
    NSInteger defaultIndex;
}

@end
