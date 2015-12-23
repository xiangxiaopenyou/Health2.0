//
//  HSCButton.m
//  AAAA
//
//  Created by zhangmh on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HSCButton.h"

@implementation HSCButton

@synthesize dragEnable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        tagImageRight = [UIImage imageNamed:@"tag_right"];
        tagImageLeft = [UIImage imageNamed:@"tag_left"];
        UIEdgeInsets insets_right = UIEdgeInsetsMake(0, 52, 0, 10);
        UIEdgeInsets insets_left = UIEdgeInsetsMake(0, 10, 0, 52);
        tagImageRight = [tagImageRight resizableImageWithCapInsets:insets_right resizingMode:UIImageResizingModeStretch];
        tagImageLeft = [tagImageLeft resizableImageWithCapInsets:insets_left resizingMode:UIImageResizingModeStretch];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    beginPoint = [touch locationInView:self];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    
    CGPoint newcenter = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
    if (newcenter.x < self.frame.size.width/2){
        newcenter.x = self.frame.size.width/2;
    }
    if (newcenter.x > [[UIScreen mainScreen] bounds].size.width - self.frame.size.width/2) {
        newcenter.x = [[UIScreen mainScreen] bounds].size.width - self.frame.size.width/2;
    }
    if (newcenter.y < self.frame.size.height/2) {
        newcenter.y = self.frame.size.height/2;
    }
    if (newcenter.y > self.superview.frame.size.height - self.frame.size.height/2) {
        newcenter.y = self.superview.frame.size.height - self.frame.size.height/2;
    }
    self.center = newcenter;
    
    if (self.center.x > SCREEN_WIDTH/2 + 10) {
        [self setBackgroundImage:tagImageRight forState:UIControlStateNormal];
    }
    else {
        [self setBackgroundImage:tagImageLeft forState:UIControlStateNormal];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"X:%f Y:%f", self.center.x, self.center.y);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
