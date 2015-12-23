//
//  CourseQAController.m
//  Health
//
//  Created by cheng on 15/3/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseQAController.h"
#import "CourseQATableViewCell.h"
#import "CourseRequest.h"
#import "CourseQAEntity.h"

@interface CourseQAController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *array;
    
    UIView *commentView;
    UIImageView *tipImage;
    UILabel *tipLabel;
    
    //是否是交流回答问题
    NSInteger flag;
    //回答问题的entity
    CourseQAEntity *question;
}

@end

@implementation CourseQAController

@synthesize commentButton, commentTextView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    array = [[NSMutableArray alloc]init];
    flag = 0;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_LABEL_X, TITLE_LABEL_Y, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"课程咨询"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    [self getQAList];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [[UIView alloc]init];
    self.tableview.backgroundColor = [UIColor colorWithRed:23/255.0 green:23/255.0 blue:23/255.0 alpha:1.0];
    [self.view addSubview:self.tableview];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupCommentView];
}

//评论或者回复框
- (void)setupCommentView{
    commentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT-64, SCREEN_WIDTH, TABBAR_HEIGHT)];
    commentView.backgroundColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1.0];
    [self.view addSubview:commentView];
    
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH - 108, TABBAR_HEIGHT - 5)];
    commentTextView.delegate = self;
    commentTextView.font = [UIFont systemFontOfSize:16];
    commentTextView.returnKeyType = UIReturnKeyDone;
    commentTextView.backgroundColor = [UIColor clearColor];
    commentTextView.textColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:246/255.0 alpha:1.0];
    [commentView addSubview:commentTextView];
    
    commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(SCREEN_WIDTH - 108, 0, 108, TABBAR_HEIGHT);
    [commentButton setTitle:@"SEND" forState:UIControlStateNormal];
    [commentButton setTitleColor:[UIColor colorWithRed:252/255.0 green:240/255.0 blue:232/255.0 alpha:1.0] forState:UIControlStateNormal];
    commentButton.titleLabel.font = [UIFont systemFontOfSize:20];
    commentButton.backgroundColor = [UIColor colorWithRed:1.0 green:101/255.0 blue:1/255.0 alpha:1.0];
    [commentButton addTarget:self action:@selector(questionSend:) forControlEvents:UIControlEventTouchUpInside];
    [commentView addSubview:commentButton];
    
    tipImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 13, 20, 20)];
    tipImage.image = [UIImage imageNamed:@"comment_tip.png"];
    [commentView addSubview:tipImage];
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 13, SCREEN_WIDTH - 132, 20)];
    tipLabel.text = @"";
    tipLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.font = [UIFont systemFontOfSize:16];
    [commentView addSubview:tipLabel];
}

- (void)getQAList{
    if (self.course == nil) {
        return;
    }
    [CourseRequest courseQAListWith:self.course.courseid success:^(id response) {
        array = response;
        [self sortData];
    } failure:^(NSError *error) {
    }];
}

- (void)sortData{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"questiontime" ascending:YES];
    [array sortUsingDescriptors:[NSArray arrayWithObjects:sort,nil]];
    [self.tableview reloadData];
}

- (void)keyBoardShow:(NSNotification *)notification{
    NSDictionary *info =[notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    [UIView beginAnimations:@"KeyboardShow" context:nil];
    [UIView setAnimationDuration:0.25];
    commentView.frame = CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT-NAVIGATIONBAR_HEIGHT - keyboardSize.height, SCREEN_WIDTH, TABBAR_HEIGHT);
    [UIView commitAnimations];
}

- (void)keyBoardHide:(NSNotification *)notification{
    
    [UIView beginAnimations:@"KeyboardHide" context:nil];
    [UIView setAnimationDuration:0.25];
    commentView.frame = CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT -NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, TABBAR_HEIGHT);
    [UIView commitAnimations];
}

- (void)questionSend:(id)sender{
    if ([Util isEmpty:commentTextView.text]) {
        return;
    }
    if (self.course == nil) {
        return;
    }
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    FriendInfo *friend = self.course.teacher;

    if (flag == 0) {
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken",self.commentTextView.text,@"consultcontent",self.course.courseid,@"courseid",friend.friendid,@"courseuserid", nil];
        [CourseRequest courseQuestionWith:dictionary success:^(id response) {
        } failure:^(NSError *error) {
        }];
        
        CourseQAEntity *entity = [[CourseQAEntity alloc]init];
        entity.questioncontent = commentTextView.text;
        entity.questiontime = [CustomDate getDateString:[NSDate date]];
        entity.questionuserid = userinfo.userid;
        entity.questionusername = userinfo.username;
        entity.questionhasanswer = @"2";
        [array addObject:entity];

    }else{
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken",self.commentTextView.text,@"answercontent",question.questionid,@"answerid",self.course.courseid,@"courseid",friend.friendid,@"courseuserid", nil];
        [CourseRequest courseAnswerWith:dictionary success:^(id response) {
        } failure:^(NSError *error) {
            
        }];
        question.questionhasanswer = @"1";
        AnswerEntity *answerEntity = [[AnswerEntity alloc]init];
        answerEntity.answerContent = self.commentTextView.text;
        answerEntity.answerTime = [CustomDate getDateString:[NSDate date]];
        [question.answerArray addObject:answerEntity];
    }
    [self sortData];
    commentTextView.text = @"";
    tipLabel.text = @"提出你的问题.";
    flag = 0;
    [commentTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CourseQACell";
    CourseQAEntity *qaEntity = [array objectAtIndex:indexPath.row];
    CourseQATableViewCell *cell = [[CourseQATableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier Data:qaEntity];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CourseQACell";
    CourseQAEntity *qaEntity = [array objectAtIndex:indexPath.row];
    CourseQATableViewCell *cell = [[CourseQATableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier Data:qaEntity];
    return [cell getHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendInfo *friend = self.course.teacher;
    
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    
    if ([userinfo.userid intValue] == [friend.friendid intValue]) {
        [commentTextView becomeFirstResponder];
        flag = 1;
        CourseQAEntity *qaEntity = [array objectAtIndex:indexPath.row];
        tipLabel.text = [NSString stringWithFormat:@"回复:%@",qaEntity.questionusername];
        question = qaEntity;
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if ([Util isEmpty:textView.text]) {
        [tipLabel setHidden:NO];
        [tipImage setHidden:NO];
    }else{
        [tipLabel setHidden:YES];
        [tipImage setHidden:YES];
    }
}


@end
