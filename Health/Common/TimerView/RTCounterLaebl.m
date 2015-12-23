//
//  RTCounterLaebl.m
//  RTHealth
//
//  Created by cheng on 15/1/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RTCounterLaebl.h"

@interface RTCounterLaebl (){
    
}

@property (strong,nonatomic) NSString *valueString;
@property (strong,nonatomic) NSTimer *clockTimer;
@property (nonatomic,assign) unsigned long value;
@property (nonatomic,assign) unsigned long resetValue;
@property (nonatomic,assign) double startTime;
@property (nonatomic,assign) double running;

@end

@implementation RTCounterLaebl

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)commonInit{
    
    self.valueString = @"";
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont systemFontOfSize:25];
    self.boldFont = [UIFont boldSystemFontOfSize:55];
    self.regularFont = [UIFont systemFontOfSize:55];
    self.countDirection = kCountDirectionUp;
    self.value = 0;
    self.startValue = 0;
    
}


#pragma mark - Setters

- (void)setValue:(unsigned long)value {
    _value = value;
    self.currentValue = _value;
    [self updateDisplay];
}

- (void)setStartValue:(unsigned long)startValue {
    _startValue = startValue;
    self.resetValue = _startValue;
    [self setValue:startValue];
}

#pragma mark - Private

- (void)updateDisplay {
    
    if (self.countDirection == kCountDirectionDown && _value < 100) {
        [self stop];
        self.valueString = @"0s";
        
        // Inform any delegates
        if (self.delegate && [self.delegate respondsToSelector:@selector(countDidEnd)]) {
            [self.delegate performSelector:@selector(countDidEnd)];
        }
    } else {
        self.valueString = [self timeFormattedStringForValue:_value];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [self setText:self.valueString afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        // Hours
        if (weakSelf.value > 3599999) {
            // The hours will be bold font, we need to set the font for the mins and secs
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)weakSelf.regularFont.fontName, weakSelf.regularFont.pointSize, NULL);
            
            if (font) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange(4, 2)];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange(8, 2)];
                CFRelease(font);
            }
        }
        
        // Mins
        if (weakSelf.value > 59999) {
            // The mins will be bold font, we need to set the font for the secs
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)weakSelf.regularFont.fontName, weakSelf.regularFont.pointSize, NULL);
            
            if (font) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange(4, 2)];
                CFRelease(font);
            }
        }
        
        CTFontRef boldFont = CTFontCreateWithName((__bridge CFStringRef)weakSelf.boldFont.fontName, weakSelf.boldFont.pointSize, NULL);
        
        if (boldFont) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)boldFont range:NSMakeRange(0, 2)];
            CFRelease(boldFont);
        }
        
        return mutableAttributedString;
    }];
    
    [self setNeedsDisplay];
}

- (void)clockDidTick:(NSTimer *)timer {
    double currentTime = CFAbsoluteTimeGetCurrent();
    
    double elapsedTime = currentTime - self.startTime;
    
    // Convert the double to milliseconds
    unsigned long milliSecs = (unsigned long)(elapsedTime * 1000);
    
    if (self.countDirection == kCountDirectionDown) {
        [self setValue:(_startValue - milliSecs)];
    } else {
        [self setValue:(_startValue + milliSecs)];
    }
    
    
    if (self.progressPoint!=nil) {
        double elap = currentTime - self.resetValue;
        unsigned long mill = (unsigned long)(elap * 1000);
        NSLog(@"mill %ld %ld %f %ld",mill,self.resetValue,currentTime,self.value);
        self.progressPoint( (float) ( self.resetValue - self.value ) / self.resetValue);
    }

}

- (void)progressReturn:(ProgressBlock)block{
    self.progressPoint = block;
}

- (NSString *)timeFormattedStringForValue:(unsigned long)value {
    int msperhour = 3600000;
    int mspermin = 60000;
    
    int hrs = value / msperhour;
    int mins = (value % msperhour) / mspermin;
    int secs = ((value % msperhour) % mspermin) / 1000;
    
    NSString *formattedString = @"";
    
    if (hrs == 0) {
        if (mins == 0) {
//            formattedString = [NSString stringWithFormat:@"%02d", secs];
            formattedString = [NSString stringWithFormat:@"%02d: %02d: %02d", hrs, mins, secs];
        } else {
            formattedString = [NSString stringWithFormat:@"%02d: %02d: %02d", hrs, mins, secs];
        }
    } else {
        formattedString = [NSString stringWithFormat:@"%02d: %02d: %02d", hrs, mins, secs];
    }
    
    return formattedString;
}

#pragma mark - Public

- (void)start {
    if (self.running) return;
    
    self.startTime = CFAbsoluteTimeGetCurrent();
    
    self.running = YES;
    self.isRunning = self.running;
    
    self.clockTimer = [NSTimer timerWithTimeInterval:0.002
                                              target:self
                                            selector:@selector(clockDidTick:)
                                            userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.clockTimer forMode:NSRunLoopCommonModes];
}

- (void)stop {
    if (self.clockTimer) {
        [self.clockTimer invalidate];
        self.clockTimer = nil;
        
        _startValue = self.value;
    }
    
    self.running = NO;
    self.isRunning = self.running;
}

- (void)reset {
    [self stop];
    
    self.startValue = self.resetValue;
    [self setValue:self.resetValue];
}

- (void)updateApperance {
    [self setValue:_currentValue];
}

@end
