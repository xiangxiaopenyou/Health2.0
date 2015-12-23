//
//  SquareHomeViewController.m
//  Health
//
//  Created by realtech on 15/4/14.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "SquareHomeViewController.h"
#import "CourseRequest.h"
#import "CourseListCell.h"
#import "ClubTableViewCell.h"
#import "ClubDetailViewController.h"
#import "CourseDetailsViewController.h"
#import "CourseGroupChatViewController.h"

@interface SquareHomeViewController ()<EGORefreshTableHeaderDelegate, ClubDetailViewDelegate>{
    AppDelegate *appDelegate;
    UIView *addTableView;
    NSMutableArray *recommendCourseArray;
    NSMutableArray *recommendClubArray;
    NSMutableArray *myCourseArray;
    NSMutableArray *myEvaluatedArray;
    NSMutableArray *myFinishedArray;
    NSMutableArray *myClubArray;
    
    NSInteger currentIndex;
    
    EGORefreshTableHeaderView *_refreshCourse;
    EGORefreshTableHeaderView *_refreshClub;
    
    BOOL _reloadCourse;
    BOOL _reloadClub;
    BOOL _moreLoadMyClub;
    BOOL _showMoreMyClub;
    BOOL _moreLoadAllClub;
    BOOL _showMoreAllClub;
    
    UIButton *myButton;
    UIButton *allButton;
    NSInteger selectedIndex;
    
    UILabel *selectedLabel;
    
    NSString *myClubLimit;
    NSString *allClubLimit;
    

}

@end

@implementation SquareHomeViewController

