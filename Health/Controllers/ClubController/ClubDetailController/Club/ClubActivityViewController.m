//
//  ClubActivityViewController.m
//  Health
//
//  Created by realtech on 15/5/20.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClubActivityViewController.h"
#import "CreateActivityViewController.h"
#import "ActivityWebViewController.h"

@interface ClubActivityViewController ()<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>{
    
    UITableView *activityTableView;
    EGORefreshTableHeaderView *_refreshActivity;
    
    UserInfo *userInfo;
    
    NSMutableArray *activitiesArray;
    
    NSString *limitString;
    NSString *totalString;
    
    BOOL _showMore;
    BOOL _loadMore;
    BOOL _reloading;
}

@end

@implementation ClubActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    _showMore = NO;
    _loadMore = YES;
    _reloading = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createActivitySuccess) name:@"createactivitysuccess" object:nil];
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"活动"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    if ([self.usertype integerValue] != 0) {
        UIButton *activityCreateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        activityCreateButton.frame = CGRectMake(SCREEN_WIDTH - 65, 22, 60, 40);
        [activityCreateButton setTitle:@"创建活动" forState:UIControlStateNormal];
        [activityCreateButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
        activityCreateButton.titleLabel.font = SMALLFONT_14;
        [activityCreateButton addTarget:self action:@selector(activityCreateClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:activityCreateButton];
    }
    
    
    activitiesArray = [[NSMutableArray alloc] init];
    
    activityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    activityTableView.delegate = self;
    activityTableView.dataSource = self;
    activityTableView.backgroundColor = CLEAR_COLOR;
    activityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    activityTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:activityTableView];
    
    if (_refreshActivity == nil) {
        _refreshActivity = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - activityTableView.bounds.size.height, activityTableView.frame.size.width, activityTableView.bounds.size.height)];
        _refreshActivity.delegate = self;
        _refreshActivity.backgroundColor = CLEAR_COLOR;
        [activityTableView addSubview:_refreshActivity];
    }
    [_refreshActivity refreshLastUpdatedDate];
    
    [self refreshClubActivity];

}
- (void)activityCreateClick{
    CreateActivityViewController *controller = [[CreateActivityViewController alloc] init];
    controller.club_id = self.club_id;
    controller.type = @"3";
    [self.navigationController pushViewController:controller animated:YES];
    
}
- (void)createActivitySuccess{
    [self refreshClubActivity];
}
- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshClubActivity{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:self.club_id forKey:@"clubid"];
    [dic setObject:@"3" forKey:@"type"];
    [ClubRequest clubCreamListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            activitiesArray = [response objectForKey:@"data"];
            limitString = [response objectForKey:@"limit"];
            totalString = [response objectForKey:@"total"];
            if ([limitString integerValue] >= [totalString integerValue]) {
                _showMore = YES;
            }
            else {
                _showMore = NO;
            }
        }
        else {
            _showMore = YES;
        }
        [self doneLoadingTableViewData];
        _loadMore = NO;
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)moreClubActivity{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:self.club_id forKey:@"clubid"];
    [dic setObject:@"3" forKey:@"type"];
    [dic setObject:limitString forKey:@"limit"];
    [ClubRequest clubCreamListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            [tempArray addObjectsFromArray:activitiesArray];
            [tempArray addObjectsFromArray:[response objectForKey:@"data"]];
            activitiesArray = tempArray;
            limitString = [response objectForKey:@"limit"];
            totalString = [response objectForKey:@"total"];
            if ([limitString integerValue] >= [totalString integerValue]) {
                _showMore = YES;
            }
            else {
                _showMore = NO;
            }
        }
        else {
            _showMore = YES;
        }
        [activityTableView reloadData];
        _loadMore = NO;
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return activitiesArray.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < activitiesArray.count) {
        static NSString *identifier = @"Cell";
        NSDictionary *tempDic = [activitiesArray objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.backgroundColor = CLEAR_COLOR;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 60)];
        titleLabel.textColor = WHITE_CLOCLOR;
        titleLabel.font = SMALLFONT_16;
        titleLabel.text = [tempDic objectForKey:@"title"];
        titleLabel.numberOfLines = 2;
        titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [cell addSubview:titleLabel];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 59.5, SCREEN_WIDTH - 10, 0.5)];
        line.backgroundColor = LINE_COLOR_GARG;
        [cell addSubview:line];
        
        return cell;
    }
    else {
        static NSString *LastIdentifier = @"LastCell";
        LastTableViewCell *lastCell = [tableView dequeueReusableCellWithIdentifier:LastIdentifier];
        if (lastCell == nil) {
            lastCell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastIdentifier];
        }
        [lastCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        lastCell.backgroundColor = CLEAR_COLOR;
        lastCell.label.textColor = TIME_COLOR_GARG;
        if (_showMore) {
            lastCell.label.text = @"没有活动咯~";
            [lastCell.indicatorView stopAnimating];
        }
        else {
            lastCell.label.text = @"加载中...";
            [lastCell.indicatorView startAnimating];
            if (!_loadMore) {
                [self moreClubActivity];
            }
        }
        return lastCell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *tempDic = [activitiesArray objectAtIndex:indexPath.row];
    ActivityWebViewController *controller = [[ActivityWebViewController alloc] init];
    controller.urlString = [tempDic objectForKey:@"url"];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [_refreshActivity egoRefreshScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshActivity egoRefreshScrollViewDidEndDragging:scrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [_refreshActivity egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)reloadTableViewDataSource{
    _reloading = YES;
    [self refreshClubActivity];
    
}

- (void)doneLoadingTableViewData{
    _reloading = NO;
    [activityTableView reloadData];
    [_refreshActivity egoRefreshScrollViewDataSourceDidFinishedLoading:activityTableView];
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
