//
//  TrendLikeMemberViewController.m
//  Health
//
//  Created by 项小盆友 on 15/1/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "TrendLikeMemberViewController.h"
#import "LikeMemberTableViewCell.h"

@interface TrendLikeMemberViewController ()<UITableViewDataSource, UITableViewDelegate, LikeMemberTableViewCellDelegate, EGORefreshTableHeaderDelegate, UIScrollViewDelegate>{
    UITableView *memberTableView;
    LikeMemberTableViewCell *memberCell;
    
    UserInfo *userInfo;
    
    NSMutableArray *memberArray;
    
    BOOL _reloading;
    BOOL showMore;
    BOOL isGetData;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    NSString *timeString;
    
}

@end

@implementation TrendLikeMemberViewController
@synthesize trendID;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] init];
    leftItem.title = @"";
    self.navigationItem.backBarButtonItem = leftItem;
    
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    memberArray = [[NSMutableArray alloc] init];
    
    _reloading = NO;
    showMore = NO;
    isGetData = YES;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    
    memberTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    memberTableView.delegate = self;
    memberTableView.dataSource = self;
    memberTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    memberTableView.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    memberTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:memberTableView];
    
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - memberTableView.bounds.size.height, memberTableView.frame.size.width, memberTableView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        [memberTableView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    [self getLikeMember];
    
}
- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getLikeMember{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", trendID, @"trendid", nil];
    [TrendRequest likeMemberWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            memberArray = [response objectForKey:@"data"];
            timeString = [response objectForKey:@"time"];
            if ([[response objectForKey:@"count"] integerValue] < 20) {
                showMore = YES;
            }
            else{
                showMore = NO;
            }
            
        }
        else{
            //[JDStatusBarNotification showWithStatus:@"加载失败" dismissAfter:1.4];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            showMore = YES;
        }
        [self doneLoadingTableViewData];
        isGetData = NO;
    } failure:^(NSError *error) {
        //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.4];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        showMore = YES;
        [self doneLoadingTableViewData];
        isGetData = NO;
    }];
}
- (void)moreLikeMember{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:trendID forKey:@"trendid"];
    if (memberArray.count > 0) {
        [dic setObject:timeString forKey:@"time"];
    }
    [TrendRequest likeMemberWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            [tempArray addObjectsFromArray:memberArray];
            [tempArray addObjectsFromArray:[response objectForKey:@"data"]];
            memberArray = tempArray;
            timeString = [response objectForKey:@"time"];
            if ([[response objectForKey:@"count"] integerValue] < 20) {
                showMore = YES;
            }
            else{
                showMore = NO;
            }
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            showMore = YES;
        }
        [memberTableView reloadData];
        isGetData = NO;
    } failure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        showMore = YES;
        [memberTableView reloadData];
        isGetData = NO;
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return memberArray.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Cell = @"Cell";
    static NSString *LastCell = @"lastCell";
    
    if (indexPath.row >= memberArray.count) {
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
                [self moreLikeMember];
                
            }
        }
        cell.label.textColor = TIME_COLOR_GARG;
        return cell;
    }
    NSDictionary *dictionary = [memberArray objectAtIndex:indexPath.row];
    memberCell = [[LikeMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell withData:dictionary];
    memberCell.backgroundColor = TABLEVIEWCELL_COLOR;
    memberCell.delegate = self;
    //[memberCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return memberCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < memberArray.count) {
        NSDictionary *tempDic = [memberArray objectAtIndex:indexPath.row];
        [self jumpPersonController:[tempDic objectForKey:@"id"]];
    }
    
}

- (void)clickAttention{
    [self getLikeMember];
}
- (void)clickHead:(NSString *)userid{
    [self jumpPersonController:userid];
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
    [self getLikeMember];
    
}

- (void)doneLoadingTableViewData{
    _reloading = NO;
    [memberTableView reloadData];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:memberTableView];
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
