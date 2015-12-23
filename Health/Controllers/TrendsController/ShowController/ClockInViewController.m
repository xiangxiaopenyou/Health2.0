//
//  ClockInViewController.m
//  Health
//
//  Created by realtech on 15/4/15.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClockInViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "RMDateSelectionViewController.h"
#import "SportsEnergyViewController.h"
#import "FoodEnergyViewController.h"
#import <TuSDK/TuSDK.h>
#import "HSCButton.h"
#import "ChooseLabelViewController.h"
#import "ChoosePositionViewController.h"

@interface ClockInViewController ()<UITextViewDelegate,CLLocationManagerDelegate, RMDateSelectionViewControllerDelegate, UIAlertViewDelegate, SportsEnergyDelegate, FoodEnergyDelegate, UIActionSheetDelegate, TuSDKPFCameraDelegate, chooseLabelDelegete, PositionViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    UILabel *tipLabel;
    //定位
    CLLocationManager *locationManager;
    
    UIImageView *positionImage;
    
    RMDateSelectionViewController *dateSelectionVC;
    
    AppDelegate *appDelegate;
    
    BOOL ispicture;
    BOOL ispublic;
    
    // 自定义系统相册组件
    TuSDKCPAlbumComponent *_albumComponent;
    
    // 图片编辑组件
    TuSDKCPPhotoEditComponent *_photoEditComponent;
    
    TuSDKPFEditEntryOptions *_editEntryOptions;
    TuSDKPFEditCuterOptions *_editCuterOptions;
    
    NSString *sportsSelectedString;
    NSString *foodSelectedString;
    NSString *address;
    
    UIView *addLabelView;
    
    BOOL isShowAddLabelButton;
    
    HSCButton *labelButton;
    HSCButton *labelButton2;
    HSCButton *labelButton3;
    HSCButton *labelButton4;
    HSCButton *labelButton5;
    
    NSInteger tag;
    
    NSMutableArray *tagArray;
    
    UserInfo *userInfo;
    
    UIView *tipView;
    
    NSArray *selectedSportsArray;
    NSArray *selectedSportsNameArray;
    NSArray *selectedFoodArray;
    NSArray *selectedFoddNameArray;
    NSDictionary *selectedSportsDic;
    NSDictionary *selectedFoodDic;
}
@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *ensureButton;

@end

