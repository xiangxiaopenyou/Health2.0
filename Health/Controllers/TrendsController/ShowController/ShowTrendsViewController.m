//
//  ShowTrendsViewController.m
//  Health
//
//  Created by 项小盆友 on 15/1/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ShowTrendsViewController.h"
#import "ExtendPhotoEditComponet.h"
#import <TuSDK/TuSDK.h>
#import "HSCButton.h"
#import "ChooseLabelViewController.h"
#import "ChoosePositionViewController.h"

@interface ShowTrendsViewController ()<UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, chooseLabelDelegete, PositionViewDelegate, UIImagePickerControllerDelegate>{
    //UIView *chooseView;
    BOOL ispublic;
    BOOL ispicture;
    BOOL isShowAddLabelButton;
    NSString *address;
    
    UILabel *tipLabel;
    
    // 自定义系统相册组件
    TuSDKCPAlbumComponent *_albumComponent;
    
    // 图片编辑组件
    TuSDKCPPhotoEditComponent *_photoEditComponent;
    
    TuSDKPFEditEntryOptions *_editEntryOptions;
    TuSDKPFEditCuterOptions *_editCuterOptions;
    //定位
    CLLocationManager *locationManager;
    
    UserInfo *userInfo;
    
    UIView *addLabelView;
    HSCButton *labelButton;
    HSCButton *labelButton2;
    HSCButton *labelButton3;
    HSCButton *labelButton4;
    HSCButton *labelButton5;
    
    NSInteger tag;
    
    NSMutableArray *tagArray;
}
@property (strong, nonatomic) UIImagePickerController *cameraController;
@property (strong, nonatomic) UIButton *chooseAlbumButton;
@end

@implementation ShowTrendsViewController

@synthesize trendImage, trendContent, privateButton, positionButton, positionImage, positionLabel;
@synthesize isCourseTrend, courseid;
@synthesize addLabelButton, addLabelImageView, addTipLabel;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takedPhoto:) name:@"_UIImagePickerControllerUserDidCaptureItem" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rejectedPhoto:) name:@"_UIImagePickerControllerUserDidRejectItem" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"_UIImagePickerControllerUserDidCaptureItem" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"_UIImagePickerControllerUserDidRejectItem" object:nil];
}

- (void)takedPhoto:(NSDictionary *)userInfo {
    [_chooseAlbumButton removeFromSuperview];
}

