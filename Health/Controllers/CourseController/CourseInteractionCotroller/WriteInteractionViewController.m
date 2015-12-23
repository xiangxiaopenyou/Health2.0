//
//  WriteInteractionViewController.m
//  Health
//
//  Created by 项小盆友 on 15/1/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "WriteInteractionViewController.h"
#import "CourseRequest.h"
#import <TuSDK/TuSDK.h>

@interface WriteInteractionViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate, TuSDKPFCameraDelegate>{
    UIImagePickerController *imagePicker;
    BOOL ispublic;
    UILabel *tipLabel;
    BOOL isimage;
    
    // 自定义系统相册组件
    TuSDKCPAlbumComponent *_albumComponent;
    
    // 图片编辑组件
    TuSDKCPPhotoEditComponent *_photoEditComponent;
    
    TuSDKPFEditEntryOptions *_editEntryOptions;
    TuSDKPFEditCuterOptions *_editCuterOptions;
    
    UserInfo *userInfo;
    
     UIButton *deleteImageButton;
    
    UIButton *putTopButton;
    NSString *discussoverhead;
}

@end

@implementation WriteInteractionViewController
@synthesize sendButton, titleTextField, contentTextView, trendImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]];
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
//    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    sendButton.frame = CGRectMake(0, 0, 40, 40);
//    [sendButton setTitle:@"发布" forState:UIControlStateNormal];
//    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
//    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 20, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    sendButton =[UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(SCREEN_WIDTH - 50, 20, 40, 40);
    [sendButton setTitle:@"发布" forState:UIControlStateNormal];
    [sendButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];

    
    //标题
    titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH - 20, 44)];
    titleTextField.placeholder = @"输入标题";
    titleTextField.font = [UIFont systemFontOfSize:17];
    titleTextField.returnKeyType = UIReturnKeyDone;
    titleTextField.delegate = self;
    titleTextField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleTextField];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT + 44, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
    [self.view addSubview:line];
    
    //图片
    trendImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 66 + NAVIGATIONBAR_HEIGHT, 60, 62)];
    trendImage.image = [UIImage imageNamed:@"default_picture.png"];
    trendImage.contentMode = UIViewContentModeScaleAspectFit;
    trendImage.clipsToBounds = YES;
    [self.view addSubview:trendImage];
    trendImage.userInteractionEnabled = YES;
    [trendImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(trendImagePress:)]];
    isimage = NO;
    
    //删除图片按钮
    deleteImageButton = [UIButton buttonWithType: UIButtonTypeCustom];
    deleteImageButton.frame = CGRectMake(67, 53 + NAVIGATIONBAR_HEIGHT, 22, 22);
    [deleteImageButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteImageButton addTarget:self action:@selector(deleteImageClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteImageButton];
    deleteImageButton.hidden = YES;
    
    //内容
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(88, 64 + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH - 108, 150)];
    contentTextView.delegate = self;
    contentTextView.showsVerticalScrollIndicator = NO;
    contentTextView.font = SMALLFONT_16;
    contentTextView.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    //contentTextView.returnKeyType = UIReturnKeyDone;
    contentTextView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentTextView];
    if (SCREEN_HEIGHT <= 480) {
        contentTextView.frame = CGRectMake(88, 64 + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH - 108, 100);
    }
    
    //提示
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(94, 0 + 71 + NAVIGATIONBAR_HEIGHT, 100, 20)];
    tipLabel.text = @"输入正文";
    tipLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    tipLabel.font = SMALLFONT_16;
    [self.view addSubview:tipLabel];
    
    [titleTextField becomeFirstResponder];
    
    if ([self.courseUserType integerValue] == 1){
        //置顶按钮
        putTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        putTopButton.frame = CGRectMake(SCREEN_WIDTH - 85, 270, 75, 20);
        [putTopButton setImage:[UIImage imageNamed:@"club_discussion_nottop"] forState:UIControlStateNormal];
        [putTopButton addTarget:self action:@selector(puTopClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:putTopButton];
        discussoverhead = 0;
    }
    
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//置顶
- (void)puTopClick{
    if (discussoverhead == 0) {
        [putTopButton setImage:[UIImage imageNamed:@"club_discussion_istop"] forState:UIControlStateNormal];
        discussoverhead = @"1";
    }
    else{
        [putTopButton setImage:[UIImage imageNamed:@"club_discussion_nottop"] forState:UIControlStateNormal];
        discussoverhead = 0;
    }
}

//点击了图片
- (void)trendImagePress:(UITapGestureRecognizer*)gesture{
    [self showActionSheet];
}
- (void)showActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册选择", nil];
    [actionSheet showInView:self.view];
}

