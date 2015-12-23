//
//  TuSDKPFEditTurnAndCutOptions.h
//  TuSDK
//
//  Created by Clear Hu on 14/11/7.
//  Copyright (c) 2014年 Lasque. All rights reserved.
//

#import "TuSDKCPImageResultOptions.h"
#import "TuSDKPFEditTurnAndCutViewController.h"

/**
 *  旋转和裁剪视图控制器配置选项
 */
@interface TuSDKPFEditTurnAndCutOptions : TuSDKCPImageResultOptions

/**
 *  视图类 (默认:TuSDKPFEditTurnAndCutView, 需要继承 TuSDKPFEditTurnAndCutView)
 */
@property (nonatomic, strong) Class viewClazz;

/**
 *  旋转和裁剪视图控制栏类 (默认:TuSDKPFEditTurnAndCutBottomView, 需要继承 TuSDKPFEditTurnAndCutBottomView)
 */
@property (nonatomic, strong) Class bottomBarViewClazz;

/**
 *  图片编辑视图 (旋转，缩放)类 (默认:TuSDKPFEditImageView, 需要继承 TuSDKPFEditImageView)
 */
@property (nonatomic, strong) Class editImageViewClazz;

/**
 *  滤镜列表视图类 (默认:TuSDKPFEditTurnAndCutFilterView, 需要继承 TuSDKPFEditTurnAndCutFilterView)
 */
@property (nonatomic, strong) Class filterViewClazz;

/**
 *  是否开启滤镜支持 (默认: 关闭)
 */
@property (nonatomic) BOOL enableFilters;

/**
 *  需要显示的滤镜名称列表 (如果为空将显示所有自定义滤镜)
 */
@property (nonatomic, retain) NSArray *filterGroup;

/**
 *  滤镜列表行视图宽度
 */
@property (nonatomic)CGFloat filterBarCellWidth;

/**
 *  滤镜列表选择栏高度
 */
@property (nonatomic)CGFloat filterBarHeight;

/**
 *  滤镜分组列表行视图类 (默认:TuSDKCPGroupFilterGroupCell, 需要继承 TuSDKCPGroupFilterGroupCell)
 */
@property (nonatomic, strong)Class filterBarGroupCellClazz;

/**
 *  滤镜列表行视图类 (默认:TuSDKCPGroupFilterItem, 需要继承 TuSDKCPGroupFilterItem)
 */
@property (nonatomic, strong)Class filterBarTableCellClazz;

/**
 *  需要裁剪的长宽
 */
@property (nonatomic) CGSize cutSize;

/**
 *  创建旋转和裁剪视图控制器对象
 *
 *  @return 旋转和裁剪视图控制器对象
 */
- (TuSDKPFEditTurnAndCutViewController *)viewController;
@end
