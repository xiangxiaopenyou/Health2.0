//
//  CourseFunctionTableViewController.m
//  Health
//
//  Created by cheng on 15/1/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseFunctionTableViewController.h"
#import "CourseDaySelectView.h"
#import "CourseDetailViewController.h"
#import "CourseTrendsViewController.h"
#import "CourseInteractionViewController.h"
#import "CourseFunctionCell.h"
#import "CourseRequest.h"
#import "CourseInteractionTableViewCell.h"
#import "FitLiveViewController.h"
#import "WriteInteractionViewController.h"
#import "WriteFitLifeViewController.h"
#import "CourseSubOfflineViewController.h"
#import "CourseOtherInfoViewController.h"
#import "CourseStudentViewController.h"
#import "CourseActionItemViewController.h"
#import "InteractionDetailViewController.h"

@interface CourseFunctionTableViewController()<CourseDaySelectViewDelegate, EGORefreshTableHeaderDelegate, UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    CourseDaySelectView *courseDaySelect;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    NSMutableArray *interactionArray;
    BOOL _reloading;
    BOOL showMore;
    BOOL isGetData;
    UserInfo *userInfo;
    int *isJoinCourse;
    
    CourseInteractionTableViewCell *interactionCell;
    
    UIView *chooseDiscussionTypeView;
}

@end

@implementation CourseFunctionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:18/255.0 green:18/255.0 blue:19/255.0 alpha:1.0];
    
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    showMore = NO;
    isGetData = YES;
    _reloading = NO;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_LABEL_X, TITLE_LABEL_Y, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:self.course.coursetitle];//课程名
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] init];
    leftButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = leftButtonItem;
    
    
    courseDaySelect = [[CourseDaySelectView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*9/16+45) Course:self.course];
    courseDaySelect.delegate = self;
    [courseDaySelect selectDayItem:^(NSString *days) {
        actionofDay = [NSNumber numberWithInt:[days intValue]];
        NSLog(@"%@",actionofDay);
    }];
    
    self.tableView.tableHeaderView = courseDaySelect;
