//
//  InteractionDetailViewController.m
//  Health
//
//  Created by 项小盆友 on 15/1/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "InteractionDetailViewController.h"
#import "InteractionDetailTableViewCell.h"
#import "InteractionCommentsTableViewCell.h"
#import "CourseRequest.h"
#import "CourseWebViewController.h"

@interface InteractionDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, EGORefreshTableHeaderDelegate, UIScrollViewDelegate, InteractionDetailTableViewCellDelegate, InteractionCommentsTableViewCellDelegate, UIAlertViewDelegate, UIActionSheetDelegate>{
    UITableView *detailTableView;
    
    UIView *commentView;
    UIImageView *tipImage;
    UILabel *tipLabel;
    
    UserInfo *userInfo;
    
    InteractionCommentsTableViewCell *commentsCell;
    InteractionDetailTableViewCell *detailCell;
    
    NSMutableArray *interactionCommentsArray;
    NSMutableDictionary *inteDic;
    NSString *isJoin;
    NSString *userType;
    
    BOOL isReply;
    NSString *commentid;
    NSString *commentuserid;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    BOOL _reloading;
    BOOL showMore;
    BOOL isGetData;
}

@end

@implementation InteractionDetailViewController

@synthesize commentButton, commentTextView, interactionId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    showMore = NO;
    isGetData = YES;
    _reloading = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWasHiden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT)];
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    
    detailTableView.backgroundColor = CLEAR_COLOR;
    detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    detailTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:detailTableView];
    
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - detailTableView.bounds.size.height, detailTableView.frame.size.width, detailTableView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        [detailTableView addSubview:_refreshHeaderView];
        
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    [self refreshInteractionDetail];
    
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
    tipLabel.text = [NSString stringWithFormat:@"评论%@",[inteDic objectForKey:@"nickname"]];
    tipLabel.textColor = [UIColor colorWithRed:63/255.0 green:62/255.0 blue:69/255.0 alpha:1.0];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.font = [UIFont systemFontOfSize:14];
    [commentView addSubview:tipLabel];
    isReply = NO;
    
}

