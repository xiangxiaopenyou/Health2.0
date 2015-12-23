//
//  RTCountView.h
//  RTHealth
//
//  Created by cheng on 15/1/8.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTCounterLaebl.h"
#import <AVFoundation/AVFoundation.h>

@protocol RTCountViewDelegate <NSObject>

@optional

- (void)timerDidEnd;

@end

@interface RTCountView : UIView <RTCounterLabelDelegate>{
    UIButton *startBtn;
}

@property (nonatomic,strong) AVAudioPlayer *audioplayer;
@property (nonatomic,assign) long timecount;
@property (nonatomic,assign) float progress;
@property (strong, nonatomic) RTCounterLaebl *counterLabel;
@property (nonatomic,assign) id<RTCountViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame time:(long)timelong;
- (void)stop;
- (void)start;
@end
