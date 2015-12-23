//
//  ShowHomeViewController.m
//  Health
//
//  Created by realtech on 15/4/23.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ShowHomeViewController.h"
#import "TrendsTableViewCell.h"
#import "TrendDetailViewController.h"
#import "TrendLikeMemberViewController.h"
#import "ClockinTableViewCell.h"
#import "ClockinDetailViewController.h"
#import "ClubDetailViewController.h"
#import "RecommendUsersTableViewCell.h"
#import "RecommendPhotosTableViewCell.h"
#import "RecommendUsersViewController.h"
#import "FocusImageViewController.h"

@interface ShowHomeViewController ()<EGORefreshTableHeaderDelegate, TrendsTableViewCellDelegate, UIActionSheetDelegate, UIScrollViewDelegate, ClockinCellDelete, UIGestureRecognizerDelegate>{
    AppDelegate *appDelegate;
    UserInfo *userInfo;
    
    NSInteger currentIndex;
    
    EGORefreshTableHeaderView *_refreshRecent;
    EGORefreshTableHeaderView *_refreshRecommend;
    EGORefreshTableHeaderView *_refreshClockin;
    
    NSString *trendId;
    
    NSString *recentLimit;
    NSString *recentTotal;
    NSString *recommendLimit;
    NSString *recommendTotal;
    NSString *clockinLimit;
    NSString *clockinTotal;
    
    NSMutableArray *arrayOfTrends;
    NSMutableArray *arrayOfClockin;
    NSMutableArray *arrayOfUsers;
    NSMutableArray *arrayOfRecommend;
    NSMutableArray *arrayOfFocusImage;
    TrendsTableViewCell *trendCell;
    ClockinTableViewCell *clockinCell;
    UILabel *selectedLabel;
    
    BOOL _showMoreTrends;
    BOOL _moreLoadTrends;
    BOOL _showMoreClockin;
    BOOL _moreLoadClockin;
    BOOL _showMoreRecommend;
    BOOL _moreLoadRecommend;
    
    UIView *bigImageView;
    UIScrollView *topScroll;
    UIPageControl *page;
}
@property (assign, nonatomic) CGPoint lastPoint;
@end

@implementation ShowHomeViewController
@synthesize recentButton, recommendButton, clockinButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _showMoreTrends = NO;
    _moreLoadTrends = YES;
    _showMoreClockin = NO;
    _moreLoadClockin = YES;
    _showMoreRecommend = NO;
    _moreLoadRecommend = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendShowSuccess) name:@"sendshowsuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendShowSuccess) name:@"deletetrendsuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clockinSuccess) name:@"clockinsuccess" object:nil];
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"坊区"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    arrayOfTrends = [[NSMutableArray alloc] init];
    arrayOfClockin = [[NSMutableArray alloc] init];
    arrayOfUsers = [[NSMutableArray alloc] init];
    arrayOfRecommend = [[NSMutableArray alloc] init];
    
    [self addHeaderView];
    [self addViewForTable];
    [self getFocusImage];
    [self refreshRecentTrends];
    [self getRecommendUsers];
    [self refreshRecommendPhotos];
    [self refreshClockinList];
    
    UIPanGestureRecognizer *recentPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlerPanGestureRecognizer:)];
    recentPanGR.delegate = self;
    [recentTableView addGestureRecognizer:recentPanGR];
    UIPanGestureRecognizer *recommendPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlerPanGestureRecognizer:)];
    recommendPanGR.delegate = self;
    [recommendTableView addGestureRecognizer:recommendPanGR];
    UIPanGestureRecognizer *clockinPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlerPanGestureRecognizer:)];
    clockinPanGR.delegate = self;
    [clockinTableView addGestureRecognizer:clockinPanGR];
}

