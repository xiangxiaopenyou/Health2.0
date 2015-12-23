//
//  ActitionDoneViewController.m
//  Health
//
//  Created by cheng on 15/3/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ActitionDoneViewController.h"
#import "CourseRequest.h"
#import <TuSDK/TuSDK.h>

@interface ActitionDoneViewController ()<UIActionSheetDelegate,TuSDKPFCameraDelegate>{
    NSString *content;
    UIImage *uploadImage;
    // 自定义系统相册组件
    TuSDKCPAlbumComponent *_albumComponent;
    
    // 图片编辑组件
    TuSDKCPPhotoEditComponent *_photoEditComponent;
    
    TuSDKPFEditEntryOptions *_editEntryOptions;
    TuSDKPFEditCuterOptions *_editCuterOptions;
}

@end

@implementation ActitionDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
    navigation.image = [UIImage imageNamed:@"navigationbar.png"];
    [self.view addSubview:navigation];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-TITLE_LABEL_WIDTH)/2,32, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT)];
    titleLabel.text = @"锻炼记录";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = BOLDFONT_17;
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage)];
    self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, NAVIGATIONBAR_HEIGHT+70, SCREEN_WIDTH-20, SCREEN_WIDTH-20)];
    self.imageview.image = [UIImage imageNamed:@"uploadimage_back.png"];
    self.imageview.userInteractionEnabled = YES;
    [self.imageview addGestureRecognizer:tap];
    [self.view addSubview:self.imageview];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.imageview.frame.origin.y+self.imageview.frame.size.height+10, SCREEN_WIDTH-20, 30)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",self.course.coursetitle];
    [self.view addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+10, SCREEN_WIDTH-20, 20)];
    self.contentLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.contentLabel.textColor = [UIColor whiteColor];
    NSInteger totalTime = 0;
    for (CourseSub *coursesub in self.courseSubArray) {
        totalTime = totalTime + [coursesub.coursesubtime integerValue];
    }
    content = [NSString stringWithFormat:@"完成%lu个动作,耗时%lu秒钟",(unsigned long)[self.courseSubArray count],totalTime];
    self.contentLabel.text = content;
    [self.view addSubview:self.contentLabel];
}

- (void)clickShared:(id)sender{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectImage{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册选择", nil];
    actionSheet.tag = 0;
    [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews]lastObject]];
}

- (void)upload:(UIImage*)image{
    
    self.imageview.image = image;
    self.imageview.frame = CGRectMake(10, NAVIGATIONBAR_HEIGHT+70, SCREEN_WIDTH-20, SCREEN_WIDTH-20);
    
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    FriendInfo*friendInfo = self.course.teacher;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:userinfo.userid forKey:@"userid"];
    [dictionary setObject:userinfo.usertoken forKey:@"usertoken"];
    [dictionary setObject:self.course.courseid forKey:@"courseid"];
    [dictionary setObject:friendInfo.friendid forKey:@"courseownerid"];
    [dictionary setObject:content forKey:@"discussioncontent"];
    [dictionary setObject:@"sports" forKey:@"discussionType"];
    [dictionary setObject:self.actionOfDay forKey:@"coursesubday"];
    
