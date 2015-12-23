//
//  CourseBuyViewController.m
//  Health
//
//  Created by cheng on 15/3/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseBuyViewController.h"
#import "CourseApplySuccessController.h"
#import "CourseRequest.h"
#import "MyInfoRequest.h"
#import "TTTAttributedLabel.h"
#import "RMDateSelectionViewController.h"
#import <TuSDK/TuSDK.h>
#import "RTUploadImageNetWork.h"
#import "TreatyViewController.h"
#import "ExampleImageViewController.h"

#define image_left [UIImage imageNamed:@"course_left_image.png"]

@interface CourseBuyViewController ()<UITextFieldDelegate,UIActionSheetDelegate,TTTAttributedLabelDelegate,TuSDKPFCameraDelegate,RMDateSelectionViewControllerDelegate>{
    UITextField *telPhoneTextField;
    UITextField *weightTextField;
    UITextField *heightTextField;
    UILabel *sexLabel;
    UILabel *birthLabel;
    
    UIImage *leftInfoImage;//从相册选择的image
    UIImage *rightInfoImage;
    UIImage *leftDefaultImage;//没有图片的时候的image
    UIImage *rightDefaultImage;
    
    UIImageView *leftImageView;
    UIImageView *rightImageView;
    
    UIButton *agreeTreatyBtn;
    NSInteger agreeOrNot;//1同意 0不同意
    
    // 自定义系统相册组件
    TuSDKCPAlbumComponent *_albumComponent;
    
    // 图片编辑组件
    TuSDKCPPhotoEditComponent *_photoEditComponent;
    
    TuSDKPFEditEntryOptions *_editEntryOptions;
    TuSDKPFEditCuterOptions *_editCuterOptions;
    
    NSInteger flag;
    
    UIButton *submitButton;
}


@end

@implementation CourseBuyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    leftDefaultImage = [UIImage imageNamed:@"info_left_image"];
    rightDefaultImage = [UIImage imageNamed:@"info_right_image"];
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 20, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"申请训练营"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self addScrollView];
    [self.view addSubview:self.scrollView];
    
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(SCREEN_WIDTH - 50, 22, 40, 40);
    submitButton.titleLabel.font = SMALLFONT_14;
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(applyCourse:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    
    NSDictionary *dicInfo = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid, @"userid", userinfo.usertoken, @"usertoken", nil];
    [MyInfoRequest myInfoWithParam:dicInfo success:^(id response) {
        if ([[response objectForKey:@"state"] intValue] == 1000) {
        }
        [self addScrollView];
    } failure:^(NSError *error) {
    }];
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addScrollView{
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *baseInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, SCREEN_WIDTH, 431)];
    baseInfoView.backgroundColor = TABLEVIEWCELL_COLOR;
    [self.scrollView addSubview:baseInfoView];
    
    UILabel *baseInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 90, 38)];
    //baseInfoLabel.backgroundColor = borderColor_rgb;
    baseInfoLabel.textColor = [UIColor whiteColor];
    baseInfoLabel.text = @"基本信息";
    //baseInfoLabel.textAlignment = NSTextAlignmentCenter;
    baseInfoLabel.font = [UIFont systemFontOfSize:16.0];
   [self.scrollView addSubview:baseInfoLabel];
    
    leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2-94)/2, 16, 94, 127)];
    leftImageView.image = leftDefaultImage;
    [baseInfoView addSubview:leftImageView];
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftImageClick)];
    leftImageView.userInteractionEnabled = YES;
    [leftImageView addGestureRecognizer:leftTap];
    
    rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+(SCREEN_WIDTH/2-94)/2, 16, 94, 127)];
    rightImageView.image = rightDefaultImage;
    [baseInfoView addSubview:rightImageView];
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightImageClick)];
    rightImageView.userInteractionEnabled = YES;
    [rightImageView addGestureRecognizer:rightTap];
    
