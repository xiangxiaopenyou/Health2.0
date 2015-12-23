//
//  ShowTrendsViewController.m
//  Health
//
//  Created by 项小盆友 on 15/1/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ShowTrendsViewController.h"
#import <TuSDK/TuSDK.h>
#import "HSCButton.h"
#import "ChooseLabelViewController.h"
#import "ChoosePositionViewController.h"

@interface ShowTrendsViewController ()<UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, TuSDKPFCameraDelegate, chooseLabelDelegete, PositionViewDelegate>{
    UIView *chooseView;
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

@end

@implementation ShowTrendsViewController

@synthesize trendImage, trendContent, privateButton, positionButton, positionImage, positionLabel;
@synthesize isCourseTrend, courseid;
@synthesize addLabelButton, addLabelImageView, addTipLabel;

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
    [self showChooseView];
    chooseView.hidden = NO;
    
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
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    chooseView.hidden = NO;
}
- (void)showChooseView {
    chooseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    chooseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    [self.view addSubview:chooseView];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2 - 100, SCREEN_WIDTH, 200)];
    view1.backgroundColor = TABLEVIEWCELL_COLOR;
    [chooseView addSubview:view1];
    
    UIButton *choosePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    choosePhotoButton.frame = CGRectMake(SCREEN_WIDTH/4 - 41, 47, 82, 106);
    [choosePhotoButton setBackgroundImage:[UIImage imageNamed:@"choose_photo"] forState:UIControlStateNormal];
    [choosePhotoButton addTarget:self action:@selector(choosePhotoClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    takePhotoButton.frame = CGRectMake(3*SCREEN_WIDTH/4 - 41, 47, 82, 106);
    [takePhotoButton setBackgroundImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];
    [takePhotoButton addTarget:self action:@selector(takePhotoClick) forControlEvents:UIControlEventTouchUpInside];
    
    [view1 addSubview:choosePhotoButton];
    
    [view1 addSubview:takePhotoButton];
    
    [chooseView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseViewPress:)]];
    chooseView.userInteractionEnabled= YES;
    
    
    chooseView.hidden = YES;
}
- (void)choosePhotoClick{
    chooseView.hidden = YES;
    [self editAdvancedComponentHandler];
}
- (void)takePhotoClick{
    chooseView.hidden = YES;
    [self cameraComponentHandler];
}
- (void)chooseViewPress:(UITapGestureRecognizer*)gesture{
    chooseView.hidden = YES;
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
         ispicture = YES;
         tag = 0;
         addLabelImageView.image = [result loadResultImage];
         [UIView animateWithDuration:0.5f animations:^{
             addLabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
         }];
         
         
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

- (void)onComponent:(TuSDKCPViewController *)controller result:(TuSDKResult *)result error:(NSError *)error{
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
