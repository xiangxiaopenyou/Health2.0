//
//  RTTabbarItem.h
//  RTHealth
//
//  Created by cheng on 14-10-15.
//  Copyright (c) 2014年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GLOW_IMAGE_TAG 2394858
#define TAB_ARROW_IMAGE_TAG 2394859

@class RTTabbarItem;

@protocol  RTTabbarItemDelegate <NSObject>

- (NSString*)titleFor:(RTTabbarItem*)tabbar atIndex:(NSUInteger)itemIndex;
- (UIImage*)imageFor:(RTTabbarItem*)tabbar atIndex:(NSUInteger)itemIndex;
- (UIImage*)imageforSelected:(RTTabbarItem*)tabbar atIndex:(NSUInteger)itemIndex;
- (UIImage*)backgroundImage;
- (UIImage*)selectedItemBackgroundImage;
- (UIImage*)glowImage;
- (UIImage*)selectedItemImage;
- (UIImage*)tabbarArrowImage;

@optional

- (void)touchUpInsideItemAtIndex:(NSUInteger)itemIndex;
- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex;
- (void)touchDownAtMidItem;

@end

@interface RTTabbarItem : UIView{
    NSMutableArray *buttons;
    NSMutableArray *buttonsImage;
    NSMutableArray *labels;
    NSObject <RTTabbarItemDelegate> *delegate;
}

@property (nonatomic,retain) NSMutableArray *buttons;
@property (nonatomic,retain) NSMutableArray *buttonsImage;
@property (nonatomic,retain) NSMutableArray *labels;


- (id) initWithItemCount:(NSUInteger)itemCount itemSize:(CGSize)itemSize tag:(NSInteger)objectTag delegate:(NSObject <RTTabbarItemDelegate> *)customTabBarDelegate;

- (void) selectItemAtIndex:(NSInteger)index;
- (void) glowItemAtIndex:(NSInteger)index;
- (void) removeGlowAtIndex:(NSInteger)index;


@end