//    TTTAttributedLabel *markLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(20, 196, scrollView_width-40, 50)];
//    markLabel.font = [UIFont systemFontOfSize:14.0];
//    markLabel.textColor = textColor_rgb;
//    markLabel.textAlignment = NSTextAlignmentCenter;
//    markLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    markLabel.numberOfLines = 0;
//    markLabel.tag = 2;
//    
//    NSString *text = @"上传照片便于教练根据你身体状况制定健身计划";
//    [markLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//        NSRange boldRange = [[mutableAttributedString string] rangeOfString:@"ipsum dolor" options:NSCaseInsensitiveSearch];
//        NSRange strikeRange = [[mutableAttributedString string] rangeOfString:@"sit amet" options:NSCaseInsensitiveSearch];
//        
//        // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
//        UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:14];
//        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
//        if (font) {
//            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:[UIFont systemFontOfSize:14.0] range:boldRange];
//            [mutableAttributedString addAttribute:kTTTStrikeOutAttributeName value:@YES range:strikeRange];
//            CFRelease(font);
//        }
//        
//        return mutableAttributedString;
//    }];
//    NSString *description = @"查看上传示例";
//    NSRange linkRange = NSMakeRange(22, [description length]);
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@http://example", [text substringWithRange:linkRange]]];
//    [markLabel addLinkToURL:url withRange:linkRange];
//    markLabel.delegate = self;
    UILabel *markLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 159, SCREEN_WIDTH, 16)];
    markLabel.text = @"上传照片便于教练根据你身体状况制定健身计划";
    markLabel.textAlignment = NSTextAlignmentCenter;
    markLabel.font = SMALLFONT_12;
    markLabel.textColor = WHITE_CLOCLOR;
    
    
    [baseInfoView addSubview:markLabel];
    
#pragma 年龄
    
    UILabel *birthLabelMarkLine = [[UILabel alloc]initWithFrame:CGRectMake(10, 191, SCREEN_WIDTH - 10, 0.5)];
    birthLabelMarkLine.backgroundColor = LINE_COLOR_GARG;
    [baseInfoView addSubview:birthLabelMarkLine];
    
    UILabel *birthLabelMark = [[UILabel alloc]initWithFrame:CGRectMake(10, 191, 60, 48)];
    birthLabelMark.font = [UIFont systemFontOfSize:14.0];
    birthLabelMark.textColor = WHITE_CLOCLOR;
    birthLabelMark.text = @"生日";
    [baseInfoView addSubview:birthLabelMark];
    
    birthLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 191, SCREEN_WIDTH-85 , 48)];
    birthLabel.textAlignment = NSTextAlignmentRight;
    birthLabel.font = [UIFont systemFontOfSize:14.0];
    birthLabel.textColor = WHITE_CLOCLOR;
    [baseInfoView addSubview:birthLabel];
    UITapGestureRecognizer *birthtapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickbirth)];
    birthLabel.userInteractionEnabled = YES;
    [birthLabel addGestureRecognizer:birthtapgesture];
    
    UILabel *birthLine = [[UILabel alloc]initWithFrame:CGRectMake(10, 239, SCREEN_WIDTH-10, 0.5)];
    birthLine.backgroundColor = LINE_COLOR_GARG;
    [baseInfoView addSubview:birthLine];
    
    
#pragma 性别
    
    UILabel *sexLabelMark = [[UILabel alloc]initWithFrame:CGRectMake(10, 239, 60, 48)];
    sexLabelMark.font = [UIFont systemFontOfSize:14.0];
    sexLabelMark.textColor = WHITE_CLOCLOR;
    sexLabelMark.text = @"性别";
    [baseInfoView addSubview:sexLabelMark];
    
    sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 239, SCREEN_WIDTH-85 , 48)];
    sexLabel.textAlignment = NSTextAlignmentRight;
    sexLabel.font = [UIFont systemFontOfSize:14.0];
    sexLabel.textColor = WHITE_CLOCLOR;
    [baseInfoView addSubview:sexLabel];
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSex)];
    sexLabel.userInteractionEnabled = YES;
    [sexLabel addGestureRecognizer:tapgesture];
    
    UILabel *sexLine = [[UILabel alloc]initWithFrame:CGRectMake(10, 287, SCREEN_WIDTH-10, 0.5)];
    sexLine.backgroundColor = LINE_COLOR_GARG;
    [baseInfoView addSubview:sexLine];

    