- (void)handlerPanGestureRecognizer:(UIPanGestureRecognizer *)panGR {
    UIView *containerView = [panGR.view superview];
    if (panGR.state == UIGestureRecognizerStateEnded) {
        _lastPoint = CGPointZero;
        if (CGRectGetMinX(containerView.frame) >= 0 || CGRectGetMinX(containerView.frame) <= -1 * SCREEN_WIDTH * 2) {
            return;
        }
        CGPoint velocity = [panGR velocityInView:self.view];
        [UIView animateWithDuration:.1
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             containerView.frame = CGRectOffset(containerView.frame, velocity.x / 20, 0);
                         } completion:^(BOOL finished) {
                             CGFloat pageIndex = (-1 * CGRectGetMinX(containerView.frame) / SCREEN_WIDTH);
                             if (pageIndex < 0.5) {
                                 [self recommendClick];
                             } else if (pageIndex < 1.5) {
                                 [self recentClick];
                             } else {
                                 [self clockinClick];
                             }
                         }];
        return;
    }
    
    CGPoint point = [panGR locationInView:self.view];
    if (panGR.state == UIGestureRecognizerStateBegan) {
        _lastPoint = point;
        return;
        
    }
    
    NSInteger changeX = point.x - _lastPoint.x;
    CGRect newFrame = CGRectOffset(containerView.frame, changeX, 0);
    if (CGRectGetMinX(newFrame) > 0) {
        newFrame.origin.x = 0;
    } else if (CGRectGetMinX(newFrame) < -1 * SCREEN_WIDTH * 2) {
        newFrame.origin.x = -1 * SCREEN_WIDTH * 2;
    }
    containerView.frame = newFrame;
    
    _lastPoint = point;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.view];
    if (fabs(translation.x) > fabs(translation.y)) {
        return YES;
    }
    
    return NO;
}


- (void)addHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 43)];
    headerView.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    recentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recentButton.frame = CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 43);
    [recentButton setTitle:@"最新" forState:UIControlStateNormal];
    [recentButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    recentButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [recentButton addTarget:self action:@selector(recentClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:recentButton];
    
    recommendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recommendButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 43);
    [recommendButton setTitle:@"推荐" forState:UIControlStateNormal];
    [recommendButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    recommendButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [recommendButton addTarget:self action:@selector(recommendClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:recommendButton];
    
    clockinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clockinButton.frame = CGRectMake(2*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 43);
    [clockinButton setTitle:@"打卡" forState:UIControlStateNormal];
    [clockinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clockinButton addTarget:self action:@selector(clockinClick) forControlEvents:UIControlEventTouchUpInside];
    clockinButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:clockinButton];
    
    selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6 - 22, headerView.frame.size.height - 3, 44, 3)];
    selectedLabel.backgroundColor = MAIN_COLOR_YELLOW;
    [headerView addSubview:selectedLabel];
    
    [self.view addSubview:headerView];
    
    currentIndex = 0;
    
}
- (void)addViewForTable{
    viewForTable = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT + 43, SCREEN_WIDTH*3, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 43 - TABBAR_HEIGHT)];
    viewForTable.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    [self.view addSubview:viewForTable];
    
    recentTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, viewForTable.frame.size.height)];
    recentTableView.delegate = self;
    recentTableView.dataSource = self;
    recentTableView.backgroundColor = [UIColor clearColor];
    recentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    recentTableView.showsVerticalScrollIndicator= NO;
    [viewForTable addSubview:recentTableView];
    
    if (_refreshRecent == nil) {
        _refreshRecent = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - recentTableView.bounds.size.height, recentTableView.frame.size.width, recentTableView.bounds.size.height)];
        _refreshRecent.delegate = self;
        _refreshRecent.backgroundColor = [UIColor clearColor];
        [recentTableView addSubview:_refreshRecent];
    }
    [_refreshRecent refreshLastUpdatedDate];
    
    recommendTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, viewForTable.frame.size.height)];
    recommendTableView.delegate = self;
    recommendTableView.dataSource = self;
    recommendTableView.backgroundColor = [UIColor clearColor];
    recommendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    recommendTableView.showsVerticalScrollIndicator = NO;
    [viewForTable addSubview:recommendTableView];
    if (_refreshRecommend == nil) {
        _refreshRecommend = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - recommendTableView.bounds.size.height, recommendTableView.frame.size.width, recommendTableView.bounds.size.height)];
        _refreshRecommend.delegate = self;
        _refreshRecommend.backgroundColor = CLEAR_COLOR;
        [recommendTableView addSubview:_refreshRecommend];
    }
    [_refreshRecommend refreshLastUpdatedDate];
    
    clockinTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, viewForTable.frame.size.height)];
    clockinTableView.delegate = self;
    clockinTableView.dataSource = self;
    clockinTableView.backgroundColor = [UIColor clearColor];
    clockinTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    clockinTableView.showsVerticalScrollIndicator = NO;
    [viewForTable addSubview:clockinTableView];
    if (_refreshClockin == nil) {
        _refreshClockin = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - clockinTableView.bounds.size.height, clockinTableView.frame.size.width, clockinTableView.bounds.size.height)];
        _refreshClockin.delegate =self;
        _refreshClockin.backgroundColor =[UIColor clearColor];
        [clockinTableView addSubview:_refreshClockin];
    }
    [_refreshClockin refreshLastUpdatedDate];
    
    
}
- (void)setupTopScroll {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
    topView.backgroundColor = CLEAR_COLOR;
    topScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
    topScroll.pagingEnabled = YES;
    topScroll.bounces = NO;
    topScroll.showsHorizontalScrollIndicator = NO;
    topScroll.delegate = self;
    for (int i = 0; i < arrayOfFocusImage.count; i ++) {
        UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(i*topScroll.frame.size.width, 0, topScroll.frame.size.width, topScroll.frame.size.height)];
        imgview.contentMode=UIViewContentModeScaleAspectFill;
        imgview.clipsToBounds=YES;
        imgview.tag = i;
        imgview.userInteractionEnabled = YES;
        [imgview sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:[[arrayOfFocusImage objectAtIndex:i] objectForKey:@"title"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
        [topScroll addSubview:imgview];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusImagePress:)];
        [imgview addGestureRecognizer:tap];
    }
    topScroll.contentSize = CGSizeMake(arrayOfFocusImage.count * topScroll.frame.size.width, 0);
    [topView addSubview:topScroll];
    recommendTableView.tableHeaderView = topView;
    
    page = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, SCREEN_WIDTH/2 - 20, 95, 15)];
    page.numberOfPages = arrayOfFocusImage.count;
    page.currentPage = 0;
    [topView addSubview:page];
}