@implementation ClockInViewController
@synthesize clockinTimeLabel, clockinWeightLabel, sportsEnergyLabel, foodEnergyLabel, contentTextView, imageView, positionLabel, positionButton, privateButton;
@synthesize addLabelButton, addLabelImageView, addTipLabel;
@synthesize selectedView, picker, cancelButton, ensureButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    self.view.backgroundColor = TABLEVIEWCELL_COLOR;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 20, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *sendButton =[UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(SCREEN_WIDTH - 50, 20, 40, 40);
    [sendButton setTitle:@"发布" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [sendButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    
    [self clockinView];
    [self contentView];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstClockin"]){
        [[NSUserDefaults  standardUserDefaults] setBool:YES forKey:@"firstClockin"];
        [self setupTipView];
    }
    [self addLabel];
    
    
}
/*
 打卡界面
 */
- (void)clockinView{
    //时间
    UIImageView *timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(18, 9 + NAVIGATIONBAR_HEIGHT, 32, 32)];
    timeImage.image = [UIImage imageNamed:@"clockin_time"];
    [self.view addSubview:timeImage];
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(60, NAVIGATIONBAR_HEIGHT, 40, 50)];
    time.text = @"时间";
    time.textColor = [UIColor whiteColor];
    time.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:time];
    
    clockinTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150, NAVIGATIONBAR_HEIGHT, 132, 50)];
    clockinTimeLabel.text = [CustomDate getStringFromDate:[NSDate date]];
    clockinTimeLabel.textColor = [UIColor whiteColor];
    clockinTimeLabel.font = SMALLFONT_14;
    clockinTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:clockinTimeLabel];
    
    UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    timeButton.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 50);
    [timeButton addTarget:self action:@selector(timeclick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:timeButton];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 50 + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH - 10, 0.5)];
    line1.backgroundColor = LINE_COLOR_GARG;
    [self.view addSubview:line1];
    
    //体重
    UIImageView *weightImage = [[UIImageView alloc] initWithFrame:CGRectMake(18, NAVIGATIONBAR_HEIGHT + 59.5, 32, 32)];
    weightImage.image = [UIImage imageNamed:@"clockin_weight"];
    [self.view addSubview:weightImage];
    
    UILabel *weight = [[UILabel alloc] initWithFrame:CGRectMake(60, NAVIGATIONBAR_HEIGHT + 50.5, 40, 50)];
    weight.text = @"体重";
    weight.textColor = [UIColor whiteColor];
    weight.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:weight];
    
    UILabel *kgLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 45, NAVIGATIONBAR_HEIGHT +50.5, 27, 50)];
    kgLabel.text = @"Kg";
    kgLabel.textColor = [UIColor whiteColor];
    kgLabel.font = SMALLFONT_14;
    kgLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:kgLabel];
    
    clockinWeightLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, NAVIGATIONBAR_HEIGHT + 50.5, 55, 50)];
    clockinWeightLabel.text = @"";
    clockinWeightLabel.textColor = MAIN_COLOR_YELLOW;
    clockinWeightLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:clockinWeightLabel];
    
    UIButton *weightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    weightButton.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT + 50.5, SCREEN_WIDTH, 50);
    [weightButton addTarget:self action:@selector(weightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weightButton];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(10, NAVIGATIONBAR_HEIGHT + 100.5, SCREEN_WIDTH - 10, 0.5)];
    line2.backgroundColor = LINE_COLOR_GARG;
    [self.view addSubview:line2];
    
    //运动
    UIImageView *sportsImage = [[UIImageView alloc] initWithFrame:CGRectMake(18, NAVIGATIONBAR_HEIGHT + 110, 32, 32)];
    sportsImage.image = [UIImage imageNamed:@"clockin_sports"];
    [self.view addSubview:sportsImage];
    
    UILabel *sports = [[UILabel alloc] initWithFrame:CGRectMake(60, NAVIGATIONBAR_HEIGHT + 101, 40, 50)];
    sports.text = @"运动";
    sports.textColor = [UIColor whiteColor];
    sports.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:sports];
    
    UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, NAVIGATIONBAR_HEIGHT + 118.5, 15, 15)];
    rightImage.image = [UIImage imageNamed:@"club_member_right"];
    [self.view addSubview:rightImage];
    
    UILabel *sportsEnergy = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, NAVIGATIONBAR_HEIGHT + 101, 45, 50)];
    sportsEnergy.text = @"大卡";
    sportsEnergy.textColor = [UIColor whiteColor];
    sportsEnergy.font = SMALLFONT_14;
    sportsEnergy.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:sportsEnergy];
    
    sportsEnergyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 140, NAVIGATIONBAR_HEIGHT + 101, 75, 50)];
    sportsEnergyLabel.text = @"";
    sportsEnergyLabel.font = SMALLFONT_14;
    sportsEnergyLabel.textColor = MAIN_COLOR_YELLOW;
    sportsEnergyLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:sportsEnergyLabel];
    
    UIButton *sportsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sportsButton.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT + 101, SCREEN_WIDTH, 50);
    [sportsButton addTarget:self action:@selector(sportsClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sportsButton];
    
    UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(10, NAVIGATIONBAR_HEIGHT + 151, SCREEN_WIDTH - 10, 0.5)];
    line3.backgroundColor = LINE_COLOR_GARG;
    [self.view addSubview:line3];
    
    //饮食
    UIImageView *foodImage = [[UIImageView alloc] initWithFrame:CGRectMake(18, NAVIGATIONBAR_HEIGHT + 160.5, 32, 32)];
    foodImage.image = [UIImage imageNamed:@"clockin_food"];
    [self.view addSubview:foodImage];
    
    UILabel *food = [[UILabel alloc] initWithFrame:CGRectMake(60, NAVIGATIONBAR_HEIGHT + 151.5, 40, 50)];
    food.text = @"饮食";
    food.textColor = [UIColor whiteColor];
    food.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:food];
    
    UIImageView *rightImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, NAVIGATIONBAR_HEIGHT + 169, 15, 15)];
    rightImage2.image = [UIImage imageNamed:@"club_member_right"];
    [self.view addSubview:rightImage2];
    
    UILabel *foodEnergy = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, NAVIGATIONBAR_HEIGHT + 151, 45, 50)];
    foodEnergy.text = @"大卡";
    foodEnergy.textColor = [UIColor whiteColor];
    foodEnergy.font = SMALLFONT_14;
    foodEnergy.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:foodEnergy];
    
    foodEnergyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 140, NAVIGATIONBAR_HEIGHT + 151.5, 75, 50)];
    foodEnergyLabel.text = @"";
    foodEnergyLabel.font = SMALLFONT_14;
    foodEnergyLabel.textColor = MAIN_COLOR_YELLOW;
    foodEnergyLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:foodEnergyLabel];
    
    UIButton *foodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    foodButton.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT + 151.5, SCREEN_WIDTH, 50);
    [foodButton addTarget:self action:@selector(foodClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:foodButton];
    
    UILabel *line4 = [[UILabel alloc] initWithFrame:CGRectMake(10, NAVIGATIONBAR_HEIGHT + 201.5, SCREEN_WIDTH - 10, 0.5)];
    line4.backgroundColor = LINE_COLOR_GARG;
    [self.view addSubview:line4];
}

