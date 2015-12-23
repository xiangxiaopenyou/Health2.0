//
//  CourseInteractionViewController.m
//  Health
//
//  Created by 项小盆友 on 15/1/28.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseInteractionViewController.h"
#import "CourseInteractionTableViewCell.h"
#import "WriteInteractionViewController.h"
#import "InteractionDetailViewController.h"
#import "CourseRequest.h"

@interface CourseInteractionViewController ()<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, UIScrollViewDelegate>{
    UITableView *interactionTableView;
    UIButton *writeButton;
    CourseInteractionTableViewCell *interactionCell;
    NSMutableArray *interactionArray;
    
    UserInfo *userInfo;
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    BOOL _reloading;
    BOOL showMore;
    BOOL isGetData;
    NSString *isJoinCourse;
    
    NSString *limitString;
    NSString *totalString;
}

@end

@implementation CourseInteractionViewController

@synthesize course;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_LABEL_X, TITLE_LABEL_Y, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"互动"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendSuccess) name:@"createinteractionsuccess" object:nil];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] init];
    leftButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = leftButtonItem;
    
    writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    writeButton.frame = CGRectMake(0, 0, 40, 40);
    [writeButton setImage:[UIImage imageNamed:@"interaction_wirte.png"] forState:UIControlStateNormal];
    [writeButton addTarget:self action:@selector(writeClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:writeButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backgroundView];
    
    
    showMore = NO;
    isGetData = YES;
    _reloading = NO;
    
    //tableview
    interactionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    interactionTableView.backgroundView = nil;
    interactionTableView.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:32/255.0 alpha:1.0];
    interactionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    interactionTableView.showsVerticalScrollIndicator = NO;
    interactionTableView.dataSource = self;
    interactionTableView.delegate = self;
    [self.view addSubview:interactionTableView];
    //[self setupHeaderView];
    
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - interactionTableView.bounds.size.height, interactionTableView.frame.size.width, interactionTableView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        [interactionTableView addSubview:_refreshHeaderView];
        
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    [self refreshInteractions];
    
}

//- (void)setupHeaderView{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
//    headerView.backgroundColor = [UIColor colorWithRed:22/255.0 green:22/255.0 blue:22/255.0 alpha:0.9];
//    //头像
//    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 39, 39)];
//    headImage.layer.masksToBounds = YES;
//    headImage.layer.cornerRadius = 19.5;
//    headImage.image = [UIImage imageNamed:@"touxiang.png"];
//    [headImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teacherHeadImagePress:)]];
//    headImage.userInteractionEnabled = YES;
//    [headerView addSubview:headImage];
//    
//    //标题
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(59, 18, SCREEN_WIDTH - 85, 20)];
//    title.text = [NSString stringWithFormat:@"%@互动营", course.coursetitle];
//    title.textColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:255/255.0 alpha:1.0];
//    title.font = SMALLFONT_16;
//    title.textAlignment = NSTextAlignmentLeft;
//    [headerView addSubview:title];
//    
//    //说明
//    UILabel *intro = [[UILabel alloc] initWithFrame:CGRectMake(59, 46, SCREEN_WIDTH - 85, 30)];
//    intro.numberOfLines = 2;
//    intro.lineBreakMode = NSLineBreakByCharWrapping;
//    intro.text = @"有问题的同学可以开贴提问，我都会尽快解答。请同学们不要灌水，发帖标题尽量贴近主题";
//    intro.textColor = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1.0];
//    intro.font = SMALLFONT_10;
//    intro.textAlignment = NSTextAlignmentLeft;
//    [headerView addSubview:intro];
//    
//    interactionTableView.tableHeaderView = headerView;
//}

- (void)sendSuccess{
    [interactionTableView setContentOffset:CGPointMake(0, -70) animated:YES];
}

