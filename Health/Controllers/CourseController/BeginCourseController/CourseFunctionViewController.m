//
//  CourseFunctionViewController.m
//  Health
//
//  Created by cheng on 15/3/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseFunctionViewController.h"
#import "CourseDaySelectView.h"
#import "CourseInteractionViewController.h"
#import "CourseFunctionCell.h"
#import "CourseRequest.h"
#import "CourseInteractionTableViewCell.h"
#import "WriteInteractionViewController.h"
#import "CourseOtherInfoViewController.h"
#import "CourseStudentViewController.h"
#import "CourseActionItemViewController.h"
#import "InteractionDetailViewController.h"
#import "GroupChatViewController.h"
#import "CourseInfomationViewController.h"

@interface CourseFunctionViewController ()<CourseDaySelectViewDelegate, EGORefreshTableHeaderDelegate, UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    CourseDaySelectView *courseDaySelect;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    NSMutableArray *interactionArray;
    BOOL _reloading;
    BOOL showMore;
    BOOL isGetData;
    UserInfo *userInfo;
    NSString *isJoinCourse;
    
    CourseInteractionTableViewCell *interactionCell;
    
    UIView *chooseDiscussionTypeView;
    UILabel *titleLabel;

    NSString *userType;
    NSString *limitString;
    NSString *totalString;
    
    UIButton *groupChatButton;
    BOOL hasGroupUnread;
    
    AppDelegate *appDelegate;
}


@end

