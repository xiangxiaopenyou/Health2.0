//
//  VideoView.m
//  Health
//
//  Created by cheng on 15/1/27.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "VideoView.h"

@implementation VideoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame Url:(NSString*)urlString{
    self = [super initWithFrame:frame];
    if (self) {
        url = urlString;
        self.playerView = [[PlayerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*9/16) Url:urlString];
        [self addSubview:self.playerView];
        
        self.clearView = [[UIView alloc]initWithFrame:self.playerView.frame];
        self.clearView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickStop)];
        [self.clearView addGestureRecognizer:tap];
        [self addSubview:self.clearView];
        
        self.backgroundView = [[UIView alloc]initWithFrame:self.playerView.frame];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 60, SCREEN_WIDTH-32, 40)];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.font = [UIFont boldSystemFontOfSize:17.0];
        self.contentLabel.textColor = [UIColor whiteColor];
        
        self.videoLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 110, SCREEN_WIDTH-32, 40)];
        self.videoLabel.textAlignment = NSTextAlignmentCenter;
        self.videoLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.videoLabel.textColor = [UIColor whiteColor];
        [self.backgroundView addSubview:self.contentLabel];
        [self.backgroundView addSubview:self.videoLabel];
        
        UITapGestureRecognizer *tapStart = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickStart)];
        
        [self.backgroundView addGestureRecognizer:tapStart];
        [self addSubview:self.backgroundView];
        
        self.fullSrceenbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.fullSrceenbtn.frame = CGRectMake(self.playerView.frame.size.width-8-32, self.playerView.frame.size.height-8-21, 32, 21);
        [self.fullSrceenbtn setBackgroundImage:[UIImage imageNamed:@"course_action_full.png"] forState:UIControlStateNormal];
        [self.fullSrceenbtn addTarget:self action:@selector(clickFullScreen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.fullSrceenbtn];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    NSLog(@"seFrame");
    if (frame.size.height*16/9>frame.size.width) {
        self.playerView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height*9/16);
    }else{
        self.playerView.frame = CGRectMake(0, 0, frame.size.height*16/9, frame.size.height);
    }
    self.clearView.frame = self.playerView.frame;
    self.backgroundView.frame = self.playerView.frame;
    
}

- (void)clickFullScreen:(id)sender{
    [self.delegate clickFullScreen:url];
}
- (void)clickStart{
    self.backgroundView.hidden = YES;
    [self.playerView play];
}

- (void)clickStop{
    self.backgroundView.hidden = NO;
    [self.playerView pause];
}

- (void)stopVideo{
    [self.playerView pause];
}

- (void)initVideoUrl:(NSString*)urlString{
    if (!self) {
    }
    url = urlString;
    [self.playerView replaceCurrentItemWithUrl:urlString];
}
@end
