//
//  VideoView.h
//  Health
//
//  Created by cheng on 15/1/27.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerView.h"

@protocol  VideoViewDelegate <NSObject>

@optional

- (void)clickFullScreen:(NSString*)string;

@end

@interface VideoView : UIView{
    NSString *url;
}

@property (nonatomic,weak) id<VideoViewDelegate>delegate;
@property (nonatomic,strong) PlayerView *playerView;
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) UIView *clearView;
@property (nonatomic,strong) UIButton *fullSrceenbtn;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *videoLabel;

- (void)initVideoUrl:(NSString*)urlString;
- (instancetype)initWithFrame:(CGRect)frame Url:(NSString*)urlString;
- (void)stopVideo;
@end
