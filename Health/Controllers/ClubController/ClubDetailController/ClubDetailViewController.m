//
//  ClubDetailViewController.m
//  Health
//
//  Created by jason on 15/3/5.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClubDetailViewController.h"
#import "ClubDiscussionTableViewCell.h"
#import "WriteClubDiscussionViewController.h"
#import "ClubDiscussionDetailViewController.h"
#import "ClubMemberViewController.h"
#import "ClubInformationViewController.h"
#import "ClubActivityViewController.h"
#import "ClubStarsViewController.h"
#import "ClubCurriculumViewController.h"
#import "ActivityWebViewController.h"
#import "ClubTrainingCampViewController.h"

@interface ClubDetailViewController ()<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, UIScrollViewDelegate, ClubDetailViewDelegate>{
    UITableView *discussionTableView;
    
    ClubDiscussionTableViewCell *discussionCell;
    
    UIButton *clubDetailButton;
    UIButton *joinClubButton;
    UserInfo *userInfo;
    NSString *typeString;
    NSString *clubuserType;
    NSString *gagString;
    NSString *limitString;
    NSString *totalString;
    NSString *age;
    NSString *dayFlag;
    NSString *signDays;
    NSString *apply_state;
    
    NSDictionary *clubDetailDic;
    NSDictionary *clubOwnerDic;
    NSString *isJoinString;
    NSMutableArray *clubDiscussionArray;
    NSMutableArray *clubCreamArray;
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    BOOL showMore;
    BOOL isGetData;
    BOOL _reloading;
    
    UILabel *label;
    UILabel *signDaysLabel;
}

@end

