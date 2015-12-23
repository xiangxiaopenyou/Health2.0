//
//  ClubMemberViewController.m
//  Health
//
//  Created by jason on 15/3/9.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClubMemberViewController.h"
#import "ClubMemberTableViewCell.h"

@interface ClubMemberViewController ()<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, ClubMemberTableviewCellDelegate, UIActionSheetDelegate>{
    UserInfo *userInfo;
    
    NSMutableArray *adminArray;
    NSMutableArray *memberArray;
    NSDictionary *ownerDic;
    NSString *memberCount;
    
    UITableView *memberTableView;
    
    BOOL showMore;
    BOOL isGetData;
    BOOL _reloading;
    
    UIActionSheet *actionSheet1;
    UIActionSheet *actionSheet2;
    UIActionSheet *actionSheet3;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    ClubMemberTableViewCell *memberCell;
}

@end

@implementation ClubMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    showMore = NO;
    isGetData = YES;
    _reloading = NO;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 20, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    memberTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT) style:UITableViewStyleGrouped];
    memberTableView.delegate = self;
    memberTableView.dataSource = self;
    memberTableView.showsVerticalScrollIndicator = NO;
    memberTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    memberTableView.backgroundView = nil;
    memberTableView.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    [memberTableView setSectionIndexColor:[UIColor clearColor]];
    [self.view addSubview:memberTableView];
    
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - memberTableView.bounds.size.height, memberTableView.frame.size.width, memberTableView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        [memberTableView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];

    [self clubMemberList];
    
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clubMemberList{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", self.clubID, @"clubid", nil];
    [ClubRequest clubMemberListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"获取成员成功");
            adminArray = [[NSMutableArray alloc] init];
            memberArray = [[NSMutableArray alloc] init];
            adminArray = [[response objectForKey:@"data"] objectForKey:@"clubadmin"];
            memberArray = [[response objectForKey:@"data"] objectForKey:@"clubmember"];
            ownerDic = [[response objectForKey:@"data"] objectForKey:@"clubuser"];
            memberCount = [[response objectForKey:@"data"] objectForKey:@"member"];
            self.clubUserTyPe = [[response objectForKey:@"data"] objectForKey:@"clubusertype"];
            if ([[response objectForKey:@"count"] integerValue] != 20) {
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
        NSLog(@"网络问题");
        showMore = YES;
        [self doneLoadingTableViewData];
        isGetData = NO;
    }];
}
- (void)moreClubMember{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:self.clubID forKey:@"clubid"];
    if (memberArray.count > 0) {
        NSDictionary *temp = [memberArray lastObject];
        [dic setObject:[temp objectForKey:@"created_time"] forKey:@"time"];
    }
    [ClubRequest clubMemberListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"获取更多成员成功");
            NSMutableArray *moreArray = [[NSMutableArray alloc] init];
            [moreArray addObjectsFromArray:memberArray];
            [moreArray addObjectsFromArray:[[response objectForKey:@"data"] objectForKey:@"clubmember"]];
            memberArray = moreArray;
            if ([[response objectForKey:@"count"] integerValue] != 20) {
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
        [memberTableView reloadData];
        isGetData = NO;
    } failure:^(NSError *error) {
        NSLog(@"网络问题");
        showMore = YES;
        [memberTableView reloadData];
        isGetData = NO;
    }];

}

