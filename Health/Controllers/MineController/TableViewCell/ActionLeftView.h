//
//  ActionLeftView.h
//  Health
//
//  Created by 王杰 on 15/2/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActionLeftViewDelegate <NSObject>

@optional

- (void) pushToMySet;

@end

typedef void (^SelectItem)(NSString *itemid);

@interface ActionLeftView : UIView<UITableViewDataSource, UITableViewDelegate> {
    UITableView *tableView;
    NSArray *dataArray;
    NSArray *imageArray;
}

@property (nonatomic, weak) id<ActionLeftViewDelegate>delegate;

@property (nonatomic, copy) SelectItem selectItem;
@property (nonatomic, assign)Boolean isShow;
@property (nonatomic, assign)Boolean isStart;
@property (nonatomic, strong)UIButton *btnSet;
@property (nonatomic,strong) UIView *blackview;

- (instancetype)initWithFrame:(CGRect)frame InfoSub:(NSArray*)infoSub ImageSub:(NSArray*)imageSub;
- (void)selectActionItem:(SelectItem)block;

- (void) mySet:(UIButton *)sender;

@end