- (void)rejectedPhoto:(NSDictionary *)userInfo {
    [_cameraController.view addSubview:_chooseAlbumButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 20, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    [self.view setBackgroundColor:TABLEVIEWCELL_COLOR];
    
    //发送按钮
    UIButton *sendButton =[UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(SCREEN_WIDTH - 50, 22, 45, 40);
    [sendButton setTitle:@"发布" forState:UIControlStateNormal];
    [sendButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    sendButton.titleLabel.font = SMALLFONT_16;
    [sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    //秀一秀图片
    trendImage = [[UIImageView alloc] initWithFrame:CGRectMake(18, 16 + NAVIGATIONBAR_HEIGHT, 62, 62)];
    trendImage.image = [UIImage imageNamed:@"clockin_default_picture"];
    trendImage.contentMode = UIViewContentModeScaleAspectFill;
    trendImage.clipsToBounds = YES;
    [self.view addSubview:trendImage];
    trendImage.userInteractionEnabled = YES;
    [trendImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(trendImagePress:)]];
    ispicture = NO;
    
    //秀一秀添加文字
    trendContent = [[UITextView alloc] initWithFrame:CGRectMake(90, 20 + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH - 108, 250)];
    trendContent.delegate = self;
    trendContent.showsVerticalScrollIndicator = NO;
    trendContent.font = SMALLFONT_14;
    trendContent.textColor = WHITE_CLOCLOR;
    trendContent.returnKeyType = UIReturnKeyDone;
    trendContent.backgroundColor = [UIColor clearColor];
    [self.view addSubview:trendContent];
    
    //[trendContent becomeFirstResponder];
    
    //提示
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(94, 24 + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH - 112, 40)];
    tipLabel.text = @"晒运动、晒美食、晒自拍、晒记录，晒出你自己吧...";
    tipLabel.numberOfLines = 0;
    tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
    tipLabel.textColor = TIME_COLOR_GARG;
    tipLabel.font = SMALLFONT_14;
    [self.view addSubview:tipLabel];
    
    [self setupPositionView];
    [self addLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiden) name:UIKeyboardWillHideNotification object:nil];
//    [self showChooseView];
//    chooseView.hidden = NO;
    
    //定位
    if([CLLocationManager locationServicesEnabled]){
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
            [locationManager requestAlwaysAuthorization];
        }
        locationManager.distanceFilter = 1000.0f;
        [locationManager startUpdatingLocation];
    }
    else{
        NSLog(@"没有开启定位");
    }
    [self takePhotoClick];
}
- (void)addLabel{
    addLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [addLabelView setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]];
    [self.view addSubview:addLabelView];
    
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
    topImageView.image = [UIImage imageNamed:@"navigationbar"];
    [addLabelView addSubview:topImageView];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(SCREEN_WIDTH - 50, 20, 40, 40);
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
    [addLabelView addSubview:finishButton];
    
    addLabelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH)];
    addLabelImageView.userInteractionEnabled = YES;
    [addLabelImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addLabelImageClick:)]];
    [addLabelView addSubview:addLabelImageView];
    
    addLabelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addLabelButton.frame = CGRectMake(SCREEN_WIDTH/2 - 27, 0 - 54, 54, 54);
    [addLabelButton setBackgroundImage:[UIImage imageNamed:@"tag_button"] forState:UIControlStateNormal];
    [addLabelButton addTarget:self action:@selector(addLabelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addLabelButton];
    isShowAddLabelButton = NO;
    
    addTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH + NAVIGATIONBAR_HEIGHT + 20, SCREEN_WIDTH, 50)];
    addTipLabel.text = @"点击图片添加标签";
    addTipLabel.font = SMALLFONT_16;
    addTipLabel.textColor = [UIColor grayColor];
    addTipLabel.textAlignment = NSTextAlignmentCenter;
    [addLabelView addSubview:addTipLabel];
    
}
- (void)setupPositionView{
    positionImage = [[UIImageView alloc] initWithFrame:CGRectMake(18, SCREEN_HEIGHT - 33, 12, 12)];
    positionImage.image = [UIImage imageNamed:@"trend_position.png"];
    [self.view addSubview:positionImage];
    
    positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, SCREEN_HEIGHT - 36, SCREEN_WIDTH - 103, 16)];
    positionLabel.font = SMALLFONT_10;
    positionLabel.textColor = TIME_COLOR_GARG;
    [self.view addSubview:positionLabel];
    
    positionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    positionButton.frame = CGRectMake(18, SCREEN_HEIGHT - 40, SCREEN_WIDTH - 100, 24);
    [positionButton addTarget:self action:@selector(positionClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:positionButton];
    
    //是否公开
    privateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    privateButton.frame = CGRectMake(SCREEN_WIDTH - 71, SCREEN_HEIGHT - 36, 53, 16);
    [privateButton setImage:[UIImage imageNamed:@"clockin_public"] forState:UIControlStateNormal];
    [privateButton addTarget:self action:@selector(privateButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:privateButton];
    ispublic = YES;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击了图片
- (void)trendImagePress:(UITapGestureRecognizer*)gesture{
    [self takePhotoClick];
}

- (void)showCamera {
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 100, SCREEN_WIDTH, 100)];
    toolView.backgroundColor = [UIColor blackColor];
    UIButton *takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    takePhotoButton.frame = CGRectMake((SCREEN_WIDTH - 80) / 2, SCREEN_HEIGHT - 80, 80, 80);
    takePhotoButton.backgroundColor = [UIColor whiteColor];
    [toolView addSubview:takePhotoButton];
    
    if (!_cameraController) {
        _cameraController = [[UIImagePickerController alloc] init];
        _cameraController.delegate = self;
        _cameraController.allowsEditing = YES;
        _cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _chooseAlbumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseAlbumButton addTarget:self action:@selector(showAlbum) forControlEvents:UIControlEventTouchUpInside];
    }
    [self presentViewController:_cameraController animated:YES completion:^{

        CGPoint origin = CGPointZero;
        CGFloat width = 0;
        for (UIView *subview in _cameraController.view.subviews) {
            if([NSStringFromClass([subview class]) isEqualToString:@"UINavigationTransitionView"]) {
                UIView *theView = (UIView *)subview;
                for (UIView *subview in theView.subviews) {
                    if([NSStringFromClass([subview class]) isEqualToString:@"UIViewControllerWrapperView"]) {
                        UIView *theView = (UIView *)subview;
                        for (UIView *subview in theView.subviews) {
                            if([NSStringFromClass([subview class]) isEqualToString:@"PLImagePickerCameraView"]) {
                                UIView *theView = (UIView *)subview;
                                for (UIView *subview in theView.subviews) {
                                    if([NSStringFromClass([subview class]) isEqualToString:@"CAMBottomBar"]) {
                                        UIView *theView = (UIView *)subview;
                                        for (UIView *view in theView.subviews) {
                                            if ([view isKindOfClass:NSClassFromString(@"CAMShutterButton")]) {
                                                origin = view.frame.origin;
                                                origin.y += CGRectGetMinY(view.superview.frame);
                                                width = CGRectGetWidth(view.frame);
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        _chooseAlbumButton.frame = CGRectMake(SCREEN_WIDTH - width - 20, origin.y, width, width);
        [_cameraController.view addSubview:_chooseAlbumButton];
        
        [[ALAssetsLibrary defaultLibrary] enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (result) {
                        [_chooseAlbumButton setBackgroundImage:[UIImage imageWithCGImage:[[result defaultRepresentation] fullResolutionImage]] forState:UIControlStateNormal];
                        *stop = YES;
                    }
                }];
                *stop = YES;
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"get album photo failed %@", error.description);
        }];
 
    }];
}

- (void)showAlbum {
    [self dismissViewControllerAnimated:NO completion:^{
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerVC.delegate = self;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"%@", info);
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        [self openEditWithImage:image];
    }];
    
}

- (void)takePhotoClick{
    [self showCamera];
}
/*
 完成打标签
 */
- (void)finishClick{
    [UIView animateWithDuration:0.3f animations:^{
        addLabelView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    
    tagArray = [[NSMutableArray alloc] init];
    
    if (tag > 0) {
        switch (tag) {
            case 1:{
                int x = labelButton.frame.origin.x;
                int y = labelButton.frame.origin.y;
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
                [tempDic setObject:labelButton.titleLabel.text forKey:@"tagText"];
                [tempDic setObject:[NSString stringWithFormat:@"%.2f", x/SCREEN_WIDTH] forKey:@"tagX"];
                [tempDic setObject:[NSString stringWithFormat:@"%.2f", y/SCREEN_WIDTH] forKey:@"tagY"];
                [tagArray addObject:tempDic];
            }
                break;
            case 2:{
                int x = labelButton.frame.origin.x;
                int y = labelButton.frame.origin.y;
                int x2 = labelButton2.frame.origin.x;
                int y2 = labelButton2.frame.origin.y;
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *tempDic2 = [[NSMutableDictionary alloc] init];
                [tempDic setObject:labelButton.titleLabel.text forKey:@"tagText"];
                [tempDic setObject:[NSString stringWithFormat:@"%.2f", x/SCREEN_WIDTH] forKey:@"tagX"];
                [tempDic setObject:[NSString stringWithFormat:@"%.2f", y/SCREEN_WIDTH] forKey:@"tagY"];
                [tagArray addObject:tempDic];
                [tempDic2 setObject:labelButton2.titleLabel.text forKey:@"tagText"];
                [tempDic2 setObject:[NSString stringWithFormat:@"%.2f", x2/SCREEN_WIDTH] forKey:@"tagX"];
                [tempDic2 setObject:[NSString stringWithFormat:@"%.2f", y2/SCREEN_WIDTH] forKey:@"tagY"];
                [tagArray addObject:tempDic2];
            }
                break;
            case 3:{
                int x = labelButton.frame.origin.x;
                int y = labelButton.frame.origin.y;
                int x2 = labelButton2.frame.origin.x;
                int y2 = labelButton2.frame.origin.y;
                int x3 = labelButton3.frame.origin.x;
                int y3 = labelButton3.frame.origin.y;
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *tempDic2 = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *tempDic3 = [[NSMutableDictionary alloc] init];
                [tempDic setObject:labelButton.titleLabel.text forKey:@"tagText"];
                [tempDic setObject:[NSString stringWithFormat:@"%.2f", x/SCREEN_WIDTH] forKey:@"tagX"];
                [tempDic setObject:[NSString stringWithFormat:@"%.2f", y/SCREEN_WIDTH] forKey:@"tagY"];
                [tagArray addObject:tempDic];
                [tempDic2 setObject:labelButton2.titleLabel.text forKey:@"tagText"];
                [tempDic2 setObject:[NSString stringWithFormat:@"%.2f", x2/SCREEN_WIDTH] forKey:@"tagX"];
                [tempDic2 setObject:[NSString stringWithFormat:@"%.2f", y2/SCREEN_WIDTH] forKey:@"tagY"];
                [tagArray addObject:tempDic2];
                [tempDic3 setObject:labelButton3.titleLabel.text forKey:@"tagText"];
                [tempDic3 setObject:[NSString stringWithFormat:@"%.2f", x3/SCREEN_WIDTH] forKey:@"tagX"];
                [tempDic3 setObject:[NSString stringWithFormat:@"%.2f", y3/SCREEN_WIDTH] forKey:@"tagY"];
                [tagArray addObject:tempDic3];
            }
                break;
            case 4:{
                int x = labelButton.frame.origin.x;
                int y = labelButton.frame.origin.y;
                int x2 = labelButton2.frame.origin.x;
                int y2 = labelButton2.frame.origin.y;
                int x3 = labelButton3.frame.origin.x;
                int y3 = labelButton3.frame.origin.y;
                int x4 = labelButton4.frame.origin.x;
                int y4 = labelButton4.frame.origin.y;
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *tempDic2 = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *tempDic3 = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *tempDic4 = [[NSMutableDictionary alloc] init];
                [tempDic setObject:labelButton.titleLabel.text forKey:@"tagText"];
                [tempDic setObject:[NSString stringWithFormat:@"%.2f", x/SCREEN_WIDTH] forKey:@"tagX"];
                [tempDic setObject:[NSString stringWithFormat:@"%.2f", y/SCREEN_WIDTH] forKey:@"tagY"];
                [tagArray addObject:tempDic];
                [tempDic2 setObject:labelButton2.titleLabel.text forKey:@"tagText"];
                [tempDic2 setObject:[NSString stringWithFormat:@"%.2f", x2/SCREEN_WIDTH] forKey:@"tagX"];
                [tempDic2 setObject:[NSString stringWithFormat:@"%.2f", y2/SCREEN_WIDTH] forKey:@"tagY"];
                [tagArray addObject:tempDic2];
                [tempDic3 setObject:labelButton3.titleLabel.text forKey:@"tagText"];
                [tempDic3 setObject:[NSString stringWithFormat:@"%.2f", x3/SCREEN_WIDTH] forKey:@"tagX"];
                [tempDic3 setObject:[NSString stringWithFormat:@"%.2f", y3/SCREEN_WIDTH] forKey:@"tagY"];
                [tagArray addObject:tempDic3];
                [tempDic4 setObject:labelButton4.titleLabel.text forKey:@"tagText"];
                [tempDic4 setObject:[NSString stringWithFormat:@"%.2f", x4/SCREEN_WIDTH] forKey:@"tagX"];
                [tempDic4 setObject:[NSString stringWithFormat:@"%.2f", y4/SCREEN_WIDTH] forKey:@"tagY"];
                [tagArray addObject:tempDic4];
            }
                break;
            case 5:{
                int x = labelButton.frame.origin.x;
                int y = labelButton.frame.origin.y;
                int x2 = labelButton2.frame.origin.x;
                int y2 = labelButton2.frame.origin.y;
                int x3 = labelButton3.frame.origin.x;
                int y3 = labelButton3.frame.origin.y;
                int x4 = labelButton4.frame.origin.x;
                int y4 = labelButton4.frame.origin.y;
                int x5 = labelButton5.frame.origin.x;
                int y5 = labelButton5.frame.origin.y;
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *tempDic2 = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *tempDic3 = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *tempDic4 = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *tempDic5 = [[NSMutableDictionary alloc] init];
                [tempDic setObject:labelButton.titleLabel.text forKey:@"tagText"];
                [tempDic setObject:[NSString stringWithFormat:@"%.2f", x/SCREEN_WIDTH] forKey:@"tagX"];
                [tempDic setObject:[NSString stringWithFormat:@"%.2f", y/SCREEN_WIDTH] forKey:@"tagY"];
                [tagArray addObject:tempDic];
                [tempDic2 setObject:labelButton2.titleLabel.text forKey:@"tagText"];
                [tempDic2 setObject:[NSString stringWithFormat:@"%.2f", x2/SCREEN_WIDTH] forKey:@"tagX"];
                [tempDic2 setObject:[NSString stringWithFormat:@"%.2f", y2/SCREEN_WIDTH] forKey:@"tagY"];
                [tagArray addObject:tempDic2];
                [tempDic3 setObject:labelButton3.titleLabel.text forKey:@"tagText"];
                [tempDic3 setObject:[NSString stringWithFormat:@"%.2f", x3/SCREEN_WIDTH] forKey:@"tagX"];
                [tempDic3 setObject:[NSString stringWithFormat:@"%.2f", y3/SCREEN_WIDTH] forKey:@"tagY"];
                [tagArray addObject:tempDic3];
                [tempDic4 setObject:labelButton4.titleLabel.text forKey:@"tagText"];
                [tempDic4 setObject:[NSString stringWithFormat:@"%.2f", x4/SCREEN_WIDTH] forKey:@"tagX"];
                [tempDic4 setObject:[NSString stringWithFormat:@"%.2f", y4/SCREEN_WIDTH] forKey:@"tagY"];
                [tagArray addObject:tempDic4];
                [tempDic5 setObject:labelButton5.titleLabel.text forKey:@"tagText"];
                [tempDic5 setObject:[NSString stringWithFormat:@"%.2f", x5/SCREEN_WIDTH] forKey:@"tagX"];
                [tempDic5 setObject:[NSString stringWithFormat:@"%.2f", y5/SCREEN_WIDTH] forKey:@"tagY"];
                [tagArray addObject:tempDic5];
                
                
            }
                break;
                
            default:
                break;
        }
    }
    //NSString *jsonString = [Util toJsonString:tagArray];
    
    addLabelButton.frame = CGRectMake(SCREEN_WIDTH/2 - 25, 0 - 50, 50, 50);
    isShowAddLabelButton = NO;
    [addLabelImageView removeAllSubviews];
}

/*
 点击打标签图片
 */
- (void)addLabelImageClick:(UITapGestureRecognizer*)gesture {
    if (!isShowAddLabelButton) {
        [UIView animateWithDuration:0.3 animations:^{
            addLabelButton.frame = CGRectMake(SCREEN_WIDTH/2 - 27, NAVIGATIONBAR_HEIGHT + SCREEN_WIDTH/2 - 27, 54, 54);
        }];
        isShowAddLabelButton = YES;
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            addLabelButton.frame = CGRectMake(SCREEN_WIDTH/2 - 27, 0 - 54, 54, 54);
        }];
        isShowAddLabelButton = NO;
    }
    
}
/*
 点击打标签
 */
- (void)addLabelClick{
    if (tag >= 5) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"标签不要超过五个哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        addLabelButton.frame = CGRectMake(SCREEN_WIDTH/2 - 27, 0 - 54, 54, 54);
        isShowAddLabelButton = NO;
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            addLabelButton.frame = CGRectMake(SCREEN_WIDTH/2 - 27, 0 - 54, 54, 54);
        }];
        isShowAddLabelButton = NO;
        //    int labelHeight = arc4random()%300 + 10;
        //    HSCButton *labelButton = [[HSCButton alloc] initWithFrame:CGRectMake(10, labelHeight, 50, 20)];
        //    labelButton.backgroundColor = [UIColor blueColor];
        //    labelButton.dragEnable = YES;
        //    [addLabelImageView addSubview:labelButton];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        ChooseLabelViewController *chooseLabelController = [[ChooseLabelViewController alloc] init];
        chooseLabelController.delegate = self;
        [appDelegate.rootNavigationController pushViewController:chooseLabelController animated:YES];
    }
        
    
}

#pragma mark - AddLabelDelegate
- (void)clickFinish:(NSString *)labelString{
    CGSize labelStringSize = [labelString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SMALLFONT_14, NSFontAttributeName, nil]];
    CGSize twoWordsSize = [@"标签" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SMALLFONT_14, NSFontAttributeName, nil]];
    UIImage *tagImageRight = [UIImage imageNamed:@"tag_right"];
    UIImage *tagImageLeft = [UIImage imageNamed:@"tag_left"];
    UIEdgeInsets insets_right = UIEdgeInsetsMake(0, 52, 0, 10);
    UIEdgeInsets insets_left = UIEdgeInsetsMake(0, 10, 0, 52);
    tagImageRight = [tagImageRight resizableImageWithCapInsets:insets_right resizingMode:UIImageResizingModeStretch];
    tagImageLeft = [tagImageLeft resizableImageWithCapInsets:insets_left resizingMode:UIImageResizingModeStretch];
    tag += 1;
    switch (tag) {
        case 1:{
            labelButton = [[HSCButton alloc] initWithFrame:CGRectMake(10, 10, labelStringSize.width + 90 - twoWordsSize.width, 28)];
            //labelButton.backgroundColor = [UIColor blueColor];
            [labelButton setBackgroundImage:tagImageLeft forState:UIControlStateNormal];
            [labelButton setTitle:labelString forState:UIControlStateNormal];
            [labelButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
            labelButton.titleLabel.font = SMALLFONT_14;
            labelButton.dragEnable = YES;
            [addLabelImageView addSubview:labelButton];
        }
            break;
        case 2:{
            labelButton2 = [[HSCButton alloc] initWithFrame:CGRectMake(10, addLabelImageView.frame.size.height - 38, labelStringSize.width + 90 - twoWordsSize.width, 28)];
            [labelButton2 setBackgroundImage:tagImageLeft forState:UIControlStateNormal];
            [labelButton2 setTitle:labelString forState:UIControlStateNormal];
            [labelButton2 setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
            labelButton2.titleLabel.font = SMALLFONT_14;
            labelButton2.dragEnable = YES;
            [addLabelImageView addSubview:labelButton2];
        }
            break;
        case 3:{
            labelButton3 = [[HSCButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - labelStringSize.width - 100 + twoWordsSize.width, 10, labelStringSize.width + 90 - twoWordsSize.width, 28)];
            [labelButton3 setBackgroundImage:tagImageRight forState:UIControlStateNormal];
            [labelButton3 setTitle:labelString forState:UIControlStateNormal];
            [labelButton3 setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
            labelButton3.titleLabel.font = SMALLFONT_14;
            labelButton3.dragEnable = YES;
            [addLabelImageView addSubview:labelButton3];
        }
            break;
        case 4:{
            labelButton4 = [[HSCButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - labelStringSize.width - 100 + twoWordsSize.width, addLabelImageView.frame.size.height - 38, labelStringSize.width + 90 - twoWordsSize.width, 28)];
            [labelButton4 setBackgroundImage:tagImageRight forState:UIControlStateNormal];
            [labelButton4 setTitle:labelString forState:UIControlStateNormal];
            [labelButton5 setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
            labelButton4.titleLabel.font = SMALLFONT_14;
            labelButton4.dragEnable = YES;
            [addLabelImageView addSubview:labelButton4];
        }
            break;
        case 5:{
            labelButton5 = [[HSCButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - labelStringSize.width/2, addLabelImageView.frame.size.height/2 - 14, labelStringSize.width + 90 - twoWordsSize.width, 28)];
            [labelButton5 setBackgroundImage:tagImageRight forState:UIControlStateNormal];
            [labelButton5 setTitle:labelString forState:UIControlStateNormal];
            [labelButton5 setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
            labelButton5.titleLabel.font = SMALLFONT_14;
            labelButton5.dragEnable = YES;
            [addLabelImageView addSubview:labelButton5];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //CLLocation *location = [locations objectAtIndex:0];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *mark = [placemarks objectAtIndex:0];
        
        address = [NSString stringWithFormat:@"%@", mark.name];
        if ([address isEqualToString:@"(null)"]) {
            address = @"";
        }
        positionLabel.text = address;
    }];
    
}

- (void)positionClick{
    ChoosePositionViewController *controller = [[ChoosePositionViewController alloc] init];
    controller.delegate = self;
    controller.defaultPositionString = address;
    [self.navigationController pushViewController:controller animated:YES];
}
#define mark - PositionViewDelegate
- (void)clickDeletePosition{
    positionLabel.text = nil;
}
- (void)clickSubmit:(NSString *)positionString{
    positionLabel.text = positionString;
}

- (void)sendClick{
    NSLog(@"点击了发布按钮");
    if (!ispicture) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"先秀出你的美图哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:userInfo.userid forKey:@"userid"];
        [dic setObject:userInfo.usertoken forKey:@"usertoken"];
        [dic setObject:@"1" forKey:@"type"];
        if (trendContent.text.length > 200) {
            [dic setObject:[trendContent.text substringWithRange:NSMakeRange(0, 199)] forKey:@"trendcontent"];
        }
        else{
            [dic setObject:trendContent.text forKey:@"trendcontent"];
        }
        if (![Util isEmpty:positionLabel.text]) {
            [dic setObject:positionLabel.text forKey:@"trendaddress"];
        }
        if (ispublic) {
            [dic setObject:@"1" forKey:@"ispublic"];
        }
        else{
            [dic setObject:@"0" forKey:@"ispublic"];
        }
        if(isCourseTrend){
            [dic setObject:courseid forKey:@"courseid"];
        }
        if (![Util isEmpty:tagArray]) {
            NSString *tagString = [Util toJsonString:tagArray];
            [dic setObject:tagString forKey:@"picTag"];
        }
        __block NSString *imageString;
        [RTUploadImageNetWork postMulti:nil imageparams:trendImage.image success:^(id response) {
            NSLog(@"上传完成");
            if (![Util isEmpty:response]) {
                imageString = [response objectForKey:@"key"];
                [dic setObject:imageString forKey:@"trendpicture"];
                [TrendRequest writeTrendsWith:dic success:^(id response) {
                    if ([[response objectForKey:@"state"] integerValue] == 1000) {
//                        if (isCourseTrend) {
//                            [[NSNotificationCenter defaultCenter] postNotificationName:@"coursesendsuccess" object:@YES];
//                        }
//                        else{
                        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                        [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector:@selector(hideAlert:) userInfo:promptAlert repeats:NO];
                        [promptAlert show];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendsuccess" object:@YES];
//}
                    }
                    else{
                        NSLog(@"发送失败");
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                } failure:^(NSError *error) {
                  //  [JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.4];
                    NSLog(@"网络问题");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }];
            }
            else{
                NSLog(@"返回为空");
            }
        } failure:^(NSError *error) {
            NSLog(@"上传失败");
        } Progress:^(NSString *key, float percent) {
            NSLog(@"percent %f", percent);
        } Cancel:^BOOL{
            return NO;
        }];
    }
}
- (void)hideAlert:(NSTimer*)theTimer{
    UIAlertView *alert = (UIAlertView*)[theTimer userInfo];
    [alert dismissWithClickedButtonIndex:0 animated:NO];
}

- (void)privateButtonClick{
    if (ispublic) {
        [privateButton setImage:[UIImage imageNamed:@"clockin_private"] forState:UIControlStateNormal];
        ispublic = NO;
    }
    else{
        [privateButton setImage:[UIImage imageNamed:@"clockin_public"] forState:UIControlStateNormal];
        ispublic = YES;
    }
}

#pragma mark - UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([@"\n" isEqualToString:text]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    [tipLabel setHidden:YES];
}

#pragma mark - keyboard
//弹出
- (void)keyboardWillShown:(NSNotification*)note{
    //得到键盘高度
    NSDictionary *info = [note userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size
    ;
    positionImage.frame = CGRectMake(18, SCREEN_HEIGHT - keyboardSize.height - 33, 12, 12);
    positionLabel.frame = CGRectMake(32, SCREEN_HEIGHT - keyboardSize.height - 36, SCREEN_WIDTH - 103, 16);
    positionButton.frame = CGRectMake(18, SCREEN_HEIGHT - keyboardSize.height - 40, SCREEN_WIDTH - 100, 24);
    privateButton.frame = CGRectMake(SCREEN_WIDTH - 71, SCREEN_HEIGHT - keyboardSize.height - 36, 53, 16);
    
}
//隐藏
- (void)keyboardWillHiden{
    
    positionImage.frame = CGRectMake(18, SCREEN_HEIGHT - 33, 12, 12);
    positionLabel.frame = CGRectMake(32, SCREEN_HEIGHT - 36, SCREEN_WIDTH - 103, 16);
    positionButton.frame = CGRectMake(18, SCREEN_HEIGHT - 40, SCREEN_WIDTH - 100, 24);
    privateButton.frame = CGRectMake(SCREEN_WIDTH - 71, SCREEN_HEIGHT - 36, 53, 16);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)openEditWithImage:(UIImage *)image {
    ExtendPhotoEditComponet *compont = [ExtendPhotoEditComponet new];
    
    [compont showSimpleWithController:self image:image callback:^(UIImage *image) {
        ispicture = YES;
        trendImage.image = image;
        addLabelImageView.image = image;
        [UIView animateWithDuration:0.3f animations:^{
            addLabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }];
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

- (void)onComponent:(TuSDKCPViewController *)controller result:(TuSDKResult *)result error:(NSError *)error{
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