//    if (![JDStatusBarNotification isVisible]) {
//        [JDStatusBarNotification showWithStatus:@"正在发布..."];
//    }
//    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    __block NSString *imageString;
    [RTUploadImageNetWork postMulti:nil imageparams:image success:^(id response) {
        if (![Util isEmpty:response]) {
            imageString = [response objectForKey:@"key"];
            [dictionary setObject:imageString forKey:@"discussphoto"];
            [CourseRequest createCourseInteractionWith:dictionary success:^(id response) {
                if ([[response objectForKey:@"state"] integerValue] == 1000) {
                    //[JDStatusBarNotification showWithStatus:@"发布成功√" dismissAfter:1.0];
//                    [[NSNotificationCenter defaultCenter]postNotificationName:@"createinteractionsuccess" object:@YES];
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                } else {
                    //[JDStatusBarNotification showWithStatus:@"发布失败" dismissAfter:1.0];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            } failure:^(NSError *error) {
                //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.0];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布失败，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }];
        }
    } failure:^(NSError *error) {
        
    } Progress:^(NSString *key, float percent) {
        NSLog(@"percent %f", percent);
    } Cancel:^BOOL{
        return NO;
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (actionSheet.tag) {
        case 0:{
            if (buttonIndex == 0) {
                [self cameraComponentHandler];
            }
            else if(buttonIndex == 1){
                [self editAdvancedComponentHandler];
            }
            else{
            }
        }break;
        default:
            break;
    }
    
}

//相机
- (void) cameraComponentHandler;
{
    // 如果不支持摄像头显示警告信息
    if ([AVCaptureDevice showAlertIfNotSupportCamera]){
        return;
    }
    
    TuSDKPFCameraOptions *opt = [TuSDKPFCameraOptions build];
    
    // 视图类 (默认:TuSDKPFCameraView, 需要继承 TuSDKPFCameraView)
    // opt.viewClazz = [TuSDKPFCameraView class];
    
    // 默认相机控制栏视图类 (默认:TuSDKPFCameraConfigView, 需要继承 TuSDKPFCameraConfigView)
    // opt.configBarViewClazz = [TuSDKPFCameraConfigView class];
    
    // 默认相机底部栏视图类 (默认:TuSDKPFCameraBottomView, 需要继承 TuSDKPFCameraBottomView)
    // opt.bottomBarViewClazz = [TuSDKPFCameraBottomView class];
    
    // 闪光灯视图类 (默认:TuSDKPFCameraFlashView, 需要继承 TuSDKPFCameraFlashView)
    // opt.flashViewClazz = [TuSDKPFCameraFlashView class];
    
    // 滤镜视图类 (默认:TuSDKPFCameraFilterView, 需要继承 TuSDKPFCameraFilterView)
    // opt.filterViewClazz = [TuSDKPFCameraFilterView class];
    
    // 聚焦触摸视图类 (默认:TuSDKICFocusTouchView, 需要继承 TuSDKICFocusTouchView)
    // opt.focusTouchViewClazz = [TuSDKICFocusTouchView class];
    
    // 摄像头前后方向 (默认为后置优先)
    // opt.avPostion = [AVCaptureDevice firstBackCameraPosition];
    
    // 设置分辨率模式
    // opt.sessionPreset = AVCaptureSessionPresetHigh;
    
    // 闪光灯模式 (默认:AVCaptureFlashModeOff)
    // opt.defaultFlashMode = AVCaptureFlashModeOff;
    
    // 是否开启滤镜支持 (默认: 关闭)
    opt.enableFilters = YES;
    
    // 默认是否显示滤镜视图 (默认: 不显示, 如果enableFilters = NO, showFilterDefault将失效)
    opt.showFilterDefault = YES;
    
    // 需要显示的滤镜名称列表 (如果为空将显示所有自定义滤镜)
    // opt.filterGroup = @[@"Normal", @"SkinTwiceMixedSigma", @"Artistic"];
    
    // 开启滤镜配置选项
    opt.enableFilterConfig = YES;
    
    // 视频视图显示比例 (默认：0， 0 <= mRegionRatio, 当设置为0时全屏显示)
    // opt.cameraViewRatio = 0.75f;
    
    // 视频视图显示比例类型 (默认:lsqRatioAll, 如果设置cameraViewRatio > 0, 将忽略ratioType)
    opt.ratioType = lsqRatioAll;
    
    // 是否开启长按拍摄 (默认: NO)
    opt.enableLongTouchCapture = YES;
    
    // 开启持续自动对焦 (默认: NO)
    opt.enableContinueFoucs = YES;
    
    // 自动聚焦延时 (默认: 5秒)
    // opt.autoFoucsDelay = 5;
    
    // 长按延时 (默认: 1.2秒)
    // opt.longTouchDelay = 1.2;
    
    // 保存到系统相册 (默认不保存, 当设置为YES时, TuSDKResult.asset)
    opt.saveToAlbum = YES;
    
    // 保存到临时文件 (默认不保存, 当设置为YES时, TuSDKResult.tmpFile)
    // opt.saveToTemp = NO;
    
    // 保存到系统相册的相册名称
    // opt.saveToAlbumName = @"TuSdk";
    
    // 照片输出压缩率 0-1 如果设置为0 将保存为PNG格式 (默认: 0.95)
    // opt.outputCompress = 0.95f;
    
    // 视频覆盖区域颜色 (默认：[UIColor clearColor])
    opt.regionViewColor = RGB(51, 51, 51);
    
    // 照片输出分辨率
    // opt.outputSize = CGSizeMake(1440, 1920);
    
    // 禁用前置摄像头自动水平镜像 (默认: NO，前置摄像头拍摄结果自动进行水平镜像)
    // opt.disableMirrorFrontFacing = YES;
    
    TuSDKPFCameraViewController *controller = opt.viewController;
    // 添加委托
    controller.delegate = self;
    [self presentModalNavigationController:controller animated:YES];
}
#pragma mark - cameraComponentHandler TuSDKPFCameraDelegate
/**
 *  获取一个拍摄结果
 *
 *  @param controller 默认相机视图控制器
 *  @param result     拍摄结果
 */
- (void)onTuSDKPFCamera:(TuSDKPFCameraViewController *)controller captureResult:(TuSDKResult *)result;
{
    //[controller dismissModalViewControllerAnimated:YES];
    [self openEditAdvancedWithController:controller result:result];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //[self editAdvancedComponentHandler];
}


#pragma mark - editAdvancedComponentHandler
- (void)editAdvancedComponentHandler;
{
    //lsqLDebug(@"editAdvancedComponentHandler");
    _albumComponent =
    [TuSDK albumCommponentWithController:self
                           callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         // 获取图片错误
         if (error) {
             [self throwWithReason:@"album reader error" userInfo:error.userInfo];
             return;
         }
         [self openEditAdvancedWithController:controller result:result];
     }];
    
    [_albumComponent showComponent];
}
/**
 *  开启图片高级编辑
 *
 *  @param controller 来源控制器
 *  @param result     处理结果
 */
- (void)openEditAdvancedWithController:(UIViewController *)controller
                                result:(TuSDKResult *)result;
{
    
    if (!controller || !result) return;
    
    _photoEditComponent =
    [TuSDK photoEditCommponentWithController:controller
                               callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         [self clearComponents];
         // 获取图片失败
         if (error) {
             [self throwWithReason:@"editAdvanced error" userInfo:error.userInfo];
             return;
         }
         [result logInfo];
         [self upload:[result loadResultImage]];
         
     }];
    _photoEditComponent.options.editEntryOptions.saveToAlbum = NO;
    _photoEditComponent.options.editCuterOptions.ratioType = lsqRatio_1_1;
    _photoEditComponent.inputImage = result.image;
    _photoEditComponent.inputTempFilePath = result.imagePath;
    _photoEditComponent.inputAsset = result.imageAsset;
    // 是否在组件执行完成后自动关闭组件 (默认:NO)
    _photoEditComponent.autoDismissWhenCompelted = YES;
    [_photoEditComponent showComponent];
    
    
}

- (void)clearComponents;
{
    // 自定义系统相册组件
    _albumComponent = nil;
    
    // 图片编辑组件
    _photoEditComponent = nil;
}



@end