- (void)refreshInteractions{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:course.courseid forKey:@"courseid"];
    //if (![Util isEmpty:self.courseSub]) {
    [dic setObject:self.courseSub.coursesubid forKey:@"coursesubid"];
    [dic setObject:self.courseSubDay forKey:@"coursesubday"];
    //}
    [CourseRequest courseInteractionListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            interactionArray = [[NSMutableArray alloc] init];
            interactionArray = [response objectForKey:@"data"];
            isJoinCourse = [response objectForKey:@"flag"];
            limitString = [response objectForKey:@"limit"];
            totalString = [response objectForKey:@"total"];
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
        [self doneLoadingTableViewData];
        isGetData = NO;
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
        showMore = YES;
        [self doneLoadingTableViewData];
        isGetData = NO;
    }];
    
}
- (void)moreInteractions{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:course.courseid forKey:@"courseid"];
    [dic setObject:self.courseSub.coursesubid forKey:@"coursesubid"];
    [dic setObject:self.courseSubDay forKey:@"coursesubday"];
    if (interactionArray.count > 0) {
        [dic setObject:limitString forKey:@"limit"];
    }
    [CourseRequest courseInteractionListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSMutableArray *moreArray = [[NSMutableArray alloc] init];
            [moreArray addObjectsFromArray:interactionArray];
            [moreArray addObjectsFromArray:[response objectForKey:@"data"]];
            interactionArray = moreArray;
            limitString = [response objectForKey:@"limit"];
            totalString = [response objectForKey:@"total"];
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
        [interactionTableView reloadData];
        isGetData = NO;
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
        showMore = YES;
        [interactionTableView reloadData];
        isGetData = NO;
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)writeClick{
    NSLog(@"点击了发帖子");
    if ([isJoinCourse integerValue] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没参加课程不能发帖子哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        WriteInteractionViewController *writeController = [[WriteInteractionViewController alloc] init];
        writeController.course = course;
        writeController.courseSub = self.courseSub;
        writeController.coursesubDay = self.courseSubDay;
        writeController.discutionType = @"question";
        [self.navigationController pushViewController:writeController animated:YES];
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return interactionArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == interactionArray.count) {
        return 48;
    }
    else{
        NSDictionary *tempDic = [interactionArray objectAtIndex:indexPath.row];
        if ([Util isEmpty:[tempDic objectForKey:@"discussoverhead"]]) {
            return 60;
        }
        else{
            return 44;
        }
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Cell = @"Cell";
    static NSString *LastCell = @"LastCell";
    if (indexPath.row >= interactionArray.count) {
        LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
        if (cell == nil) {
            cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        if (showMore) {
            cell.label.text = @"没有更多帖子喽~";
            [cell.indicatorView stopAnimating];
        }
        else{
            cell.label.text = @"加载中...";
            [cell.indicatorView startAnimating];
            if (!isGetData) {
                [self moreInteractions];
               
            }
        }
        return cell;
    }
    NSDictionary *interactionDic = [interactionArray objectAtIndex:indexPath.row];
    interactionCell = [[CourseInteractionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell withDic:interactionDic];
    if (indexPath.row%2 != 0) {
        interactionCell.backgroundColor = [UIColor colorWithRed:18/255.0 green:18/255.0 blue:19/255.0 alpha:1.0];
    }
    else{
        interactionCell.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:32/255.0 alpha:1.0];
    }
    [interactionCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return interactionCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < interactionArray.count) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        InteractionDetailViewController *detailController = [[InteractionDetailViewController alloc] init];
        NSDictionary *tempDic = [interactionArray objectAtIndex:indexPath.row];
        detailController.interactionId = [tempDic objectForKey:@"id"];
        detailController.interactionDic = tempDic;
        [self.navigationController pushViewController:detailController animated:YES];
    }
    
}


- (void)teacherHeadImagePress:(UITapGestureRecognizer*)gesture{
    NSLog(@"点击了教练头像");
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
    
    [self refreshInteractions];
}

- (void)doneLoadingTableViewData{
    _reloading = NO;
    [interactionTableView reloadData];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:interactionTableView];
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





@end
