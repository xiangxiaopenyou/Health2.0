//
//  CourseClockinListViewController.m
//  Health
//
//  Created by realtech on 15/6/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseClockinListViewController.h"
#import "ClockinTableViewCell.h"
#import "ClockinDetailViewController.h"
#import "ClubDetailViewController.h"

@interface CourseClockinListViewController ()<EGORefreshTableHeaderDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, ClockinCellDelete, UIActionSheetDelegate, UIAlertViewDelegate>{
    EGORefreshTableHeaderView *_refreshClockin;
    
    NSString *clockinLimit;
    NSString *clockinTotal;
    NSMutableArray *arrayOfClockin;
    ClockinTableViewCell *clockinCell;
    BOOL _reloading;
    
    BOOL _showMoreClockin;
    BOOL _moreLoadClockin;
    
    UserInfo *userInfo;
    
    NSString *trendId;
}

@end

@implementation CourseClockinListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [back setTitle:@"" forState:UIControlStateNormal];
    [back setFrame:CGRectMake(5, 2, 52, 30)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = barButton;
    
    _showMoreClockin = NO;
    _moreLoadClockin = YES;
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"学员打卡"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    arrayOfClockin = [[NSMutableArray alloc] init];
    
    clockinTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    clockinTableView.delegate = self;
    clockinTableView.dataSource = self;
    clockinTableView.backgroundColor = [UIColor clearColor];
    clockinTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    clockinTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:clockinTableView];
    if (_refreshClockin == nil) {
        _refreshClockin = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - clockinTableView.bounds.size.height, clockinTableView.frame.size.width, clockinTableView.bounds.size.height)];
        _refreshClockin.delegate =self;
        _refreshClockin.backgroundColor =[UIColor clearColor];
        [clockinTableView addSubview:_refreshClockin];
    }
    [_refreshClockin refreshLastUpdatedDate];
    
    [self refreshClockinList];
    
}

- (void)refreshClockinList{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", self.courseid, @"courseid", nil];
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
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", self.courseid, @"courseid", clockinLimit, @"limit", nil];
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

- (void)bClick{
    AppDelegate *appDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.rootNavigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - ClockinDelegate
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
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)clickClockinComment:(NSString *)trendid{
    ClockinDetailViewController *detailController = [[ClockinDetailViewController alloc] init];
    detailController.isCommentIn = YES;
    detailController.hidesBottomBarWhenPushed = YES;
    detailController.trendid = trendid;
    [self.navigationController pushViewController:detailController animated:YES];
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
    if (buttonIndex == 1) {
        NSDictionary *deleteDic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", trendId, @"trendid", nil];
        [TrendRequest deleteTrendWith:deleteDic success:^(id response) {
            if ([[response objectForKey:@"state"] integerValue] == 1000) {
                NSLog(@"删除打卡成功");
                [self refreshClockinList];
            }
            else{
                NSLog(@"删除打卡失败");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        } failure:^(NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayOfClockin.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == arrayOfClockin.count) {
        return 48;
    }
    else {
        clockinCell = (ClockinTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return clockinCell.height;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *LastCell = @"LastCell";
    static NSString *clockinIdentifier = @"ClockinCell";
    if (indexPath.row < arrayOfClockin.count) {
        NSDictionary *dic = [arrayOfClockin objectAtIndex:indexPath.row];
        clockinCell = [[ClockinTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:clockinIdentifier withDic:dic];
        clockinCell.delegate = self;
        [clockinCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return clockinCell;
    }
    else {
        LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
        if (cell == nil) {
            cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = CLEAR_COLOR;
        cell.label.textColor = TIME_COLOR_GARG;
        if (_showMoreClockin) {
            if (arrayOfClockin.count == 0) {
                cell.label.text = @"还没人打过卡哦~";
            }
            else {
                cell.label.text = @"没有更多喽~";
            }
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
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [_refreshClockin egoRefreshScrollViewDidScroll:scrollView];
  
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    [_refreshClockin egoRefreshScrollViewDidEndDragging:scrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    [_refreshClockin egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)reloadTableViewDataSource{
    _reloading = YES;
   
    [self refreshClockinList];
    
}

- (void)doneLoadingTableViewData{
    _reloading = NO;
    
    [clockinTableView reloadData];
    [_refreshClockin egoRefreshScrollViewDataSourceDidFinishedLoading:clockinTableView];
    
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
