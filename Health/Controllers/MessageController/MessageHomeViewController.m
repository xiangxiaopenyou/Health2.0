//
//  MessageHomeViewController.m
//  Health
//
//  Created by realtech on 15/4/20.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MessageHomeViewController.h"
#import "MessageReplyCell.h"
#import "MessageFavoriteCell.h"
#import "MessageRequest.h"
#import "MessageEntity.h"
#import "TrendDetailViewController.h"
#import "RCConversation.h"
#import "ChatListCell.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "GroupChatViewController.h"
#import "InteractionDetailViewController.h"
#import "ClubDiscussionDetailViewController.h"
#import "ClockinDetailViewController.h"
#import "ActivityWebViewController.h"


#define NOTREAD_COLOR [UIColor redColor]

@interface MessageHomeViewController ()<UITableViewDataSource, UITableViewDelegate>{
    UIButton *chatButton;
    UIButton *replyButton;
    UIButton *favoriteButton;
    UIButton *systemButton;
    UILabel *markLabel;
    
    UILabel *dontReadChat;
    UILabel *dontReadReply;
    UILabel *dontReadFavorite;
    UILabel *dontReadSystem;
    
    UIView *viewForTable;
    UITableView *chatTableView;
    UITableView *replyTableView;
    UITableView *favoriteTableView;
    UITableView *systemTableView;
    
    NSInteger currentIndex;
    
    EGORefreshTableHeaderView *_refreshChatList;
    BOOL _reloadChatList;
    
    EGORefreshTableHeaderView *_refreshReply;
    BOOL _reloadReply;
    
    EGORefreshTableHeaderView *_refreshFavorite;
    BOOL _reloadFavorite;
    
    EGORefreshTableHeaderView *_refreshSystem;
    BOOL _reloadSystem;
    
    BOOL _moreLoadReply;//判断是否正在加载
    BOOL _moreLoadFavorite;
    
    BOOL _showMoreReply;//判断是否有更多数据
    BOOL _showMoreFavorite;
    
    BOOL _showMoreSystem;
    BOOL _moreLoadSystem;
    
    NSMutableArray *favoriteArray;
    NSMutableArray *replyArray;
    NSMutableArray *chatListArray;
    NSMutableArray *systemMessageArray;
    
    UserInfo *userInfo;
    
    AppDelegate *appDelegate;

}

@end

@implementation MessageHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    _showMoreFavorite = NO;
    _showMoreReply = NO;
    _showMoreSystem = NO;
    _moreLoadReply = YES;
    _moreLoadFavorite = YES;
    _moreLoadSystem = YES;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"消息"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    [self setupData];
   
    [self setupSegment];
    [self addTableView];
    
    //[self chatClick];
//    [self refreshFavorite];
//    [self refreshReply];
//    [self refreshSystemMessage];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setupMark) name:GETALLMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshChatList) name:NOTIFICATION_CHAT object:nil];
    [self setupMark];
    

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshChatList];
}


- (void)setupData{
    favoriteArray = [[NSMutableArray alloc]init];
    replyArray = [[NSMutableArray alloc]init];
    systemMessageArray = [[NSMutableArray alloc] init];
    // [self refreshReply];
}
- (void)setupSegment{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 43)];
    headerView.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chatButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, 43);
    [chatButton setTitle:@"聊天" forState:UIControlStateNormal];
    [chatButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    chatButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [chatButton addTarget:self action:@selector(chatClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:chatButton];
    dontReadChat = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3-40, 8, 8, 8)];
    dontReadChat.backgroundColor = NOTREAD_COLOR;
    dontReadChat.layer.cornerRadius = 8;
    dontReadChat.layer.masksToBounds = YES;
    //    [chatButton addSubview:dontReadChat];
    
    replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    replyButton.frame = CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, 43);
    [replyButton setTitle:@"回复" forState:UIControlStateNormal];
    [replyButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    replyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [replyButton addTarget:self action:@selector(replyClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:replyButton];
    dontReadReply = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4-30, 8, 8, 8)];
    dontReadReply.backgroundColor = NOTREAD_COLOR;
    dontReadReply.layer.cornerRadius = 4;
    dontReadReply.layer.masksToBounds = YES;
    [replyButton addSubview:dontReadReply];
    
    favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteButton.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/4, 43);
    [favoriteButton setTitle:@"赞我" forState:UIControlStateNormal];
    [favoriteButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [favoriteButton addTarget:self action:@selector(favoriteClick) forControlEvents:UIControlEventTouchUpInside];
    favoriteButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:favoriteButton];
    dontReadFavorite = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4-30, 8, 8, 8)];
    dontReadFavorite.backgroundColor = NOTREAD_COLOR;
    dontReadFavorite.layer.cornerRadius = 4;
    dontReadFavorite.layer.masksToBounds = YES;
    [favoriteButton addSubview:dontReadFavorite];
    
    systemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    systemButton.frame = CGRectMake(3*SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, 43);
    [systemButton setTitle:@"系统" forState:UIControlStateNormal];
    [systemButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [systemButton addTarget:self action:@selector(systemClick) forControlEvents:UIControlEventTouchUpInside];
    systemButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:systemButton];
    
