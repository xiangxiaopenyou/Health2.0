//
//  ExtendPhotoEditComponet.m
//  Health
//
//  Created by 天池邵 on 15/6/19.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ExtendPhotoEditComponet.h"

/**
 *  图片编辑组件范例 (对现有组件进行扩展 - 修改界面)
 */
@interface ExtendPhotoEditComponet()
// 自定义系统相册组件
@property (strong, nonatomic) TuSDKCPAlbumComponent *albumComponent;
// 多功能图片编辑组件
@property (strong, nonatomic) TuSDKCPPhotoEditMultipleComponent *photoEditMultipleComponent;
@end

@implementation ExtendPhotoEditComponet

- (instancetype)init {
    self = [super init];
    return self;
}

/**
 *  显示范例
 *
 *  @param controller 启动控制器
 */
- (void)showSimpleWithController:(UIViewController *)controller image:(UIImage *)image callback:(void(^)(UIImage *))block {
    if (!controller) return;
    
    // 组件选项配置
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKCPPhotoEditMultipleComponent.html
    _photoEditMultipleComponent =
    [TuSDK photoEditMultipleWithController:controller
                             callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller) {
                                 _albumComponent = nil;
                                 // 获取图片失败
                                 if (error) {
                                     lsqLError(@"editMultiple error: %@", error.userInfo);
                                     return;
                                 }
                                 [result logInfo];
                                 !block ?: block([UIImage imageWithCGImage:[[result.imageAsset defaultRepresentation] fullResolutionImage]]);
                                 [controller dismissViewControllerAnimated:YES completion:nil];
                                 [controller.navigationController popViewControllerAnimated:YES];
                             }];
    
    // 禁用功能模块 默认：加载全部模块
    [_photoEditMultipleComponent.options.editMultipleOptions disableModule:lsqTuSDKCPEditActionAdjust];
    [_photoEditMultipleComponent.options.editMultipleOptions disableModule:lsqTuSDKCPEditActionSkin];
    [_photoEditMultipleComponent.options.editMultipleOptions disableModule:lsqTuSDKCPEditActionSharpness];
    [_photoEditMultipleComponent.options.editMultipleOptions disableModule:lsqTuSDKCPEditActionVignette];
    [_photoEditMultipleComponent.options.editMultipleOptions disableModule:lsqTuSDKCPEditActionAperture];

    // 控制器关闭后是否自动删除临时文件
        _photoEditMultipleComponent.options.editMultipleOptions.isAutoRemoveTemp = YES;
    
    // 图片编辑裁切旋转控制器配置选项
        _photoEditMultipleComponent.options.editCuterOptions.ratioType = lsqRatio_1_1;
    //_photoEditMultipleComponent.options.editCuterOptions.saveToAlbum = NO;
    //_photoEditMultipleComponent.options.editMultipleOptions.saveToAlbum = NO;
    
    // 设置图片
    _photoEditMultipleComponent.inputImage = image;
    _photoEditMultipleComponent.autoDismissWhenCompelted = YES;
    [_photoEditMultipleComponent showComponent];
}
@end