#pragma 身高
    
    UILabel *heightLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 287, 60, 48)];
    heightLabel.font = [UIFont systemFontOfSize:14.0];
    heightLabel.textColor = WHITE_CLOCLOR;
    heightLabel.text = @"身高(cm)";
    [baseInfoView addSubview:heightLabel];
    
    heightTextField = [[UITextField alloc]initWithFrame:CGRectMake(75, 287, SCREEN_WIDTH-85, 48)];
    heightTextField.textAlignment = NSTextAlignmentRight;
    heightTextField.font = [UIFont systemFontOfSize:14.0];
    heightTextField.returnKeyType = UIReturnKeyDone;
    heightTextField.textColor = WHITE_CLOCLOR;
    heightTextField.delegate = self;
    [baseInfoView addSubview:heightTextField];
    
    UILabel *heightLine = [[UILabel alloc]initWithFrame:CGRectMake(10, 335, SCREEN_WIDTH-10, 0.5)];
    heightLine.backgroundColor = LINE_COLOR_GARG;
    [baseInfoView addSubview:heightLine];
    
    
#pragma 体重
    UILabel *weightLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 335, 60, 48)];
    weightLabel.font = [UIFont systemFontOfSize:14.0];
    weightLabel.textColor = WHITE_CLOCLOR;
    weightLabel.text = @"体重(kg)";
    [baseInfoView addSubview:weightLabel];
    
    weightTextField = [[UITextField alloc]initWithFrame:CGRectMake(75, 335, SCREEN_WIDTH-85, 48)];
    weightTextField.textAlignment = NSTextAlignmentRight;
    weightTextField.font = [UIFont systemFontOfSize:14.0];
    weightTextField.returnKeyType = UIReturnKeyDone;
    weightTextField.textColor = WHITE_CLOCLOR;
    weightTextField.delegate = self;
    [baseInfoView addSubview:weightTextField];
    
    UILabel *weightLine = [[UILabel alloc]initWithFrame:CGRectMake(10, 383, SCREEN_WIDTH-10, 0.5)];
    weightLine.backgroundColor = LINE_COLOR_GARG;
    [baseInfoView addSubview:weightLine];
    
    
    
#pragma 手机
    
    UILabel *telPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 383, 60, 48)];
    telPhoneLabel.font = [UIFont systemFontOfSize:14.0];
    telPhoneLabel.textColor = WHITE_CLOCLOR;
    telPhoneLabel.text = @"手机号";
    [baseInfoView addSubview:telPhoneLabel];
    
    telPhoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(75, 383, SCREEN_WIDTH-85 , 48)];
    telPhoneTextField.textAlignment = NSTextAlignmentRight;
    telPhoneTextField.font = [UIFont systemFontOfSize:14.0];
    telPhoneTextField.returnKeyType = UIReturnKeyDone;
    telPhoneTextField.textColor = WHITE_CLOCLOR;
    telPhoneTextField.delegate = self;
    [baseInfoView addSubview:telPhoneTextField];
    
    
    
