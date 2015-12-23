//
//  RTCountView.m
//  RTHealth
//
//  Created by cheng on 15/1/8.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RTCountView.h"
#import <AudioToolbox/AudioToolbox.h>

#define startbutton_height 140
#define startbutton_width 140
#define PI 3.14159265358979323846

@implementation RTCountView
//传入计时的时间
- (id)initWithFrame:(CGRect)frame time:(long)timelong{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.timecount = timelong;
        [self setupUI];
        [self setupButton];
        NSLog(@"%f",frame.size.height);
        UIView *viewCount = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [self addSubview:viewCount];
        NSURL *url = [[NSBundle mainBundle]URLForResource:@"54321.mp3" withExtension:nil];
        self.audioplayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        [self.audioplayer prepareToPlay];
        self.backgroundColor = [UIColor clearColor];
        
        //计时器返回的进度
        [self.counterLabel progressReturn:^(float number){
            if (number>_progress) {
                _progress = number;
            }
            if (self.counterLabel.currentValue <= 5*1000) {
                //播放音乐
                [self playMusic];
            }
            [self setNeedsDisplay];
        }];
    }
    return self;
}

//播放音乐
- (void)playMusic{
    if (self.audioplayer.isPlaying) {
        
    }else{
        [self.audioplayer play];
    }
}

- (void)stopMusic{
    if (self.audioplayer.isPlaying) {
        [self.audioplayer stop];
    }else{
    }
}

//加载倒计时

- (void)setupUI{
    CGPoint centerpoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(centerpoint.x-startbutton_width/2, centerpoint.y-startbutton_height/2, startbutton_width, startbutton_height);
    [startBtn addTarget:self action:@selector(clickStart) forControlEvents:UIControlEventTouchUpInside];
    startBtn.layer.cornerRadius = startbutton_height/2;
    startBtn.layer.masksToBounds = YES;
    [self addSubview:startBtn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, startbutton_width, 40)];
    label.text = @"倒计时";
    label.font = [UIFont boldSystemFontOfSize:10.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [startBtn addSubview:label];
    
    self.counterLabel = [[RTCounterLaebl alloc]initWithFrame:CGRectMake(0, startbutton_height-48, startbutton_width, 40)];
//    [self.counterLabel setBoldFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20]];
//    [self.counterLabel setRegularFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20]];
    [self.counterLabel setBoldFont:[UIFont systemFontOfSize:12]];
    [self.counterLabel setRegularFont:[UIFont systemFontOfSize:12]];
    [self.counterLabel setFont:[UIFont systemFontOfSize:10]];
    self.counterLabel.textColor = [UIColor whiteColor];
    self.counterLabel.countDirection = kCountDirectionDown;
    self.counterLabel.startValue = self.timecount;
    self.counterLabel.delegate = self;
    [self.counterLabel updateApperance];
    [startBtn addSubview:self.counterLabel];
}
#pragma mark -  RTCounterLabel Delegate
//计时结束
- (void)countDidEnd{
    _progress = 1.0;
    [self setNeedsDisplay];
    [self stopMusic];
    [self.delegate timerDidEnd];
}
- (void)setupButton{
    if (self.counterLabel.isRunning) {
        [startBtn setBackgroundImage:[UIImage imageNamed:@"course_action_start.png"] forState:UIControlStateNormal];
    }else{
        [startBtn setBackgroundImage:[UIImage imageNamed:@"course_action_stop.png"] forState:UIControlStateNormal];
    }
}
//计时暂停
- (void)stop{
    [self.counterLabel stop];
    [self stopMusic];
    [self setupButton];
}
//计时开始
- (void)start{
    [self.counterLabel start];
    [self setupButton];
}
//画进度条
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetRGBStrokeColor(context,202.0/255.0, 87.0f/255.0, 6.0f/255.0,  1.0);
//    CGContextAddArc(context,self.frame.size.width/2,self.frame.size.height/2, 60, 0, 2*PI*_progress, 0);
    CGContextAddArc(context,self.frame.size.width/2,self.frame.size.height/2, 60, -PI/2, 2*PI*_progress-PI/2, 0);
    CGContextSetLineWidth(context, 15.0);
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)clickStart{
    if (self.counterLabel.isRunning) {
        [self stop];
    }else{
        [self start];
    }
}
@end
