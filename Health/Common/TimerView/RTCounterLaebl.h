//
//  RTCounterLaebl.h
//  RTHealth
//
//  Created by cheng on 15/1/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "TTTAttributedLabel.h"

typedef NS_ENUM(NSInteger, kCountDirection){
    kCountDirectionUp = 0,
    kCountDirectionDown
};

typedef  void (^ProgressBlock)(float number);

@protocol RTCounterLabelDelegate <NSObject>

@optional

- (void)countDidEnd;

@end

@interface RTCounterLaebl : TTTAttributedLabel

@property (weak) id<RTCounterLabelDelegate> delegate;
@property (nonatomic,assign) unsigned long currentValue;
@property (nonatomic,assign) unsigned long startValue;
@property (nonatomic,assign) NSInteger countDirection;
@property (strong,nonatomic) UIFont *boldFont;
@property (strong,nonatomic) UIFont *regularFont;
@property (nonatomic,assign) BOOL isRunning;
@property (nonatomic,copy) ProgressBlock progressPoint;

- (void)progressReturn:(ProgressBlock)block;

#pragma mark - Public

- (void)start;
- (void)stop;
- (void)reset;
- (void)updateApperance;

@end