#pragma 协议
    
    
//    TTTAttributedLabel *treatyLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(60, 780, scrollView_width-60, 30)];
//    treatyLabel.font = [UIFont systemFontOfSize:14.0];
//    treatyLabel.textColor = textColor_rgb;
//    treatyLabel.textAlignment = NSTextAlignmentLeft;
//    treatyLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    treatyLabel.tag = 1;
//    treatyLabel.numberOfLines = 0;
//    
//    NSString *treatyText = @"我已同意并阅读健身训练营协议";
//    [treatyLabel setText:treatyText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//        NSRange boldRange = [[mutableAttributedString string] rangeOfString:@"ipsum dolor" options:NSCaseInsensitiveSearch];
//        NSRange strikeRange = [[mutableAttributedString string] rangeOfString:@"sit amet" options:NSCaseInsensitiveSearch];
//        
//        // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
//        UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:14];
//        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
//        if (font) {
//            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:[UIFont systemFontOfSize:14.0] range:boldRange];
//            [mutableAttributedString addAttribute:kTTTStrikeOutAttributeName value:@YES range:strikeRange];
//            CFRelease(font);
//        }
//        
//        return mutableAttributedString;
//    }];
//    NSString *treatyTextdescription = @"健身训练营协议";
//    NSRange treatyRange = NSMakeRange(7, [treatyTextdescription length]);
//    NSURL *treatyurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@http://treaty", [treatyText substringWithRange:treatyRange]]];
//    [treatyLabel addLinkToURL:treatyurl withRange:treatyRange];
//    treatyLabel.delegate = self;
//    [self.scrollView addSubview:treatyLabel];
    
    UILabel *privateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 469, SCREEN_WIDTH, 50)];
    privateLabel.textColor = TIME_COLOR_GARG;
    privateLabel.font = [UIFont systemFontOfSize:12.0];
    privateLabel.textAlignment = NSTextAlignmentCenter;
    privateLabel.text = @"您所填写的资料只针对该课程教练公开";
    [self.scrollView addSubview:privateLabel];
    
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 481)];
    
    
    
    [self setData];
    
}

- (void)setData{
    @try {
        
        UserData *userdata = [UserData shared];
        UserInfo *userinfo = userdata.userInfo;
//        birthLabel.text = userinfo.userbirthday;
        if ([userinfo.usersex intValue] == 1) {
            sexLabel.text = @"男";
        }else{
            sexLabel.text = @"女";
        }
        if (![Util isEmpty:userinfo.userbirthday]) {
            birthLabel.text = [NSString stringWithFormat:@"%@",userinfo.userbirthday];
        }
        if (![Util isEmpty:userinfo.userheight]) {
            heightTextField.text = [NSString stringWithFormat:@"%@",userinfo.userheight];
        }
        if (![Util isEmpty:userinfo.userweight]) {
            weightTextField.text = [NSString stringWithFormat:@"%@",userinfo.userweight];
        }
        
        if (![Util isEmpty:userinfo.usertelphone]) {
            telPhoneTextField.text = [NSString stringWithFormat:@"%@",userinfo.usertelphone];
        }
        
        if (leftInfoImage != nil){
            leftImageView.image = leftInfoImage;
        }else if (![Util isEmpty:userinfo.userbodyphoto]){
            NSArray *array = [userinfo.userbodyphoto componentsSeparatedByString:@";"];
            [leftImageView sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:[array objectAtIndex:0]]]];
        }
        
        if (rightInfoImage != nil) {
            rightImageView.image = rightInfoImage;
        }else if (![Util isEmpty:userinfo.userbodyphoto]){
            NSArray *array = [userinfo.userbodyphoto componentsSeparatedByString:@";"];
            [rightImageView sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:[array objectAtIndex:1]]]];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