@synthesize courseItemButton, clubItemButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    _moreLoadMyClub = YES;
    _moreLoadAllClub = YES;
    _showMoreMyClub = NO;
    _showMoreAllClub = NO;
    
    myClubArray = [[NSMutableArray alloc] init];
    recommendClubArray = [[NSMutableArray alloc] init];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clubChange) name:@"joinclub" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(courseApplyChange) name:MINECOURSECHANGE object:nil];
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@""];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake(SCREEN_WIDTH/2 - 68, 28.5, 68, 27);
    [myButton setTitle:@"我的" forState:UIControlStateNormal];
    [myButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    myButton.titleLabel.font = SMALLFONT_14;
    myButton.layer.masksToBounds = YES;
    myButton.layer.cornerRadius = 13.5;
    myButton.backgroundColor = MAIN_COLOR_YELLOW;
    [myButton addTarget:self action:@selector(myButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myButton];
    
    allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    allButton.frame = CGRectMake(SCREEN_WIDTH/2, 28.5, 68, 27);
    [allButton setTitle:@"全部" forState:UIControlStateNormal];
    [allButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    allButton.titleLabel.font = SMALLFONT_14;
    allButton.layer.masksToBounds = YES;
    allButton.layer.cornerRadius = 13.5;
    allButton.backgroundColor = CLEAR_COLOR;
    [allButton addTarget:self action:@selector(allButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allButton];
    
    selectedIndex = 0;
    
 
    [self addTopView];
    [self addTable];
    
    //[self getCourseList];
    [self getMyCourseList];
    [self getAllCourseList];
    [self getClubList];
    [self getAllClubList];
    
}
- (void)addTopView{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 43)];
    topView.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    [self.view addSubview:topView];
    
    courseItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    courseItemButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 43);
    [courseItemButton setTitle:@"训练营" forState:UIControlStateNormal];
    [courseItemButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    courseItemButton.titleLabel.font = SMALLFONT_16;
    [courseItemButton addTarget:self action:@selector(courseItemClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:courseItemButton];
    
    clubItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clubItemButton.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 43);
    [clubItemButton setTitle:@"俱乐部" forState:UIControlStateNormal];
    [clubItemButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    clubItemButton.titleLabel.font = SMALLFONT_16;
    [clubItemButton addTarget:self action:@selector(clubItemClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:clubItemButton];
    
    selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4 - 22, topView.frame.size.height - 3, 44, 3)];
    selectedLabel.backgroundColor = MAIN_COLOR_YELLOW;
    [topView addSubview:selectedLabel];
    
    currentIndex = 0;
}
- (void)addTable{
    addTableView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT + 43, SCREEN_WIDTH * 2, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 43 - TABBAR_HEIGHT)];
    addTableView.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    courseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, addTableView.frame.size.height)];
    courseTableView.delegate = self;
    courseTableView.dataSource = self;
    courseTableView.backgroundColor = [UIColor clearColor];
    courseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [addTableView addSubview:courseTableView];
    
    if (_refreshCourse == nil) {
        _refreshCourse = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - courseTableView.bounds.size.height, courseTableView.frame.size.width, courseTableView.bounds.size.height)];
        _refreshCourse.delegate = self;
        _refreshCourse.backgroundColor = [UIColor clearColor];
        [courseTableView addSubview:_refreshCourse];
    }
    [_refreshCourse refreshLastUpdatedDate];
    
    clubTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, addTableView.frame.size.height)];
    clubTableView.delegate = self;
    clubTableView.dataSource = self;
    clubTableView.backgroundColor = [UIColor clearColor];
    clubTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [addTableView addSubview:clubTableView];
    
    if (_refreshClub == nil) {
        _refreshClub = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - clubTableView.bounds.size.height, clubTableView.frame.size.width, clubTableView.bounds.size.height)];
        _refreshClub.delegate =self;
        _refreshClub.backgroundColor = [UIColor clearColor];
        [clubTableView addSubview:_refreshClub];
    }
    [_refreshClub refreshLastUpdatedDate];
    //[]
    [self.view addSubview:addTableView];
    
}
- (void)clubChange{
    [self getClubList];
}
- (void)courseApplyChange{
    [self getAllCourseList];
}
- (void)myButtonClick{
    selectedIndex = 0;
    [myButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    myButton.backgroundColor = MAIN_COLOR_YELLOW;
    [allButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    allButton.backgroundColor = CLEAR_COLOR;

    [self doneLoadingTableViewData];
}
- (void)allButtonClick{
    selectedIndex = 1;
    [allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    allButton.backgroundColor = MAIN_COLOR_YELLOW;
    [myButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    myButton.backgroundColor = CLEAR_COLOR;
    [self doneLoadingTableViewData];
}

//- (void)getCourseList{
//    [CourseRequest courseListWithSuccess:^(id response) {
//        [self setupCourseData:0];
//    } failure:^(NSError *error) {
//    }];
//}
- (void) getMyCourseList {
    [CourseRequest myCourseListWithSuccess:^(id response) {
        [self setupCourseData:1];
    } failure:^(NSError *error) {

    }];
}
- (void) getAllCourseList {
    [CourseRequest allCourseListWithSuccess:^(id response) {
        [self setupCourseData:2];
    } failure:^(NSError *error) {
    }];
}

- (void)setupCourseData: (NSInteger)index{
    UserData *userData = [UserData shared];
    UserInfo *userInfo = userData.userInfo;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"coursecreatedtime" ascending:NO];
    if (index == 1) {
        myCourseArray = [NSMutableArray arrayWithArray:[userInfo.minecourse allObjects]];
        [myCourseArray sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
        myEvaluatedArray = [NSMutableArray arrayWithArray:[userInfo.myevaluatedcourse allObjects]];
        [myEvaluatedArray sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
        myFinishedArray = [NSMutableArray arrayWithArray:[userInfo.myfinishedcourse allObjects]];
        [myFinishedArray sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
    }
    else {
        recommendCourseArray = [NSMutableArray arrayWithArray:[userInfo.recommendcourse allObjects]];
        [recommendCourseArray sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
    }
    
    [self doneLoadingTableViewData];
}


- (void)getClubList{
   
    UserData *userData = [UserData shared];
    UserInfo *userInfo = userData.userInfo;
    //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [ClubRequest myClubListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"获取成功");
            myClubArray = [response objectForKey:@"data"];
            myClubLimit = [response objectForKey:@"limit"];
            NSInteger total = [[response objectForKey:@"total"] integerValue];
            if ([myClubLimit integerValue] >= total) {
                _showMoreMyClub = YES;
            }
            else {
                _showMoreMyClub = NO;
            }
        }
        else{
            _showMoreMyClub = YES;
            NSLog(@"获取失败");
        }
        [self doneLoadingTableViewData];
        _moreLoadMyClub = NO;
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
    }];
    
}
- (void)getAllClubList{
    UserData *userData = [UserData shared];
    UserInfo *userInfo = userData.userInfo;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", nil];
    [ClubRequest allClubListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"获取成功");
            recommendClubArray = [response objectForKey:@"data"];
            allClubLimit = [response objectForKey:@"limit"];
            NSInteger total = [[response objectForKey:@"total"] integerValue];
            if ([allClubLimit integerValue] >= total) {
                _showMoreAllClub = YES;
            }
            else{
                _showMoreAllClub = NO;
            }
        }
        else{
            NSLog(@"获取失败");
            _showMoreAllClub = YES;
        }
        _moreLoadAllClub = NO;
        [self doneLoadingTableViewData];
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
    }];
}
- (void)moreClubList{
    UserData *userData = [UserData shared];
    UserInfo *userInfo = userData.userInfo;
    if (selectedIndex == 0) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", myClubLimit, @"limit", nil];
        [ClubRequest myClubListWith:dic success:^(id response) {
            if ([[response objectForKey:@"state"] integerValue] == 1000) {
                NSLog(@"获取成功");
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                [tempArray addObjectsFromArray:myClubArray];
                [tempArray addObjectsFromArray:[response objectForKey:@"data"]];
                myClubArray = tempArray;
                myClubLimit = [response objectForKey:@"limit"];
                NSInteger total = [[response objectForKey:@"total"] integerValue];
                if ([myClubLimit integerValue] >= total) {
                    _showMoreMyClub = YES;
                }
                else {
                    _showMoreMyClub = NO;
                }
            }
            else{
                _showMoreMyClub = YES;
                NSLog(@"获取失败");
            }
            [clubTableView reloadData];
            _moreLoadMyClub = NO;
        } failure:^(NSError *error) {
            NSLog(@"检查网络");
        }];

    }
    else {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", allClubLimit, @"limit", nil];
        [ClubRequest allClubListWith:dic success:^(id response) {
            if ([[response objectForKey:@"state"] integerValue] == 1000) {
                NSLog(@"获取成功");
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                [tempArray addObjectsFromArray:recommendClubArray];
                [tempArray addObjectsFromArray:[response objectForKey:@"data"]];
                recommendClubArray = tempArray;
                allClubLimit = [response objectForKey:@"limit"];
                NSInteger total = [[response objectForKey:@"total"] integerValue];
                if ([allClubLimit integerValue] >= total) {
                    _showMoreAllClub = YES;
                }
                else{
                    _showMoreAllClub = NO;
                }
            }
            else{
                NSLog(@"获取失败");
                _showMoreAllClub = YES;
            }
            _moreLoadAllClub = NO;
            [clubTableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"检查网络");
        }];
    }
}
//- (void)setupClubData{
//    
//}

