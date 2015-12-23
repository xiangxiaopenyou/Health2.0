//
//  PersonalViewController.m
//  Health
//
//  Created by cheng on 15/3/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PersonalViewController.h"
#import "PeosonInfoCell.h"
#import "AttentionCell.h"
#import "SegmentSelectCell.h"
#import "PersonPhotoCell.h"
#import "PersonTrainCell.h"
#import "PersonRequest.h"
#import "PersonEntity.h"
#import "TrendDetailViewController.h"
#import "CourseGroupChatViewController.h"
#import "MineInfoCell.h"
#import "PersonFansViewController.h"
#import "AttentionViewController.h"
#import "PersonDetailInfoViewController.h"
#import "ChatViewController.h"
#import "CLWeeklyCalendarView.h"
#import "DairyTableViewCell.h"
#import "MyInfoRequest.h"
#import "ClockinDetailViewController.h"
#import "CourseDetailsViewController.h"

@interface PersonalViewController ()<MineInfoCellDelegate, CLWeeklyCalendarViewDelegate>{
    NSInteger flagIndex;
    EGORefreshTableHeaderView *_refresh;
     EGORefreshTableHeaderView *_refreshDairy;
    BOOL _reload;
    
    BOOL _moreLoadPhoto;//判断是否正在加载
    BOOL _showMorePhoto;//判断是否有更多数据
    
    BOOL _moreLoadCourse;
    BOOL _showMoreCourse;
    
    BOOL _moreLoadDairy;//日记
    BOOL _showMoreDairy;
    
    NSMutableArray *dairyArray;
    NSDictionary *weightInfoDic;
    
    NSMutableArray *photoArray;
    NSMutableArray *trainArray;
    
    PersonEntity *personInfo;
    
    UILabel *titleLabel;
    
    AppDelegate *appDelegate;
    NSInteger currentIndex;
    
    UILabel *yearLabel;
    UILabel *dateLabel;
    NSString *dateString;
    NSString *limitString;
    NSString *totalString;
    
    DairyTableViewCell *dairyCell;
    UILabel *labelCenter;
    UILabel *basicLabel;
    UILabel *sportsConsumeLabel;
    UILabel *needsConsumeLabel;
    
    CourseEntity *selectedCourse;

}
@property (nonatomic, strong)CLWeeklyCalendarView *calendarView;

@end