/*
 图片、内容界面
 */
- (void)contentView{
    //文字内容
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(18, 220 + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH - 36, 150)];
    contentTextView.delegate = self;
    contentTextView.showsVerticalScrollIndicator = NO;
    contentTextView.font = SMALLFONT_14;
    contentTextView.textColor = [UIColor whiteColor];
    contentTextView.returnKeyType = UIReturnKeyDone;
    contentTextView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentTextView];
    
    
    //提示
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 226+ NAVIGATIONBAR_HEIGHT, 100, 20)];
    tipLabel.text = @"说点什么吧~";
    tipLabel.textColor = TIME_COLOR_GARG;
    tipLabel.font = SMALLFONT_14;
    [self.view addSubview:tipLabel];
    
    //图片
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, SCREEN_HEIGHT - 112, 62, 62)];
    imageView.image = [UIImage imageNamed:@"clockin_default_picture"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePress:)]];
    [self.view addSubview:imageView];
    ispicture = NO;
    
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
    
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0f) {
            [locationManager requestAlwaysAuthorization];
        }
        locationManager.distanceFilter = 1000.0f;
        [locationManager startUpdatingLocation];
    }
    else{
        NSLog(@"没有开启定位");
    }
}

-(void)setupTipView{
    tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tipView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:tipView];
    
    //体重
    UIImageView *weightImage = [[UIImageView alloc] initWithFrame:CGRectMake(18, NAVIGATIONBAR_HEIGHT + 59.5, 32, 32)];
    weightImage.image = [UIImage imageNamed:@"clockin_weight"];
    [tipView addSubview:weightImage];
    
    UILabel *weight = [[UILabel alloc] initWithFrame:CGRectMake(60, NAVIGATIONBAR_HEIGHT + 50.5, 40, 50)];
    weight.text = @"体重";
    weight.textColor = [UIColor whiteColor];
    weight.font = [UIFont systemFontOfSize:17];
    [tipView addSubview:weight];
    
    //运动
    UIImageView *sportsImage = [[UIImageView alloc] initWithFrame:CGRectMake(18, NAVIGATIONBAR_HEIGHT + 110, 32, 32)];
    sportsImage.image = [UIImage imageNamed:@"clockin_sports"];
    [tipView addSubview:sportsImage];
    
    UILabel *sports = [[UILabel alloc] initWithFrame:CGRectMake(60, NAVIGATIONBAR_HEIGHT + 101, 40, 50)];
    sports.text = @"运动";
    sports.textColor = [UIColor whiteColor];
    sports.font = [UIFont systemFontOfSize:17];
    [tipView addSubview:sports];
    
    
    //饮食
    UIImageView *foodImage = [[UIImageView alloc] initWithFrame:CGRectMake(18, NAVIGATIONBAR_HEIGHT + 160.5, 32, 32)];
    foodImage.image = [UIImage imageNamed:@"clockin_food"];
    [tipView addSubview:foodImage];
    
    UILabel *food = [[UILabel alloc] initWithFrame:CGRectMake(60, NAVIGATIONBAR_HEIGHT + 151.5, 40, 50)];
    food.text = @"饮食";
    food.textColor = [UIColor whiteColor];
    food.font = [UIFont systemFontOfSize:17];
    [tipView addSubview:food];
    
    UIImageView *tipImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(56, NAVIGATIONBAR_HEIGHT + 210, 226, 108)];
    tipImage1.image = [UIImage imageNamed:@"tip03"];
    [tipView addSubview:tipImage1];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(18, SCREEN_HEIGHT - 112, 62, 62)];
    image.image = [UIImage imageNamed:@"clockin_default_picture"];
    [tipView addSubview:image];
    
    UIImageView *tipImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(34, SCREEN_HEIGHT - 166, 146, 101)];
    tipImage2.image = [UIImage imageNamed:@"tip04"];
    [tipView addSubview:tipImage2];
    
    UIButton *knownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    knownButton.frame = CGRectMake(SCREEN_WIDTH - 116, SCREEN_HEIGHT - 108, 70, 30);
    [knownButton setBackgroundImage:[UIImage imageNamed:@"known"] forState:UIControlStateNormal];
    [knownButton addTarget:self action:@selector(knownClick) forControlEvents:UIControlEventTouchUpInside];
    [tipView addSubview:knownButton];
    
}

