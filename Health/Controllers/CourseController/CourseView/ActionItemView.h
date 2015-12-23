//
//  ActionItemView.h
//  Health
//
//  Created by cheng on 15/1/28.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectItem)(NSString *itemid);

@interface ActionItemView : UIView<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableview;
    NSArray *arrayData;
}

@property (nonatomic,assign) BOOL isShow;
@property (nonatomic, copy) SelectItem selectItem;
@property (nonatomic,assign) BOOL isStart;


- (instancetype)initWithFrame:(CGRect)frame CourseSub:(NSArray*)courseSubArray;

- (void)selectActionItem:(SelectItem)block;

- (void)reloadTable;
@end
