//
//  TrendDetailViewController.m
//  Health
//
//  Created by 项小盆友 on 15/1/27.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "TrendDetailViewController.h"
#import "TrendDetailTableViewCell.h"
#import "TrendCommentsTableViewCell.h"
#import "TrendLikeMemberViewController.h"

@interface TrendDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, TrendDetailTableViewCellDelegate, UIAlertViewDelegate, TrendCommentsCellDelegate , UIActionSheetDelegate, EGORefreshTableHeaderDelegate, UIScrollViewDelegate>{
    UITableView *detailTableView;
    
    TrendDetailTableViewCell *detailCell;
    TrendCommentsTableViewCell *commentsCell;
    
    UIView *commentView;
    UILabel *tipLabel;
    UIImageView *tipImage;
    
    UserInfo *userInfo;
    
    NSDictionary *detailDic;
    NSMutableArray *commentsArray;
    NSString *timeString;
    
    BOOL isReply;
    NSString *commentid;
    NSString *commentuserid;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    BOOL isGetData;
    BOOL showMore;
    
}

@end

@implementation TrendDetailViewController

@synthesize commentTextView,commentButton;
@synthesize isCommentsShow, isCommentIn, trendid;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"详情"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    detailDic = [[NSDictionary alloc] init];
    commentsArray = [[NSMutableArray alloc] init];

    showMore = NO;
    isGetData = YES;
    _reloading = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWasHiden:) name:UIKeyboardWillHideNotification object:nil];
    
    detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT)];
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    detailTableView.showsVerticalScrollIndicator = NO;
    [detailTableView setSectionIndexColor:[UIColor clearColor]];
    [detailTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [detailTableView setBackgroundView:nil];
    [detailTableView setBackgroundColor:TABLEVIEW_BACKGROUNDCOLOR];
    [self.view addSubview:detailTableView];
    
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - detailTableView.bounds.size.height, detailTableView.frame.size.width, detailTableView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        [detailTableView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    [self setupCommentView];
    [self getTrendDetail];
    
}

- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//评论或者回复框
- (void)setupCommentView{
    commentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT, SCREEN_WIDTH, TABBAR_HEIGHT)];
    commentView.backgroundColor = TABLEVIEWCELL_COLOR;
    [self.view addSubview:commentView];
    
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 8.5, SCREEN_WIDTH - 80, 32)];
    commentTextView.delegate = self;
    commentTextView.font = [UIFont systemFontOfSize:14];
    commentTextView.returnKeyType = UIReturnKeyDone;
    commentTextView.backgroundColor = [UIColor clearColor];
    commentTextView.textColor = [UIColor whiteColor];
    commentTextView.layer.masksToBounds = YES;
    commentTextView.layer.cornerRadius = 3;
    commentTextView.layer.borderWidth = 0.5;
    commentTextView.layer.borderColor = TIME_COLOR_GARG.CGColor;
    [commentView addSubview:commentTextView];
    
    commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 60, TABBAR_HEIGHT);
    [commentButton setTitle:@"发送" forState:UIControlStateNormal];
    [commentButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    commentButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [commentButton addTarget:self action:@selector(commentButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [commentView addSubview:commentButton];
    
    tipImage = [[UIImageView alloc] initWithFrame:CGRectMake(22, 17, 15, 15)];
    tipImage.image = [UIImage imageNamed:@"comment_tip.png"];
    [commentView addSubview:tipImage];
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 13, SCREEN_WIDTH - 132, 20)];
    tipLabel.text = @"评论";
    tipLabel.textColor = [UIColor colorWithRed:63/255.0 green:62/255.0 blue:69/255.0 alpha:1.0];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.font = [UIFont systemFontOfSize:14];
    [commentView addSubview:tipLabel];
    isReply = NO;
    
    if (isCommentIn) {
        [commentTextView becomeFirstResponder];
    }
    
}


#pragma mark - UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([@"\n" isEqualToString:text]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    [tipLabel setHidden:YES];
    [tipImage setHidden:YES];
}


#pragma mark - Kayboard
- (void)KeyboardWasShown:(NSNotification*)note{
    NSDictionary *info =[note userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    [UIView beginAnimations:@"KeyboardShow" context:nil];
    [UIView setAnimationDuration:0.25];
    commentView.frame = CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT - keyboardSize.height, SCREEN_WIDTH, TABBAR_HEIGHT);
    [UIView commitAnimations];
}
- (void)KeyboardWasHiden:(NSNotification*)note{
    [UIView beginAnimations:@"KeyboardHide" context:nil];
    [UIView setAnimationDuration:0.25];
    commentView.frame = CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT, SCREEN_WIDTH, TABBAR_HEIGHT);
    [UIView commitAnimations];
}