@implementation ClubDetailViewController
@synthesize recentButton, hottestButton, createDiscussionButton, creamButton;
@synthesize clubTagImage, joinClubAgeLabel, signButton, clubCampButton, clubCurriculumButton, clubActivityButton, clubstarsButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    showMore = NO;
    isGetData = YES;
    _reloading = NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(creamCreate:) name:@"createcreamsuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyClubSuccess) name:@"applyclubsuccess" object:nil];
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:self.clubNameString];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(writeClubDiscussionSuccess) name:@"writeclubdiscussionsuccess" object:nil];
    
    clubDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clubDetailButton.frame = CGRectMake(SCREEN_WIDTH - 44,20,44,44);
    //[clubDetailButton setImage:[UIImage imageNamed:@"club_detail"] forState:UIControlStateNormal];
    [clubDetailButton addTarget:self action:@selector(clubDetailClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clubDetailButton];
    
    UIImageView *infoImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 14, 14)];
    infoImage.image = [UIImage imageNamed:@"report.png"];
    [clubDetailButton addSubview:infoImage];
    
    recentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recentButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 43);
    [recentButton setTitle:@"最新" forState:UIControlStateNormal];
    [recentButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    recentButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [recentButton addTarget:self action:@selector(recentClick) forControlEvents:UIControlEventTouchUpInside];
    
    hottestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hottestButton.frame = CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 43);
    [hottestButton setTitle:@"最热" forState:UIControlStateNormal];
    [hottestButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    hottestButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [hottestButton addTarget:self action:@selector(hottestClick) forControlEvents:UIControlEventTouchUpInside];
    
    creamButton = [UIButton buttonWithType:UIButtonTypeCustom];
    creamButton.frame = CGRectMake(2*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 43);
    [creamButton setTitle:@"精华" forState:UIControlStateNormal];
    [creamButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    creamButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [creamButton addTarget:self action:@selector(creamClick) forControlEvents:UIControlEventTouchUpInside];
    
    discussionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    discussionTableView.delegate = self;
    discussionTableView.dataSource = self;
    discussionTableView.showsVerticalScrollIndicator = NO;
    [discussionTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    discussionTableView.backgroundView = nil;
    discussionTableView.backgroundColor = CLEAR_COLOR;
    [discussionTableView setSectionIndexColor:[UIColor clearColor]];
    [self.view addSubview:discussionTableView];
    
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - discussionTableView.bounds.size.height, discussionTableView.frame.size.width, discussionTableView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        [discussionTableView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
//    [self setupHeaderView];
    
    createDiscussionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    createDiscussionButton.frame = CGRectMake(SCREEN_WIDTH - 57, SCREEN_HEIGHT - 57, 47, 47);
    [createDiscussionButton setImage:[UIImage imageNamed:@"add_discussion"] forState:UIControlStateNormal];
    [createDiscussionButton addTarget:self action:@selector(createDiscussionClick) forControlEvents:UIControlEventTouchUpInside];
    createDiscussionButton.hidden = YES;
    [self.view addSubview:createDiscussionButton];
    
    typeString = @"1";
    
    clubDiscussionArray = [[NSMutableArray alloc] init];
    clubCreamArray = [[NSMutableArray alloc] init];
    
    [self refreshClubDetail];
    
    

}
- (void)creamCreate:(NSNotification*)note{
    if ([typeString integerValue] == 3) {
        [self refreshClubCream];
    }
}
- (void)applyClubSuccess{
    [self refreshClubDetail];
}
- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 169.5)];
    headerView.backgroundColor = CLEAR_COLOR;
    
    clubTagImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 50, 50)];
    clubTagImage.layer.masksToBounds = YES;
    clubTagImage.layer.cornerRadius = 25;
    [clubTagImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[clubDetailDic objectForKey:@"clublogo"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
    [headerView addSubview:clubTagImage];
    
    joinClubAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(77, 12, 140, 50)];
    joinClubAgeLabel.font = SMALLFONT_14;
    joinClubAgeLabel.textColor = WHITE_CLOCLOR;
    if ([isJoinString integerValue] == 1) {
        joinClubAgeLabel.text = [NSString stringWithFormat:@"您的会龄：%@天", age];
    }
    else {
        joinClubAgeLabel.text = @"您还未加入本俱乐部";
        UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        joinButton.frame = CGRectMake(SCREEN_WIDTH - 110, 22, 100, 30);
        [joinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [joinButton setBackgroundColor:MAIN_COLOR_YELLOW];
        joinButton.titleLabel.font = SMALLFONT_14;
        joinButton.layer.masksToBounds = YES;
        joinButton.layer.cornerRadius = 2;
        if ([apply_state integerValue] == 2 || [apply_state integerValue] == 4) {
            [joinButton setTitle:@"立即加入" forState:UIControlStateNormal];
            [joinButton addTarget:self action:@selector(joinClick) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [joinButton setTitle:@"请等待审核..." forState:UIControlStateNormal];
        }
        [headerView addSubview:joinButton];
    }
    [headerView addSubview:joinClubAgeLabel];
    
    if ([isJoinString integerValue] == 1) {
        if ([dayFlag integerValue] == 2) {
            signButton = [UIButton buttonWithType:UIButtonTypeCustom];
            signButton.frame = CGRectMake(SCREEN_WIDTH - 97, 19, 82, 36);
            [signButton setImage:[UIImage imageNamed:@"club_sign"] forState:UIControlStateNormal];
            [signButton addTarget:self action:@selector(signClick) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:signButton];
        }
        else {
            signButton = [UIButton buttonWithType:UIButtonTypeCustom];
            signButton.frame = CGRectMake(SCREEN_WIDTH - 107, 19, 82, 36);
            [signButton setImage:[UIImage imageNamed:@"club_signed"] forState:UIControlStateNormal];
            [headerView addSubview:signButton];
            
            signDaysLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 25, 36)];
            signDaysLabel.font = SMALLFONT_14;
            signDaysLabel.textColor = MAIN_COLOR_YELLOW;
            signDaysLabel.text = [NSString stringWithFormat:@"%@", signDays];
            signDaysLabel.textAlignment = NSTextAlignmentCenter;
            [signButton addSubview:signDaysLabel];
        }
    }
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, 95.5)];
    toolView.backgroundColor = TABLEVIEWCELL_COLOR;
    [headerView addSubview:toolView];
    
    clubCampButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clubCampButton.frame = CGRectMake(SCREEN_WIDTH/8 - 23.5, 13, 47, 47);
    [clubCampButton setImage:[UIImage imageNamed:@"club_training_camp"] forState:UIControlStateNormal];
    [clubCampButton addTarget:self action:@selector(clubCampClick) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:clubCampButton];
    
    UILabel *campLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/8 - 23.5, 66, 47, 16)];
    campLabel.font = SMALLFONT_14;
    campLabel.textColor = WHITE_CLOCLOR;
    campLabel.text = @"训练营";
    campLabel.textAlignment = NSTextAlignmentCenter;
    [toolView addSubview:campLabel];
    
    clubCurriculumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clubCurriculumButton.frame = CGRectMake(3*SCREEN_WIDTH/8 - 23.5, 13, 47, 47);
    [clubCurriculumButton setImage:[UIImage imageNamed:@"club_curriculum"] forState:UIControlStateNormal];
    [clubCurriculumButton addTarget:self action:@selector(clubCurriculumClick) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:clubCurriculumButton];
    
    UILabel *curriculumLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*SCREEN_WIDTH/8 - 23.5, 66, 47, 16)];
    curriculumLabel.font = SMALLFONT_14;
    curriculumLabel.textColor = WHITE_CLOCLOR;
    curriculumLabel.text = @"课程表";
    curriculumLabel.textAlignment = NSTextAlignmentCenter;
    [toolView addSubview:curriculumLabel];
    
    clubActivityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clubActivityButton.frame = CGRectMake(5*SCREEN_WIDTH/8 - 23.5, 13, 47, 47);
    [clubActivityButton setImage:[UIImage imageNamed:@"club_activity"] forState:UIControlStateNormal];
    [clubActivityButton addTarget:self action:@selector(clubActivityClick) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:clubActivityButton];
    
    UILabel *activityLabel = [[UILabel alloc] initWithFrame:CGRectMake(5*SCREEN_WIDTH/8 - 23.5, 66, 47, 16)];
    activityLabel.font = SMALLFONT_14;
    activityLabel.textColor = WHITE_CLOCLOR;
    activityLabel.text = @"活动";
    activityLabel.textAlignment = NSTextAlignmentCenter;
    [toolView addSubview:activityLabel];
    
    clubstarsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clubstarsButton.frame = CGRectMake(7*SCREEN_WIDTH/8 - 23.5, 13, 47, 47);
    [clubstarsButton setImage:[UIImage imageNamed:@"club_stars"] forState:UIControlStateNormal];
    [clubstarsButton addTarget:self action:@selector(clubStarsClick) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:clubstarsButton];
    
    UILabel *starsLabel = [[UILabel alloc] initWithFrame:CGRectMake(7*SCREEN_WIDTH/8 - 23.5, 66, 47, 16)];
    starsLabel.font = SMALLFONT_14;
    starsLabel.textColor = WHITE_CLOCLOR;
    starsLabel.text = @"明星";
    starsLabel.textAlignment = NSTextAlignmentCenter;
    [toolView addSubview:starsLabel];
    
    discussionTableView.tableHeaderView = headerView;
    
}
- (void)joinClick{
    ClubInformationViewController *controller = [[ClubInformationViewController alloc] init];
    controller.clubID = self.clubId;
    controller.usertype = clubuserType;
    controller.isJoin = isJoinString;
    controller.applyState = apply_state;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)refreshClubDetail{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:self.clubId forKey:@"clubid"];
    if ([typeString isEqualToString:@"1"]) {
        [dic setObject:@"1" forKey:@"type"];
    }
    else{
        [dic setObject:@"2" forKey:@"type"];
    }
    [ClubRequest clubDetailWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"获取成功");
            clubDetailDic = [[response objectForKey:@"data"] objectForKey:@"club"];
            clubOwnerDic = [[response objectForKey:@"data"] objectForKey:@"clubuser"];
            clubDiscussionArray = [[response objectForKey:@"data"] objectForKey:@"clubposts"];
            isJoinString = [[response objectForKey:@"data"] objectForKey:@"flag"];
            clubuserType = [[response objectForKey:@"data"] objectForKey:@"clubusertype"];
            age = [[response objectForKey:@"data"] objectForKey:@"age"];
            dayFlag = [[response objectForKey:@"data"] objectForKey:@"day_flag"];
            signDays = [[response objectForKey:@"data"] objectForKey:@"day"];
            gagString = [[response objectForKey:@"data"] objectForKey:@"gag"];
            apply_state = [[response objectForKey:@"data"] objectForKey:@"type"];
            [self setupHeaderView];
            
            limitString = [response objectForKey:@"limit"];
            totalString = [response objectForKey:@"total"];
            createDiscussionButton.hidden = NO;
            
            
            if ([limitString integerValue] >= [totalString integerValue]) {
                showMore = YES;
            }
            else{
                showMore = NO;
            }
            //[self setupDetailView];
        }
        else{
            NSLog(@"获取失败");
            showMore = YES;
        }
        [self doneLoadingTableViewData];
        isGetData = NO;
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
        showMore = YES;
        [self doneLoadingTableViewData];
        isGetData = NO;
    }];
}
- (void)moreClubDetail{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:self.clubId forKey:@"clubid"];
    //NSDictionary *tempDic = [clubDiscussionArray lastObject];
    [dic setObject:limitString forKey:@"limit"];
    if ([typeString isEqualToString:@"1"]) {
        [dic setObject:@"1" forKey:@"type"];
    }
    else{
        [dic setObject:@"2" forKey:@"type"];
    }
    [ClubRequest clubDetailWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"获取成功");
            clubDetailDic = [[response objectForKey:@"data"] objectForKey:@"club"];
            limitString = [response objectForKey:@"limit"];
            totalString = [response objectForKey:@"total"];
            NSMutableArray *moreArray = [[NSMutableArray alloc] init];
            [moreArray addObjectsFromArray:clubDiscussionArray];
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            tempArray = [[response objectForKey:@"data"] objectForKey:@"clubposts"];
            for(int i = 0; i < tempArray.count; i++){
                NSDictionary *tempDic = [tempArray objectAtIndex:i];
                if ([Util isEmpty:[tempDic objectForKey:@"discussoverhead"]]) {
                    [moreArray addObject:tempDic];
                }
            }
            clubDiscussionArray = moreArray;
            if ([limitString integerValue] >= [totalString integerValue]) {
                showMore = YES;
            }
            else{
                showMore = NO;
            }
        }
        else{
            NSLog(@"获取失败");
            showMore = YES;
        }
        [discussionTableView reloadData];
        isGetData = NO;
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
        showMore = YES;
        [discussionTableView reloadData];
        isGetData = NO;
    }];
}
- (void)refreshClubCream{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:self.clubId forKey:@"clubid"];
    [dic setObject:@"1" forKey:@"type"];
    [ClubRequest clubCreamListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            clubCreamArray = [response objectForKey:@"data"];
            limitString = [response objectForKey:@"limit"];
            totalString = [response objectForKey:@"total"];
            if ([limitString integerValue] >= [totalString integerValue]) {
                showMore = YES;
            }
            else{
                showMore = NO;
            }
        }
        else {
            NSLog(@"获取失败");
            showMore = YES;
        }
        [self doneLoadingTableViewData];
        isGetData = NO;
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
        showMore = YES;
        [self doneLoadingTableViewData];
        isGetData = NO;
    }];
}
- (void)moreClubCream {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:self.clubId forKey:@"clubid"];
    [dic setObject:@"1" forKey:@"type"];
    [dic setObject:limitString forKey:@"limit"];
    [ClubRequest clubCreamListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            [tempArray addObjectsFromArray:clubCreamArray];
            [tempArray addObjectsFromArray:[response objectForKey:@"data"]];
            clubCreamArray = tempArray;
            limitString = [response objectForKey:@"limit"];
            totalString = [response objectForKey:@"total"];
            if ([limitString integerValue] >= [totalString integerValue]) {
                showMore = YES;
            }
            else{
                showMore = NO;
            }
        }
        else {
            NSLog(@"获取失败");
            showMore = YES;
        }
        [discussionTableView reloadData];
        isGetData = NO;
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
        showMore = YES;
        [discussionTableView reloadData];
        isGetData = NO;
    }];

}