@implementation PersonalViewController
@synthesize chooseDairyButton, chooseMineButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UserData *userdata = [UserData shared];
    userinfo = userdata.userInfo;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    chooseDairyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseDairyButton.frame = CGRectMake(SCREEN_WIDTH/2, 28.5, 68, 27);
    [chooseDairyButton setTitle:@"日记" forState:UIControlStateNormal];
    [chooseDairyButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    chooseDairyButton.titleLabel.font = SMALLFONT_14;
    chooseDairyButton.layer.masksToBounds = YES;
    chooseDairyButton.layer.cornerRadius = 13.5;
    chooseDairyButton.backgroundColor = CLEAR_COLOR;
    [chooseDairyButton addTarget:self action:@selector(chooseDairyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseDairyButton];
    
    chooseMineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseMineButton.frame = CGRectMake(SCREEN_WIDTH/2 - 68, 28.5, 68, 27);
    [chooseMineButton setTitle:@"主页" forState:UIControlStateNormal];
    [chooseMineButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    chooseMineButton.titleLabel.font = SMALLFONT_14;
    chooseMineButton.layer.masksToBounds = YES;
    chooseMineButton.layer.cornerRadius = 13.5;
    chooseMineButton.backgroundColor = MAIN_COLOR_YELLOW;
    [chooseMineButton addTarget:self action:@selector(chooseMineClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseMineButton];
    
    currentIndex = 0;

    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chatButton.frame = CGRectMake(SCREEN_WIDTH - 50, 22, 45, 40);
    [chatButton setTitle:@"聊天" forState:UIControlStateNormal];
    [chatButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    chatButton.titleLabel.font = SMALLFONT_16;
    [chatButton addTarget:self action:@selector(chatClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chatButton];
    
    [self addViewForTable];
    
    photoArray = [[NSMutableArray alloc]init];
    trainArray = [[NSMutableArray alloc]init];
    dairyArray = [[NSMutableArray alloc] init];
    
    personInfo = [[PersonEntity alloc]init];
    personInfo.personid = self.personID;
    [self getPersonInfo];
    [self getPersonWeightInfo];
    
    [self refreshDairyList];
}
- (void)addViewForTable{
    viewForTable = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH*2, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    viewForTable.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    [self.view addSubview:viewForTable];
    
    dairyTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, viewForTable.frame.size.height)];
    dairyTableView.delegate = self;
    dairyTableView.dataSource = self;
    dairyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dairyTableView.backgroundColor = CLEAR_COLOR;
    dairyTableView.showsVerticalScrollIndicator = NO;
    [viewForTable addSubview:dairyTableView];
    [self setupDairyHeaderView];
    
    if (_refreshDairy == nil) {
        _refreshDairy = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - dairyTableView.bounds.size.height, dairyTableView.frame.size.width, dairyTableView.bounds.size.height)];
        _refreshDairy.delegate = self;
        _refreshDairy.backgroundColor = CLEAR_COLOR;
        [dairyTableView addSubview:_refreshDairy];
    }
    [_refreshDairy refreshLastUpdatedDate];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, viewForTable.frame.size.height)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = CLEAR_COLOR;
    self.tableview.showsVerticalScrollIndicator = NO;
    [viewForTable addSubview:self.tableview];
    if (_refresh == nil) {
        _refresh = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - self.tableview.bounds.size.height, self.tableview.frame.size.width, self.tableview.bounds.size.height)];
        _refresh.delegate = self;
        _refresh.backgroundColor = [UIColor clearColor];
        [self.tableview addSubview:_refresh];
    }
    [_refresh refreshLastUpdatedDate];
    flagIndex = 1;
    
    
}
- (void)setupDairyHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2 + 179)];
    headerView.backgroundColor = CLEAR_COLOR;
    
    //    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 50, 16)];
    //    label1.text = @"连续打卡";
    //    label1.font = SMALLFONT_12;
    //    label1.textColor = WHITE_CLOCLOR;
    //    [headerView addSubview:label1];
    
    clockinDaysLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 120, 16)];
    clockinDaysLabel.font = SMALLFONT_12;
    clockinDaysLabel.textColor = WHITE_CLOCLOR;
    clockinDaysLabel.textAlignment = NSTextAlignmentCenter;
    //clockinDaysLabel.text = @"您距离20";
    [headerView addSubview:clockinDaysLabel];
    //    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(95, 12, 20, 16)];
    //    label2.text = @"天";
    //    label2.font = SMALLFONT_12;
    //    label2.textColor = WHITE_CLOCLOR;
    //    [headerView addSubview:label2];
    
    //体重区域
    UIImageView *weightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 28, SCREEN_WIDTH, SCREEN_WIDTH/2 + 2)];
    weightImageView.image = [UIImage imageNamed:@"dairy_header_view"];
    weightImageView.userInteractionEnabled = YES;
    [weightImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weightPress:)]];
    [headerView addSubview:weightImageView];
    
    nowWeightLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/10 - 17, SCREEN_WIDTH/4 - 6, 48, 27)];
    nowWeightLabel.font = [UIFont boldSystemFontOfSize:24];
    nowWeightLabel.text = @"48";
    nowWeightLabel.textColor = WHITE_CLOCLOR;
    nowWeightLabel.textAlignment = NSTextAlignmentCenter;
    [weightImageView addSubview:nowWeightLabel];
    
    labelCenter = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 30, SCREEN_WIDTH/10, 60, 30)];
    labelCenter.font = [UIFont systemFontOfSize:21];
    labelCenter.textColor = MAIN_COLOR_YELLOW;
    labelCenter.textAlignment = NSTextAlignmentCenter;
    labelCenter.text = @"已减";
    [weightImageView addSubview:labelCenter];
    
    reducedWeightLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 50, SCREEN_WIDTH/4 - 10, 100, 44)];
    reducedWeightLabel.font = [UIFont boldSystemFontOfSize:56];
    reducedWeightLabel.text = @"20";
    reducedWeightLabel.textColor = MAIN_COLOR_YELLOW;
    reducedWeightLabel.textAlignment = NSTextAlignmentCenter;
    [weightImageView addSubview:reducedWeightLabel];
    
    targetWeightLabel = [[UILabel alloc] initWithFrame:CGRectMake(8 * SCREEN_WIDTH/10 - 23, SCREEN_WIDTH/4 - 6, 48, 27)];
    targetWeightLabel.font = [UIFont boldSystemFontOfSize:24];
    targetWeightLabel.text = @"42";
    targetWeightLabel.textColor = WHITE_CLOCLOR;
    targetWeightLabel.textAlignment = NSTextAlignmentCenter;
    [weightImageView addSubview:targetWeightLabel];
    
    UIView *todayEnergyView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/2 + 30, SCREEN_WIDTH, 45)];
    todayEnergyView.backgroundColor = CLEAR_COLOR;
    [headerView addSubview:todayEnergyView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 50, 16)];
    label.font = SMALLFONT_12;
    label.text = @"今日消耗";
    label.textColor = [UIColor colorWithRed:227/255.0 green:223/255.0 blue:249/255.0 alpha:1.0];
    [todayEnergyView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 9, 9)];
    label1.backgroundColor = [UIColor colorWithRed:172/255.0 green:168/255.0 blue:213/255.0 alpha:1.0];
    label1.layer.masksToBounds = YES;
    label1.layer.cornerRadius = 4.5;
    [todayEnergyView addSubview:label1];
    
    basicLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 23, 100, 13)];
    basicLabel.textColor = [UIColor colorWithRed:172/255.0 green:168/255.0 blue:213/255.0 alpha:1.0];
    basicLabel.font = SMALLFONT_10;
    [todayEnergyView addSubview:basicLabel];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, 25, 9, 9)];
    label2.backgroundColor = [UIColor colorWithRed:172/255.0 green:168/255.0 blue:213/255.0 alpha:1.0];
    label2.layer.masksToBounds = YES;
    label2.layer.cornerRadius = 4.5;
    [todayEnergyView addSubview:label2];
    
    sportsConsumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 28, 23, 100, 13)];
    sportsConsumeLabel.textColor = [UIColor colorWithRed:172/255.0 green:168/255.0 blue:213/255.0 alpha:1.0];
    sportsConsumeLabel.font = SMALLFONT_10;
    [todayEnergyView addSubview:sportsConsumeLabel];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 25, 9, 9)];
    label3.backgroundColor = [UIColor colorWithRed:172/255.0 green:168/255.0 blue:213/255.0 alpha:1.0];
    label3.layer.masksToBounds = YES;
    label3.layer.cornerRadius = 4.5;
    [todayEnergyView addSubview:label3];
    
    needsConsumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 98, 23, 90, 13)];
    needsConsumeLabel.textColor = [UIColor colorWithRed:172/255.0 green:168/255.0 blue:213/255.0 alpha:1.0];
    needsConsumeLabel.font = SMALLFONT_10;
    [todayEnergyView addSubview:needsConsumeLabel];
    
    
    //日期选择区域
    [headerView addSubview:self.calendarView];
    
    //回到今天
    UIButton *returnTodayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnTodayButton.frame = CGRectMake(SCREEN_WIDTH - 48, SCREEN_WIDTH/2 + 75, 48, 49);
    returnTodayButton.backgroundColor = [UIColor colorWithRed:240/255.0 green:131/255.0 blue:0 alpha:1.0];
    [returnTodayButton addTarget:self action:@selector(returnTodayClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:returnTodayButton];
    
    UILabel *returnTodayLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 37, SCREEN_WIDTH/2 + 75, 26, 49)];
    returnTodayLabel.text = @"回到今天";
    returnTodayLabel.font = SMALLFONT_13;
    returnTodayLabel.textColor = WHITE_CLOCLOR;
    returnTodayLabel.numberOfLines = 2;
    returnTodayLabel.lineBreakMode = NSLineBreakByCharWrapping;
    returnTodayLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:returnTodayLabel];
    
    UIView *energyView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/2 + 30 + 94, SCREEN_WIDTH, 54)];
    energyView.backgroundColor = TABLEVIEWCELL_COLOR;
    [headerView addSubview:energyView];
    
    //显示时间
    yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 11, 60, 18)];
    yearLabel.textColor = WHITE_CLOCLOR;
    yearLabel.font = [UIFont systemFontOfSize:15];
    [energyView addSubview:yearLabel];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 29, 60, 18)];
    dateLabel.textColor = WHITE_CLOCLOR;
    dateLabel.font = SMALLFONT_13;
    [energyView addSubview:dateLabel];
    [self markDateSelected:[NSDate new]];
    
    
    //消耗、摄入
    UILabel *consumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 11, 25, 18)];
    consumeLabel.text = @"消耗";
    consumeLabel.font = SMALLFONT_12;
    consumeLabel.textColor = WHITE_CLOCLOR;
    [energyView addSubview:consumeLabel];
    
    UILabel *englobeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 29, 25, 18)];
    englobeLabel.textColor = WHITE_CLOCLOR;
    englobeLabel.text = @"摄入";
    englobeLabel.font = SMALLFONT_12;
    [energyView addSubview:englobeLabel];
    
    consumeImage = [[UIImageView alloc] initWithFrame:CGRectMake(150, 14, 78, 12)];
    [energyView addSubview:consumeImage];
    
    englobeImage = [[UIImageView alloc] initWithFrame:CGRectMake(150, 32, 78, 12)];
    [energyView addSubview:englobeImage];
    
    consumeEnergyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 82, 10, 70, 18)];
    consumeEnergyLabel.font = SMALLFONT_12;
    consumeEnergyLabel.textColor = MAIN_COLOR_YELLOW;
    consumeEnergyLabel.textAlignment = NSTextAlignmentRight;
    [energyView addSubview:consumeEnergyLabel];
    
    englobeEnergyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 82, 29, 70, 18)];
    englobeEnergyLabel.font = SMALLFONT_12;
    englobeEnergyLabel.textColor = MAIN_COLOR_YELLOW;
    englobeEnergyLabel.textAlignment = NSTextAlignmentRight;
    [energyView addSubview:englobeEnergyLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/2 + 178, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:63/255.0 green:62/255.0 blue:69/255.0 alpha:1.0];
    [headerView addSubview:line];
    
    dairyTableView.tableHeaderView = headerView;

}

