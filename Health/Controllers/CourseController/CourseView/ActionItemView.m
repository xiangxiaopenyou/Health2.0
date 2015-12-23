//
//  ActionItemView.m
//  Health
//
//  Created by cheng on 15/1/28.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ActionItemView.h"
#import "ActionRightViewCell.h"

@implementation ActionItemView

- (instancetype)initWithFrame:(CGRect)frame CourseSub:(NSArray*)courseSubArray{
    self = [super initWithFrame:frame];
    if (self) {
        arrayData = courseSubArray;
        self.isShow = NO;
        tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        tableview.dataSource = self;
        tableview.delegate = self;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.tableFooterView = [[UIView alloc]init];
        [self addSubview:tableview];
        
        self.backgroundColor = TABLEVIEWCELL_COLOR;
        tableview.backgroundColor = [UIColor clearColor];
        @try {
            [tableview selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        @catch (NSException *exception) {
        }
        @finally {
            
        }
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectItem != nil) {
        self.selectItem([NSString stringWithFormat:@"%ld",(long)indexPath.row]);
    }
}

- (void)selectActionItem:(SelectItem)block{
    self.selectItem = block;
}

- (void)reloadTable{
    [tableview reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CourseSub *courseSubTemp = [arrayData objectAtIndex:indexPath.row];
    static NSString *identifier = @"ActionRightView";
    
    ActionRightViewCell *rightCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (rightCell == nil) {
        rightCell = [[ActionRightViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    rightCell.selectionStyle = UITableViewCellSelectionStyleNone;
    rightCell.title.text = [NSString stringWithFormat:@"%d.%@",courseSubTemp.coursesuborder.intValue, courseSubTemp.coursesubtitle];
    rightCell.intrduce.text = courseSubTemp.coursesubintrduce;
   
    if (self.isStart) {
        
        if (indexPath.row == 0 && [courseSubTemp.coursesubflag intValue] == 1) {
            rightCell.lockImage.image = [UIImage imageNamed:@"already_finish.png"];
        }else if (indexPath.row == 0 && [courseSubTemp.coursesubflag intValue] != 1){
            
        }else{
            CourseSub *courseSubTempFront = [arrayData objectAtIndex:indexPath.row-1];
            if ([courseSubTemp.coursesubflag intValue] == 1){
                rightCell.lockImage.image = [UIImage imageNamed:@"already_finish.png"];
            } else if ([courseSubTempFront.coursesubflag intValue] == 1) {
//                rightCell.lockImage.image = [UIImage imageNamed:@"already_finish.png"];
            }else{
                rightCell.lockImage.image = [UIImage imageNamed:@"lock_action_image.png"];
                rightCell.selected = NO;
            }
        }
        
        
    }else{
        
        rightCell.lockImage.image = [UIImage imageNamed:@"lock_action_image.png"];
    }
    return rightCell;
}

@end