//发帖子或者删帖子成功
- (void)writeClubDiscussionSuccess{
    [self refreshClubDetail];
}

//签到
- (void)signClick{
    [signButton setImage:[UIImage imageNamed:@"club_signed"] forState:UIControlStateNormal];
    signDaysLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 25, 36)];
    signDaysLabel.font = SMALLFONT_14;
    signDaysLabel.textColor = MAIN_COLOR_YELLOW;
    signDaysLabel.text = [NSString stringWithFormat:@"%ld", [signDays integerValue] + 1];
    signDaysLabel.textAlignment = NSTextAlignmentCenter;
    [signButton addSubview:signDaysLabel];

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", self.clubId, @"clubid", nil];
    [ClubRequest clubSignWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            [self.delegate signSuccess];
        }
    } failure:^(NSError *error) {
    }];
    
}

//点击训练营
- (void)clubCampClick{
    ClubTrainingCampViewController *controller = [[ClubTrainingCampViewController alloc] init];
    controller.club_id = self.clubId;
    controller.titleString = self.clubNameString;
    [self.navigationController pushViewController:controller animated:YES];
}
//点击课程表
- (void)clubCurriculumClick{
    ClubCurriculumViewController *controller = [[ClubCurriculumViewController alloc] init];
    controller.club_id = self.clubId;
    controller.user_type = clubuserType;
    [self.navigationController pushViewController:controller animated:YES];
}
//点击活动
- (void)clubActivityClick{
    ClubActivityViewController *controller = [[ClubActivityViewController alloc] init];
    controller.club_id = self.clubId;
    controller.usertype = clubuserType;
    [self.navigationController pushViewController:controller animated:YES];
}
//点击明星
- (void)clubStarsClick{
    ClubStarsViewController *controller = [[ClubStarsViewController alloc] init];
    controller.club_id = self.clubId;
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([typeString integerValue] == 3) {
        return clubCreamArray.count + 1;
    }
    else {
        return clubDiscussionArray.count + 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *LastCell = @"LastCell";
    if ([typeString integerValue] == 3) {
        if (indexPath.row < clubCreamArray.count) {
            static NSString *identifier = @"CreamCell";
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSDictionary *tempDic = [clubCreamArray objectAtIndex:indexPath.row];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.backgroundColor = CLEAR_COLOR;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 60)];
            titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
            titleLabel.numberOfLines = 2;
            titleLabel.textColor = WHITE_CLOCLOR;
            titleLabel.font = SMALLFONT_16;
            titleLabel.text = [tempDic objectForKey:@"title"];
            [cell addSubview:titleLabel];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 59.5, SCREEN_WIDTH - 10, 0.5)];
            line.backgroundColor = LINE_COLOR_GARG;
            [cell addSubview:line];
            return cell;
        }
        else {
            LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
            if (cell == nil) {
                cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = [UIColor clearColor];
            if (showMore) {
                cell.label.text = @"没有更多喽~";
                [cell.indicatorView stopAnimating];
            }
            else{
                cell.label.text = @"加载中...";
                [cell.indicatorView startAnimating];
                if (!isGetData) {
                    [self moreClubCream];
                    
                }
            }
            return cell;
        }
    }
    else {
        if (indexPath.row < clubDiscussionArray.count) {
            static NSString *cellIdentifier = @"Cell";
            NSDictionary *tempdic = [clubDiscussionArray objectAtIndex:indexPath.row];
            discussionCell = [[ClubDiscussionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withDic:tempdic];
            discussionCell.backgroundColor = CLEAR_COLOR;
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 59.5, SCREEN_WIDTH - 10, 0.5)];
            line.backgroundColor = LINE_COLOR_GARG;
            [discussionCell addSubview:line];
            
            return discussionCell;
        }
        else {
            LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
            if (cell == nil) {
                cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = [UIColor clearColor];
            cell.label.textColor = TIME_COLOR_GARG;
            if (showMore) {
                cell.label.text = @"没有更多帖子喽~";
                [cell.indicatorView stopAnimating];
            }
            else{
                cell.label.text = @"加载中...";
                [cell.indicatorView startAnimating];
                if (!isGetData) {
                    [self moreClubDetail];
                    
                }
            }
            return cell;
        }
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([typeString integerValue] == 3) {
        if (indexPath.row < clubCreamArray.count) {
            NSDictionary *tempDic = [clubCreamArray objectAtIndex:indexPath.row];
            ActivityWebViewController *controller = [[ActivityWebViewController alloc] init];
            controller.urlString = [tempDic objectForKey:@"url"];
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }
    else{
        if (indexPath.row < clubDiscussionArray.count) {
            NSDictionary *tempDic = [clubDiscussionArray objectAtIndex:indexPath.row];
            ClubDiscussionDetailViewController *discussionDetailController = [[ClubDiscussionDetailViewController alloc] init];
            discussionDetailController.discussionId = [tempDic objectForKey:@"id"];
            discussionDetailController.clubUSerType = clubuserType;
            [self.navigationController pushViewController:discussionDetailController animated:YES];
        }
    }
    
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [headerView setBackgroundColor:CLEAR_COLOR];
    [headerView addSubview:recentButton];
    [headerView addSubview:hottestButton];
    [headerView addSubview:creamButton];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6 - 22, 40, 44, 3)];
    if ([typeString integerValue] == 1){
        label.frame = CGRectMake(SCREEN_WIDTH/6 - 22, 40, 44, 3);
    }
    else if ([typeString integerValue] == 2) {
        label.frame = CGRectMake(SCREEN_WIDTH/2 - 22, 40, 44, 3);
    }
    else {
        label.frame = CGRectMake(SCREEN_WIDTH/6 * 5 - 22, 40, 44, 3);
    }
    label.backgroundColor = MAIN_COLOR_YELLOW;
    [headerView addSubview:label];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 42.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = LINE_COLOR_GARG;
    [headerView addSubview:line];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (void)recentClick{
    typeString = @"1";
    [recentButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    [hottestButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [creamButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    label.frame = CGRectMake(SCREEN_WIDTH/6 - 22, 40, 44, 3);
    [self refreshClubDetail];
}
- (void)hottestClick{
    typeString = @"2";
    [recentButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [hottestButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    [creamButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    label.frame = CGRectMake(SCREEN_WIDTH/2 - 22, 40, 44, 3);
    [self refreshClubDetail];
}
- (void)creamClick{
    typeString = @"3";
    [recentButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [hottestButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [creamButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    label.frame = CGRectMake(SCREEN_WIDTH/6 *5 - 22, 40, 44, 3);
    [self refreshClubCream];
    
}
- (void)createDiscussionClick{
    if ([isJoinString integerValue] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没加入这个俱乐部哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        if ([gagString integerValue] == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你已经被禁言了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            WriteClubDiscussionViewController *writeController = [[WriteClubDiscussionViewController alloc] init];
            writeController.clubId = self.clubId;
            writeController.clubOwnerId = [clubOwnerDic objectForKey:@"id"];
            writeController.clubUserType = clubuserType;
            [self.navigationController pushViewController:writeController animated:YES];}
    }
}

- (void)clubDetailClick{
    ClubInformationViewController *controller = [[ClubInformationViewController alloc] init];
    controller.clubID = self.clubId;
    controller.usertype = clubuserType;
    controller.isJoin = isJoinString;
    controller.applyState = apply_state;
    controller.introUrl = [clubDetailDic objectForKey:@"url"];
    [self.navigationController pushViewController:controller animated:YES];
}



#pragma mark - ClubDetailView Delegate
- (void)clickManager:(NSString*)userid{
    [self jumpPersonController:userid];
}
- (void)clickMemberNumber{
    ClubMemberViewController *memberController = [[ClubMemberViewController alloc] init];
    memberController.clubID = self.clubId;
    //memberController.clubUserTyPe = clubuserType;
    [self.navigationController pushViewController:memberController animated:YES];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - EGORefreshTableHeaderDelegate
- (void)reloadTableViewDataSource{
    _reloading = YES;
    if ([typeString integerValue] == 3) {
        [self refreshClubCream];
    }
    else {
        [self refreshClubDetail];
    }
    
}

- (void)doneLoadingTableViewData{
    _reloading = NO;
    [discussionTableView reloadData];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:discussionTableView];
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading;
    
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
}

//转到个人主页
- (void)jumpPersonController:(NSString*)friendid{
    if ([friendid intValue] == [userInfo.userid intValue]) {
        OwnInfoViewController *ownInfoController = [[OwnInfoViewController alloc]init];
        ownInfoController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ownInfoController animated:YES];
    }else{
        PersonalViewController *personController = [[PersonalViewController alloc]init];
        personController.personID = friendid;
        personController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personController animated:YES];
    }
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