//    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor colorWithRed:18/255.0 green:18/255.0 blue:19/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.tableView.showsVerticalScrollIndicator = NO;
    if (self.course == nil) {
        [self getCourseData];
    }
    
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - self.tableView.bounds.size.height, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        [self.tableView addSubview:_refreshHeaderView];
        
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    [self refreshInteractions];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(SCREEN_WIDTH - 68, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 104, 44, 44);
    [sendButton setImage:[UIImage imageNamed:@"add_discussion"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    UIButton *fitlifeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fitlifeButton.frame = CGRectMake(SCREEN_WIDTH - 68, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 54, 44, 44);
    [fitlifeButton setImage:[UIImage imageNamed:@"show_fitlive"] forState:UIControlStateNormal];
    [fitlifeButton addTarget:self action:@selector(fitLifeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fitlifeButton];

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
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)refreshInteractions{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:self.course.courseid forKey:@"courseid"];
    [CourseRequest courseInteractionListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            interactionArray = [[NSMutableArray alloc] init];
            interactionArray = [response objectForKey:@"data"];
            isJoinCourse = [[response objectForKey:@"flag"] integerValue];
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
    if (interactionArray.count != 0) {
        NSDictionary *tempDic = [interactionArray lastObject];
        [dic setObject:[tempDic objectForKey:@"created_time"] forKey:@"time"];
    }
    [CourseRequest courseInteractionListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            [interactionArray addObjectsFromArray:[response objectForKey:@"data"]];
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

- (void)clickStudent:(id)sender{
    if (self.course == nil) {
        return;
    }
    CourseStudentViewController *studentController = [[CourseStudentViewController alloc]init];
    studentController.course = self.course;
    [self.navigationController pushViewController:studentController animated:YES];
}
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
    }else{
        CourseSub *courseSub = [actionCourseSub objectAtIndex:0];
        if ([courseSub.coursesubtype integerValue] == 1) {
            CourseActionItemViewController *actionItemController = [[CourseActionItemViewController alloc]init];
            actionItemController.course = self.course;
            actionItemController.actionOfDay = actionofDay;
            actionItemController.courseSubArray = actionCourseSub;
            [self.navigationController pushViewController:actionItemController animated:YES];
        }else{
            CourseSubOfflineViewController *offlineController = [[CourseSubOfflineViewController alloc]init];
            offlineController.course = self.course;
            offlineController.courseSubArray = actionCourseSub;
            [self.navigationController pushViewController:offlineController animated:YES];
        }
    }
}

- (void)sendButtonClick{
//    WriteInteractionViewController *writeController = [[WriteInteractionViewController alloc] init];
//    writeController.course = self.course;
//    [self.navigationController pushViewController:writeController animated:YES];
//    WriteFitLifeViewController *writeController = [[WriteFitLifeViewController alloc] init];
    //writeController.course = self.course;
//    [self.navigationController pushViewController:writeController animated:YES];
    self.navigationController.navigationBarHidden = YES;
    chooseDiscussionTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    chooseDiscussionTypeView.backgroundColor = [UIColor grayColor];
    
    UIImageView *foodImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 177, 64, 64)];
    foodImage.image = [UIImage imageNamed:@"interaction_food"];
    [chooseDiscussionTypeView addSubview:foodImage];
    
    UILabel *foodLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 243, 64, 20)];
    foodLabel.text = @"食物";
    foodLabel.textColor = [UIColor whiteColor];
    foodLabel.textAlignment = NSTextAlignmentCenter;
    foodLabel.font = SMALLFONT_14;
    [chooseDiscussionTypeView addSubview:foodLabel];
    
    UIButton *foodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    foodButton.frame = CGRectMake(25, 177, 64, 90);
    [foodButton addTarget:self action:@selector(foodClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseDiscussionTypeView addSubview:foodButton];
    
    UIImageView *sportsImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 32, 177, 64, 64)];
    sportsImage.image = [UIImage imageNamed:@"interaction_sports"];
    [chooseDiscussionTypeView addSubview:sportsImage];
    
    UILabel *sportsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 32, 243, 64, 20)];
    sportsLabel.text = @"运动";
    sportsLabel.textColor = [UIColor whiteColor];
    sportsLabel.textAlignment = NSTextAlignmentCenter;
    sportsLabel.font = SMALLFONT_14;
    [chooseDiscussionTypeView addSubview:sportsLabel];
    
    UIButton *sportsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sportsButton.frame = CGRectMake(SCREEN_WIDTH/2 - 32, 177, 64, 90);
    [sportsButton addTarget:self action:@selector(sportsClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseDiscussionTypeView addSubview:sportsButton];
    
    UIImageView *showImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 89, 177, 64, 64)];
    showImage.image = [UIImage imageNamed:@"interaction_show"];
    [chooseDiscussionTypeView addSubview:showImage];
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 89, 243, 64, 20)];
    showLabel.text = @"show";
    showLabel.textColor = [UIColor whiteColor];
    showLabel.textAlignment = NSTextAlignmentCenter;
    showLabel.font = SMALLFONT_14;
    [chooseDiscussionTypeView addSubview:showLabel];
    UIButton *showButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showButton.frame = CGRectMake(SCREEN_WIDTH - 89, 177, 64, 90);
    [showButton addTarget:self action:@selector(showClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseDiscussionTypeView addSubview:showButton];
    
    UIImageView *questionImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 293, 64, 64)];
    questionImage.image = [UIImage imageNamed:@"interaction_question"];
    [chooseDiscussionTypeView addSubview:questionImage];
    UILabel *questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 359, 64, 20)];
    questionLabel.text = @"提问";
    questionLabel.textColor = [UIColor whiteColor];
    questionLabel.textAlignment = NSTextAlignmentCenter;
    questionLabel.font = SMALLFONT_14;
    [chooseDiscussionTypeView addSubview:questionLabel];
    UIButton *questionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    questionButton.frame = CGRectMake(30, 293, 50, 90);
    [questionButton addTarget:self action:@selector(questionClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseDiscussionTypeView addSubview:questionButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(SCREEN_WIDTH - 67, SCREEN_HEIGHT - 74, 42, 42);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseDiscussionTypeView addSubview:cancelButton];
    
    [self.view addSubview:chooseDiscussionTypeView];

}

- (void)fitLifeClick{
    FitLiveViewController *fitController = [[FitLiveViewController alloc] init];
    fitController.courseid = self.course.courseid;
    [self.navigationController pushViewController:fitController animated:YES];
}

/*
 选择类型页面按钮点击
 */