- (void)sendClick{
    NSLog(@"点击了发送");
    if ([Util isEmpty:titleTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"标题不要空哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        if (titleTextField.text.length > 30) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"标题不要超过30字哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            if ([Util isEmpty:contentTextView.text]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正文不要空哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
//                    if (![JDStatusBarNotification isVisible]) {
//                        [JDStatusBarNotification showWithStatus:@"正在发布..."];
//                    }
//                    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
                    [self.navigationController popViewControllerAnimated:YES];
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:userInfo.userid forKey:@"userid"];
                    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
                    [dic setObject:self.course.courseid forKey:@"courseid"];
                    if ([discussoverhead integerValue] == 1) {
                        [dic setObject:@"1" forKeyedSubscript:@"discussoverhead"];
                    }
                    //[dic setObject:[CustomDate getDateString:[NSDate date]] forKey:@"created_time"];
                    [dic setObject:self.discutionType forKey:@"discussionType"];
                    if (![Util isEmpty:self.coursesubDay]) {
                        [dic setObject:self.coursesubDay forKey:@"coursesubday"];
                    }
                    FriendInfo *friendInfo = self.course.teacher;
                    [dic setObject:friendInfo.friendid forKey:@"courseownerid"];
                    [dic setObject:titleTextField.text forKey:@"discussiontitle"];
                    [dic setObject:contentTextView.text forKey:@"discussioncontent"];
                    if (![Util isEmpty:self.courseSub]) {
                        [dic setObject:self.courseSub.coursesubid forKey:@"coursesubid"];
                        [dic setObject:self.coursesubDay forKey:@"coursesubday"];
                    }
                    if (isimage) {
                        
                        __block NSString *imageString;
                        [RTUploadImageNetWork postMulti:nil imageparams:trendImage.image success:^(id response) {
                            if (![Util isEmpty:response]) {
                                imageString = [response objectForKey:@"key"];
                                [dic setObject:imageString forKey:@"discussphoto"];
                                [CourseRequest createCourseInteractionWith:dic success:^(id response) {
                                    if ([[response objectForKey:@"state"] integerValue] == 1000) {
                                        //[JDStatusBarNotification showWithStatus:@"发布成功√" dismissAfter:1.0];
                                        [[NSNotificationCenter defaultCenter]postNotificationName:@"createinteractionsuccess" object:@YES];
                                    }
                                    else{
                                        //[JDStatusBarNotification showWithStatus:@"发布失败" dismissAfter:1.4];
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                        [alert show];
                                    }
                                } failure:^(NSError *error) {
                                    //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.4];
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    [alert show];
                                }];
                            }
                        } failure:^(NSError *error) {
                            //[JDStatusBarNotification showWithStatus:@"发送失败" dismissAfter:1.4];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                            
                        } Progress:^(NSString *key, float percent) {
                            NSLog(@"percent %f", percent);
                        } Cancel:^BOOL{
                            return NO;
                        }];
                    }
                    else{
                        [CourseRequest createCourseInteractionWith:dic success:^(id response) {
                            if ([[response objectForKey:@"state"] integerValue] == 1000) {
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"createinteractionsuccess" object:@YES];
                            }
                            else{
                                //[JDStatusBarNotification showWithStatus:@"发布失败" dismissAfter:1.4];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                [alert show];
                            }
                        } failure:^(NSError *error) {
                            //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.4];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }];
                    }
                    
                
            }
            
        }
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [titleTextField resignFirstResponder];
    [contentTextView resignFirstResponder];
}

#pragma mark - UITextView Delegate
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if ([@"\n" isEqualToString:text]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
//    return YES;
//}
- (void)textViewDidChange:(UITextView *)textView{
    [tipLabel setHidden:YES];
}
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([@"\n" isEqualToString:string]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - UIAlertView Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {//拍照上传
        [self cameraComponentHandler];
    }else if(buttonIndex == 1) {//从相册选择
        [self editAdvancedComponentHandler];
    }
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
    //    // 图片编辑入口控制器配置选项
    //    _editEntryOptions = [TuSDKPFEditEntryOptions build];
    //    // 默认: true, 开启裁剪旋转功能
    //    _editEntryOptions.enableCuter = YES;
    //    // 默认: true, 开启滤镜功能
    //    _editEntryOptions.enableFilter = YES;
    //    // 默认: true, 开启贴纸功能
    //    _editEntryOptions.enableSticker = YES;
    //    // 最大输出图片按照设备屏幕 (默认:false, 如果设置了LimitSideSize, 将忽略LimitForScreen)
    //    _editEntryOptions.limitForScreen = YES;
    //    // 保存到系统相册
    //    _editEntryOptions.saveToAlbum = NO;
    //
    //    // 图片编辑滤镜控制器配置选项
    //    _editFilterOptions = [TuSDKPFEditFilterOptions build];
    //    // 默认: true, 开启滤镜配置选项
    //    _editFilterOptions.enableFilterConfig = YES;
    //    // 是否仅返回滤镜，不返回处理图片(默认：false)
    //    _editFilterOptions.onlyReturnFilter = YES;
    //
    //    // 图片编辑裁切旋转控制器配置选项
    _editCuterOptions = [TuSDKPFEditCuterOptions build];
    //    // 是否开启图片旋转(默认: false)
    //    _editCuterOptions.enableTrun = YES;
    //    // 是否开启图片镜像(默认: false)
    //    _editCuterOptions.enableMirror = YES;
    // 裁剪比例 (默认:lsqRatioAll)
    //    _editCuterOptions.ratioType = lsqRatio_1_1;
    // 是否仅返回裁切参数，不返回处理图片
    //   _editCuterOptions.onlyReturnCuter = YES;
    //
    //    // 本地贴纸选择控制器配置选项
    //    _stickerLocalOptions = [TuSDKPFStickerLocalOptions build];
    
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
         trendImage.image = [result loadResultImage];
         isimage = YES;
         deleteImageButton.hidden = NO;
         
     }];
    // 设置图片
    _photoEditComponent.options.editEntryOptions.saveToAlbum = NO;
    _photoEditComponent.options.editCuterOptions.ratioType = lsqRatio_1_1;
    _photoEditComponent.inputImage = result.image;
    _photoEditComponent.inputTempFilePath = result.imagePath;
    _photoEditComponent.inputAsset = result.imageAsset;
    // 是否在组件执行完成后自动关闭组件 (默认:NO)
    _photoEditComponent.autoDismissWhenCompelted = YES;
    [_photoEditComponent showComponent];
    
    
}

/**
 *  清楚所有控件
 */
- (void)clearComponents;
{
    // 自定义系统相册组件
    _albumComponent = nil;
    
    // 图片编辑组件
    _photoEditComponent = nil;
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

- (void)deleteImageClick{
    trendImage.image = [UIImage imageNamed:@"default_picture.png"];
    isimage = NO;
    deleteImageButton.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
