//
//  RecommendUsersViewController.m
//  Health
//
//  Created by realtech on 15/5/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RecommendUsersViewController.h"
#import "TrendDetailViewController.h"
#import "UsersListTableViewCell.h"

@interface RecommendUsersViewController ()<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, UIScrollViewDelegate>{
    BOOL _reloading;
    BOOL _showMore;
    BOOL _moreLoad;
    NSString *limitString;
    NSString *totalString;
    UserInfo *userInfo;
    NSMutableArray *arrayOfUsers;
    
    EGORefreshTableHeaderView *_refresh;
}

@end

@implementation RecommendUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    _showMore = NO;
    _moreLoad = YES;
    _reloading = NO;
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"推荐用户"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    usersTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    usersTableView.delegate = self;
    usersTableView.dataSource = self;
    usersTableView.backgroundColor = CLEAR_COLOR;
    usersTableView.showsVerticalScrollIndicator = NO;
    usersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:usersTableView];
    if (_refresh == nil) {
        _refresh = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, - usersTableView.bounds.size.height, usersTableView.frame.size.width, usersTableView.bounds.size.height)];
        _refresh.delegate = self;
        _refresh.backgroundColor = CLEAR_COLOR;
        [usersTableView addSubview:_refresh];
    }
    [_refresh refreshLastUpdatedDate];
    
    arrayOfUsers = [[NSMutableArray alloc] init];
    
    [self refreshUsers];
}

- (void)refreshUsers {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", nil];
    [TrendRequest recommendUserListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            [arrayOfUsers removeAllObjects];
            [arrayOfUsers addObjectsFromArray:[response objectForKey:@"data"]];
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
        _moreLoad = NO;
        [self doneLoadingTableViewData];
    } failure:^(NSError *error) {
        [self doneLoadingTableViewData];
    }];
}
- (void)moreUsers {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:limitString forKey:@"limit"];
    [TrendRequest recommendUserListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:arrayOfUsers];
            [tempArray addObjectsFromArray:[response objectForKey:@"data"]];
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
        _moreLoad = NO;
        [usersTableView reloadData];
    } failure:^(NSError *error) {
        [usersTableView reloadData];
    }];
}

- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayOfUsers.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= arrayOfUsers.count) {
        return 48;
    }
    else {
        return 58;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < arrayOfUsers.count) {
        static NSString *userIdentifier = @"UserCell";
        NSDictionary *tempDic = [arrayOfUsers objectAtIndex:indexPath.row];
        UsersListTableViewCell *cell = [[UsersListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier wihtDic:tempDic];
        cell.backgroundColor = TABLEVIEWCELL_COLOR;
        return cell;

    }
    else {
       static NSString *lastIdentifier = @"LastCell";
        LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lastIdentifier];
        if (cell == nil) {
            cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lastIdentifier];
        }
        cell.backgroundColor = CLEAR_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_showMore) {
            cell.label.text = @"没有更多推荐喽~";
            [cell.indicatorView stopAnimating];
        }
        else {
            cell.label.text = @"加载中...";
            [cell.indicatorView startAnimating];
            if (!_moreLoad) {
                [self moreUsers];
            }
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < arrayOfUsers.count) {
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
        tempDic = [arrayOfUsers objectAtIndex:indexPath.row];
        [self jumpPersonController:[tempDic objectForKey:@"userid"]];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_refresh egoRefreshScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refresh egoRefreshScrollViewDidEndDragging:scrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [_refresh egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - EGORefreshTableHeaderDelegate
- (void)reloadTableViewDataSource{
    _reloading = YES;
    [self refreshUsers];
    
}

- (void)doneLoadingTableViewData{
    _reloading = NO;
    [usersTableView reloadData];
    [_refresh egoRefreshScrollViewDataSourceDidFinishedLoading:usersTableView];
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