- (void)changeSegment{
    [self doneLoadingTableViewData];
}
- (void)courseItemClick{
    currentIndex = 0;
    [courseItemButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    [clubItemButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        [self doneLoadingTableViewData];
        addTableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT + 43, 2*SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 43 - TABBAR_HEIGHT);
        selectedLabel.frame = CGRectMake(SCREEN_WIDTH/4 - 22, 40, 44, 3);
    }];
}
- (void)clubItemClick{
    currentIndex = 1;
    [courseItemButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [clubItemButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        [self doneLoadingTableViewData];
        addTableView.frame = CGRectMake(0-SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 43, 2*SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 43 - TABBAR_HEIGHT);
        selectedLabel.frame = CGRectMake(3*SCREEN_WIDTH/4 - 22, 40, 44, 3);
    }];
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (selectedIndex == 0) {
        if (currentIndex == 0) {
            return 3;
        }
        else {
            return 1;
        }
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (selectedIndex == 0) {
        if (currentIndex == 0) {
            switch (section) {
                case 0:
                    return myCourseArray.count;
                    break;
                case 1:
                    return myEvaluatedArray.count;
                    break;
                case 2:
                    return myFinishedArray.count;
                    
                default:
                    return 0;
                    break;
            }
        }
        else {
            return myClubArray.count + 1;
        }
    }
    else{
        if (currentIndex == 0) {
            return recommendCourseArray.count;
        }
        else{
            return recommendClubArray.count + 1;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectedIndex == 0) {
        if (currentIndex == 0) {
            return SCREEN_WIDTH/2+6;
        }
        else{
            if (indexPath.row >= myClubArray.count) {
                return 48;
            }
            else{
                return 70;
            }
        }
    }
    else{
        if (currentIndex == 0) {
            return SCREEN_WIDTH/2+6;
        }
        else{
            if (indexPath.row >= recommendClubArray.count) {
                return 48;
            }
            else{
                return 70;
            }
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (selectedIndex == 0) {
        if (currentIndex == 0){
//            if (myCourseArray.count == 0) {
//                return SCREEN_WIDTH*9/16;
//            }
            if (section == 0) {
                return 0;
            }
            else if (section == 1){
                if (myEvaluatedArray.count > 0) {
                    return 40;
                }
                else {
                    return 0;
                }
                
            }
            else {
                if (myFinishedArray.count > 0) {
                    return 40;
                }
                else {
                    return 0;
                }
            }
        }
        else{
            if (myClubArray.count == 0) {
                return 90;
            }
            else{
                return 0;
            }
        }
    }
    else {
        return 0;
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    if (currentIndex == 0) {
//        if (myCourseArray.count == 0) {
//            headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*9/16);
//            UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
//            headerImage.image = [UIImage imageNamed:@"havenot_course_image.png"];
//            //headerImage.contentMode = UIViewContentModeCenter;
//            [headerView addSubview:headerImage];
//        }
        if (section == 1) {
            headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
            headerView.backgroundColor = TABLEVIEWCELL_COLOR;
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH, 16)];
            headerLabel.text = @"待评价的训练营";
            headerLabel.textColor = TIME_COLOR_GARG;
            headerLabel.font = SMALLFONT_12;
            headerLabel.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:headerLabel];
        }
        else if (section == 2) {
            headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
            headerView.backgroundColor = TABLEVIEWCELL_COLOR;
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH, 16)];
            headerLabel.text = @"历史训练营";
            headerLabel.textColor = TIME_COLOR_GARG;
            headerLabel.font = SMALLFONT_12;
            headerLabel.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:headerLabel];
        }
        else {}
    }
    else{
        if (myClubArray.count == 0) {
            headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
            UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
            headerImage.image = [UIImage imageNamed:@"no_club"];
            headerImage.contentMode = UIViewContentModeCenter;
            [headerView addSubview:headerImage];

        }
    }
    return headerView;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *myCourseIdentifier = @"MyCourseCell";
    static NSString *recommendCourseIdentifier = @"RecommendCourseCell";
    
    
    if (selectedIndex == 0) {
        if (currentIndex == 0) {
            Course *mycourse;
            if (indexPath.section == 0) {
                mycourse = [myCourseArray objectAtIndex:indexPath.row];
            }
            else if (indexPath.section == 1) {
                mycourse = [myEvaluatedArray objectAtIndex:indexPath.row];
            }
            else {
                mycourse = [myFinishedArray objectAtIndex:indexPath.row];
            }
            //Course *mycourse = [myCourseArray objectAtIndex:indexPath.row];
            CourseListCell *myCourseCell = [tableView dequeueReusableCellWithIdentifier:myCourseIdentifier];
            if (myCourseCell == nil) {
                myCourseCell = [[CourseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCourseIdentifier];
            }
            myCourseCell.titleLabel.text = mycourse.coursetitle;
            myCourseCell.dateLabel.text = [NSString stringWithFormat:@"%@开课", [mycourse.coursestarttime substringWithRange:NSMakeRange(5, 5)]];
            myCourseCell.countLabel.text = [NSString stringWithFormat:@"%@人班", mycourse.coursecount];
            myCourseCell.daysLabel.text = [NSString stringWithFormat:@"%@天",mycourse.courseday];
            [myCourseCell.image_view sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:mycourse.coursephoto]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
            myCourseCell.priceLabel.text = [NSString stringWithFormat:@"%@", mycourse.courseprice];
            myCourseCell.oldpriceLabel.text = [NSString stringWithFormat:@"￥%@", mycourse.courseoldprice];
            if (![Util isEmpty:mycourse.courseofclub]) {
                myCourseCell.clubLabel.text = mycourse.courseofclub;
            }
            if ([mycourse.coursedifficultty integerValue] <= 2) {
                myCourseCell.difficultyImage.image = [UIImage imageNamed:@"difficulty_easy"];
                myCourseCell.difficultyLabel.text = @"简单";
                
            }
            else if ([mycourse.coursedifficultty integerValue] <= 4){
                myCourseCell.difficultyImage.image = [UIImage imageNamed:@"difficulty_normal"];
                myCourseCell.difficultyLabel.text = @"普通";
            }
            else {
                myCourseCell.difficultyImage.image = [UIImage imageNamed:@"difficulty_diffcult"];
                myCourseCell.difficultyLabel.text = @"困难";
            }
            
            switch ([mycourse.coursebody integerValue]) {
                case 10:
                    myCourseCell.bodyLabel.text = @"增肌";
                    break;
                case 11:
                    myCourseCell.bodyLabel.text = @"减肥";
                    break;
                case 12:
                    myCourseCell.bodyLabel.text = @"塑性";
                    break;
                case 13:
                    myCourseCell.bodyLabel.text = @"康复";
                    break;
                case 14:
                    myCourseCell.bodyLabel.text = @"健美";
                    break;
                default:
                    myCourseCell.bodyLabel.text = @"其他";
                    break;
            }
            
            if ([mycourse.courseisstart integerValue] == 1) {
                myCourseCell.stateImageView.image = [UIImage imageNamed:@"course_state_start"];
            }
            
            else if ([mycourse.courseisstart integerValue] == 2){
                if ([mycourse.courseisappraise integerValue] == 0) {
                    myCourseCell.stateImageView.image = [UIImage imageNamed:@"course_state_toevaluate"];
                }
                else {
                    myCourseCell.stateImageView.image = [UIImage imageNamed:@"course_state_finish"];
                }
                
            }
            else {
                myCourseCell.stateImageView.image = [UIImage imageNamed:@"course_state_notstart"];
            }
            myCourseCell.selectionStyle = UITableViewCellSelectionStyleNone;
            myCourseCell.backgroundColor = TABLEVIEWCELL_COLOR;
            return myCourseCell;
        }
        else{
            
            if (indexPath.row < myClubArray.count){
                static NSString *myClubIdentifier = @"MyClubCell";
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
                tempDic = [myClubArray objectAtIndex:indexPath.row];
                //ClubTableViewCell *myClubCell = [tableView dequeueReusableCellWithIdentifier:myClubIdentifier];
                //if (myClubCell == nil) {
                ClubTableViewCell *myClubCell = [[ClubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myClubIdentifier withDic:tempDic];
                //}
                
                myClubCell.backgroundColor = TABLEVIEWCELL_COLOR;
                return myClubCell;
            }
            else {
                static NSString *LastCell = @"LastCell";
                LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
                if (cell == nil) {
                    cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.backgroundColor = [UIColor clearColor];
                cell.label.textColor = TIME_COLOR_GARG;
                if (_showMoreMyClub) {
                    cell.label.text = @"没有更多俱乐部喽~";
                    [cell.indicatorView stopAnimating];
                }
                else{
                    cell.label.text = @"加载中...";
                    [cell.indicatorView startAnimating];
                    if (!_moreLoadMyClub) {
                        _moreLoadMyClub = YES;
                        [self moreClubList];
                    }
                }
                return cell;
            }
        }
        
    }
    else{
        if (currentIndex == 0) {
            Course *course = [recommendCourseArray objectAtIndex:indexPath.row];
            CourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendCourseIdentifier];
            if (cell == nil) {
                cell = [[CourseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recommendCourseIdentifier];
            }
            cell.titleLabel.text = course.coursetitle;
            cell.dateLabel.text = [NSString stringWithFormat:@"%@开课", [course.coursestarttime substringWithRange:NSMakeRange(5, 5)]];
            cell.countLabel.text = [NSString stringWithFormat:@"%@人班", course.coursecount];
            cell.backgroundColor = [UIColor whiteColor];
            [cell.image_view sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:course.coursephoto]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
            cell.daysLabel.text = [NSString stringWithFormat:@"%@天",course.courseday];
            cell.priceLabel.text = [NSString stringWithFormat:@"%@", course.courseprice];
            cell.oldpriceLabel.text = [NSString stringWithFormat:@"￥%@", course.courseoldprice];
            
            if (![Util isEmpty:course.courseofclub]) {
                cell.clubLabel.text = course.courseofclub;
            }
            if ([course.coursedifficultty integerValue] <= 2) {
                cell.difficultyImage.image = [UIImage imageNamed:@"difficulty_easy"];
                cell.difficultyLabel.text = @"简单";
                
            }
            else if ([course.coursedifficultty integerValue] <= 4){
                cell.difficultyImage.image = [UIImage imageNamed:@"difficulty_normal"];
                cell.difficultyLabel.text = @"普通";
            }
            else {
                cell.difficultyImage.image = [UIImage imageNamed:@"difficulty_diffcult"];
                cell.difficultyLabel.text = @"困难";
            }
            switch ([course.coursebody integerValue]) {
                case 10:
                    cell.bodyLabel.text = @"增肌";
                    break;
                case 11:
                    cell.bodyLabel.text = @"减肥";
                    break;
                case 12:
                    cell.bodyLabel.text = @"塑性";
                    break;
                case 13:
                    cell.bodyLabel.text = @"康复";
                    break;
                case 14:
                    cell.bodyLabel.text = @"健美";
                    break;
                default:
                    cell.bodyLabel.text = @"其他";
                    break;
            }
            
            if ([course.courseisstart integerValue] == 1) {
                cell.stateImageView.image = [UIImage imageNamed:@"course_state_start"];
            }
            else {
                cell.stateImageView.image = [UIImage imageNamed:@"course_state_notstart"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = TABLEVIEWCELL_COLOR;
            return cell;
        }
        else{
            
            //if (clubCell == nil) {
            
            if (indexPath.row < recommendClubArray.count) {
                static NSString *recommendClubIdentifier = @"RecommendClubCell";
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
                tempDic = [recommendClubArray objectAtIndex:indexPath.row];
                //ClubTableViewCell *clubCell = [tableView dequeueReusableCellWithIdentifier:recommendClubIdentifier];
                //if (clubCell == nil) {
                ClubTableViewCell *clubCell = [[ClubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recommendClubIdentifier withDic:tempDic];
                //}
                
                //}
                clubCell.backgroundColor = TABLEVIEWCELL_COLOR;
                return clubCell;
            }
            else  {
                static NSString *LastCell = @"LastCell";
                LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
                if (cell == nil) {
                    cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.backgroundColor = [UIColor clearColor];
                cell.label.textColor = TIME_COLOR_GARG;
                if (_showMoreAllClub) {
                    cell.label.text = @"没有更多俱乐部喽~";
                    [cell.indicatorView stopAnimating];
                }
                else{
                    cell.label.text = @"加载中...";
                    [cell.indicatorView startAnimating];
                    if (!_moreLoadAllClub) {
                        _moreLoadAllClub = YES;
                        [self moreClubList];
                    }
                }
                return cell;
            }
            
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (selectedIndex == 0) {
        if (currentIndex == 0) {
            Course *mycourse = [myCourseArray objectAtIndex:indexPath.row];
            selectedCourse = mycourse;
            [self turnToGoupChat];
            [[RCIM sharedRCIM] joinGroup:selectedCourse.courseid groupName:selectedCourse.coursetitle completion:^{
                //[self performSelectorOnMainThread:@selector(turnToGoupChat) withObject:nil waitUntilDone:YES];
                
            } error:^(RCErrorCode status) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加入群聊失败哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }];
//            [[RCIM sharedRCIM] quitGroup:mycourse.courseid completion:^{
//                
//            } error:^(RCErrorCode status) {
//                
//            }];
        }
        else{
            if (indexPath.row < myClubArray.count) {
                ClubDetailViewController *clubDetailController = [[ClubDetailViewController alloc] init];
                clubDetailController.delegate = self;
                NSDictionary *tempDic = [myClubArray objectAtIndex:indexPath.row];
                clubDetailController.clubId = [tempDic objectForKey:@"id"];
                clubDetailController.clubNameString = [tempDic objectForKey:@"clubname"];
                //clubDetailController.clubDic = tempDic;
                //clubDetailController.isJoin = [NSString stringWithFormat:@"1"];
                [appDelegate.rootNavigationController pushViewController:clubDetailController animated:YES];
            }
            
        }
    }
    else {
        if (currentIndex == 0) {
            Course *commonCourse = [recommendCourseArray objectAtIndex:indexPath.row];
            CourseDetailsViewController *detailsController = [[CourseDetailsViewController alloc] init];
            detailsController.courseid = commonCourse.courseid;
            detailsController.course = commonCourse;
            [appDelegate.rootNavigationController pushViewController:detailsController animated:YES];
        }
        else {
            if (indexPath.row < recommendClubArray.count) {
                ClubDetailViewController *clubDetailController = [[ClubDetailViewController alloc] init];
                NSDictionary *tempDic = [recommendClubArray objectAtIndex:indexPath.row];
                clubDetailController.clubId = [tempDic objectForKey:@"id"];
                clubDetailController.clubNameString = [tempDic objectForKey:@"clubname"];
                //clubDetailController.clubDic = tempDic;
                //clubDetailController.isJoin = [NSString stringWithFormat:@"0"];
                [appDelegate.rootNavigationController pushViewController:clubDetailController animated:YES];
            }
            
        }
    }
}

- (void)turnToGoupChat{
    CourseGroupChatViewController *controller = [[CourseGroupChatViewController alloc]init];
    [appDelegate.rootNavigationController pushViewController:controller animated:YES];
    [appDelegate.rootNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"] forBarMetrics:UIBarMetricsDefault];
    //controller.navigationController.interactivePopGestureRecognizer.enabled = NO;
    appDelegate.rootNavigationController.navigationBarHidden = NO;
    controller.course = selectedCourse;
    controller.currentTarget = selectedCourse.courseid;
    controller.currentTargetName = selectedCourse.coursetitle;
    controller.conversationType = ConversationType_GROUP;
    controller.enableUnreadBadge = NO;
    controller.enableVoIP = NO;
    controller.portraitStyle = RCUserAvatarCycle;
}

#pragma mark - ClubDetailViewDelegate
- (void)signSuccess {
    [self getClubList];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (currentIndex == 0) {
        [_refreshCourse egoRefreshScrollViewDidScroll:scrollView];
    }
    else{
        [_refreshClub egoRefreshScrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (currentIndex == 0) {
        [_refreshCourse egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else{
        [_refreshClub egoRefreshScrollViewDidEndDragging:scrollView];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (currentIndex == 0) {
        [_refreshCourse egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else{
        [_refreshClub egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)reloadTableViewDataSource{
    if (currentIndex == 0) {
        _reloadCourse = YES;
        //[self getCourseList];
        if (selectedIndex == 0) {
            [self getMyCourseList];
        }
        else {
            [self getAllCourseList];
        }
    }else{
        if (selectedIndex == 0) {
           [self getClubList];
        }
        else {
            [self getAllClubList];
        }
        _reloadClub = YES;
        
    }
}

- (void)doneLoadingTableViewData{
    if (currentIndex == 0) {
        _reloadCourse = NO;
        [courseTableView reloadData];
        [_refreshCourse egoRefreshScrollViewDataSourceDidFinishedLoading:courseTableView];
    }else{
        _reloadClub = NO;
        [clubTableView reloadData];
        [_refreshClub egoRefreshScrollViewDataSourceDidFinishedLoading:clubTableView];
    }
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    if (currentIndex == 0) {
        return  _reloadCourse;
    }else{
        return _reloadClub;
    }
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
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
