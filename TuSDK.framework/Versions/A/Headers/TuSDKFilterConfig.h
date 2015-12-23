//
//  TuSDKFilterConfig.h
//  TuSDK
//
//  Created by Clear Hu on 14/10/26.
//  Copyright (c) 2014年 Lasque. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TuSDKFilterOption.h"
#import "TuSDKFilterGroup.h"
#import "TuSDKConfig.h"
#import "TuSDKTKImageViewTask.h"

/**
 *  默认滤镜代号
 */
extern NSString * const lsqNormalFilterCode;

/**
 *  原生滤镜配置委托
 */
@protocol TuSDKFilterConfigDelegate <NSObject>
/**
 *  滤镜初始化完成
 */
- (void)onTuSDKFilterConfigInited;
@end

/**
 *  原生滤镜配置
 */
@interface TuSDKFilterConfig : TuSDKTKImageViewTask

/**
 *  原生滤镜代号列表
 */
@property (nonatomic, readonly) NSArray *codes;

/**
 *  滤镜分组列表
 */
@property (nonatomic, readonly) NSArray *groups;

/**
 *  是否已初始化
 */
@property (nonatomic, readonly) BOOL isInited;

/**
 *  原生滤镜配置委托
 */
@property (nonatomic, assign) id<TuSDKFilterConfigDelegate> delegate;

/**
 *  原生滤镜配置
 *
 *  @param config Sdk配置
 *
 *  @return 原生滤镜配置
 */
+ (instancetype)initWithConfig:(TuSDKConfig *)config;

/**
 *  原生滤镜配置
 *
 *  @return 原生滤镜配置
 */
+ (instancetype)config;

/**
 *  默认滤镜选项
 *
 *  @return 默认滤镜选项
 */
- (TuSDKFilterOption *)normalOption;

/**
 *  获取滤镜选项配置
 *
 *  @param code 滤镜代号
 *
 *  @return 滤镜选项配置 (如果未找到对应选项，返回默认滤镜)
 */
- (TuSDKFilterOption *)optionWithCode:(NSString *)code;

/**
 *  验证滤镜代号
 *
 *  @param filterCodes 滤镜代号列表
 *
 *  @return 滤镜名称
 */
- (NSArray *)verifyCodes:(NSArray *)codes;

/**
 *  获取指定名称的滤镜列表
 *
 *  @param codes 滤镜代号列表
 *
 *  @return 滤镜列表
 */
- (NSArray *)optionsWithCodes:(NSArray *)codes;

/**
 *  获取滤镜组
 *
 *  @param group 滤镜分组
 *
 *  @return 滤镜列表
 */
- (NSArray *)optionsWithGroup:(TuSDKFilterGroup *)group;

/**
 *  滤镜组名称键
 *
 *  @param groupID 滤镜组ID
 *
 *  @return 滤镜组名称键
 */
- (NSString *)groupNameKeyWithGroupID:(uint64_t)groupID;

/**
 *  加载材质列表
 *
 *  @param code 滤镜代号
 *
 *  @return 材质列表
 */
- (NSArray *)loadTexturesWithCode:(NSString *)code;

#pragma mark - imageLoad
/**
 *  加载滤镜组预览图
 *
 *  @param view 图片视图
 *  @param group 滤镜分组
 */
- (void)loadGroupThumbWithImageView:(UIImageView *)view group:(TuSDKFilterGroup *)group;

/**
 *  加载滤镜组默认滤镜预览图
 *
 *  @param view 图片视图
 *  @param group 滤镜分组
 */
- (void)loadGroupDefaultFilterThumbWithImageView:(UIImageView *)view group:(TuSDKFilterGroup *)group;

/**
 *  加载滤镜组默认滤镜预览图
 *
 *  @param view 图片视图
 *  @param option 滤镜配置选项
 */
- (void)loadFilterThumbWithImageView:(UIImageView *)view option:(TuSDKFilterOption *)option;
@end