/*
 *获取动态详情
 *
 */
- (void)getTrendDetail{
//    if (![JDStatusBarNotification isVisible]) {
//        [JDStatusBarNotification showWithStatus:@"稍等..."];
//    }
//    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", trendid, @"trendid", nil];
    [TrendRequest trendDetailWtih:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"获取动态详情成功");
            detailDic = [response objectForKey:@"data"];
            commentsArray = [detailDic objectForKey:@"comments"];
            timeString = [response objectForKey:@"time"];
            tipLabel.text = [NSString stringWithFormat:@"评论%@", [detailDic objectForKey:@"usernickname"]];
            if ([[response objectForKey:@"count"] integerValue] < 20) {
                showMore = YES;
            }
            else{
                showMore = NO;
            }
            [self doneLoadingTableViewData];
            if (isCommentsShow) {
                NSUInteger ii[2] = {0, 1};
                NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
                [detailTableView scrollToRowAtIndexPath:indexPath
                                       atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
        else{
            NSLog(@"获取动态详情失败");
            //[JDStatusBarNotification showWithStatus:@"加载失败" dismissAfter:1.4];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            showMore = YES;
        }
        isGetData = NO;
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
        //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.4];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        showMore = YES;
        [self doneLoadingTableViewData];
        isGetData = NO;
    }];
}

- (void)moreTrendDetail{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:trendid forKey:@"trendid"];
    if (commentsArray.count > 0) {
        [dic setObject:timeString forKey:@"time"];
    }
    [TrendRequest trendDetailWtih:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"获取动态详情成功");
            detailDic = [response objectForKey:@"data"];
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            [tempArray addObjectsFromArray:commentsArray];
            [tempArray addObjectsFromArray:[detailDic objectForKey:@"comments"]];
            commentsArray = tempArray;
            timeString = [response objectForKey:@"time"];
//            tipLabel.text = [NSString stringWithFormat:@"评论%@", [detailDic objectForKey:@"usernickname"]];
            if ([[response objectForKey:@"count"] integerValue] < 20) {
                showMore = YES;
            }
            else{
                showMore = NO;
            }
            [detailTableView reloadData];
        }
        else{
            NSLog(@"获取动态详情失败");
            //[JDStatusBarNotification showWithStatus:@"加载失败" dismissAfter:1.4];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载更多失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            showMore = YES;
        }
        isGetData = NO;
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
        //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.4];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        showMore = YES;
        [detailTableView reloadData];
        isGetData = NO;
    }];
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

