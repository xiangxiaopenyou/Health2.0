//
//  PlayerView.m
//  AVPlayerProject
//
//  Created by cheng on 15/1/27.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self setupUI];
    }
    return self;
}

//view init
- (instancetype)initWithFrame:(CGRect)frame Url:(NSString*)urlString{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        playerUrl = [Util urlPhoto:urlString];
        [self setupUI];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

//添加avplayer的container
- (void)setupUI{
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame=self.bounds;
    playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;//视频填充模式
    [self.layer addSublayer:playerLayer];
}

//初始化player
- (AVPlayer*)player{
    if (!_player) {
        if (playerUrl == nil) {
            return _player;
        }
        self.playerItem=[self getPlayItem:playerUrl];
        _player=[AVPlayer playerWithPlayerItem:self.playerItem];
    }
    return _player;
}
-(void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");
    if (playerUrl != nil) {
        [self replaceCurrentItemWithUrl:playerUrl];
        [self play];
    }
}

//加载AVPlayerItem
-(AVPlayerItem *)getPlayItem:(NSString*)urlString{
    NSString *urlStr = urlString;
    urlStr =[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    return playerItem;
}

//播放
- (void)play{
    if (_player){
        [self.player play];
    }
}

//暂停
- (void)pause{
    if (_player) {
        [_player pause];
    }
}

//替换播放地址
- (void)replaceCurrentItemWithUrl:(NSString*)urlString{
    if (urlString) {
        playerUrl = [Util urlForVideo:urlString];
        [_player replaceCurrentItemWithPlayerItem:[self getPlayItem:playerUrl]];
    }
}
@end
