//
//  PlayerView.h
//  AVPlayerProject
//
//  Created by cheng on 15/1/27.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerView : UIView{
    NSString *playerUrl;
}

@property (nonatomic,strong) AVPlayer *player;//播放器对象
@property (nonatomic,strong) AVPlayerItem *playerItem;
- (instancetype)initWithFrame:(CGRect)frame Url:(NSString*)urlString;//初始化播放器，传入网络地址
- (void)play;//播放
- (void)pause;//暂停
- (void)replaceCurrentItemWithUrl:(NSString*)urlString;//切换播放地址
@end