@implementation CourseFunctionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMessage) name:NOTIFICATION_CHAT object:nil];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [back setTitle:@"" forState:UIControlStateNormal];
    [back setFrame:CGRectMake(5, 2, 52, 30)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = barButton;
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createInteractionSuccess) name:@"createinteractionsuccess" object:nil];
    
    showMore = NO;
    isGetData = YES;
    _reloading = NO;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, SCREEN_WIDTH - 100, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:self.course.coursetitle];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    
    courseDaySelect = [[CourseDaySelectView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH*9/16 + 10) Course:self.course];
    courseDaySelect.delegate = self;
    NSInteger count_index = [self.course.courseday integerValue];
    NSInteger today_index = [CustomDate getDayToDate:[CustomDate getBirthdayDate:self.course.coursestarttime]] + 1;
    if (today_index <= 0 || today_index >= count_index) {
        actionofDay = [NSNumber numberWithInt:1];
    }else{
        actionofDay = [NSNumber numberWithInteger:today_index];
    }
    [courseDaySelect selectDayItem:^(NSString *days) {
        actionofDay = [NSNumber numberWithInt:[days intValue]];
        NSLog(@"%@",actionofDay);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = courseDaySelect;
    self.tableView.backgroundColor = CLEAR_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    if (self.course == nil) {
        [self getCourseData];
    }
//    else{
//        [self receiveMessage];
//    }
    
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - self.tableView.bounds.size.height, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        [self.tableView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    [self refreshInteractions];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(SCREEN_WIDTH - 50, 22, 40, 40);
    [sendButton setTitle:@"发帖" forState:UIControlStateNormal];
    //[sendButton setImage:[UIImage imageNamed:@"add_discussion"] forState:UIControlStateNormal];
    [sendButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
}
- (void)bClick{
    
    if (self.isChatIn) {
        appDelegate.rootNavigationController.navigationBarHidden = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createInteractionSuccess{
    [self refreshInteractions];

}

- (void)getCourseData{
    if (self.courseid == nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.course = [Course MR_findFirstByAttribute:@"courseid" withValue:self.courseid];
    if (self.course == nil) {
        self.course = [Course MR_createEntity];
        self.course.courseid = self.courseid;
    }
    [CourseRequest courseDetailMineWith:self.course success:^(id response) {
        [courseDaySelect setupUI:self.course];
        [self.tableView reloadData];
        titleLabel.text = self.course.coursetitle;
        //[self receiveMessage];
    } failure:^(NSError *error) {
    }];
}

- (void)refreshInteractions{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:self.course.courseid forKey:@"courseid"];
    [dic setObject:@"1" forKey:@"type"];
    [CourseRequest courseInteractionListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            interactionArray = [[NSMutableArray alloc] init];
            interactionArray = [response objectForKey:@"data"];
            isJoinCourse = [response objectForKey:@"flag"];
            userType = [response objectForKey:@"type"];
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
    [dic setObject:self.course.courseid forKey:@"courseid"];
    [dic setObject:@"1" forKey:@"type"];
    if (interactionArray.count != 0) {
        [dic setObject:limitString forKey:@"limit"];
    }
    [CourseRequest courseInteractionListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSMutableArray *moreArray = [[NSMutableArray alloc] init];
            [moreArray addObjectsFromArray:interactionArray];
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            tempArray = [response objectForKey:@"data"];
            limitString = [response objectForKey:@"limit"];
            totalString = [response objectForKey:@"total"];
            for(int i = 0; i < tempArray.count; i++){
                NSDictionary *tempDic = [tempArray objectAtIndex:i];
                if ([Util isEmpty:[tempDic objectForKey:@"discussoverhead"]]) {
                    [moreArray addObject:tempDic];
                }
            }
            interactionArray = moreArray;
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
        [self.tableView reloadData];
        isGetData = NO;
    } failure:^(NSError *error) {
        NSLog(@"检查网络");
        showMore = YES;
        [self.tableView reloadData];
        isGetData = NO;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - click Student

//- (void)clickStudent:(id)sender{
//    if (self.course == nil) {
//        return;
//    }
//    CourseStudentViewController *studentController = [[CourseStudentViewController alloc]init];
//    studentController.course = self.course;
//    [self.navigationController pushViewController:studentController animated:YES];
//}

#pragma mark - CourseDaySelectDelegate
- (void)clickCourseInfo{
    if (self.course == nil) {
        return;
    }
    CourseOtherInfoViewController *courseOtherInfoController = [[CourseOtherInfoViewController alloc]init];
    courseOtherInfoController.course = self.course;
    [self presentViewController:courseOtherInfoController animated:YES completion:^{
        
    }];
}

- (void)clickStartCourseAction:(NSInteger)index{
    actionofDay = [NSNumber numberWithInteger:index];
    
    NSInteger today_index = [CustomDate getDayToDate:[CustomDate getBirthdayDate:self.course.coursestarttime]] + 1;
    if (today_index<[actionofDay intValue]) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"选择课程进度" message:@"选择课程尚未开始" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    //判断是否是线下活动
    NSArray *tempCourseSub = [self.course.coursesub allObjects];
    NSPredicate *preTemplate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"coursesubday=='%ld'",(long)index]];
    actionCourseSub = [NSMutableArray arrayWithArray:[tempCourseSub filteredArrayUsingPredicate:preTemplate]];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"coursesuborder" ascending:YES];
    [actionCourseSub sortUsingDescriptors:[NSArray arrayWithObjects:sort,nil]];
    
    if (actionCourseSub.count == 0 || actionCourseSub == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"任务" message:@"没有任务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else{
        //CourseSub *courseSub = [actionCourseSub objectAtIndex:0];
        CourseActionItemViewController *actionItemController = [[CourseActionItemViewController alloc]init];
        actionItemController.course = self.course;
        actionItemController.actionOfDay = actionofDay;
        actionItemController.courseSubArray = actionCourseSub;
        [self.navigationController pushViewController:actionItemController animated:YES];
    }
}

- (void)sendButtonClick{
    if ([self.course.coursehastake integerValue] != 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没参加这个课程哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        WriteInteractionViewController *writeController = [[WriteInteractionViewController alloc] init];
        writeController.course = self.course;
        writeController.discutionType = @"question";
        writeController.coursesubDay = actionofDay;
        writeController.courseUserType = userType;
        [self.navigationController pushViewController:writeController animated:YES];
//        CourseInfomationViewController *controller = [[CourseInfomationViewController alloc] init];
//        controller.course_info = self.course;
//        [self.navigationController pushViewController:controller animated:YES];
        
    }
    
}


#pragma mark - 群消息提醒
//- (void)modifyUnreadMark{
//    if (hasGroupUnread) {
//        //有未读
//        [groupChatButton setImage:[UIImage imageNamed:@"course_group_message"] forState:UIControlStateNormal];
//    }else{
//        //没有
//        [groupChatButton setImage:[UIImage imageNamed:@"course_group_chat"] forState:UIControlStateNormal];
//    }
//}

/*
 群聊
 */
//- (void)receiveMessage{
//    NSInteger unreadInt = [[RCIM sharedRCIM]getUnreadCount:ConversationType_GROUP targetId:self.course.courseid];
//    if (unreadInt>0) {
//        hasGroupUnread = YES;
//        
//    }else{
//        hasGroupUnread = NO;
//        
//    }
//    
//    [self performSelectorOnMainThread:@selector(modifyUnreadMark) withObject:nil waitUntilDone:YES];
//}

//- (void)groupChatClick{
//    
//    if ([self.course.coursehastake intValue] != 1)  {
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"参与群聊" message:@"没有参与课程，不能参与群聊" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//        return;
//    }
//    else{
//    //groupChatButton.userInteractionEnabled = NO;
//        //[self joinGroup];
//        [[RCIM sharedRCIM] joinGroup:self.course.courseid groupName:self.course.coursetitle completion:^{
//            
//            //[self performSelectorOnMainThread:@selector(joinGroup) withObject:nil waitUntilDone:YES];
//            
//        } error:^(RCErrorCode status) {
//            
//            //groupChatButton.userInteractionEnabled = YES;
//        }];
//    }
//    
//    
//}
//- (void)joinGroup{
//    
//    
//    //groupChatButton.userInteractionEnabled = YES;
//    hasGroupUnread = NO;
//    [self modifyUnreadMark];
//    
//    GroupChatViewController *controller = [[GroupChatViewController alloc]init];
//    controller.currentTarget = self.course.courseid;
//    controller.currentTargetName = self.course.coursetitle;
//    controller.conversationType = ConversationType_GROUP;
//    controller.enableUnreadBadge = NO;
//    controller.enableVoIP = NO;
//    controller.portraitStyle = RCUserAvatarCycle;
//    
//    [self.navigationController pushViewController:controller animated:YES];
//    
//    self.navigationController.navigationBarHidden = NO;
//    
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return interactionArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Cell = @"Cell";
    static NSString *lastCell = @"LastCell";
    
    if (indexPath.row >= interactionArray.count){
        LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lastCell];
        if (cell == nil) {
            cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lastCell];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.label.textColor = TIME_COLOR_GARG;
        if (showMore) {
            cell.label.text = @"没有更多喽~";
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
    else{
        NSDictionary *interactionDic = [interactionArray objectAtIndex:indexPath.row];
        interactionCell = [[CourseInteractionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell withDic:interactionDic];
        interactionCell.backgroundColor = TABLEVIEWCELL_COLOR;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 59.5, SCREEN_WIDTH - 10, 0.5)];
        line.backgroundColor = LINE_COLOR_GARG;
        [interactionCell addSubview:line];

        //[interactionCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return interactionCell;
    }
    //    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < interactionArray.count) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        InteractionDetailViewController *detailController = [[InteractionDetailViewController alloc] init];
        NSDictionary *dic = [interactionArray objectAtIndex:indexPath.row];
        detailController.interactionId = [dic objectForKey:@"id"];
        detailController.interactionDic = dic;
        [self.navigationController pushViewController:detailController animated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        return 60;
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
    [self.tableView reloadData];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
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
