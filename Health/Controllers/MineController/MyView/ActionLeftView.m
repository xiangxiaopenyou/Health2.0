//
//  ActionLeftView.m
//  Health
//
//  Created by 王杰 on 15/2/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ActionLeftView.h"
#import "ActionLeftCellTableViewCell.h"

@implementation ActionLeftView

- (instancetype)initWithFrame:(CGRect)frame InfoSub:(NSArray *)infoSub ImageSub:(NSArray *)imageSub{
    self = [super initWithFrame:frame];
    if (self) {
        dataArray = infoSub;
        imageArray = imageSub;
        self.isShow = NO;
        tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = [[UIView alloc]init];
        [self addSubview:tableView];
        
        self.blackview = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60-64, frame.size.width, 60)];
        [self.blackview setBackgroundColor:[UIColor blackColor]];
        [self addSubview:self.blackview];
 
        self.btnSet = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2 - 35, 10, 80, 40)];
        [self.btnSet setBackgroundImage:[UIImage imageNamed:@"mineset"] forState:UIControlStateNormal];
        [self.btnSet addTarget:self action:@selector(mySet:) forControlEvents:UIControlEventTouchUpInside];
        [self.blackview addSubview:self.btnSet];
        
        self.backgroundColor = [UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1.0];
        tableView.backgroundColor = [UIColor clearColor];
        @try {
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        [self.delegate pushToMyCollection];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    CourseSub *courseSubTemp = [arrayData objectAtIndex:indexPath.row];
    static NSString *identifier = @"ActionLeftView";
    
    ActionLeftCellTableViewCell *leftcell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (leftcell == nil) {
        leftcell = [[ActionLeftCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    leftcell.selectionStyle = UITableViewCellSelectionStyleNone;
    leftcell.infoLabel.text = dataArray[indexPath.row];
    leftcell.infoImageView.image = imageArray[indexPath.row];
    return leftcell;
}



- (void)mySet:(UIButton *)sender {
    [self.delegate pushToMySet];
}
@end
