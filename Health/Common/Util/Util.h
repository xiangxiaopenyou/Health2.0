//
//  Util.h
//  Health
//
//  Created by cheng on 15/1/23.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

/*
 判断是否登录成功
 一.userdefault里面是否存在userid和usertoken
 */
+ (BOOL)isLogin;

/*
 空值判断
 */
+ (BOOL)isEmpty:(id)sender;

/*
 星级选择
 */

+ (UIImage*)levelImage:(NSString*)string;

//原图
+ (NSString*)urlPhoto:(NSString*)key;
//缩放图片
+ (NSString*)urlZoomPhoto:(NSString*)key;

+ (NSString*)urlWeixinPhoto:(NSString*)key;

+ (NSString*)urlForVideo:(NSString*)key;

+ (BOOL)isValidateMobile:(NSString *)mobile;

//计算热量
+ (NSInteger)getSportsEnergy:(NSInteger)sportsTime withPerEnergy:(NSInteger)perEnergy;
+ (NSInteger)getFoodEnergy:(NSInteger)foodWeight withPerEnergy:(NSInteger)perEnergy;

//json
+ (NSString*)toJsonString:(id)theData;
+ (NSArray*)toArray:(NSString*)jsonString;

//能量图片
+ (NSString*)energyImage:(NSString *)energy;

@end