//    dontReadSystem = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4-30, 8, 8, 8)];
//    dontReadSystem.backgroundColor = NOTREAD_COLOR;
//    dontReadSystem.layer.cornerRadius = 4;
//    dontReadSystem.layer.masksToBounds = YES;
//    [systemButton addSubview:dontReadSystem];
    
    currentIndex = 0;
    
    markLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/8 - 22, 40, 44, 3)];
    markLabel.backgroundColor = MAIN_COLOR_YELLOW;
    [headerView addSubview:markLabel];
    [self.view addSubview:headerView];
}

- (void)addTableView{
    viewForTable = [[UIView alloc]initWithFrame:CGRectMake(0, 43 + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH*4, SCREEN_HEIGHT-TABBAR_HEIGHT- 43 - NAVIGATIONBAR_HEIGHT)];
    viewForTable.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;

    chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, viewForTable.frame.size.height)];
    chatTableView.delegate = self;
    chatTableView.dataSource = self;
    //chatTableView.tableFooterView = [[UIView alloc]init];
    chatTableView.backgroundColor = [UIColor clearColor];
    chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [viewForTable addSubview:chatTableView];
    //    if (_refreshChatList == nil) {
    //        _refreshChatList = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - chatTableView.bounds.size.height, chatTableView.frame.size.width, chatTableView.bounds.size.height)];
    //        _refreshChatList.delegate = self;
    //        _refreshChatList.backgroundColor = [UIColor clearColor];
    //        [chatTableView addSubview:_refreshChatList];
    //    }
    //    [_refreshChatList refreshLastUpdatedDate];
    
    replyTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, viewForTable.frame.size.height)];
    replyTableView.delegate = self;
    replyTableView.dataSource = self;
    //replyTableView.tableFooterView = [[UIView alloc]init];
    replyTableView.backgroundColor = [UIColor clearColor];
    replyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [viewForTable addSubview:replyTableView];
    
    if (_refreshReply == nil) {
        _refreshReply = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - replyTableView.bounds.size.height, replyTableView.frame.size.width, replyTableView.bounds.size.height)];
        _refreshReply.delegate = self;
        _refreshReply.backgroundColor = [UIColor clearColor];
        [replyTableView addSubview:_refreshReply];
    }
    [_refreshReply refreshLastUpdatedDate];
    
    favoriteTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, viewForTable.frame.size.height)];
    favoriteTableView.dataSource = self;
    favoriteTableView.delegate = self;
    //favoriteTableView.tableFooterView = [[UIView alloc]init];
    favoriteTableView.backgroundColor = [UIColor clearColor];
    favoriteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [viewForTable addSubview:favoriteTableView];
    if (_refreshFavorite == nil) {
        _refreshFavorite = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - favoriteTableView.bounds.size.height, favoriteTableView.frame.size.width, favoriteTableView.bounds.size.height)];
        _refreshFavorite.delegate = self;
        _refreshFavorite.backgroundColor = [UIColor clearColor];
        [favoriteTableView addSubview:_refreshFavorite];
    }
    [_refreshFavorite refreshLastUpdatedDate];
    
    systemTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, viewForTable.frame.size.height)];
    systemTableView.delegate = self;
    systemTableView.dataSource = self;
    systemTableView.backgroundColor = CLEAR_COLOR;
    systemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [viewForTable addSubview:systemTableView];
    
    if (_refreshSystem == nil) {
        _refreshSystem = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - systemTableView.bounds.size.height, systemTableView.frame.size.width, systemTableView.bounds.size.height)];
        _refreshSystem.delegate = self;
        _refreshSystem.backgroundColor = [UIColor clearColor];
        [systemTableView addSubview:_refreshSystem];
    }
    [_refreshSystem refreshLastUpdatedDate];
    
    [self.view addSubview:viewForTable];
}