- (void)foodClick{
    WriteFitLifeViewController *writeController = [[WriteFitLifeViewController alloc] init];
    writeController.course = self.course;
    writeController.discussionType = @"food";
    [self.navigationController pushViewController:writeController animated:YES];
    self.navigationController.navigationBarHidden = NO;
    [chooseDiscussionTypeView removeFromSuperview];
}
- (void)sportsClick{
    WriteFitLifeViewController *writeController = [[WriteFitLifeViewController alloc] init];
    writeController.course = self.course;
    writeController.discussionType = @"sports";
    [self.navigationController pushViewController:writeController animated:YES];
    self.navigationController.navigationBarHidden = NO;
    [chooseDiscussionTypeView removeFromSuperview];
}
- (void)showClick{
    WriteFitLifeViewController *writeController = [[WriteFitLifeViewController alloc] init];
    writeController.course = self.course;
    writeController.discussionType = @"show";
    [self.navigationController pushViewController:writeController animated:YES];
    self.navigationController.navigationBarHidden = NO;
    [chooseDiscussionTypeView removeFromSuperview];
}
- (void)questionClick{
    WriteInteractionViewController *writeController = [[WriteInteractionViewController alloc] init];
    writeController.course = self.course;
    writeController.discutionType = @"question";
    [self.navigationController pushViewController:writeController animated:YES];
    self.navigationController.navigationBarHidden = NO;
    [chooseDiscussionTypeView removeFromSuperview];
}
- (void)cancelClick{
    self.navigationController.navigationBarHidden= NO;
    [chooseDiscussionTypeView removeFromSuperview];
}

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
    static NSString *identifier = @"cell";
    static NSString *Cell = @"Cell";
    static NSString *lastCell = @"LastCell";
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[CourseFunctionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.backgroundColor = [UIColor colorWithRed:18/255.0 green:18/255.0 blue:19/255.0 alpha:1.0];
        UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 8, 24, 24)];
        titleImage.image = [UIImage imageNamed:@"discussion_title"];
        [cell addSubview:titleImage];
        //标题
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 8, SCREEN_WIDTH - 85, 24)];
        title.text = @"FIT LIFE";
        title.textColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:255/255.0 alpha:1.0];
        title.font = SMALLFONT_16;
        title.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:title];
        
        //说明
        UILabel *intro = [[UILabel alloc] initWithFrame:CGRectMake(12, 42, SCREEN_WIDTH - 30, 30)];
        intro.numberOfLines = 2;
        intro.lineBreakMode = NSLineBreakByCharWrapping;
        intro.text = @"有问题的同学可以开贴提问，我都会尽快解答。请同学们不要灌水，发帖标题尽量贴近主题";
        intro.textColor = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1.0];
        intro.font = SMALLFONT_12;
        intro.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:intro];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if (indexPath.row >= interactionArray.count){
        LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lastCell];
        if (cell == nil) {
            cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lastCell];
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
                [self moreInteractions];
                
            }
        }
        return cell;
    }
    else{
        NSDictionary *interactionDic = [interactionArray objectAtIndex:indexPath.row - 1];
        interactionCell = [[CourseInteractionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell withDic:interactionDic];
        if (indexPath.row%2 == 0) {
            interactionCell.backgroundColor = [UIColor colorWithRed:18/255.0 green:18/255.0 blue:19/255.0 alpha:1.0];
        }
        else{
            interactionCell.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:32/255.0 alpha:1.0];
        }
        [interactionCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return interactionCell;
    }
//    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row >= interactionArray.count) {
//        CourseInteractionViewController *interactionController = [[CourseInteractionViewController alloc] init];
//        interactionController.course = self.course;
//        [self.navigationController pushViewController:interactionController animated:YES];
//        FitLiveViewController *fitController = [[FitLiveViewController alloc] init];
//        [self.navigationController pushViewController:fitController animated:YES];
    }
    else{
//        CourseTrendsViewController *trendController = [[CourseTrendsViewController alloc] init];
//        trendController.course = self.course;
//        [self.navigationController pushViewController:trendController animated:YES];
        InteractionDetailViewController *detailController = [[InteractionDetailViewController alloc] init];
        NSDictionary *dic = [interactionArray objectAtIndex:indexPath.row - 1];
        detailController.interactionId = [dic objectForKey:@"id"];
        detailController.interactionDic = dic;
        [self.navigationController pushViewController:detailController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 85;
    }
    else{
        return 60;
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