- (void)commentButtonClick{
    NSLog(@"点击了发送");
    NSString *commentString = commentTextView.text;
    if ([Util isEmpty:commentTextView.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"先说点什么吧~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        if (commentTextView.text.length > 200) {
            commentString = [commentString substringWithRange:NSMakeRange(0, 199)];
        }
        else{
            [commentTextView resignFirstResponder];
            commentTextView.text = nil;
            [tipImage setHidden:NO];
            [tipLabel setHidden:NO];
            if (isReply) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:userInfo.userid forKey:@"userid"];
                [dic setObject:userInfo.usertoken forKey:@"usertoken"];
                [dic setObject:trendid forKey:@"trendid"];
                [dic setObject:commentid forKey:@"commentid"];
                [dic setObject:commentuserid forKey:@"commentuserid"];
                [dic setObject:commentString forKey:@"cpartakcontent"];
                [TrendRequest replyTrendWith:dic success:^(id response) {
                    if ([[response objectForKey:@"state"] integerValue] == 1000) {
                        NSLog(@"回复成功");
                        [self getTrendDetail];
                    }
                    else{
                        //[JDStatusBarNotification showWithStatus:@"回复失败" dismissAfter:1.4];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"回复失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                } failure:^(NSError *error) {
                    //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.4];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"回复失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }];
            }
            else{
                NSDictionary *dic= [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", trendid, @"trendid", commentString, @"commentcontent", nil];
                [TrendRequest commentTrendWith:dic success:^(id response) {
                    if ([[response objectForKey:@"state"] integerValue] == 1000) {
                        NSLog(@"评论成功");
                        [self getTrendDetail];
                    }
                    else{
                        NSLog(@"评论失败");
                        //[JDStatusBarNotification showWithStatus:@"评论失败咯~" dismissAfter:1.4];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                } failure:^(NSError *error) {
                    //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.4];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }];
            }
        }
    }
    
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return commentsArray.count + 2;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *DetailCell = @"DetailCell";
    static NSString *CommentsCell = @"CommentsCell";
    static NSString *LastCell = @"lastCell";
    if (indexPath.row == 0) {
        detailCell = [[TrendDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCell withData:detailDic];
        detailCell.delegate = self;
        [detailCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return detailCell;
    }
    else{
        if (indexPath.row >= commentsArray.count + 1) {
            LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
            if (cell == nil) {
                cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = [UIColor clearColor];
            if (showMore) {
                if(commentsArray.count > 0){
                    cell.label.text = @"没有更多评论喽~";
                }
                else{
                    cell.label.text = @"还没评论哦~";
                }
                [cell.indicatorView stopAnimating];
            }
            else{
                cell.label.text = @"加载中...";
                [cell.indicatorView startAnimating];
                if (!isGetData) {
                    [self moreTrendDetail];
                    
                }
            }
            cell.label.textColor = TIME_COLOR_GARG;
            return cell;
        }
        NSDictionary *commentDic = [commentsArray objectAtIndex:indexPath.row - 1];
        commentsCell = [[TrendCommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentsCell withData:commentDic];
        commentsCell.delegate = self;
        return commentsCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        detailCell = (TrendDetailTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return detailCell.iHeight;
    }
    else{
        if (indexPath.row <= commentsArray.count){
            commentsCell = (TrendCommentsTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return commentsCell.height;
        }
        else{
            return 60;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row > 0 && indexPath.row < commentsArray.count + 1){
        NSDictionary *commentDic = [commentsArray objectAtIndex:indexPath.row - 1];
        if ([userInfo.userid isEqualToString:[commentDic objectForKey:@"commentuserid"]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能回复自己哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            isReply = YES;
            commentid = [commentDic objectForKey:@"id"];
            commentuserid = [commentDic objectForKey:@"commentuserid"];
            tipLabel.text = [NSString stringWithFormat:@"回复%@", [commentDic objectForKey:@"commentusernickname"]];
            tipImage.hidden = NO;
            tipLabel.hidden = NO;
            [commentTextView becomeFirstResponder];
        }
    }
}

#pragma mark - TrendDetailTableViewCell Delegate
- (void)clickLikeMember{
    TrendLikeMemberViewController *memberController = [[TrendLikeMemberViewController alloc] init];
    memberController.trendID = [detailDic objectForKey:@"id"];
    [self.navigationController pushViewController:memberController animated:YES];
}
- (void)clickComment:(NSString *)usernickname{
    isReply = NO;
    tipLabel.text = [NSString stringWithFormat:@"评论%@",usernickname];
    tipImage.hidden = NO;
    tipLabel.hidden = NO;
    [commentTextView becomeFirstResponder];
}
- (void)clickDelete{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alert show];
}
- (void)clickReport{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"投诉不良信息" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", trendid, @"complaintstargetid", @"show", @"type", nil];
        [TrendRequest reportWith:dic success:^(id response) {
            if ([[response objectForKey:@"state"] integerValue] == 1000) {
                NSLog(@"投诉成功");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"投诉成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else{
                NSLog(@"投诉失败");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"投诉失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        } failure:^(NSError *error) {
            NSLog(@"网络问题");
        }];
    }
}

- (void)clickHead{
    [self jumpPersonController:[detailDic objectForKey:@"userid"]];
}
- (void)clickLike{
    //[self getTrendDetail];
}
- (void)clickNickname{
    [self jumpPersonController:[detailDic objectForKey:@"userid"]];
}
- (void)clickShare{}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSDictionary *deleteDic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", trendid, @"trendid", nil];
        [TrendRequest deleteTrendWith:deleteDic success:^(id response) {
            if ([[response objectForKey:@"state"] integerValue] == 1000) {
                NSLog(@"删除动态成功");
                //[self refreshMethods];
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDelete" object:@YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"deletetrendsuccess" object:@YES];
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

- (void)clickCommentHead:(NSString *)userid{
    [self jumpPersonController:userid];
}
- (void)clickReplyNickname:(NSString *)userid{
    [self jumpPersonController:userid];
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
    [self getTrendDetail];
    
}

- (void)doneLoadingTableViewData{
    _reloading = NO;
    [detailTableView reloadData];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:detailTableView];
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading;
    
    
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

@end