- (void)setupSelectedView {
    selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    selectedView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    selectedView.userInteractionEnabled = YES;
    [selectedView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonClick)]];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2 - 100, SCREEN_WIDTH - 60, 162)];
    picker.delegate = self;
    picker.dataSource = self;
    picker.backgroundColor = [UIColor colorWithRed:238/255.0 green:244/255.0 blue:251/255.0 alpha:1.0];
    picker.layer.masksToBounds = YES;
    picker.layer.cornerRadius = 5;
    [selectedView addSubview:picker];
    
    CGRect pickerFrame = picker.frame;
    UILabel *minutesLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60)/2 + 30, CGRectGetHeight(pickerFrame)/2 - 15, 40, 30)];
    minutesLabel.text = @"克";
    minutesLabel.font = [UIFont systemFontOfSize:18];
    [picker addSubview:minutesLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 157.5, SCREEN_WIDTH - 60, 0.5)];
    line.backgroundColor = LINE_COLOR_GARG;
    [picker addSubview:line];
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(30, SCREEN_HEIGHT/2 + 58, (SCREEN_WIDTH-60)/2, 35);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor colorWithRed:238/255.0 green:244/255.0 blue:251/255.0 alpha:1.0];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [selectedView addSubview:cancelButton];
    
    ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ensureButton.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 + 58, (SCREEN_WIDTH-60)/2, 35);
    [ensureButton setTitle:@"确定" forState:UIControlStateNormal];
    [ensureButton setTitleColor:TABLEVIEW_BACKGROUNDCOLOR forState:UIControlStateNormal];
    ensureButton.backgroundColor = MAIN_COLOR_YELLOW;
    [ensureButton addTarget:self action:@selector(ensureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [selectedView addSubview:ensureButton];
    
    [self.view addSubview:selectedView];
    
    [selectedView setHidden:YES];
}
- (void)cancelButtonClick{
    [selectedView setHidden:YES];
}
- (void)ensureButtonClick{
    [selectedView setHidden:YES];
}

- (void)knownClick{
    [tipView removeFromSuperview];
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
    addLabelButton.frame = CGRectMake(SCREEN_WIDTH/2 - 25, 0 - 50, 50, 50);
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

#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.2f];
    self.view.frame = CGRectMake(0, - 220, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    positionImage.frame = CGRectMake(18, SCREEN_HEIGHT - 100, 12, 12);
    positionLabel.frame = CGRectMake(32, SCREEN_HEIGHT - 103, SCREEN_WIDTH - 103, 16);
    positionButton.frame = CGRectMake(18, SCREEN_HEIGHT - 107, SCREEN_WIDTH - 100, 24);
    privateButton.frame = CGRectMake(SCREEN_WIDTH - 71, SCREEN_HEIGHT - 103, 53, 16);
    imageView.frame = CGRectMake(18, SCREEN_HEIGHT - 179, 62, 62);
    
}
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
- (void)textViewDidEndEditing:(UITextView *)textView{
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.2f];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    positionImage.frame = CGRectMake(18, SCREEN_HEIGHT - 33, 12, 12);
    positionLabel.frame = CGRectMake(32, SCREEN_HEIGHT - 36, SCREEN_WIDTH - 103, 16);
    positionButton.frame = CGRectMake(18, SCREEN_HEIGHT - 40, SCREEN_WIDTH - 100, 24);
    privateButton.frame = CGRectMake(SCREEN_WIDTH - 71, SCREEN_HEIGHT - 36, 53, 16);
    imageView.frame = CGRectMake(18, SCREEN_HEIGHT - 112, 62, 62);
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)timeclick{
    [self startDatePicker];
}
- (void)weightClick{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入体重" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *alertText = [alert textFieldAtIndex:0];
    alertText.keyboardType = UIKeyboardTypeDecimalPad;
    [alert show];
}
- (void)sportsClick{
    SportsEnergyViewController *sportsController = [[SportsEnergyViewController alloc] init];
    sportsController.delegate = self;
    if (selectedSportsNameArray.count != 0) {
        sportsController.selectedSportsArray = [[NSMutableArray alloc] initWithArray:selectedSportsNameArray];
        sportsController.selectedArray = [[NSMutableArray alloc] initWithArray:selectedSportsArray];
        sportsController.selectDic = [[NSMutableDictionary alloc] initWithDictionary:selectedSportsDic];
        sportsController.countEnergy = [sportsEnergyLabel.text integerValue];
    }
    [appDelegate.rootNavigationController pushViewController:sportsController animated:YES];
}
- (void)foodClick{
    FoodEnergyViewController *foodController = [[FoodEnergyViewController alloc] init];
    foodController.delegate = self;
    if (selectedFoddNameArray.count != 0) {
        foodController.selectedFoodArray = [[NSMutableArray alloc] initWithArray:selectedFoddNameArray];
        foodController.selectedArray = [[NSMutableArray alloc] initWithArray:selectedFoodArray];
        foodController.selectDic = [[NSMutableDictionary alloc] initWithDictionary:selectedFoodDic];
        foodController.countEnergy = [foodEnergyLabel.text integerValue];
    }
    [appDelegate.rootNavigationController pushViewController:foodController animated:YES];
}

- (void)imagePress:(UITapGestureRecognizer*)gesture{
    [self showActionSheet];
}
- (void)showActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册选择", nil];
    [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews]lastObject]];
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self cameraComponentHandler];
    }
    else if(buttonIndex == 1){
        [self editAdvancedComponentHandler];
    }
    else{
    }
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


