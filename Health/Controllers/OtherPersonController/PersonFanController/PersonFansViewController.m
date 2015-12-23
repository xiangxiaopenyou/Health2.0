//
//  PersonFansViewController.m
//  Health
//
//  Created by cheng on 15/3/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PersonFansViewController.h"
#import "PersonalViewController.h"
#import "MyFuns.h"
#import "PersonFansCell.h"
#import "RelationRequest.h"
#import "MyInfoRequest.h"
#import "OwnInfoViewController.h"

@interface PersonFansViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>{
    EGORefreshTableHeaderView *_refresh;
    BOOL _reload;
    BOOL _moreLoad;//判断是否正在加载
    BOOL _showMore;//判断是否有更多数据
    NSMutableArray *dataArray;
    UILabel *titleLabel;
}

@end

@implementation PersonFansViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    if (self.flagIndex == 2) {
        [customLab setText:@"TA的粉丝"];
    }else{
        [customLab setText:@"我的粉丝"];
    }
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    dataArray = [[NSMutableArray alloc]init];
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview setBackgroundColor:CLEAR_COLOR];
    self.tableview.tableFooterView = [[UIView alloc]init];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    if (_refresh == nil) {
        _refresh = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - self.tableview.bounds.size.height, self.tableview.frame.size.width, self.tableview.bounds.size.height)];
        _refresh.delegate = self;
        _refresh.backgroundColor = [UIColor clearColor];
        [self.tableview addSubview:_refresh];
    }
    [_refresh refreshLastUpdatedDate];
}
- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh{
    NSString *url;
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSDictionary *dictionary;
    if (self.flagIndex == 2) {
        url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_FRIEND_FANS];
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken", self.personid,@"friendid",nil];
    }else{
        url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_FANS];
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken", nil];
    }
    [RelationRequest fansListWith:dataArray parameter:dictionary URL:url success:^(id response) {
        if ([[response objectForKey:@"count"] intValue] < 20) {
            _showMore = YES;//不显示更多
        }else{
            _showMore = NO;
        }
        [self doneLoadingTableViewData];
    } failure:^(NSError *error) {
    }];
}

- (void)loadMore{
    NSString *url ;
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:userinfo.userid forKey:@"userid"];
    [dictionary setObject:userinfo.usertoken forKey:@"usertoken"];
    if (self.flagIndex == 2) {
        url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_FRIEND_FANS];
        //dictionary = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken", self.personid,@"friendid",nil];
        [dictionary setObject:self.personid forKey:@"friendid"];
        
    }else{
        url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_FANS];
        //dictionary = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken", nil];
        
    }
    if (dataArray.count == 0 || dataArray == nil) {
    }else{
        MyFuns *entity = [dataArray objectAtIndex:dataArray.count-1];
        //[dictionary setValue:entity.created_time forKey:@"time"];
        [dictionary setObject:entity.time forKey:@"time"];
    }
    [RelationRequest fansMoreListWith:dataArray parameter:dictionary URL:url success:^(id response) {
        if ([[response objectForKey:@"count"] intValue] < 20) {
            _showMore = YES;//不显示更多
        }else{
            _showMore = NO;
        }
        _moreLoad = NO;
        [self doneLoadingTableViewData];
    } failure:^(NSError *error) {
    }];
}

- (void)sortData{
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
    [dataArray sortUsingDescriptors:[NSArray arrayWithObjects:sort,nil]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row >= dataArray.count) {
        return;
    }
    
    UserData *userdata = [UserData shared];
    UserInfo *userInfo = userdata.userInfo;
    MyFuns *myfan = [dataArray objectAtIndex:indexPath.row];
    if ([myfan.ID intValue] == [userInfo.userid intValue]) {
        OwnInfoViewController *ownInfoController = [[OwnInfoViewController alloc]init];
        ownInfoController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ownInfoController animated:YES];
    }else{
        PersonalViewController *personController = [[PersonalViewController alloc]init];
        personController.personID = myfan.ID;
        [self.navigationController pushViewController:personController animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < dataArray.count) {
        
        static NSString* fans = @"FansCell";
        PersonFansCell *fanscell = [tableView dequeueReusableCellWithIdentifier:fans];
        if (fanscell == nil) {
            fanscell = [[PersonFansCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fans];
        }
        
        fanscell.backgroundColor = TABLEVIEWCELL_COLOR;
//        fanscell.backgroundColor = [UIColor clearColor];
        MyFuns *myfan = [dataArray objectAtIndex:indexPath.row];
        [fanscell.imagePortrait sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:myfan.portrait]]];
        fanscell.nameLabel.text = myfan.nickname;
        if ([myfan.sex integerValue] == 2) {
            fanscell.imageSex.image = [UIImage imageNamed:@"wsex"];
        } else {
            fanscell.imageSex.image = [UIImage imageNamed:@"msex"];
        }
        if ([myfan.flag integerValue] == 2 ) {
            [fanscell.btnFocus setBackgroundImage:[UIImage imageNamed:@"focuseachother"] forState:UIControlStateNormal];
        }else {
            [fanscell.btnFocus setBackgroundImage:[UIImage imageNamed:@"addfocus"] forState:UIControlStateNormal];
        }
        UserData *userdata = [UserData shared];
        UserInfo *userInfo = userdata.userInfo;
        if ([myfan.ID intValue] == [userInfo.userid intValue]) {
            fanscell.btnFocus.hidden = YES;
        }
        if (![Util isEmpty:myfan.birthday]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *birthday = [formatter dateFromString:myfan.birthday];
            NSTimeInterval dateDiff = [birthday timeIntervalSinceNow];
            int age=-trunc(dateDiff/(60*60*24))/365;
            fanscell.ageLabel.text = [NSString stringWithFormat:@"%d岁",age];
        } else {
            fanscell.ageLabel.text = @"保密";
        }
        [fanscell clickAttention:^(NSInteger index) {
            
            UserData *userdata = [UserData shared];
            UserInfo *userInfo = userdata.userInfo;
            NSDictionary *dicFanCreate = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken",myfan.ID, @"fansid", nil];
            if ([myfan.flag integerValue] == 2 ) {
                [MyInfoRequest fanDelesWithParam:dicFanCreate success:^(id response) {
                    
                } failure:^(NSError *error) {
                    
                }];
                myfan.flag = @"3";
                [fanscell.btnFocus setBackgroundImage:[UIImage imageNamed:@"addfocus"] forState:UIControlStateNormal];
            }else {
                [MyInfoRequest fanCreateWithParam:dicFanCreate success:^(id response) {
                    
                } failure:^(NSError *error) {
                    
                }];
                myfan.flag = @"2";
                [fanscell.btnFocus setBackgroundImage:[UIImage imageNamed:@"focuseachother"] forState:UIControlStateNormal];
            }
        }];
        return fanscell;

    }else{
        static NSString *LastCell = @"LastCell";
        LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
        if (cell == nil) {
            cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        if (_showMore) {
            cell.label.text = @"没有更多粉丝喽~";
            [cell.indicatorView stopAnimating];
        }
        else{
            cell.label.text = @"加载中...";
            [cell.indicatorView startAnimating];
            if (!_moreLoad) {
                _moreLoad = YES;
                [self loadMore];
            }
        }return cell;
    }
    
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refresh egoRefreshScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refresh egoRefreshScrollViewDidEndDragging:scrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [_refresh egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)reloadTableViewDataSource{
    _reload = YES;
    [self refresh];
}

- (void)doneLoadingTableViewData{
    
    [self sortData];
    _reload = NO;
    [self.tableview reloadData];
    [_refresh egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableview];
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return  _reload;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
}


@end