- (void)keyBoardShow:(NSNotification*)notification{
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = rect.origin.y;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    if (self.scrollView.frame.origin.y+self.scrollView.frame.size.height + 64 > y - 10 ) {
        self.view.frame = CGRectMake(0,0-(self.scrollView.frame.origin.y+self.scrollView.frame.size.height-y),  SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    [UIView commitAnimations];
}
- (void)keyBoardHide:(NSNotification*)notification{
    if (self.view.frame.origin.y<=64) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
        
        [UIView commitAnimations];
    }
}
//- (void)clickTreatyBtn{
//    if (agreeOrNot == 0) {
//        agreeOrNot =1;
//        [submitButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:101/255.0 blue:1.0/255.0 alpha:1.0]];
//    }else{
//        agreeOrNot = 0;
//        [submitButton setBackgroundColor:[UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1.0]];
//    }
//    [self addScrollView];
//}

- (void)applyCourse:(id)sender{
    UIButton *btn = (UIButton*)sender;
    
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    
    userinfo.userweight = weightTextField.text;
    userinfo.userheight = heightTextField.text;
    userinfo.usertelphone = telPhoneTextField.text;
    if (self.course == nil) {
        return;
    }
    if ([Util isEmpty: telPhoneTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"资料不完全" message:@"手机号为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (![Util isValidateMobile: userinfo.usertelphone]){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"资料不完全" message:@"不是合法的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([Util isEmpty:userinfo.userbodyphoto]&&(leftInfoImage == nil||rightInfoImage == nil)) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"资料不完全" message:@"请上传照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([Util isEmpty:weightTextField.text]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"资料不完全" message:@"请上传体重" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([Util isEmpty:heightTextField.text]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"资料不完全" message:@"请上传身高" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([Util isEmpty:userinfo.userbirthday]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"资料不完全" message:@"请上传生日" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [btn setUserInteractionEnabled:NO];
    
    NSMutableDictionary *parameter;
    parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken",self.course.courseid,@"courseid",@"0",@"money",userinfo.usertelphone,@"tel",userinfo.userbirthday,@"userbirthday",userinfo.userweight,@"userweight",userinfo.userheight,@"userheight",userinfo.usersex,@"usersex", nil];
    
//    if (![JDStatusBarNotification isVisible]) {
//        [JDStatusBarNotification showWithStatus:@"正在上传资料"];
//    }
//    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    
    __block NSString *leftImageString;
    __block NSString *rightImageString;
    __block volatile NSInteger uploadFlag = 0;
    
    if (leftInfoImage == nil) {
        NSArray *array = [userinfo.userbodyphoto componentsSeparatedByString:@";"];
        leftImageString = [array objectAtIndex:0];
        
        if (rightInfoImage == nil) {
            NSArray *array = [userinfo.userbodyphoto componentsSeparatedByString:@";"];
            rightImageString = [array objectAtIndex:1];
            [parameter setObject:[NSString stringWithFormat:@"%@;%@",leftImageString,rightImageString] forKey:@"ownerphoto"];
            [CourseRequest applyCourse:parameter success:^(id response) {
                if ([[response objectForKey:@"state"] intValue] == 1000) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:MINECOURSECHANGE object:nil];//通知更新
                    CourseApplySuccessController *applySuccess = [[CourseApplySuccessController alloc]init];
                    applySuccess.course = self.course;
                    [self.navigationController pushViewController:applySuccess animated:YES];
                    //[JDStatusBarNotification showWithStatus:@"申请成功" dismissAfter:1.0];
                    
                }else if ([[response objectForKey:@"state"] intValue] == 1021){
                    //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }else if ([[response objectForKey:@"state"] intValue] == 1011){
                    //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }else{
                    //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                [btn setUserInteractionEnabled:YES];
            } failure:^(NSError *error) {
                [btn setUserInteractionEnabled:YES];
                //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }];
            return;
        }
        else{
            [RTUploadImageNetWork postMulti:nil imageparams:rightInfoImage success:^(id response) {
                if (![Util isEmpty:response]) {
                    rightImageString = [response objectForKey:@"key"];
                    [parameter setObject:[NSString stringWithFormat:@"%@;%@",leftImageString,rightImageString] forKey:@"ownerphoto"];
                    [CourseRequest applyCourse:parameter success:^(id response) {
                        if ([[response objectForKey:@"state"] intValue] == 1000) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:MINECOURSECHANGE object:nil];//通知更新
                            CourseApplySuccessController *applySuccess = [[CourseApplySuccessController alloc]init];
                            applySuccess.course = self.course;
                            [self.navigationController pushViewController:applySuccess animated:YES];
                            //[JDStatusBarNotification showWithStatus:@"申请成功" dismissAfter:1.0];
                            
                        }else if ([[response objectForKey:@"state"] intValue] == 1021){
                            //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }else if ([[response objectForKey:@"state"] intValue] == 1011){
                            //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }else{
                            //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                        [btn setUserInteractionEnabled:YES];
                    } failure:^(NSError *error) {
                        [btn setUserInteractionEnabled:YES];
                        //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }];
                }
            }failure:^(NSError *error) {
                [btn setUserInteractionEnabled:YES];
                //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } Progress:^(NSString *key, float percent) {
            } Cancel:^BOOL{
                return NO;
            }];
        }
    
    }else{
        [RTUploadImageNetWork postMulti:nil imageparams:leftInfoImage success:^(id response) {
            uploadFlag = uploadFlag+1;
            if (![Util isEmpty:response]) {
                leftImageString = [response objectForKey:@"key"];
                if (rightInfoImage == nil) {
                    NSArray *array = [userinfo.userbodyphoto componentsSeparatedByString:@";"];
                    rightImageString = [array objectAtIndex:1];
                    
                    [CourseRequest applyCourse:parameter success:^(id response) {
                        if ([[response objectForKey:@"state"] intValue] == 1000) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:MINECOURSECHANGE object:nil];//通知更新
                            CourseApplySuccessController *applySuccess = [[CourseApplySuccessController alloc]init];
                            applySuccess.course = self.course;
                            [self.navigationController pushViewController:applySuccess animated:YES];
                            //[JDStatusBarNotification showWithStatus:@"申请成功" dismissAfter:1.0];
                            
                        }else if ([[response objectForKey:@"state"] intValue] == 1021){
                            //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }else if ([[response objectForKey:@"state"] intValue] == 1011){
                            //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }else{
                            //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                        [btn setUserInteractionEnabled:YES];
                    } failure:^(NSError *error) {
                        [btn setUserInteractionEnabled:YES];
                        //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }];
                    return;
                }
                else{
                    [RTUploadImageNetWork postMulti:nil imageparams:rightInfoImage success:^(id response) {
                        if (![Util isEmpty:response]) {
                            rightImageString = [response objectForKey:@"key"];
                            [parameter setObject:[NSString stringWithFormat:@"%@;%@",leftImageString,rightImageString] forKey:@"ownerphoto"];
                            [CourseRequest applyCourse:parameter success:^(id response) {
                                if ([[response objectForKey:@"state"] intValue] == 1000) {
                                    [[NSNotificationCenter defaultCenter]postNotificationName:MINECOURSECHANGE object:nil];//通知更新
                                    CourseApplySuccessController *applySuccess = [[CourseApplySuccessController alloc]init];
                                    applySuccess.course = self.course;
                                    [self.navigationController pushViewController:applySuccess animated:YES];
                                    //[JDStatusBarNotification showWithStatus:@"申请成功" dismissAfter:1.0];
                                    
                                }else if ([[response objectForKey:@"state"] intValue] == 1021){
                                    //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    [alert show];
                                }else if ([[response objectForKey:@"state"] intValue] == 1011){
                                    //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    [alert show];
                                }else{
                                    //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                                [btn setUserInteractionEnabled:YES];
                            } failure:^(NSError *error) {
                                [btn setUserInteractionEnabled:YES];
                                //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                [alert show];
                            }];
                        }
                    }failure:^(NSError *error) {
                        [btn setUserInteractionEnabled:YES];
                        //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    } Progress:^(NSString *key, float percent) {
                    } Cancel:^BOOL{
                        return NO;
                    }];
                }
            }
        }failure:^(NSError *error) {
            [btn setUserInteractionEnabled:YES];
            //[JDStatusBarNotification showWithStatus:@"申请失败" dismissAfter:1.0];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        } Progress:^(NSString *key, float percent) {
        } Cancel:^BOOL{
            return NO;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)leftImageClick{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册选择", nil];
    actionSheet.tag = 0;
    [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews]lastObject]];
    flag = 1;
}

- (void)rightImageClick{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册选择", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews]lastObject]];
    flag = 2;
}

- (void)clickbirth{
    [self datePicker];
}

- (void)clickSex{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    actionSheet.tag = 2;
    [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews]lastObject]];
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
        case 1:{
            if (buttonIndex == 0) {
                [self cameraComponentHandler];
            }
            else if(buttonIndex == 1){
                [self editAdvancedComponentHandler];
            }
            else{
            }
        }break;
        case 2:{
            if (buttonIndex == 0) {
                UserData *userdata = [UserData shared];
                UserInfo *userInfo = userdata.userInfo;
                userInfo.usersex = @"1";
                [self addScrollView];
            }
            else if(buttonIndex == 1){
                UserData *userdata = [UserData shared];
                UserInfo *userInfo = userdata.userInfo;
                userInfo.usersex = @"2";
                [self addScrollView];
            }
        }break;
        default:
            break;
    }
    
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    userinfo.userweight = weightTextField.text;
    userinfo.userheight = heightTextField.text;
    userinfo.usertelphone = telPhoneTextField.text;
}

#pragma mark TTTAttributedLabel Delegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    if (label.tag == 2) {
        //跳转示例
        NSLog(@"示例");
        ExampleImageViewController *controller = [[ExampleImageViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        NSLog(@"跳转协议");
        TreatyViewController *controller = [[TreatyViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)datePicker
{
    [RMDateSelectionViewController setLocalizedTitleForCancelButton:@"取消"];
    [RMDateSelectionViewController setLocalizedTitleForSelectButton:@"确定"];
    [RMDateSelectionViewController setLocalizedTitleForNowButton:@"现在"];
    RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    dateSelectionVC.delegate = self;
    dateSelectionVC.titleLabel.text = @"";
    dateSelectionVC.hideNowButton = YES;
    
    //You can enable or disable blur, bouncing and motion effects
    dateSelectionVC.disableBouncingWhenShowing = NO;
    dateSelectionVC.disableMotionEffects = NO;
    dateSelectionVC.disableBlurEffects = YES;
    
    dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDate;
    dateSelectionVC.datePicker.minuteInterval = 5;
    dateSelectionVC.datePicker.date = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    
    UserData *userdata = [UserData shared];
    UserInfo *userInfo = userdata.userInfo;
    if (![Util isEmpty: userInfo.userbirthday]) {
        dateSelectionVC.datePicker.date = [CustomDate getBirthdayDate:userInfo.userbirthday];
    }
    
    
    //The example project is universal. So we first need to check whether we run on an iPhone or an iPad.
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [dateSelectionVC show];
    } else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [dateSelectionVC showFromRect:self.view.frame inView:self.view];
    }
    
}
#pragma mark RMDateSelection delegate
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    UserData *userdata = [UserData shared];
    UserInfo *userInfo = userdata.userInfo;
    userInfo.userbirthday = [CustomDate getBirthDayString:aDate];
    [self addScrollView];
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    NSLog(@"Date selection was canceled");
}


#pragma mark TuSDKPFCameraDelegate
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
         if (flag == 1) {
             leftInfoImage = [result loadResultImage];
         }else{
             rightInfoImage = [result loadResultImage];
         }
         [self addScrollView];
         
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
- (void)onComponent:(TuSDKCPViewController *)controller result:(TuSDKResult *)result error:(NSError *)error{
    
}

@end