#pragma mark - UITableView Delegare
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return adminArray.count + 1;
    }
    else{
        return memberArray.count + 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 40)];
    headerLabel.font = SMALLFONT_16;
    headerLabel.textColor = WHITE_CLOCLOR;
    if (section == 0) {
        headerLabel.text = [NSString stringWithFormat:@"创建者、管理员(%lu人)", adminArray.count + 1];
    }
    else{
        headerLabel.text = [NSString stringWithFormat:@"俱乐部成员(%lu人)", [memberCount intValue] - adminArray.count];
    }
    [headerView addSubview:headerLabel];
    
    return headerView;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    static NSString *LastCell = @"LastCell";
    if ([self.clubUserTyPe integerValue] == 0) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                memberCell = [[ClubMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withDic:ownerDic withType:@"0" withUserType:@"1"];
                memberCell.delegate = self;
                [memberCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                memberCell.backgroundColor = TABLEVIEWCELL_COLOR;
                
                return memberCell;
            }
            else{
                NSDictionary *tempDic = [adminArray objectAtIndex:indexPath.row - 1];
                memberCell = [[ClubMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withDic:tempDic withType:@"0" withUserType:@"2"];
                memberCell.delegate = self;
                [memberCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                memberCell.backgroundColor = TABLEVIEWCELL_COLOR;
                return memberCell;
            }
            
        }
        else{
            if (indexPath.row >= memberArray.count) {
                LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
                if (cell == nil) {
                    cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.backgroundColor = [UIColor clearColor];
                if (showMore) {
                    cell.label.text = @"没有成员喽~";
                    [cell.indicatorView stopAnimating];
                }
                else{
                    cell.label.text = @"加载中...";
                    [cell.indicatorView startAnimating];
                    if (!isGetData) {
                        [self moreClubMember];
                        
                    }
                }
                return cell;
            }
            NSDictionary *tempDic = [memberArray objectAtIndex:indexPath.row];
            memberCell = [[ClubMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withDic:tempDic withType:@"0" withUserType:@"0"];
            memberCell.delegate = self;
            [memberCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            memberCell.backgroundColor = TABLEVIEWCELL_COLOR;
            return memberCell;
        }
        
    }
    else if ([self.clubUserTyPe integerValue] == 1){
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                memberCell = [[ClubMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withDic:ownerDic withType:@"1" withUserType:@"1"];
                memberCell.delegate = self;
                [memberCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                if (indexPath.row%2 == 0) {
                    memberCell.backgroundColor = [UIColor colorWithRed:18/255.0 green:18/255.0 blue:19/255.0 alpha:1.0];
                }
                else{
                    memberCell.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:32/255.0 alpha:1.0];
                }
                return memberCell;
            }
            else{
                NSDictionary *tempDic = [adminArray objectAtIndex:indexPath.row - 1];
                memberCell = [[ClubMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withDic:tempDic withType:@"1" withUserType:@"2"];
                memberCell.delegate = self;
                [memberCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                if (indexPath.row%2 == 0) {
                    memberCell.backgroundColor = [UIColor colorWithRed:18/255.0 green:18/255.0 blue:19/255.0 alpha:1.0];
                }
                else{
                    memberCell.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:32/255.0 alpha:1.0];
                }
                return memberCell;
            }
        }
        else{
            if (indexPath.row >= memberArray.count) {
                LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
                if (cell == nil) {
                    cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.backgroundColor = [UIColor clearColor];
                if (showMore) {
                    cell.label.text = @"没有成员喽~";
                    [cell.indicatorView stopAnimating];
                }
                else{
                    cell.label.text = @"加载中...";
                    [cell.indicatorView startAnimating];
                    if (!isGetData) {
                        [self moreClubMember];
                        
                    }
                }
                return cell;
            }
            NSDictionary *tempDic = [memberArray objectAtIndex:indexPath.row];
            memberCell = [[ClubMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withDic:tempDic withType:@"1" withUserType:@"0"];
            memberCell.delegate = self;
            [memberCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            memberCell.backgroundColor = TABLEVIEWCELL_COLOR;
            return memberCell;
        }
        
    }
    else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                memberCell = [[ClubMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withDic:ownerDic withType:@"2" withUserType:@"1"];
                memberCell.delegate = self;
                [memberCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                memberCell.backgroundColor = TABLEVIEWCELL_COLOR;
                return memberCell;
            }
            else{
                NSDictionary *tempDic = [adminArray objectAtIndex:indexPath.row - 1];
                memberCell = [[ClubMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withDic:tempDic withType:@"2" withUserType:@"2"];
                memberCell.delegate = self;
                [memberCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                memberCell.backgroundColor = TABLEVIEWCELL_COLOR;
                return memberCell;
            }
        }
        else{
            if (indexPath.row >= memberArray.count) {
                LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
                if (cell == nil) {
                    cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.backgroundColor = [UIColor clearColor];
                if (showMore) {
                    cell.label.text = @"没有成员喽~";
                    [cell.indicatorView stopAnimating];
                }
                else{
                    cell.label.text = @"加载中...";
                    [cell.indicatorView startAnimating];
                    if (!isGetData) {
                        [self moreClubMember];
                        
                    }
                }
                return cell;
            }
            NSDictionary *tempDic = [memberArray objectAtIndex:indexPath.row];
            memberCell = [[ClubMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withDic:tempDic withType:@"2" withUserType:@"0"];
            [memberCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            memberCell.delegate = self;
            memberCell.backgroundColor = TABLEVIEWCELL_COLOR;
            return memberCell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            [self jumpPersonController:[ownerDic objectForKey:@"id"]];
        }
        else{
            NSDictionary *tempDic = [adminArray objectAtIndex:indexPath.row - 1];
            [self jumpPersonController:[tempDic objectForKey:@"id"]];
        }
        
    }
    else{
        if (indexPath.row < memberArray.count) {
            NSDictionary *tempDic = [memberArray objectAtIndex:indexPath.row];
            [self jumpPersonController:[tempDic objectForKey:@"id"]];
        }
        
    }
}

#pragma mark - ClubMemberTableViewCell Delegate
- (void)clickManage:(NSDictionary *)dic withType:(NSString *)typeString withUserType:(NSString *)userType{
    self.memberClickDic = dic;
    NSString *gagString;
    if ([[dic objectForKey:@"gag"] integerValue] == 0) {
        gagString = @"禁言";
    }
    else{
        gagString = @"取消禁言";
    }
    if ([typeString integerValue] == 1) {
        if ([userType integerValue] == 0) {
            actionSheet1 = [[UIActionSheet alloc] initWithTitle:@"成员管理" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"设为管理员", gagString, @"移出俱乐部", nil];
            [actionSheet1 showInView:self.view];
        }
        else {
            actionSheet2 = [[UIActionSheet alloc] initWithTitle:@"成员管理" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"取消管理资格", gagString, @"移出俱乐部", nil];
            [actionSheet2 showInView:self.view];
        }
        
    }
    else{
        actionSheet3 = [[UIActionSheet alloc] initWithTitle:@"成员管理" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:gagString, @"移出俱乐部", nil];
        [actionSheet3 showInView:self.view];
        
    }
    
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet == actionSheet1) {
        switch (buttonIndex) {
            case 0:{
                [self clubAdminCreate];
            }
                break;
            case 1:{
                if ([[self.memberClickDic objectForKey:@"gag"] integerValue] == 0) {
                    [self clubMemberGag];
                }
                else{
                    [self clubMemberCancelGag];
                }
            }
                break;
                
            case 2:{
                [self clubMemberDelete];
            }
                break;
                
            default:
                break;
        }
    }
    else if(actionSheet == actionSheet2){
        switch (buttonIndex) {
            case 0:{
                [self clubAdminCancel];
            }
                break;
            case 1:{
                if ([[self.memberClickDic objectForKey:@"gag"] integerValue] == 0) {
                    [self clubMemberGag];
                }
                else{
                    [self clubMemberCancelGag];
                }
            }
                break;
            case 2:{
                [self clubAdminDelete];
            }
                break;
            default:
                break;
        }
    }
    else{
        switch (buttonIndex) {
            case 0:{
                if ([[self.memberClickDic objectForKey:@"gag"] integerValue] == 0) {
                    [self clubMemberGag];
                }
                else{
                    [self clubMemberCancelGag];
                }
            }
                break;
            case 1:{
                [self clubMemberDelete];
            }
                
            default:
                break;
        }
    }
}

- (void)clubAdminCreate{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", self.clubID, @"clubid", [self.memberClickDic objectForKey:@"id"], @"adminid", nil];
    [ClubRequest clubAdminCreateWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"设置管理员成功");
            [self clubMemberList];
        }
        else{
            NSLog(@"设置管理员失败");
            //[JDStatusBarNotification showWithStatus:@"设置管理员失败" dismissAfter:1.0];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置管理员失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
         //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.0];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设置管理员失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
- (void)clubAdminDelete{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", self.clubID, @"clubid", [self.memberClickDic objectForKey:@"id"], @"adminid", nil];
    [ClubRequest clubAdminDeleteWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"删除管理员成功");
            [self clubMemberList];
        }
        else{
            NSLog(@"删除管理员失败");
            //[JDStatusBarNotification showWithStatus:@"移出失败" dismissAfter:1.0];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成员失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
        //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.0];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成员失败失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
- (void)clubAdminCancel{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", self.clubID, @"clubid", [self.memberClickDic objectForKey:@"id"], @"adminid", [ownerDic objectForKey:@"id"], @"clubuserid", nil];
    [ClubRequest clubAdminCancelWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"取消管理资格成功");
            [self clubMemberList];
        }
        else{
            NSLog(@"取消管理资格失败");
             //[JDStatusBarNotification showWithStatus:@"取消管理资格失败" dismissAfter:1.0];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消管理资格失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
        //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.0];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消管理资格失败失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
- (void)clubMemberDelete{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", self.clubID, @"clubid", [self.memberClickDic objectForKey:@"id"], @"clubmemberuserid", nil];
    [ClubRequest clubMemberDeleteWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"删除成员成功");
            [self clubMemberList];
        }
        else{
            NSLog(@"删除成员失败");
            //[JDStatusBarNotification showWithStatus:@"移出成员失败" dismissAfter:1.0];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成员失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
        //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.0];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成员失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
- (void)clubMemberGag{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", self.clubID, @"clubid", [self.memberClickDic objectForKey:@"id"], @"gagid", nil];
    [ClubRequest clubMemberGagWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"成员禁言成功");
            [self clubMemberList];
        }
        else{
            NSLog(@"成员禁言失败");
            //[JDStatusBarNotification showWithStatus:@"禁言失败" dismissAfter:1.0];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"禁言失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
        //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.0];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"禁言失败，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
- (void)clubMemberCancelGag{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", self.clubID, @"clubid", [self.memberClickDic objectForKey:@"id"], @"gagid", nil];
    [ClubRequest clubMemberCancelGagWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"成员取消禁言成功");
            [self clubMemberList];
        }
        else{
            NSLog(@"成员取消禁言失败");
            //[JDStatusBarNotification showWithStatus:@"取消禁言失败" dismissAfter:1.0];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消禁言失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
        //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.0];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消禁言失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
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
    [self clubMemberList];
    
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