- (void)refreshInteractionDetail{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:interactionId forKey:@"trendid"];
    [CourseRequest courseInteractionDetailWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"获取详情成功");
            inteDic = [[NSMutableDictionary alloc] init];
            inteDic = [[response objectForKey:@"data"] objectForKey:@"discussion"];
            isJoin = [response objectForKey:@"flag"];
            interactionCommentsArray = [[NSMutableArray alloc] init];
            interactionCommentsArray = [[response objectForKey:@"data"] objectForKey:@"comment"];
            userType = [response objectForKey:@"type"];
            if ([[response objectForKey:@"count"] integerValue] != 20) {
                showMore = YES;
            }
            else{
                showMore = NO;
            }
            [self setupCommentView];
            [self setupDeleteDiscussionButton];
        }
        else{
            NSLog(@"获取详情失败");
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
//删除按钮
- (void)setupDeleteDiscussionButton{
    if ([userType integerValue] == 1 || [[inteDic objectForKey:@"discussionuserid"] isEqualToString:userInfo.userid]) {
        UIButton *deleteDiscussionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteDiscussionButton.frame = CGRectMake(SCREEN_WIDTH - 50, 22, 40, 40);
        [deleteDiscussionButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteDiscussionButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
        deleteDiscussionButton.titleLabel.font = SMALLFONT_14;
        [deleteDiscussionButton addTarget:self action:@selector(deleteDiscussionClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:deleteDiscussionButton];
    }
    else {
        reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        reportButton.frame = CGRectMake(SCREEN_WIDTH - 44, 20, 44, 44);
        [reportButton addTarget:self action:@selector(reportButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:reportButton];
        
        UIImageView *infoImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 14, 14)];
        infoImage.image = [UIImage imageNamed:@"report.png"];
        [reportButton addSubview:infoImage];
    }
}
- (void)deleteDiscussionClick{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)reportButtonClick{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"投诉不良信息" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", interactionId, @"complaintstargetid", @"course", @"type", nil];
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

#define mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:userInfo.userid forKey:@"userid"];
        [dic setObject:userInfo.usertoken forKey:@"usertoken"];
        [dic setObject:[inteDic objectForKey:@"courseid"] forKey:@"courseid"];
        [dic setObject:interactionId forKey:@"discussionid"];
        [self.navigationController popViewControllerAnimated:YES];
        
        [CourseRequest deleteCourseInteractionWith:dic success:^(id response) {
            if ([[response objectForKey:@"state"] intValue] == 1000) {
                NSLog(@"删除成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"createinteractionsuccess" object:@YES];
            }
            else{
                NSLog(@"删除失败");
                //[JDStatusBarNotification showWithStatus:@"删除失败" dismissAfter:1.0];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        } failure:^(NSError *error) {
            NSLog(@"网络问题");
            //[JDStatusBarNotification showWithStatus:@"网络问题" dismissAfter:1.0];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
}

- (void)moreInteractionComments{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:interactionId forKey:@"trendid"];
    [CourseRequest courseInteractionDetailWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"获取更多评论成功");
            NSMutableArray *moreCommentsArray = [[NSMutableArray alloc] init];
            [moreCommentsArray addObjectsFromArray:interactionCommentsArray];
            [moreCommentsArray addObjectsFromArray:[[response objectForKey:@"data"] objectForKey:@"comment"]];
            interactionCommentsArray = moreCommentsArray;
            if ([[response objectForKey:@"count"] integerValue] != 20) {
                showMore = YES;
            }
            else{
                showMore = NO;
            }
        }
        else{
            NSLog(@"获取更多评论失败");
            showMore = YES;
        }
        [detailTableView reloadData];
        isGetData = NO;
    } failure:^(NSError *error) {
        NSLog(@"网络问题");
        showMore = YES;
        [detailTableView reloadData];
        isGetData = NO;
    }];
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

- (void)commentButtonClick{
    if ([isJoin integerValue] != 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"参加了课程才能进行评论回复哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
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
                    [dic setObject:[inteDic objectForKey:@"id"] forKey:@"discussionid"];
                    [dic setObject:commentid forKey:@"commentid"];
                    [dic setObject:commentuserid forKey:@"commentreplyuserid"];
                    [dic setObject:[inteDic objectForKey:@"discussionuserid"] forKey:@"discussionuserid"];
                    [dic setObject:commentString forKey:@"reply"];
                    [CourseRequest courseInteractionReplyWith:dic success:^(id response) {
                        if ([[response objectForKey:@"state"] integerValue] == 1000) {
                            NSLog(@"回复成功");
                            [self refreshInteractionDetail];
                        }
                        else{
                            //[JDStatusBarNotification showWithStatus:@"回复失败" dismissAfter:1.4];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"回复失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    } failure:^(NSError *error) {
                        //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.4];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"回复失败，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }];
                }
                else{
                    //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", interactionId, @"discussionid", [self.interactionDic objectForKey:@"discussionuserid"], @"discussionuserid", commentString, @"[inteDic objectForKey:@"id"]", nil];
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:userInfo.userid forKey:@"userid"];
                    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
                    [dic setObject:[inteDic objectForKey:@"id"] forKey:@"discussionid"];
                    [dic setObject:[inteDic objectForKey:@"discussionuserid"] forKey:@"discussionuserid"];
                    [dic setObject:commentString forKey:@"commentcontent"];
                    [CourseRequest courseInteractionCommentWith:dic success:^(id response) {
                        if ([[response objectForKey:@"state"] integerValue] == 1000) {
                            NSLog(@"评论成功");
                            [self refreshInteractionDetail];
                        }
                        else{
                            NSLog(@"评论失败");
                            //[JDStatusBarNotification showWithStatus:@"评论失败咯~" dismissAfter:1.4];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                        
                    } failure:^(NSError *error) {
                        //[JDStatusBarNotification showWithStatus:@"请检查网络" dismissAfter:1.4];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论失败，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }];
                }
                
            }
        }

    }
    
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return interactionCommentsArray.count + 2;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *DetailCell = @"DetailCell";
    static NSString *CommentsCell = @"CommentsCell";
    static NSString *LastCell = @"LastCell";
    if (indexPath.row == 0) {
        detailCell = [[InteractionDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCell withData:inteDic];
        [detailCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        detailCell.delegate = self;
        return detailCell;
    }
    else if(indexPath.row >= interactionCommentsArray.count+1){
        LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
        if (cell == nil) {
            cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.label.textColor = TIME_COLOR_GARG;
        if (showMore) {
            if (interactionCommentsArray.count == 0) {
                cell.label.text = @"还没有评论哦~";
            }
            else{
                cell.label.text = @"没有更多喽~";
            }
            [cell.indicatorView stopAnimating];
        }
        else{
            cell.label.text = @"加载中...";
            [cell.indicatorView startAnimating];
            if (!isGetData) {
                [self moreInteractionComments];
                
            }
        }
        return cell;
    }
    else{
        NSDictionary *tempDic = [interactionCommentsArray objectAtIndex:indexPath.row - 1];
        commentsCell = [[InteractionCommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentsCell withData:tempDic];
        commentsCell.delegate = self;
        return commentsCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        detailCell = (InteractionDetailTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return detailCell.iHeight;
    }
    else if(indexPath.row == interactionCommentsArray.count+1){
        return 48;
    }
    else{
        commentsCell = (InteractionCommentsTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return commentsCell.height;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row > 0 && indexPath.row <= interactionCommentsArray.count) {
        NSDictionary *commentDic = [interactionCommentsArray objectAtIndex:indexPath.row - 1];
        if ([userInfo.userid isEqualToString:[commentDic objectForKey:@"commentuserid"]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能回复自己哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            if ([isJoin integerValue] != 1) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"参加了课程才能进行回复哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
}

#pragma mark - InteractionDetailTableViewCellDelegate
- (void)clickComment{
    if ([isJoin integerValue] != 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"参加了课程才能进行评论哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        isReply = NO;
        tipLabel.text = [NSString stringWithFormat:@"评论%@",[inteDic objectForKey:@"nickname"]];
        tipImage.hidden = NO;
        tipLabel.hidden = NO;
        [commentTextView becomeFirstResponder];
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
    
    [self refreshInteractionDetail];
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
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark - InteractionDetailTableViewCellDelegate
- (void)clickDetailHead{
    [self jumpPersonController:[inteDic objectForKey:@"discussionuserid"]];
}
- (void)clickDetailNickname{
    [self jumpPersonController:[inteDic objectForKey:@"discussionuserid"]];
}
- (void)clickLink:(NSString *)linkString{
    CourseWebViewController *webController = [[CourseWebViewController alloc] init];
    webController.urlString = linkString;
    [self.navigationController pushViewController:webController animated:YES];
}

#pragma mark - InteractionCommentTableViewCellDelegate
- (void)clickCommentHead:(NSString *)userid{
    [self jumpPersonController:userid];
}
- (void)clickReplyNickname:(NSString *)userid{
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