- (void)privateButtonClick{
    if (ispublic) {
        [privateButton setImage:[UIImage imageNamed:@"clockin_private"] forState:UIControlStateNormal];
        ispublic = NO;
    }
    else {
        [privateButton setImage:[UIImage imageNamed:@"clockin_public"] forState:UIControlStateNormal];
        ispublic = YES;
    }
}
/*
 发送
 */
- (void)sendClick{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:@"2" forKey:@"type"];
    [dic setObject:clockinTimeLabel.text forKey:@"time"];
    if (![Util isEmpty:clockinWeightLabel.text]) {
        [dic setObject:clockinWeightLabel.text forKey:@"weight"];
    }
    if ([Util isEmpty:sportsEnergyLabel.text] &&[Util isEmpty:foodEnergyLabel.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"运动或者饮食至少填一项哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
        if (![Util isEmpty:sportsEnergyLabel.text]) {
            [dic setObject:sportsEnergyLabel.text forKey:@"sport_num"];
            [dic setObject:sportsSelectedString forKey:@"playcard_sport"];
        }
        if (![Util isEmpty:foodEnergyLabel.text]) {
            [dic setObject:foodEnergyLabel.text forKey:@"food_num"];
            [dic setObject:foodSelectedString forKey:@"playcard_food"];
        }
        
        if (![Util isEmpty:contentTextView.text]) {
            if (contentTextView.text.length > 200) {
                [dic setObject:[contentTextView.text substringWithRange:NSMakeRange(0, 199)] forKey:@"trendcontent"];
            }
            else{
                [dic setObject:contentTextView.text forKey:@"trendcontent"];
            }
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
        if (![Util isEmpty:tagArray]) {
            NSString *tagString = [Util toJsonString:tagArray];
            [dic setObject:tagString forKey:@"picTag"];
        }
        
        if (ispicture) {
            [RTUploadImageNetWork postMulti:nil imageparams:imageView.image success:^(id response) {
                if (![Util isEmpty:response]) {
                    NSString *imageString = [response objectForKey:@"key"];
                    [dic setObject:imageString forKey:@"trendpicture"];
                    [TrendRequest writeTrendsWith:dic success:^(id response) {
                        if ([[response objectForKey:@"state"] integerValue] == 1000) {
                            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"打卡成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                            [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector:@selector(hideAlert:) userInfo:promptAlert repeats:NO];
                            [promptAlert show];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"clockinsuccess" object:@YES];
                        }
                        else{
                            NSLog(@"发送失败");
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    } failure:^(NSError *error) {
                        NSLog(@"网络问题");
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }];

                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"图片发送失败,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            } failure:^(NSError *error) {
                NSLog(@"发送失败");
            } Progress:^(NSString *key, float percent) {
                
            } Cancel:^BOOL{
                return NO;
            }];
        }
        else {
            [TrendRequest writeTrendsWith:dic success:^(id response) {
                if ([[response objectForKey:@"state"] integerValue] == 1000) {
                    //  [JDStatusBarNotification showWithStatus:@"发送成功√" dismissAfter:1.4]
                    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"打卡成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector:@selector(hideAlert:) userInfo:promptAlert repeats:NO];
                    [promptAlert show];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"clockinsuccess" object:@YES];
                }
                else{
                    // [JDStatusBarNotification showWithStatus:@"发送失败" dismissAfter:1.4];
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
        
    }
}
- (void)hideAlert:(NSTimer*)theTimer{
    UIAlertView *alert = (UIAlertView*)[theTimer userInfo];
    [alert dismissWithClickedButtonIndex:0 animated:NO];
}


//时间选择器
- (void)startDatePicker
{
    [RMDateSelectionViewController setLocalizedTitleForCancelButton:@"取消"];
    [RMDateSelectionViewController setLocalizedTitleForSelectButton:@"确定"];
    [RMDateSelectionViewController setLocalizedTitleForNowButton:@"现在"];
    dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    dateSelectionVC.delegate = self;
    dateSelectionVC.titleLabel.text = @"";
    dateSelectionVC.hideNowButton = YES;
    
    
    //You can enable or disable blur, bouncing and motion effects
    dateSelectionVC.disableBouncingWhenShowing = NO;
    dateSelectionVC.disableMotionEffects = NO;
    dateSelectionVC.disableBlurEffects = YES;
    
    dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    dateSelectionVC.datePicker.minuteInterval = 5;
    dateSelectionVC.datePicker.date = [NSDate date];
    
    
    //The example project is universal. So we first need to check whether we run on an iPhone or an iPad.
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [dateSelectionVC show];
    } else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [dateSelectionVC showFromRect:self.view.frame inView:self.view];
    }
    
}
#pragma mark - RMDateSelection delegate
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:aDate];
    clockinTimeLabel.text = dateString;
}
- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc
{
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField *alertTextField = [alertView textFieldAtIndex:0];
    if (buttonIndex == 1) {
        clockinWeightLabel.text = alertTextField.text;
    }
}

#pragma mark - SportsEnergyDelegate
- (void)clickSave:(NSArray *)selectedSports withSelectedName:(NSArray *)nameArray WithDic:(NSDictionary *)dic withAllEnergy:(NSInteger)allEnergy{
    selectedSportsArray = selectedSports;
    selectedSportsNameArray = nameArray;
    selectedSportsDic = dic;
    sportsEnergyLabel.text = [NSString stringWithFormat:@"%ld", (long)allEnergy];
    if (![Util isEmpty:selectedSports]){
        sportsSelectedString = @"";
        for (NSDictionary *tempDic in selectedSports){
            sportsSelectedString = [sportsSelectedString stringByAppendingString:[tempDic objectForKey:@"id"]];
            sportsSelectedString = [sportsSelectedString stringByAppendingString:@","];
        }
        sportsSelectedString = [sportsSelectedString substringWithRange:NSMakeRange(0, sportsSelectedString.length - 1)];
    }
}
#pragma mark - FoodEnergyDelegate
- (void)clickFoodSave:(NSArray *)selectedFood withSelectedName:(NSArray *)nameArray withDic:(NSDictionary *)dic withAllEnergy:(NSInteger)allEnergy{
    selectedFoodArray = selectedFood;
    selectedFoddNameArray = nameArray;
    selectedFoodDic = dic;
    foodEnergyLabel.text = [NSString stringWithFormat:@"%ld", (long)allEnergy];
    if (![Util isEmpty:selectedFood]) {
        foodSelectedString = @"";
        for (NSDictionary *tempDic in selectedFood){
            foodSelectedString = [foodSelectedString stringByAppendingString:[tempDic objectForKey:@"id"]];
            foodSelectedString = [foodSelectedString stringByAppendingString:@","];
        }
        foodSelectedString = [foodSelectedString substringWithRange:NSMakeRange(0, foodSelectedString.length - 1)];
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
         imageView.image = [result loadResultImage];
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