- (void)chatClick{
    //去掉未读提醒  marklabel位置移动  字体颜色改变
    currentIndex = 0;
    [chatButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    [replyButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [favoriteButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [systemButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [self refreshChatList];
    [UIView animateWithDuration:0.2 animations:^{
        markLabel.frame = CGRectMake(SCREEN_WIDTH/8 - 22, 40, 44, 3);
        viewForTable.frame = CGRectMake(0, 43 + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH*4, SCREEN_HEIGHT-TABBAR_HEIGHT- 43 - NAVIGATIONBAR_HEIGHT);
    }];
    
}

- (void)replyClick{
    currentIndex = 1;
    [chatButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [replyButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    [favoriteButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [systemButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [self refreshReply];
    [[NSNotificationCenter defaultCenter] postNotificationName:GETALLMESSAGE object:@YES];
    [UIView animateWithDuration:0.2 animations:^{
        markLabel.frame = CGRectMake(3*SCREEN_WIDTH/8-22, 40, 44, 3);
        //[replyTableView reloadData];
        viewForTable.frame = CGRectMake(-SCREEN_WIDTH, 43 + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH*4, SCREEN_HEIGHT-TABBAR_HEIGHT- 43 - NAVIGATIONBAR_HEIGHT);
    }];
    [self doneLoadingTableViewData];
    [self setupMark];
}

- (void)favoriteClick{
    currentIndex = 2;
    [chatButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [replyButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [favoriteButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    [systemButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [self refreshFavorite];
    [[NSNotificationCenter defaultCenter] postNotificationName:GETALLMESSAGE object:@YES];
    [UIView animateWithDuration:0.2 animations:^{
        markLabel.frame = CGRectMake(5*SCREEN_WIDTH/8-22, 40, 44, 3);
        //[favoriteTableView reloadData];
        viewForTable.frame = CGRectMake(-SCREEN_WIDTH*2, 43 + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH*4, SCREEN_HEIGHT-TABBAR_HEIGHT- 43 - NAVIGATIONBAR_HEIGHT);
    }];
    [self doneLoadingTableViewData];
    
    [self setupMark];
}
- (void)systemClick{
    currentIndex = 3;
    [chatButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [replyButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [favoriteButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    [systemButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    [self refreshSystemMessage];
    [UIView animateWithDuration:0.2 animations:^{
        markLabel.frame = CGRectMake(7*SCREEN_WIDTH/8 - 22, 40, 44, 3);
        //[favoriteTableView reloadData];
        viewForTable.frame = CGRectMake(-SCREEN_WIDTH*3, 43 + NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH*4, SCREEN_HEIGHT-TABBAR_HEIGHT-43 - NAVIGATIONBAR_HEIGHT);
    }];
    [self doneLoadingTableViewData];
}

- (void)setupMark{
    UserData *userdata = [UserData shared];
    if (userdata.replyNum.intValue !=0) {
        [self refreshReply];
        [dontReadReply setHidden:NO];
    }else{
        [dontReadReply setHidden:YES];
    }
    if (userdata.favoriteNum.intValue !=0) {
        [self refreshFavorite];
        [dontReadFavorite setHidden:NO];
    }else{
        [dontReadFavorite setHidden:YES];
    }
}

- (void)refreshChatList{
    //[chatListArray removeAllObjects];
    
    chatListArray = [NSMutableArray arrayWithArray:[[RCIM sharedRCIM]getConversationList:[NSArray arrayWithObjects:[NSNumber numberWithInt:ConversationType_PRIVATE],[NSNumber numberWithInt:ConversationType_GROUP], nil]]];
    //[[RCIM sharedRCIM] clearConversations:[NSArray arrayWithObjects:[NSNumber numberWithInt:ConversationType_GROUP], nil]];
    [chatTableView reloadData];
    
}

- (void)refreshReply{
    
    UserData *userdata = [UserData shared];
    userdata.replyNum = [NSNumber numberWithInt:0];
    [self setupMark];
    [MessageRequest replyListRefreshWith:replyArray success:^(id response) {
        if ([[response objectForKey:@"count"] intValue] < 10) {
            _showMoreReply = YES;//不显示更多
        }else{
            _showMoreReply = NO;
        }
        _moreLoadReply = NO;
        [self sortData];
    } failure:^(NSError *error) {
        [self doneLoadingTableViewData];
    }];
}
- (void)refreshFavorite{
    UserData *userdata = [UserData shared];
    userdata.favoriteNum = [NSNumber numberWithInt:0];
    [self setupMark];
    [MessageRequest favoriteListRefreshWith:favoriteArray success:^(id response) {
        if ([[response objectForKey:@"count"] intValue] < 10) {
            _showMoreFavorite = YES;//不显示更多
        }else{
            _showMoreFavorite = NO;
        }
        _moreLoadFavorite = NO;
        [self sortData];
    } failure:^(NSError *error) {
        [self doneLoadingTableViewData];
    }];
}
- (void)loadMoreReply{//加载更多回复
    [MessageRequest replyListWith:replyArray success:^(id response) {
        if ([[response objectForKey:@"count"] intValue] < 10) {
            _showMoreReply = YES;//不显示更多
        }else{
            _showMoreReply = NO;
        }
        _moreLoadReply = NO;//没有正在加载
        [self sortData];
    } failure:^(NSError *error) {
        [self doneLoadingTableViewData];
    }];
}
-(void)loadMoreFavorite{//加载更多赞
    [MessageRequest favoriteListWith:favoriteArray success:^(id response) {
        if ([[response objectForKey:@"count"] intValue] < 10) {
            _showMoreFavorite = YES;//不显示更多
        }else{
            _showMoreFavorite = NO;
        }
        _moreLoadFavorite = NO;
        [self sortData];
    } failure:^(NSError *error) {
        [self doneLoadingTableViewData];
    }];
}
- (void)refreshSystemMessage{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", nil];
    [MessageRequest getSystemMessage:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            systemMessageArray = [response objectForKey:@"data"];
            if ([[response objectForKey:@"count"] integerValue] < 10) {
                _showMoreSystem = YES;
            }
            else {
                _showMoreSystem = NO;
            }
        }
        else {
            _showMoreSystem = YES;
        }
        _moreLoadSystem = NO;
        [self doneLoadingTableViewData];
    } failure:^(NSError *error) {
        [self doneLoadingTableViewData];
    }];
}
- (void)moreSystemMessage {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", nil];
    NSString *time = [[systemMessageArray lastObject] objectForKey:@"created_time"];
    [dic setObject:time forKey:@"time"];
    [MessageRequest getSystemMessage:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            systemMessageArray = [response objectForKey:@"data"];
            if ([[response objectForKey:@"count"] integerValue] < 10) {
                _showMoreSystem = YES;
            }
            else {
                _showMoreSystem = NO;
            }
        }
        else {
            _showMoreSystem = YES;
        }
        _moreLoadSystem = NO;
        [systemTableView reloadData];
    } failure:^(NSError *error) {
        [systemTableView reloadData];
    }];
}

- (void)sortData{
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"favoriteTime" ascending:NO];
    [favoriteArray sortUsingDescriptors:[NSArray arrayWithObjects:sort,nil]];
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"replyTime" ascending:NO];
    [replyArray sortUsingDescriptors:[NSArray arrayWithObjects:sort1, nil]];
    [self doneLoadingTableViewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    static NSString *LastCell = @"LastCell";
    switch (currentIndex) {
        case 0:{
            static NSString *indentifier = @"ChatListCell";
            //ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
            //if (cell == nil) {
            ChatListCell *cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
                //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            //}
            
            RCConversation *conversation = [chatListArray objectAtIndex:indexPath.row];
            if (conversation.conversationType == ConversationType_PRIVATE) {
                
                RCMessageContent *lastMessage = conversation.lastestMessage;
                AppDelegate *appDeledate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [appDeledate getUserInfoWithUserId:conversation.targetId completion:^(RCUserInfo *user) {
                    [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                    cell.nameLabel.text = user.name;
                }];
                if (conversation.unreadMessageCount <= 0) {
                    cell.notReadLabel.hidden = YES;
                }else if (conversation.unreadMessageCount <= 99){
                    cell.notReadLabel.text = [NSString stringWithFormat:@"%ld",(long)conversation.unreadMessageCount];
                }else{
                    cell.notReadLabel.text = @"99";
                }
                if ([lastMessage isKindOfClass:[RCTextMessage class]]) {
                    RCTextMessage *message = (RCTextMessage*)lastMessage;
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",message.content];
                }else if([lastMessage isKindOfClass:[RCImageMessage class]]){
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",@"发来一张图片"];
                }else if([lastMessage isKindOfClass:[RCVoiceMessage class]]){
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",@"发来一段语言"];
                }else if([lastMessage isKindOfClass:[RCRichContentMessage class]]){
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",@"发来一个链接"];
                }else if([lastMessage isKindOfClass:[RCLocationMessage class]]){
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",@"发来一个位置"];
                }
                cell.timeLabel.text = [CustomDate getDateStringToDete:[CustomDate getStringFromDate:[NSDate dateWithTimeIntervalSince1970:conversation.receivedTime/1000]]];
                
            }else if (conversation.conversationType == ConversationType_GROUP){
                
                RCMessageContent *lastMessage = conversation.lastestMessage;
                AppDelegate *appDeledate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [appDeledate getGroupInfoWithGroupId:conversation.targetId completion:^(RCGroup *group) {
                    
                    [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:group.portraitUri] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                    cell.nameLabel.text = group.groupName;
                } ];
                
                if (conversation.unreadMessageCount <= 0) {
                    cell.notReadLabel.hidden = YES;
                }else if (conversation.unreadMessageCount <= 99){
                    cell.notReadLabel.text = [NSString stringWithFormat:@"%ld",(long)conversation.unreadMessageCount];
                }else{
                    cell.notReadLabel.text = @"99";
                }
                
                
                [appDeledate getUserInfoWithUserId:conversation.senderUserId completion:^(RCUserInfo *user) {
                    
                    if ([lastMessage isKindOfClass:[RCTextMessage class]]) {
                        RCTextMessage *message = (RCTextMessage*)lastMessage;
                        cell.contentLabel.text = [NSString stringWithFormat:@"%@:%@",user.name,message.content];
                    }else if([lastMessage isKindOfClass:[RCImageMessage class]]){
                        cell.contentLabel.text = [NSString stringWithFormat:@"%@:%@",user.name,@"发来一张图片"];
                    }else if([lastMessage isKindOfClass:[RCVoiceMessage class]]){
                        cell.contentLabel.text = [NSString stringWithFormat:@"%@:%@",user.name,@"发来一段语言"];
                    }else if([lastMessage isKindOfClass:[RCRichContentMessage class]]){
                        cell.contentLabel.text = [NSString stringWithFormat:@"%@:%@",user.name,@"发来一个链接"];
                    }else if([lastMessage isKindOfClass:[RCLocationMessage class]]){
                        cell.contentLabel.text = [NSString stringWithFormat:@"%@:%@",user.name,@"发来一个位置"];
                    }
                }];
                cell.timeLabel.text = [CustomDate getDateStringToDete:[CustomDate getStringFromDate:[NSDate dateWithTimeIntervalSince1970:conversation.receivedTime/1000]]];
            }
            cell.backgroundColor = TABLEVIEWCELL_COLOR;
            return cell;
        }break;
        case 1:{
            if (indexPath.row >= replyArray.count) {
                LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
                if (cell == nil) {
                    cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.backgroundColor = [UIColor clearColor];
                cell.label.textColor = TIME_COLOR_GARG;
                if (_showMoreReply) {
                    if (replyArray.count == 0) {
                        cell.label.text = @"";
                    }
                    else{
                        cell.label.text = @"没有更多喽~";
                    }
                    [cell.indicatorView stopAnimating];
                }
                else{
                    cell.label.text = @"加载中...";
                    [cell.indicatorView startAnimating];
                    if (!_moreLoadReply) {
                        //_moreLoadReply = YES;
                        [self loadMoreReply];
                    }
                }return cell;
            }else{
                MessageReplyCell *replycell = [replyTableView dequeueReusableCellWithIdentifier:identifier];
                if (replycell == nil) {
                    replycell = [[MessageReplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                MessageReplyEntity *reply = [replyArray objectAtIndex:indexPath.row];
                
                [replycell.portraitImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:reply.userPortrait]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                replycell.nameLabel.text = reply.username;
                replycell.contentLabel.text = reply.replyContent;
                NSString *timeString;
                NSDate *date = [CustomDate getTimeDate:reply.replyTime];
                if ([[CustomDate compareDate:date] isEqualToString:@"今天"]) {
                    timeString = [reply.replyTime substringWithRange:NSMakeRange(11, 5)];
                }
                else if ([[CustomDate compareDate:date] isEqualToString:@"昨天"]){
                    timeString = @"昨天";
                    //timeString = [timeString stringByAppendingString:@" "];
                    timeString = [timeString stringByAppendingString:[reply.replyTime substringWithRange:NSMakeRange(11, 5)]];
                }
                else{
                    timeString = [reply.replyTime substringWithRange:NSMakeRange(5, 11)];
                }
                replycell.timeLabel.text = timeString;
                if ([reply.replyType isEqualToString:@"trendscomment"]) {
                    if ([reply.replyTrendType  integerValue] == 1) {
                        replycell.fromLabel.text = [NSString stringWithFormat:@"来自秀一秀的回复"];
                    }
                    else {
                        replycell.fromLabel.text = [NSString stringWithFormat:@"来自打卡的回复"];
                    }
                    
                }
                else if([reply.replyType isEqualToString:@"coursecomment"]){
                    if ([Util isEmpty:reply.replyTitle] ||[reply.replyTitle isEqualToString:@"<null>"]) {
                        replycell.fromLabel.text = [NSString stringWithFormat:@"来自训练营的回复"];
                    }
                    else{
                        
                        replycell.fromLabel.text = [NSString stringWithFormat:@"来自%@的回复", reply.replyTitle];
                    }
                }
                else{
                    if ([Util isEmpty:reply.replyTitle] || [reply.replyTitle isEqualToString:@"<null>"]){
                        replycell.fromLabel.text = [NSString stringWithFormat:@"来自俱乐部的回复"];
                        
                    }
                    else{
                        replycell.fromLabel.text = [NSString stringWithFormat:@"来自%@的回复", reply.replyTitle];
                    }
                }
                [replycell.photoimage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:reply.replyPhoto]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                
                replycell.backgroundColor = TABLEVIEWCELL_COLOR;
                return replycell;
            }
        }break;
        case 2:{
            if (indexPath.row >= favoriteArray.count) {
                
                LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
                if (cell == nil) {
                    cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.backgroundColor = [UIColor clearColor];
                cell.label.textColor = TIME_COLOR_GARG;
                if (_showMoreFavorite) {
                    if (favoriteArray.count == 0) {
                        cell.label.text = @"";
                    }
                    else{
                        cell.label.text = @"没有更多喽~";
                    }
                    [cell.indicatorView stopAnimating];
                }else{
                    cell.label.text = @"加载中...";
                    [cell.indicatorView startAnimating];
                    if (!_moreLoadFavorite) {
                        //_moreLoadFavorite = YES;
                        [self loadMoreFavorite];
                    }
                }
                return cell;
            }else{
                MessageFavoriteCell *favoritecell = [replyTableView dequeueReusableCellWithIdentifier:identifier];
                if (favoritecell == nil) {
                    favoritecell = [[MessageFavoriteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                
                MessageFavoriteEntity *entity = [favoriteArray objectAtIndex:indexPath.row];
                
                [favoritecell.portraitImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:entity.userPortrait]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                favoritecell.nameLabel.text = entity.username;
                NSString *timeString;
                NSDate *date = [CustomDate getTimeDate:entity.favoriteTime];
                if ([[CustomDate compareDate:date] isEqualToString:@"今天"]) {
                    timeString = [entity.favoriteTime substringWithRange:NSMakeRange(11, 5)];
                }
                else if ([[CustomDate compareDate:date] isEqualToString:@"昨天"]){
                    timeString = @"昨天";
                    //timeString = [timeString stringByAppendingString:@" "];
                    timeString = [timeString stringByAppendingString:[entity.favoriteTime substringWithRange:NSMakeRange(11, 5)]];
                }
                else{
                    timeString = [entity.favoriteTime substringWithRange:NSMakeRange(5, 11)];
                }
                
                favoritecell.timeLabel.text = timeString;
                if ([entity.favoriteType isEqualToString:@"fans"]) {
                    favoritecell.fromLabel.text = [NSString stringWithFormat:@"关注了你"];
                }
                else{
                    if ([entity.favoriteTrendsType  integerValue] == 2){
                         favoritecell.fromLabel.text = [NSString stringWithFormat:@"在打卡中赞了你"];
                    }
                    else {
                        favoritecell.fromLabel.text = [NSString stringWithFormat:@"赞了你"];
                    }
                    [favoritecell.photoimage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:entity.replyPhoto]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                }
                
                
                favoritecell.backgroundColor = TABLEVIEWCELL_COLOR;
                return favoritecell;
            }
        }break;
        case 3:{
            if (indexPath.row >= systemMessageArray.count) {
                LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCell];
                if (cell == nil) {
                    cell = [[LastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCell];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.backgroundColor = [UIColor clearColor];
                cell.label.textColor = TIME_COLOR_GARG;
                if (_showMoreSystem) {
                    if (systemMessageArray.count == 0) {
                        cell.label.text = @"没有系统消息";
                    }
                    else{
                        cell.label.text = @"没有更多喽~";
                    }
                    [cell.indicatorView stopAnimating];
                }else{
                    cell.label.text = @"加载中...";
                    [cell.indicatorView startAnimating];
                    if (!_moreLoadSystem) {
                        _moreLoadSystem = YES;
                        [self moreSystemMessage];
                    }
                }
                return cell;
            }
            else {
                static NSString *identifier = @"systemCell";
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.backgroundColor = TABLEVIEWCELL_COLOR;
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 60)];
                NSDictionary *tempDic = [systemMessageArray objectAtIndex:indexPath.row];
                titleLabel.text = [tempDic objectForKey:@"content"];
                titleLabel.font = SMALLFONT_14;
                titleLabel.textColor = WHITE_CLOCLOR;
                [cell addSubview:titleLabel];
                
                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 59.5, SCREEN_WIDTH - 10, 0.5)];
                line.backgroundColor = LINE_COLOR_GARG;
                [cell addSubview:line];
                
                return cell;
            }

        }
            break;
        default:{
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (currentIndex) {
        case 0:{
            RCConversation *conversation = [chatListArray objectAtIndex:indexPath.row];
            if (conversation.conversationType == ConversationType_PRIVATE) {
                ChatViewController *chatController = [[ChatViewController alloc]init];
                chatController.portraitStyle = RCUserAvatarCycle;
                chatController.currentTarget = conversation.targetId;
                AppDelegate *appDeledate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [appDeledate getUserInfoWithUserId:conversation.targetId completion:^(RCUserInfo *userinfo) {
                    chatController.currentTargetName = userinfo.name;
                }];
                chatController.conversationType = ConversationType_PRIVATE;
                [appDeledate.rootNavigationController pushViewController:chatController animated:YES];
                appDelegate.rootNavigationController.navigationBarHidden = NO;
            }else if (conversation.conversationType == ConversationType_GROUP){
                
                GroupChatViewController *controller = [[GroupChatViewController alloc]init];
                [appDelegate.rootNavigationController pushViewController:controller animated:YES];
                controller.currentTarget = conversation.targetId;
                controller.currentTargetName = conversation.conversationTitle;
                controller.conversationType = ConversationType_GROUP;
                controller.enableUnreadBadge = NO;
                controller.enableVoIP = NO;
                controller.portraitStyle = RCUserAvatarCycle;
                appDelegate.rootNavigationController.navigationBarHidden = NO;
                
            }
        }break;
        case 1:{
            if (indexPath.row >= replyArray.count) {
                
            }else{
                MessageReplyEntity *entity = [replyArray objectAtIndex:indexPath.row];
                if ([entity.replyType isEqualToString:@"trendscomment"]){
                    if ([entity.replyTrendType  integerValue] == 1) {
                        TrendDetailViewController *controller = [[TrendDetailViewController alloc]init];
                        controller.trendid = entity.trendid;
                        [appDelegate.rootNavigationController pushViewController:controller animated:YES];
                    }
                    else {
                        ClockinDetailViewController *controller = [[ClockinDetailViewController alloc] init];
                        controller.trendid = entity.trendid;
                        [appDelegate.rootNavigationController pushViewController:controller animated:YES];
                    }
                    
                }
                else if ([entity.replyType isEqualToString:@"coursecomment"]){
                    InteractionDetailViewController *controller = [[InteractionDetailViewController alloc] init];
                    controller.interactionId = entity.trendid;
                    [appDelegate.rootNavigationController pushViewController:controller animated:YES];
                }
                else{
                    ClubDiscussionDetailViewController *controller = [[ClubDiscussionDetailViewController alloc] init];
                    controller.discussionId = entity.trendid;
                    [appDelegate.rootNavigationController pushViewController:controller animated:YES];
                }
            }
        }break;
        case 2:{
            if (indexPath.row >= favoriteArray.count) {
                
            }else{
                MessageFavoriteEntity *entity = [favoriteArray objectAtIndex:indexPath.row];
                if ([entity.favoriteType isEqualToString:@"fans"]) {
                    [self jumpPersonController:entity.userid];
                }
                else{
                    if ([entity.favoriteTrendsType  integerValue] == 1) {
                        TrendDetailViewController *controller = [[TrendDetailViewController alloc]init];
                        controller.trendid = entity.trendid;
                        [appDelegate.rootNavigationController pushViewController:controller animated:YES];
                    }
                    else{
                        ClockinDetailViewController *controller = [[ClockinDetailViewController alloc] init];
                        controller.trendid = entity.trendid;
                        [appDelegate.rootNavigationController pushViewController:controller animated:YES];
                    }
                }
                    
            }
        }break;
        case 3:{
            if (indexPath.row < systemMessageArray.count) {
                NSDictionary *dicTemp = [systemMessageArray objectAtIndex:indexPath.row];
                ActivityWebViewController *controller = [[ActivityWebViewController alloc] init];
                controller.urlString = [dicTemp objectForKey:@"url"];
                [appDelegate.rootNavigationController pushViewController:controller animated:YES];
            }
        }break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (currentIndex) {
        case 0:
            return 60;break;
        case 1:
            return 75;break;
        case 2:
            return 75;break;
        case 3:
            return 60;break;
        default:
            return 0;
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (currentIndex) {
        case 0:
            return chatListArray.count;break;
        case 1:{
            //if (replyArray.count>=10) {
            return replyArray.count+1;
            //}
        }break;
        case 2:{
            //if (favoriteArray.count>=10) {
            return favoriteArray.count+1;
            //}
        }break;
        case 3:{
            return systemMessageArray.count + 1;
        }
        default:
            return 0;
            break;
    }
}
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//
//}



#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (currentIndex == 1) {
        [_refreshReply egoRefreshScrollViewDidScroll:scrollView];
    }else if(currentIndex == 2){
        [_refreshFavorite egoRefreshScrollViewDidScroll:scrollView];
    }else if(currentIndex == 0){
        [_refreshChatList egoRefreshScrollViewDidScroll:scrollView];
    }
    else {
        [_refreshSystem egoRefreshScrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (currentIndex == 1) {
        [_refreshReply egoRefreshScrollViewDidEndDragging:scrollView];
    }else if(currentIndex == 2){
        [_refreshFavorite egoRefreshScrollViewDidEndDragging:scrollView];
    }else if(currentIndex ==0){
        [_refreshChatList egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else {
        [_refreshSystem egoRefreshScrollViewDidEndDragging:scrollView];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (currentIndex == 1) {
        [_refreshReply egoRefreshScrollViewDidEndDragging:scrollView];
    }else if(currentIndex == 2){
        [_refreshFavorite egoRefreshScrollViewDidEndDragging:scrollView];
    }else if(currentIndex == 0){
        [_refreshChatList egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else {
        [_refreshSystem egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)reloadTableViewDataSource{
    
    if (currentIndex == 1) {
        _reloadReply = YES;
        [self refreshReply];
    }else if(currentIndex == 2){
        _reloadFavorite = YES;
        [self refreshFavorite];
    }else if (currentIndex ==0){
        _reloadChatList = YES;
        [self refreshChatList];
    }
    else {
        _reloadSystem = YES;
        [self refreshSystemMessage];
    }
}

- (void)doneLoadingTableViewData{
    if (currentIndex == 1) {
        _reloadReply = NO;
        [replyTableView reloadData];
        [_refreshReply egoRefreshScrollViewDataSourceDidFinishedLoading:replyTableView];
    }else if(currentIndex == 2){
        _reloadFavorite = NO;
        [favoriteTableView reloadData];
        [_refreshFavorite egoRefreshScrollViewDataSourceDidFinishedLoading:favoriteTableView];
    }else if(currentIndex == 0){
        _reloadChatList = NO;
        [chatTableView reloadData];
        [_refreshChatList egoRefreshScrollViewDataSourceDidFinishedLoading:chatTableView];
    }
    else {
        _reloadSystem = NO;
        [systemTableView reloadData];
        [_refreshSystem egoRefreshScrollViewDataSourceDidFinishedLoading:systemTableView];
        
    }
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    if (currentIndex == 1) {
        return  _reloadReply;
    }else if(currentIndex == 2){
        return  _reloadFavorite;
    }else if(currentIndex == 0){
        return _reloadChatList;
    }
    else {
        return _refreshSystem;
    }
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
}

//转到个人主页
- (void)jumpPersonController:(NSString*)friendid{
    if ([friendid intValue] == [userInfo.userid intValue]) {
        OwnInfoViewController *ownInfoController = [[OwnInfoViewController alloc]init];
        ownInfoController.hidesBottomBarWhenPushed = YES;
        [appDelegate.rootNavigationController pushViewController:ownInfoController animated:YES];
    }else{
        PersonalViewController *personController = [[PersonalViewController alloc]init];
        personController.personID = friendid;
        personController.hidesBottomBarWhenPushed = YES;
        [appDelegate.rootNavigationController pushViewController:personController animated:YES];
    }
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