//焦点图
- (void)getFocusImage{
    arrayOfFocusImage = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", nil];
    [TrendRequest focusImageWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            arrayOfFocusImage = [response objectForKey:@"data"];
            if (![Util isEmpty:arrayOfFocusImage]) {
                [self setupTopScroll];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

//最新动态
- (void)refreshRecentTrends{
    for(Trend *removeTrend in userInfo.alltrends){
        [removeTrend MR_deleteEntity];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [userInfo.alltrendsSet removeAllObjects];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:@"1" forKey:@"sign"];
    [TrendRequest getTrendsListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"获取最新动态成功");
            [arrayOfTrends removeAllObjects];
            [arrayOfTrends addObjectsFromArray:[userInfo.alltrends allObjects]];
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"trendtime" ascending:NO];
            [arrayOfTrends sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
            recentLimit = [response objectForKey:@"limit"];
            recentTotal = [response objectForKey:@"total"];
            if ([recentLimit integerValue] >= [recentTotal integerValue]) {
                _showMoreTrends = YES;
            }
            else{
                _showMoreTrends = NO;
            }
        }
        else{
            NSLog(@"获取最新动态失败");
            _showMoreTrends = YES;
        }
        [self doneLoadingTableViewData];
        _moreLoadTrends = NO;
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
        [self doneLoadingTableViewData];
    }];
}
- (void)moreRecentTrends{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:recentLimit forKey:@"limit"];
    [dic setObject:@"1" forKey:@"sign"];
    [TrendRequest getTrendsListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"获取最新动态成功");
            [arrayOfTrends removeAllObjects];
            [arrayOfTrends addObjectsFromArray:[userInfo.alltrends allObjects]];
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"trendtime" ascending:NO];
            [arrayOfTrends sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
            recentLimit = [response objectForKey:@"limit"];
            recentTotal = [response objectForKey:@"total"];
            if ([recentLimit integerValue] >= [recentTotal integerValue]) {
                _showMoreTrends = YES;
            }
            else{
                _showMoreTrends = NO;
            }
        }
        else{
            NSLog(@"加载失败");
            _showMoreTrends = YES;
        }
        [recentTableView reloadData];
        _moreLoadTrends = NO;
        
    } failure:^(NSError *error) {
        [recentTableView reloadData];
        NSLog(@"加载失败");
    }];
}
- (void)getRecommendUsers {
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", nil];
    [TrendRequest recommendUsersWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            arrayOfUsers = [response objectForKey:@"data"];
            [recommendTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)refreshRecommendPhotos{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [TrendRequest recommendPhotosListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            [arrayOfRecommend removeAllObjects];
            [arrayOfRecommend addObjectsFromArray:[response objectForKey:@"data"]];
            recommendLimit = [response objectForKey:@"limit"];
            recommendTotal = [response objectForKey:@"total"];
            if ([recommendLimit integerValue] >= [recommendTotal integerValue]) {
                _showMoreRecommend = YES;
            }
            else {
                _showMoreRecommend = NO;
            }
        }
        else {
            _showMoreRecommend = YES;
        }
        [self doneLoadingTableViewData];
        _moreLoadRecommend = NO;
        
    } failure:^(NSError *error) {
        [self doneLoadingTableViewData];
    }];
}
- (void)moreRecommendPhotos{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:recommendLimit forKey:@"limit"];
    [TrendRequest recommendPhotosListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            [tempArr addObjectsFromArray:arrayOfRecommend];
            [tempArr addObjectsFromArray:[response objectForKey:@"data"]];
            arrayOfRecommend  = tempArr;
            recommendLimit = [response objectForKey:@"limit"];
            recommendTotal = [response objectForKey:@"total"];
            if ([recommendLimit integerValue] >= [recommendTotal integerValue]) {
                _showMoreRecommend = YES;
            }
            else {
                _showMoreRecommend = NO;
            }
        }
        else {
            _showMoreRecommend = YES;
        }
        [recommendTableView reloadData];
        _moreLoadRecommend = NO;
        
    } failure:^(NSError *error) {
        [recommendTableView reloadData];
    }];

    
}
- (void)refreshClockinList{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", nil];
    [TrendRequest clockinListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            [arrayOfClockin removeAllObjects];
            [arrayOfClockin addObjectsFromArray:[response objectForKey:@"data"]];
            clockinLimit = [response objectForKey:@"limit"];
            clockinTotal = [response objectForKey:@"total"];
            
            if ([clockinLimit integerValue] >= [clockinTotal integerValue]) {
                _showMoreClockin = YES;
            }
            else{
                _showMoreClockin = NO;
            }
            
        }
        else {
            _showMoreClockin = YES;
        }
        [self doneLoadingTableViewData];
        _moreLoadClockin = NO;
        
    } failure:^(NSError *error) {
        [self doneLoadingTableViewData];
    }];
}
- (void)moreClickinList{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", clockinLimit, @"limit", nil];
    [TrendRequest clockinListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            [tempArray addObjectsFromArray:arrayOfClockin];
            [tempArray addObjectsFromArray:[response objectForKey:@"data"]];
            arrayOfClockin = tempArray;
            clockinLimit = [response objectForKey:@"limit"];
            clockinTotal = [response objectForKey:@"total"];
            
            if ([clockinLimit integerValue] >= [clockinTotal integerValue]) {
                _showMoreClockin = YES;
            }
            else{
                _showMoreClockin = NO;
            }
            
        }
        else {
            _showMoreClockin = YES;
        }
        [clockinTableView reloadData];
        _moreLoadClockin = NO;
        
    } failure:^(NSError *error) {
        [clockinTableView reloadData];
    }];
}
- (void)recentClick{
    currentIndex = 1;
    [recentButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    [recommendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clockinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        viewForTable.frame = CGRectMake(0 - SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 43, SCREEN_WIDTH*3, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 43 - TABBAR_HEIGHT);
        selectedLabel.frame = CGRectMake(SCREEN_WIDTH/2 - 22, 40, 44, 3);
        
    }];
    [self doneLoadingTableViewData];
}
- (void)recommendClick{
    currentIndex = 0;
    [recommendButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    [recentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clockinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        viewForTable.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT + 43, SCREEN_WIDTH*3, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 43 - TABBAR_HEIGHT);
        selectedLabel.frame = CGRectMake(SCREEN_WIDTH/6 - 22, 40, 44, 3);
    }];
    [self doneLoadingTableViewData];
}
- (void)clockinClick{
    currentIndex =2;
    [clockinButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    [recentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [recommendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        viewForTable.frame = CGRectMake(0 - 2*SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 43, SCREEN_WIDTH*3, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 43 - TABBAR_HEIGHT);
        selectedLabel.frame = CGRectMake(5*SCREEN_WIDTH/6 - 22, 40, 44, 3);
    }];
    [self doneLoadingTableViewData];
}

- (void)sendShowSuccess{
    [recentTableView setContentOffset:CGPointMake(0,-70) animated:YES];
}
- (void)clockinSuccess{
    [clockinTableView setContentOffset:CGPointMake(0,-70) animated:YES];
}

/*
 点击焦点图
 */
- (void)focusImagePress:(UITapGestureRecognizer*)gesture{
    UIImageView *image = (UIImageView*)gesture.view;
    NSDictionary *tempDic = [arrayOfFocusImage objectAtIndex:image.tag];
    FocusImageViewController *controller = [[FocusImageViewController alloc] init];
    controller.url = [tempDic objectForKey:@"url"];
    controller.type = [NSString stringWithFormat:@"%@", [tempDic objectForKey:@"type"]];
    [appDelegate.rootNavigationController pushViewController:controller animated:YES];
}

#pragma mark - TrendsTableViewCellDelegate
- (void)clickCommentsList:(NSString *)trendid{
    TrendDetailViewController *detailController = [[TrendDetailViewController alloc] init];
    detailController.isCommentsShow = YES;
    detailController.trendid = trendid;
    detailController.hidesBottomBarWhenPushed = YES;
    [appDelegate.rootNavigationController pushViewController:detailController animated:YES];
}
- (void)clickLikeMember:(NSString *)trendid{
    TrendLikeMemberViewController *likeController = [[TrendLikeMemberViewController alloc] init];
    likeController.hidesBottomBarWhenPushed = YES;
    likeController.trendID = trendid;
    [appDelegate.rootNavigationController pushViewController:likeController animated:YES];
}

- (void)clickcomment:(NSString *)trendid{
    TrendDetailViewController *detailController = [[TrendDetailViewController alloc] init];
    detailController.isCommentIn = YES;
    detailController.hidesBottomBarWhenPushed = YES;
    detailController.trendid = trendid;
    [appDelegate.rootNavigationController pushViewController:detailController animated:YES];
}
- (void)clickDelete:(NSString *)trendid{
    trendId = trendid;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alert.tag = 0;
    [alert show];
}
- (void)clickHead:(NSString *)userid{
    [self jumpPersonController:userid];
}
- (void)clickLike:(NSString *)trendid{
}
- (void)clickNickname:(NSString *)userid{
    [self jumpPersonController:userid];
}
- (void)clickReport:(NSString *)trendid{
    trendId = trendid;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"投诉不良信息" otherButtonTitles:nil, nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", trendId, @"complaintstargetid", @"show", @"type", nil];
        [TrendRequest reportWith:dic success:^(id response) {
            if ([[response objectForKey:@"state"] integerValue] == 1000) {
                NSLog(@"投诉成功");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"投诉成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else{
                NSLog(@"投诉失败");
            }
        } failure:^(NSError *error) {
            NSLog(@"网络问题");
        }];
    }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            NSDictionary *deleteDic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", trendId, @"trendid", nil];
            [TrendRequest deleteTrendWith:deleteDic success:^(id response) {
                if ([[response objectForKey:@"state"] integerValue] == 1000) {
                    NSLog(@"删除动态成功");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDelete" object:@YES];
                    [self refreshRecentTrends];
                }
                else{
                    NSLog(@"删除动态失败");
                    //[JDStatusBarNotification showWithStatus:@"删除失败" dismissAfter:1.4];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            } failure:^(NSError *error) {
                //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.4];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }];
        }
    }
    else {
        if (buttonIndex == 1) {
            NSDictionary *deleteDic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", trendId, @"trendid", nil];
            [TrendRequest deleteTrendWith:deleteDic success:^(id response) {
                if ([[response objectForKey:@"state"] integerValue] == 1000) {
                    NSLog(@"删除打卡成功");
                    [self refreshClockinList];
                }
                else{
                    NSLog(@"删除打卡失败");
                    //[JDStatusBarNotification showWithStatus:@"删除失败" dismissAfter:1.4];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            } failure:^(NSError *error) {
                //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.4];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }];
        }
    }
    
}


#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (currentIndex == 0) {
        return 2;
    }
    else {
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (currentIndex == 1) {
        return arrayOfTrends.count + 1;
    }
    else if(currentIndex == 0){
        if (section == 0) {
            return arrayOfUsers.count;
        }
        else {
            return (arrayOfRecommend.count + 2)/3 + 1;
        }
    }
    else{
        return arrayOfClockin.count + 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (currentIndex == 1) {
        if (indexPath.row == arrayOfTrends.count) {
            return 48;
        }
        else{
            trendCell = (TrendsTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return trendCell.iHeight;
        }
    }else if(currentIndex == 0){
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return 52 + (SCREEN_WIDTH - 36)/3;
            }
            else {
                return 114 + (SCREEN_WIDTH - 36)/3;
            }
        }
        else{
            if (indexPath.row == (arrayOfRecommend.count + 2)/3) {
                return 48;
            }
            return 6 + (SCREEN_WIDTH - 36)/3;
        }
    }
    else{
        if (indexPath.row == arrayOfClockin.count) {
            return 48;
        }
        else{
            clockinCell = (ClockinTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return clockinCell.height;
        }
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TrendCell = @"TrendCell";
    static NSString *LastCell = @"LastCell";
    static NSString *ClockinCell = @"ClockinCell";
    if (currentIndex == 1) {
        if (indexPath.row >= arrayOfTrends.count) {
            LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
            if (cell == nil) {
                cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = [UIColor clearColor];
            if (_showMoreTrends) {
                cell.label.text = @"没有更多动态喽~";
                [cell.indicatorView stopAnimating];
            }
            else {
                cell.label.text = @"加载中...";
                [cell.indicatorView startAnimating];
                if (!_moreLoadTrends) {
                    [self moreRecentTrends];
                  
                }
            }
            return cell;
        }
        Trend *trend = [arrayOfTrends objectAtIndex:indexPath.row];
        trendCell = [[TrendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TrendCell withData:trend];
        trendCell.delegate = self;
        //trendCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [trendCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return trendCell;
        
    }
    else if (currentIndex == 2){
        if (indexPath.row >= arrayOfClockin.count) {
            LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
            if (cell == nil) {
                cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.label.textColor = TIME_COLOR_GARG;
            cell.backgroundColor = [UIColor clearColor];
            if (_showMoreClockin) {
                cell.label.text = @"没有更多喽~";
                [cell.indicatorView stopAnimating];
            }
            else {
                cell.label.text = @"加载中...";
                [cell.indicatorView startAnimating];
                if (!_moreLoadClockin) {
                    [self moreClickinList];
                }
            }
            return cell;
        }
        NSDictionary *dic = [arrayOfClockin objectAtIndex:indexPath.row];
        clockinCell = [[ClockinTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ClockinCell withDic:dic];
        clockinCell.delegate = self;
        [clockinCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return clockinCell;
    }
    else {
        static NSString *userIdentifier = @"UserCell";
        static NSString *photoIdentifier = @"PhotoCell";
        if (indexPath.section == 0) {
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
            tempDic = [arrayOfUsers objectAtIndex:indexPath.row];
            //if (cell == nil) {
            RecommendUsersTableViewCell *cell = [[RecommendUsersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier withDic:tempDic];
            //}
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[[tempDic objectForKey:@"terminal"] objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
            cell.nicknameLabel.text = [[tempDic objectForKey:@"terminal"] objectForKey:@"nickname"];
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            arr = [tempDic objectForKey:@"trends"];
            [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:[[arr objectAtIndex:0] objectForKey:@"trendpicture"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
            [cell.centerImage sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:[[arr objectAtIndex:1] objectForKey:@"trendpicture"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
            [cell.rightImage sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:[[arr objectAtIndex:2] objectForKey:@"trendpicture"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
            [cell clickImage:^(NSInteger index) {
                if (index == 1) {
                    //点击左边图片
                    TrendDetailViewController *controller = [[TrendDetailViewController alloc] init];
                    controller.trendid = [[arr objectAtIndex:0] objectForKey:@"id"];
                    [appDelegate.rootNavigationController pushViewController:controller animated:YES];
                }
                else if (index == 2) {
                    TrendDetailViewController *controller = [[TrendDetailViewController alloc] init];
                    controller.trendid = [[arr objectAtIndex:1] objectForKey:@"id"];
                    [appDelegate.rootNavigationController pushViewController:controller animated:YES];
                }
                else {
                    TrendDetailViewController *controller = [[TrendDetailViewController alloc] init];
                    controller.trendid = [[arr objectAtIndex:2] objectForKey:@"id"];
                    [appDelegate.rootNavigationController pushViewController:controller animated:YES];
                }
            }];
            if (indexPath.row == 1) {
                UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, (SCREEN_WIDTH - 36)/3 + 52, SCREEN_WIDTH, 62)];
                footerView.backgroundColor = TABLEVIEWCELL_COLOR;
                
                UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 150, 50)];
                footerLabel.text = @"查看更多推荐用户";
                footerLabel.textColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:118/255.0 alpha:1.0];
                footerLabel.font = SMALLFONT_12;
                [footerView addSubview:footerLabel];
                
                UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 27, 17.5, 15, 15)];
                rightImage.image = [UIImage imageNamed:@"club_member_right"];
                [footerView addSubview:rightImage];
                
                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 12)];
                line.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
                [footerView addSubview:line];
                
                UIButton *moreUsersButton = [UIButton buttonWithType:UIButtonTypeCustom];
                moreUsersButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
                [moreUsersButton addTarget:self action:@selector(moreUserClick) forControlEvents:UIControlEventTouchUpInside];
                [footerView addSubview:moreUsersButton];
                [cell addSubview:footerView];
            }
            cell.backgroundColor = TABLEVIEWCELL_COLOR;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            if (indexPath.row < (arrayOfRecommend.count+ 2)/3) {
                RecommendPhotosTableViewCell *photoCell = [[RecommendPhotosTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:photoIdentifier];
                NSDictionary *leftDic = [arrayOfRecommend objectAtIndex:indexPath.row*3];
                NSDictionary *centerDic;
                NSDictionary *rightDic;
                [photoCell.leftPhoto sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:[leftDic objectForKey:@"trendpicture"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                if ((indexPath.row+ 1)*3 <= arrayOfRecommend.count) {
                    centerDic = [arrayOfRecommend objectAtIndex:indexPath.row*3 + 1];
                    [photoCell.centerPhoto sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:[centerDic objectForKey:@"trendpicture"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                    rightDic = [arrayOfRecommend objectAtIndex:indexPath.row*3 + 2];
                    [photoCell.rightPhoto sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:[rightDic objectForKey:@"trendpicture"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                }
                else {
                    if (arrayOfRecommend.count%3 == 0) {
                        centerDic = [arrayOfRecommend objectAtIndex:indexPath.row*3 + 1];
                        [photoCell.centerPhoto sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:[centerDic objectForKey:@"trendpicture"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                        rightDic = [arrayOfRecommend objectAtIndex:indexPath.row*3 + 2];
                        [photoCell.rightPhoto sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:[rightDic objectForKey:@"trendpicture"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                    }
                    else if (arrayOfRecommend.count % 3 == 2){
                        centerDic = [arrayOfRecommend objectAtIndex:indexPath.row*3 + 1];
                        [photoCell.centerPhoto sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:[centerDic objectForKey:@"trendpicture"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                        photoCell.rightPhoto.hidden = YES;
                    }
                    else {
                        photoCell.centerPhoto.hidden = YES;
                        photoCell.rightPhoto.hidden = YES;
                    }
                }
                [photoCell clickImage:^(NSInteger index) {
                    if (index == 1) {
                        TrendDetailViewController *controller = [[TrendDetailViewController alloc] init];
                        controller.trendid = [leftDic objectForKey:@"id"];
                        [appDelegate.rootNavigationController pushViewController:controller animated:YES];
                    }
                    else if (index == 2) {
                        TrendDetailViewController *controller = [[TrendDetailViewController alloc] init];
                        controller.trendid = [centerDic objectForKey:@"id"];
                        [appDelegate.rootNavigationController pushViewController:controller animated:YES];
                    }
                    else {
                        TrendDetailViewController *controller = [[TrendDetailViewController alloc] init];
                        controller.trendid = [rightDic objectForKey:@"id"];
                        [appDelegate.rootNavigationController pushViewController:controller animated:YES];
                    }
                }];
                photoCell.backgroundColor = TABLEVIEWCELL_COLOR;
                photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return photoCell;
                
            }
            else {
                LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
                if (cell == nil) {
                    cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.backgroundColor = [UIColor clearColor];
                if (_showMoreRecommend) {
                    cell.label.text = @"没有更多图片喽~";
                    [cell.indicatorView stopAnimating];
                }
                else {
                    cell.label.text = @"加载中...";
                    [cell.indicatorView startAnimating];
                    if (!_moreLoadRecommend) {
                        [self moreRecommendPhotos];
                    }
                }
                return cell;
            }
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (currentIndex == 1) {
        if(indexPath.row < arrayOfTrends.count){
            TrendDetailViewController *detailController = [[TrendDetailViewController alloc] init];
            Trend *trend = [arrayOfTrends objectAtIndex:indexPath.row];
            detailController.hidesBottomBarWhenPushed = YES;
            detailController.trendid = trend.trendid;
            [appDelegate.rootNavigationController pushViewController:detailController animated:YES];
        }
        
    }
    else if (currentIndex == 0){
        if (indexPath.section == 0) {
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
            tempDic = [arrayOfUsers objectAtIndex:indexPath.row];
            [self jumpPersonController:[[tempDic objectForKey:@"terminal"] objectForKey:@"userid"]];
        }
    }
    else{
        if (indexPath.row < arrayOfTrends.count) {
            ClockinDetailViewController *controller = [[ClockinDetailViewController alloc] init];
            NSDictionary *tempDic = [arrayOfClockin objectAtIndex:indexPath.row];
            controller.trendid = [tempDic objectForKey:@"id"];
            [appDelegate.rootNavigationController pushViewController:controller animated:YES];
        }
        
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (currentIndex == 0) {
        return 30;
    }
    else {
        return 0;
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headerView.backgroundColor = TABLEVIEWCELL_COLOR;
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, 150, 22)];
    headerLabel.textColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:118/255.0 alpha:1.0];
    if (section == 0) {
        headerLabel.text = @"推荐用户";
    }
    else {
        headerLabel.text = @"精选图片";
    }
    headerLabel.font = SMALLFONT_12;
    [headerView addSubview:headerLabel];
    return headerView;
}

/*
 查看更多推荐用户
 */
- (void)moreUserClick {
    RecommendUsersViewController *controller = [[RecommendUsersViewController alloc] init];
    [appDelegate.rootNavigationController pushViewController:controller animated:YES];
}

#pragma mark - ClockinCellDelegate
- (void)clickClockinUserHead:(NSString *)userid{
    [self jumpPersonController:userid];
}
- (void)clickClockinUserNickname:(NSString *)userid{
    [self jumpPersonController:userid];
}
- (void)clickClockinDelete:(NSString *)trendid{
    trendId = trendid;
    UIAlertView *clockinAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    clockinAlert.tag = 1;
    [clockinAlert show];
}
- (void)clickClockinReport:(NSString *)trendid{
    trendId = trendid;
    UIActionSheet *clockinActionSheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"投诉不良信息" otherButtonTitles:nil, nil];
    clockinActionSheet.tag = 1;
    [clockinActionSheet showInView:self.view];
}
- (void)clickClockinCourse:(NSString *)courseid withTitle:(NSString *)title{
    ClubDetailViewController *controller = [[ClubDetailViewController alloc] init];
    controller.clubId = courseid;
    controller.clubNameString = title;
    [appDelegate.rootNavigationController pushViewController:controller animated:YES];
}
- (void)clickClockinComment:(NSString *)trendid{
    ClockinDetailViewController *detailController = [[ClockinDetailViewController alloc] init];
    detailController.isCommentIn = YES;
    detailController.hidesBottomBarWhenPushed = YES;
    detailController.trendid = trendid;
    [appDelegate.rootNavigationController pushViewController:detailController animated:YES];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == topScroll) {
        page.currentPage = floor(scrollView.contentOffset.x / scrollView.frame.size.width);
    }
    else {
        if (currentIndex == 1) {
            [_refreshRecent egoRefreshScrollViewDidScroll:scrollView];
        }
        else if (currentIndex == 0){
            [_refreshRecommend egoRefreshScrollViewDidScroll:scrollView];
        }
        else{
            [_refreshClockin egoRefreshScrollViewDidScroll:scrollView];
        }
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

    if (currentIndex == 1) {
        [_refreshRecent egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else if (currentIndex == 0){
        [_refreshRecommend egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else {
        [_refreshClockin egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (currentIndex == 1) {
        [_refreshRecent egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else if (currentIndex == 0){
        [_refreshRecommend egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else{
        [_refreshClockin egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)reloadTableViewDataSource{
    _reloading = YES;
    if(currentIndex == 1){
        [self refreshRecentTrends];
    }
    else if(currentIndex == 0){
        [self getRecommendUsers];
        [self refreshRecommendPhotos];
    }
    else{
        [self refreshClockinList];
    }
    
}

- (void)doneLoadingTableViewData{
    _reloading = NO;
    if (currentIndex == 1) {
        [recentTableView reloadData];
        [_refreshRecent egoRefreshScrollViewDataSourceDidFinishedLoading:recentTableView];
    }
    else if (currentIndex == 0){
        [recommendTableView reloadData];
        [_refreshRecommend egoRefreshScrollViewDataSourceDidFinishedLoading:recommendTableView];
    }
    else {
        [clockinTableView reloadData];
        [_refreshClockin egoRefreshScrollViewDataSourceDidFinishedLoading:clockinTableView];
    }
    
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
        [appDelegate.rootNavigationController pushViewController:ownInfoController animated:YES];
    }else{
        PersonalViewController *personController = [[PersonalViewController alloc]init];
        personController.personID = friendid;
        personController.hidesBottomBarWhenPushed = YES;
        [appDelegate.rootNavigationController pushViewController:personController animated:YES];
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