/*
 点击了体重区域
 */
- (void)weightPress:(UITapGestureRecognizer*)gesture{
    
}

- (void)returnTodayClick{
    [self.calendarView redrawToDate:[NSDate new]];
    [self markDateSelected:[NSDate new]];
    dateString = nil;
}
- (void)markDateSelected:(NSDate*)date{
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dayString = [dayFormatter stringFromDate:date];
    dateLabel.text = [dayString substringWithRange:NSMakeRange(5, 6)];
    yearLabel.text = [dayString substringWithRange:NSMakeRange(0, 5)];
    [self refreshDairyList];
}
-(CLWeeklyCalendarView *)calendarView
{
    if(!_calendarView){
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/2 + 75, SCREEN_WIDTH - 48, 49)];
        _calendarView.delegate = self;
    }
    return _calendarView;
}
- (void)chooseDairyClick{
    currentIndex = 1;
    [self doneLoadingTableViewData];
    [UIView animateWithDuration:0.2 animations:^{
        viewForTable.frame = CGRectMake(0 - SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH*2, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT);
    }];
    [chooseDairyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    chooseDairyButton.backgroundColor = MAIN_COLOR_YELLOW;
    [chooseMineButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    chooseMineButton.backgroundColor = CLEAR_COLOR;
}
- (void)chooseMineClick{
    currentIndex = 0;
    [self doneLoadingTableViewData];
    [UIView animateWithDuration:0.2 animations:^{
        viewForTable.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH*2, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT);
    }];
    [chooseDairyButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    chooseDairyButton.backgroundColor = CLEAR_COLOR;
    [chooseMineButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    chooseMineButton.backgroundColor = MAIN_COLOR_YELLOW;
}
- (void)bClick{
    if (self.isChat == 1) {
        appDelegate.rootNavigationController.navigationBarHidden = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getPersonWeightInfo{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid, @"userid", userinfo.usertoken, @"usertoken", self.personID, @"friendid", nil];
    [MyInfoRequest myWeightInfo:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"获取体重信息成功");
            weightInfoDic = [response objectForKey:@"data"];
            NSString *tempStr = [NSString stringWithFormat:@"%@",[weightInfoDic objectForKey:@"day"]];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"他距离目标还剩 %@ 天", [weightInfoDic objectForKey:@"day"]]];
            [str addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR_YELLOW range:NSMakeRange(8, tempStr.length)];
            clockinDaysLabel.attributedText = str;
            nowWeightLabel.text = [NSString stringWithFormat:@"%@", [weightInfoDic objectForKey:@"newweight"]];
            float reduced = [[weightInfoDic objectForKey:@"haveweight"] floatValue];
            if (reduced < 0) {
                labelCenter.text = @"已增";
                reducedWeightLabel.text = [NSString stringWithFormat:@"%.1f", 0-reduced];
            }
            else{
                reducedWeightLabel.text = [NSString stringWithFormat:@"%.1f", reduced];
            }
            targetWeightLabel.text = [NSString stringWithFormat:@"%@", [weightInfoDic objectForKey:@"weight"]];
            
            NSString *tempStr1 = [NSString stringWithFormat:@"%@",[weightInfoDic objectForKey:@"bmr"]];
            NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"基础代谢%@大卡", [weightInfoDic objectForKey:@"bmr"]]];
            [str1 addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR_YELLOW range:NSMakeRange(4, tempStr1.length)];
            basicLabel.attributedText = str1;
            
            NSString *tempStr2 = [NSString stringWithFormat:@"%@",[weightInfoDic objectForKey:@"sport_num"]];
            NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"运动消耗%@大卡", [weightInfoDic objectForKey:@"sport_num"]]];
            [str2 addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR_YELLOW range:NSMakeRange(4, tempStr2.length)];
            sportsConsumeLabel.attributedText = str2;
            
            NSString *tempStr3 = [NSString stringWithFormat:@"%@",[weightInfoDic objectForKey:@"need"]];
            NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"还需消耗%@大卡", [weightInfoDic objectForKey:@"need"]]];
            [str3 addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR_YELLOW range:NSMakeRange(4, tempStr3.length)];
            needsConsumeLabel.attributedText = str3;
        }
        else {
        }
    } failure:^(NSError *error) {
    }];
}
- (void)refreshDairyList{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userinfo.userid forKey:@"userid"];
    [dic setObject:userinfo.usertoken forKey:@"usertoken"];
    [dic setObject:self.personID forKey:@"friendid"];
    if (![Util isEmpty:dateString]) {
        [dic setObject:dateString forKey:@"time"];
    }
    [MyInfoRequest dairyInfoList:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            if (![Util isEmpty:[response objectForKey:@"data"]]) {
                dairyArray = [response objectForKey:@"data"];
            }
            limitString = [response objectForKey:@"limit"];
            totalString = [response objectForKey:@"total"];
            consumeEnergyLabel.text = [NSString stringWithFormat:@"%@大卡", [response objectForKey:@"total_sport"]];
            englobeEnergyLabel.text = [NSString stringWithFormat:@"%@大卡", [response objectForKey:@"total_food"]];
            NSInteger sportsEnergy = [[response objectForKey:@"total_sport"] integerValue];
            NSInteger foodEnergy = [[response objectForKey:@"total_food"] integerValue];
            NSInteger max = sportsEnergy > foodEnergy? sportsEnergy:foodEnergy;
            if (max < 4000) {
                consumeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"consume%02ld", sportsEnergy/400 + 1]];
                englobeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"englobe%02ld", foodEnergy/400 + 1]];
                if (sportsEnergy == 0) {
                    consumeImage.image = [UIImage imageNamed:@"consume00"];
                }
                if (foodEnergy == 0) {
                    englobeImage.image = [UIImage imageNamed:@"englobe00"];
                }
                
            }
            else {
                NSInteger per = max/10;
                consumeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"consume%02ld", sportsEnergy/(per+1) + 1]];
                englobeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"englobe%02ld", foodEnergy/(per+1) + 1]];
            }

            if ([limitString integerValue] >= [totalString integerValue]) {
                _showMoreDairy = YES;
            }
            else{
                _showMoreDairy = NO;
            }
        }
        else {
            _showMoreDairy = YES;
        }
        [self doneLoadingTableViewData];
        _moreLoadDairy = NO;
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
        [self doneLoadingTableViewData];
    }];
}
- (void)moreDairyList{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userinfo.userid forKey:@"userid"];
    [dic setObject:userinfo.usertoken forKey:@"usertoken"];
    [dic setObject:self.personID forKey:@"friendid"];
    if (![Util isEmpty:dateString]) {
        [dic setObject:dateString forKey:@"time"];
    }
    [dic setObject:limitString forKey:@"limit"];
    [MyInfoRequest dairyInfoList:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            if (![Util isEmpty:[response objectForKey:@"data"]]) {
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                [tempArray addObjectsFromArray:dairyArray];
                [tempArray addObjectsFromArray:[response objectForKey:@"data"]];
                dairyArray = tempArray;
            }
            limitString = [response objectForKey:@"limit"];
            totalString = [response objectForKey:@"total"];
            if ([limitString integerValue] >= [totalString integerValue]) {
                _showMoreDairy = YES;
            }
            else{
                _showMoreDairy = NO;
            }
        }
        else {
            _showMoreDairy = YES;
        }
        [dairyTableView reloadData];
        _moreLoadDairy = NO;
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
        [dairyTableView reloadData];
    }];
    
}
- (void)chatClick{
    //私信
    ChatViewController *chatController = [[ChatViewController alloc]init];
    chatController.portraitStyle = RCUserAvatarCycle;
    chatController.currentTarget = personInfo.personid;
    chatController.currentTargetName = personInfo.name;
    chatController.conversationType = ConversationType_PRIVATE;
    [appDelegate.rootNavigationController pushViewController:chatController animated:YES];
    appDelegate.rootNavigationController.navigationBarHidden = NO;
}
- (void)getPersonInfo{
    
    [PersonRequest personInfoWith:personInfo success:^(id response) {
        [self.tableview reloadData];
        titleLabel.text = personInfo.name;
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMore{
    if (flagIndex == 1) {
        [PersonRequest pictureMoreListWith:photoArray PersonID:personInfo.personid success:^(id response) {
            if ([[response objectForKey:@"count"] intValue] < 10) {
                _showMorePhoto = YES;//不显示更多
            }else{
                _showMorePhoto = NO;
            }
            _moreLoadPhoto = NO;
            [self doneLoadingTableViewData];
        } failure:^(NSError *error) {
            
        }];
    }else{
        [PersonRequest courseMoreListWith:trainArray PersonID:personInfo.personid success:^(id response) {
            if ([[response objectForKey:@"count"] intValue] < 10) {
                _showMoreCourse = YES;//不显示更多
            }else{
                _showMoreCourse = NO;
            }
            _moreLoadCourse = NO;
            [self doneLoadingTableViewData];
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)refresh{
    [self getPersonInfo];
    if (flagIndex == 1) {
        [PersonRequest pictureListWith:photoArray PersonID:personInfo.personid success:^(id response) {
            if ([[response objectForKey:@"count"] intValue] < 10) {
                _showMorePhoto = YES;//不显示更多
            }else{
                _showMorePhoto = NO;
            }
            [self doneLoadingTableViewData];
        } failure:^(NSError *error) {
            
        }];
    }else{
        [PersonRequest courseListWith:trainArray PersonID:personInfo.personid success:^(id response) {
            if ([[response objectForKey:@"count"] intValue] < 10) {
                _showMoreCourse = YES;//不显示更多
            }else{
                _showMoreCourse = NO;
            }
            [self doneLoadingTableViewData];
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)sortData{
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createdtime" ascending:NO];
    [photoArray sortUsingDescriptors:[NSArray arrayWithObjects:sort,nil]];
    [trainArray sortUsingDescriptors:[NSArray arrayWithObjects:sort,nil]];
}
#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (currentIndex == 1){
        if (indexPath.row >= dairyArray.count) {
            static NSString *LastCell = @"LastCell";
            LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
            if (cell == nil) {
                cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = [UIColor clearColor];
            cell.label.textColor = TIME_COLOR_GARG;
            if (_showMoreDairy) {
                cell.label.text = @"没有更多喽~";
                [cell.indicatorView stopAnimating];
            }
            else{
                cell.label.text = @"加载中...";
                [cell.indicatorView startAnimating];
                if (!_moreLoadDairy) {
                    _moreLoadDairy = YES;
                    [self moreDairyList];
                }
            }return cell;
            
        }
        static NSString *identifer = @"DairyCell";
        NSDictionary *tempDic = [dairyArray objectAtIndex:indexPath.row];
        dairyCell = [[DairyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer withDic:tempDic];
        [dairyCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        dairyCell.backgroundColor = TABLEVIEWCELL_COLOR;
        dairyCell.timeLabel.frame = CGRectMake(15, dairyCell.height/2 - 27, 54, 54);
        dairyCell.timeLabel.layer.masksToBounds = YES;
        dairyCell.timeLabel.layer.cornerRadius = 27;
        dairyCell.timeLabel.layer.borderWidth = 2;
        dairyCell.timeLabel.layer.borderColor = MAIN_COLOR_YELLOW.CGColor;
        
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(41, 0, 2, dairyCell.height/2 - 27)];
        line1.backgroundColor = line_color;
        [dairyCell addSubview:line1];
        
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(41, dairyCell.height/2 + 27, 2, dairyCell.height/2 - 27)];
        line2.backgroundColor = line_color;
        [dairyCell addSubview:line2];
        
        return dairyCell;

    }
    else {
        if (indexPath.row == 0) {
            
            if ([personInfo.isTeacher intValue] == 1) {
                
                static NSString *indentifier = @"PeosonInfoCell";
                PeosonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
                if (cell == nil) {
                    NSArray *array = [[NSBundle mainBundle] loadNibNamed:indentifier owner:self options:nil];
                    cell = [array objectAtIndex:0];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:personInfo.photo]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                cell.nameLabel.text = personInfo.name;
                cell.attentionLabel.text = [NSString stringWithFormat:@"关注 %@",personInfo.attention];
                cell.fansLabel.text = [NSString stringWithFormat:@"粉丝 %@",personInfo.fans];
                cell.teacherLabel.text = [NSString stringWithFormat:@"教学态度:%@分",personInfo.tearchPoint];
                cell.skillLabel.text = [NSString stringWithFormat:@"专业技能:%@分",personInfo.skillPoint];
                if (![Util isEmpty:personInfo.goodAt]) {
                    cell.goodAtLabel.text = [NSString stringWithFormat:@"擅长项目:%@",personInfo.goodAt];
                }
                else{
                    cell.goodAtLabel.text = [NSString stringWithFormat:@"擅长项目: "];
                }
                if ([personInfo.sex integerValue] == 1) {
                    cell.sexImage.image = [UIImage imageNamed:@"msex.png"];
                }else{
                    cell.sexImage.image = [UIImage imageNamed:@"wsex.png"];
                }
                [cell clickLabel:^(NSInteger index) {
                    //
                    if (index == 1) {
                        //关注
                        AttentionViewController *controller = [[AttentionViewController alloc]init];
                        controller.hidesBottomBarWhenPushed = YES;
                        controller.flagIndex = 2;
                        controller.personid = self.personID;
                        [appDelegate.rootNavigationController pushViewController:controller animated:YES];
                    }else if (index == 2){
                        //粉丝
                        PersonFansViewController *controller = [[PersonFansViewController alloc]init];
                        controller.hidesBottomBarWhenPushed = YES;
                        controller.flagIndex = 2;
                        controller.personid = self.personID;
                        [appDelegate.rootNavigationController pushViewController:controller animated:YES];
                    }else if (index ==3){
                        PersonDetailInfoViewController *controller = [[PersonDetailInfoViewController alloc]init];
                        controller.hidesBottomBarWhenPushed = YES;
                        controller.personInfo = personInfo;
                        [appDelegate.rootNavigationController pushViewController:controller animated:YES];
                    }
                }];
                return cell;
            }else{
                static NSString *indentifier = @"MineInfoCell";
                MineInfoCell *infocell = [tableView dequeueReusableCellWithIdentifier:indentifier];
                if (infocell == nil) {
                    infocell = [[MineInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
                }
                CGSize usernameSize = [personInfo.name sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SMALLFONT_14, NSFontAttributeName, nil]];
                infocell.name.text = personInfo.name;
                infocell.name.frame = CGRectMake(SCREEN_WIDTH/2 - usernameSize.width/2, 86, usernameSize.width, usernameSize.height);
                [infocell.fansNum setTitle:[NSString stringWithFormat:@"粉丝 %@",personInfo.fans] forState:UIControlStateNormal];
                [infocell.focusNum setTitle:[NSString stringWithFormat:@"关注 %@",personInfo.attention] forState:UIControlStateNormal];
                [infocell.imageviewPortrait sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:personInfo.photo]] placeholderImage:[UIImage imageNamed:@"training"]];
                infocell.sex.frame = CGRectMake(SCREEN_WIDTH/2 + usernameSize.width/2 + 3, 87, 15, 15);
                if ([personInfo.sex integerValue] == 1) {
                    infocell.sex.image = [UIImage imageNamed:@"msex"];
                } else {
                    infocell.sex.image = [UIImage imageNamed:@"wsex"];
                }
                infocell.delegate = self;
                return infocell;
            }
            
        }
        else if (indexPath.row == 1){
            static NSString *indentifier = @"AttentionCell";
            AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
            if (cell == nil) {
                //NSArray *array = [[NSBundle mainBundle] loadNibNamed:indentifier owner:self options:nil];
                //cell = [array objectAtIndex:0];
                cell = [[AttentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            cell.backgroundColor = TABLEVIEWCELL_COLOR;
            if ([personInfo.flag intValue] == 2) {
                [cell.attentionBtn setBackgroundImage:[UIImage imageNamed:@"attention_each.png"] forState:UIControlStateNormal];
            }
            else if ([personInfo.flag integerValue] == 4){
                [cell.attentionBtn setBackgroundImage:[UIImage imageNamed:@"homepage_isattention.png"] forState:UIControlStateNormal];
            }
            else{
                [cell.attentionBtn setBackgroundImage:[UIImage imageNamed:@"homepage_attention.png"] forState:UIControlStateNormal];
            }
            [cell attention:^(NSInteger index) {
                if (index == 1) {
                    //私信
                    //                ChatViewController *chatController = [[ChatViewController alloc]init];
                    //                chatController.portraitStyle = RCUserAvatarCycle;
                    //                chatController.currentTarget = personInfo.personid;
                    //                chatController.currentTargetName = personInfo.name;
                    //                chatController.conversationType = ConversationType_PRIVATE;
                    //                [appDelegate.rootNavigationController pushViewController:chatController animated:YES];
                    //                appDelegate.rootNavigationController.navigationBarHidden = NO;
                }else{
                    //关注或者取消关注
                    if ([personInfo.flag intValue] == 4 || [personInfo.flag intValue] == 2) {
                        //取消关注
                        [PersonRequest deleteAttentionWith:self.personID success:^(id response) {
                            
                        } failure:^(NSError *error) {
                            
                        }];
                        if ([personInfo.flag intValue] == 4) {
                            personInfo.flag = @"1";
                        }
                        else {
                            personInfo.flag = @"3";
                        }
                        if ([personInfo.flag intValue] == 2) {
                            [cell.attentionBtn setBackgroundImage:[UIImage imageNamed:@"attention_each.png"] forState:UIControlStateNormal];
                        }
                        else if([personInfo.flag intValue] == 4){
                            [cell.attentionBtn setBackgroundImage:[UIImage imageNamed:@"homepage_isattention.png"] forState:UIControlStateNormal];
                        }
                        
                        else{
                            [cell.attentionBtn setBackgroundImage:[UIImage imageNamed:@"homepage_attention.png"] forState:UIControlStateNormal];
                        }
                    }else{
                        //添加关注
                        [PersonRequest addAttentionWith:self.personID success:^(id response) {
                            
                        } failure:^(NSError *error) {
                            
                        }];
                        if ([personInfo.flag integerValue] == 1) {
                            personInfo.flag = @"4";
                        }
                        else {
                            personInfo.flag = @"2";
                        }
                        if ([personInfo.flag intValue] == 2) {
                            [cell.attentionBtn setBackgroundImage:[UIImage imageNamed:@"attention_each.png"] forState:UIControlStateNormal];
                        }
                        else if([personInfo.flag intValue] == 4){
                            [cell.attentionBtn setBackgroundImage:[UIImage imageNamed:@"homepage_isattention.png"] forState:UIControlStateNormal];
                        }else{
                            [cell.attentionBtn setBackgroundImage:[UIImage imageNamed:@"homepage_attention.png"] forState:UIControlStateNormal];
                        }
                        
                    }
                }
            }];
            return cell;
        }
        else if (indexPath.row == 2){
            static NSString *indentifier = @"SegmentSelectCell";
            SegmentSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
            if (cell == nil) {
                cell = [[SegmentSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier Index:flagIndex];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            [cell selectIndex:^(NSInteger index) {
                flagIndex = index;
                //[self.tableview reloadData];
                [self getPersonInfo];
                
            }];
            return cell;
            
        }
        else {
            if (flagIndex == 1) {
                //加载更多
                if (indexPath.row < (photoArray.count+1)/2+3) {
                    NSLog(@"%@ INDEXPATH",indexPath);
                    static NSString *indentifier = @"PersonPhotoCell";
                    PersonPhotoCell *cell =  [[PersonPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = TABLEVIEWCELL_COLOR;
                    PhotoEntity *leftEntity = [photoArray objectAtIndex:(indexPath.row-3)*2];
                    
                    [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:leftEntity.trendpicture]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                    if ((indexPath.row-3)*2+1 < photoArray.count) {
                        PhotoEntity *rightEntity = [photoArray objectAtIndex:(indexPath.row-3)*2+1];
                        [cell.rightImage sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:rightEntity.trendpicture]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                    }
                    if ((indexPath.row-3)*2+1 >= photoArray.count){
                        cell.rightImage.hidden = YES;
                    }
                    [cell clickImage:^(NSInteger index) {
                        if (index == 1) {
                            //点击左边
                            TrendDetailViewController *controller = [[TrendDetailViewController alloc]init];
                            controller.trendid = leftEntity.trendid;
                            [appDelegate.rootNavigationController pushViewController:controller animated:YES];
                        }else{
                            //点击右边
                            PhotoEntity *entity = [photoArray objectAtIndex:(indexPath.row-3)*2+1];
                            TrendDetailViewController *controller = [[TrendDetailViewController alloc]init];
                            controller.trendid = entity.trendid;
                            [appDelegate.rootNavigationController pushViewController:controller animated:YES];
                        }
                    }];
                    return cell;
                }
                else{
                    static NSString *LastCell = @"LastCell";
                    LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
                    if (cell == nil) {
                        cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
                    }
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.label.textColor = TIME_COLOR_GARG;
                    if (_showMorePhoto) {
                        cell.label.text = @"没有更多喽~";
                        [cell.indicatorView stopAnimating];
                    }
                    else{
                        cell.label.text = @"加载中...";
                        [cell.indicatorView startAnimating];
                        if (!_moreLoadPhoto) {
                            _moreLoadPhoto = YES;
                            [self loadMore];
                        }
                    }return cell;
                }
            }else{
                //加载更多
                if (indexPath.row < trainArray.count+3) {
                    
                    static NSString *indentifier = @"PersonTrainCell";
                    PersonTrainCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
                    if (cell == nil) {
                        NSArray *array = [[NSBundle mainBundle] loadNibNamed:indentifier owner:self options:nil];
                        cell = [array objectAtIndex:0];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    }
                    cell.backgroundColor = TABLEVIEWCELL_COLOR;
                    
                    CourseEntity *entity = [trainArray objectAtIndex:indexPath.row -3];
                    selectedCourse = entity;
                    [cell.trainImage sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:entity.coursephoto]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                    cell.commentLabel.text = [NSString stringWithFormat:@"共%@条学员评价",entity.coursecommentnumber];
                    cell.pointLabel.text = [NSString stringWithFormat:@"%@分",entity.courseLevel];
                    cell.levelImage.image = [Util levelImage:entity.courseLevel];
                    
                    NSInteger index = [CustomDate getDayToDate:[CustomDate getBirthdayDate:entity.coursestarttime]]+1;//根据时间进行判断是否开始结束
                    if ( index>0 && index<= [entity.coursecourseday intValue]) {
                        cell.stateImage.image = [UIImage imageNamed:@"course_state_start.png"];
                    }else if (index <= 0) {
                        cell.stateImage.image = [UIImage imageNamed:@"course_state_notstart.png"];
                    }else if ( index > [entity.coursecourseday intValue]) {
                        cell.stateImage.image = [UIImage imageNamed:@"course_state_finish.png"];
                    }
                    [cell clickImage:^{
                        if ([entity.is_join integerValue] == 1) {
                            [[RCIM sharedRCIM] joinGroup:entity.courseid groupName:entity.coursetitle completion:^{
                                [self performSelectorOnMainThread:@selector(turnToGoupChat) withObject:nil waitUntilDone:YES];
                                
                            } error:^(RCErrorCode status) {
                                
                            }];
                        }
                        else {
                            CourseDetailsViewController *controller = [[CourseDetailsViewController alloc] init];
                            controller.courseid = entity.courseid;
                            [self.navigationController pushViewController:controller animated:YES];
                        }

                    }];
                    return cell;
                }else{
                    static NSString *LastCell = @"LastCell";
                    LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
                    if (cell == nil) {
                        cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
                    }
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.label.textColor = TIME_COLOR_GARG;
                    if (_showMoreCourse) {
                        cell.label.text = @"没有更多喽~";
                        [cell.indicatorView stopAnimating];
                    }
                    else{
                        cell.label.text = @"加载中...";
                        [cell.indicatorView startAnimating];
                        if (!_moreLoadCourse) {
                            _moreLoadCourse = YES;
                            [self loadMore];
                        }
                    }return cell;
                }
            }
        }
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (currentIndex == 0) {
        if (flagIndex == 1) {
            return (photoArray.count+1)/2+4;
        }else{
            return trainArray.count+4;
        }
    }
    else {
        return dairyArray.count + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (currentIndex == 0) {
        if (indexPath.row == 0 ) {
            if([personInfo.isTeacher intValue] == 1) {
                return 193;
            }else{
                return SCREEN_WIDTH/2;
            }
        }else if (indexPath.row == 1){
            return 40;
        }else if (indexPath.row == 2){
            return 45;
        }else{
            if (flagIndex == 1) {
                if (indexPath.row >= (photoArray.count+1)/2+3) {
                    return 40;
                }
                return  (SCREEN_WIDTH-30)*150/(2*145)+10;
            }else{
                if (indexPath.row >= trainArray.count+3) {
                    return 40;
                }
                return SCREEN_WIDTH/2+13;
            }
        }
    }
    else {
        if (indexPath.row >= dairyArray.count) {
            return 40;
        }
        dairyCell = (DairyTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return dairyCell.height;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (currentIndex == 0) {
        if (indexPath.section == 0) {
            PersonDetailInfoViewController *controller = [[PersonDetailInfoViewController alloc]init];
            controller.personInfo = personInfo;
            controller.hidesBottomBarWhenPushed = YES;
            [appDelegate.rootNavigationController pushViewController:controller animated:YES];
        }
    }
    else {
        if (indexPath.row < dairyArray.count) {
            ClockinDetailViewController *controller = [[ClockinDetailViewController alloc] init];
            NSDictionary *tempDic = [dairyArray objectAtIndex:indexPath.row];
            controller.trendid = [tempDic objectForKey:@"id"];
            [appDelegate.rootNavigationController pushViewController:controller animated:YES];
        }
        
    }
}

- (void)turnToGoupChat{
    CourseGroupChatViewController *controller = [[CourseGroupChatViewController alloc]init];
    //controller.course = selectedCourse;
    controller.courseid = selectedCourse.courseid;
    controller.currentTarget = selectedCourse.courseid;
    controller.currentTargetName = selectedCourse.coursetitle;
    controller.conversationType = ConversationType_GROUP;
    controller.enableUnreadBadge = NO;
    controller.enableVoIP = NO;
    controller.portraitStyle = RCUserAvatarCycle;
    
    [appDelegate.rootNavigationController pushViewController:controller animated:YES];
    [appDelegate.rootNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"] forBarMetrics:UIBarMetricsDefault];
    appDelegate.rootNavigationController.navigationBarHidden = NO;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (currentIndex == 0) {
        [_refresh egoRefreshScrollViewDidScroll:scrollView];
    }
    else {
        [_refreshDairy egoRefreshScrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (currentIndex == 0) {
        [_refresh egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else {
        [_refreshDairy egoRefreshScrollViewDidEndDragging:scrollView];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (currentIndex == 0) {
        [_refresh egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else {
        [_refreshDairy egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark - EGORefreshTableHeaderDelegate
- (void)reloadTableViewDataSource{
    _reload = YES;
    if (currentIndex == 0) {
        [self refresh];
    }
    else {
        [self getPersonWeightInfo];
        [self refreshDairyList];
    }
}

- (void)doneLoadingTableViewData{
    
    _reload = NO;
    if (currentIndex == 0) {
        [self sortData];
        [self.tableview reloadData];
        [_refresh egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableview];
    }
    else {
        [dairyTableView reloadData];
        [_refreshDairy egoRefreshScrollViewDataSourceDidFinishedLoading:dairyTableView];
    }
}- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
        return  _reload;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark MineInfoCellDelegate

- (void)pushTOMyFun{
    PersonFansViewController *controller = [[PersonFansViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.flagIndex = 2;
    controller.personid = self.personID;
    [appDelegate.rootNavigationController pushViewController:controller animated:YES];
}
- (void)pushtoMyFocus{
    AttentionViewController *controller = [[AttentionViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.flagIndex = 2;
    controller.personid = self.personID;
    [appDelegate.rootNavigationController pushViewController:controller animated:YES];
}
- (void)pushtoMyDetailInfo{
    PersonDetailInfoViewController *controller = [[PersonDetailInfoViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.personInfo = personInfo;
    [appDelegate.rootNavigationController pushViewController:controller animated:YES];
}
#pragma mark - CLWeeklyCalendarViewDelegate
- (NSDictionary *)CLCalendarBehaviorAttributes{
    return @{
             CLCalendarWeekStartDay : @7,                 //Start Day of the week, from 1-7 Mon-Sun -- default 1
             //             CLCalendarDayTitleTextColor : [UIColor yellowColor],
             //             CLCalendarSelectedDatePrintColor : [UIColor greenColor],
             };
}
- (void)dailyCalendarViewDidSelect:(NSDate *)date{
    dateString = [CustomDate getBirthDayString:date];
    [self markDateSelected:date];
}

@end
