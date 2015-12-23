//
//  ClubInformationViewController.m
//  Health
//
//  Created by realtech on 15/5/20.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClubInformationViewController.h"
#import "ClubMemberViewController.h"
#import "CreateActivityViewController.h"
#import "ApplyInformationViewController.h"
#import "ActivityWebViewController.h"

@interface ClubInformationViewController ()<UIAlertViewDelegate>{
    UserInfo *userInfo;
    
    NSMutableArray *memberArray;
    NSDictionary *ownerDic;
    NSString *memberCount;
}

@end

@implementation ClubInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appSuccess) name:@"applyclubsuccess" object:@YES];
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"俱乐部信息"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 48)];
    infoTableView.showsVerticalScrollIndicator = NO;
    infoTableView.delegate =self;
    infoTableView.dataSource = self;
    infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    infoTableView.backgroundColor = CLEAR_COLOR;
    [self.view addSubview:infoTableView];
    
    self.applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.applyButton.frame = CGRectMake(0, SCREEN_HEIGHT - 48, SCREEN_WIDTH, 48);
    [self.applyButton setBackgroundColor:MAIN_COLOR_YELLOW];
    [self.applyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     self.applyButton.titleLabel.font = BOLDFONT_18;
    [self.view addSubview:self.applyButton];
    
    [self setApplyButton];
    
    [self getMember];
    
    
}
- (void)setApplyButton{
    if ([self.applyState integerValue] == 4 || [self.applyState integerValue] == 2) {
        if ([self.usertype integerValue] != 1) {
            [self.applyButton setTitle:@"申请加入" forState:UIControlStateNormal];
            
        }
        else {
            self.applyButton.hidden = YES;
        }
    }
    else if ([self.applyState integerValue] == 3) {
        [self.applyButton setTitle:@"请等待审核..." forState:UIControlStateNormal];
        //self.applyButton.userInteractionEnabled = NO;
    }
    else {
        if ([self.usertype integerValue] != 1) {
            [self.applyButton setTitle:@"退出俱乐部" forState:UIControlStateNormal];
            [self.applyButton addTarget:self action:@selector(exitClubClick) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            self.applyButton.hidden = YES;
        }
    }
    [self.applyButton addTarget:self action:@selector(applyClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)getMember{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", self.clubID, @"clubid", nil];
    [ClubRequest clubMemberListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            NSLog(@"获取成员成功");
            memberArray = [[NSMutableArray alloc] init];
            memberArray = [[response objectForKey:@"data"] objectForKey:@"clubmember"];
            ownerDic = [[response objectForKey:@"data"] objectForKey:@"clubuser"];
            memberCount = [[response objectForKey:@"data"] objectForKey:@"member"];
            [infoTableView reloadData];
        }
        else{
            NSLog(@"获取失败");
        }
    } failure:^(NSError *error) {
    }];
}
- (void)applyClick{
    ApplyInformationViewController *controller = [[ApplyInformationViewController alloc] init];
    controller.club_id = self.clubID;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)appSuccess{
    [self.applyButton setTitle:@"请等待审核..." forState:UIControlStateNormal];
}
- (void)exitClubClick{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出俱乐部吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlerView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:userInfo.userid forKey:@"userid"];
        [dic setObject:userInfo.usertoken forKey:@"usertoken"];
        [dic setObject:self.clubID forKey:@"clubid"];
        [ClubRequest exitClubWith:dic success:^(id response) {
            if ([[response objectForKey:@"state"] integerValue] == 1000) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"applyclubsuccess" object:@YES];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出俱乐部失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        } failure:^(NSError *error) {
            NSLog(@"网络问题");
        }];
    }
}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.usertype integerValue] == 0) {
        return 2;
    }
    else {
        return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = TABLEVIEWCELL_COLOR;
    if (indexPath.row == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 30, 60)];
        label.text = @"成员";
        label.textColor = WHITE_CLOCLOR;
        label.font = SMALLFONT_14;
        [cell addSubview:label];
        
        if (memberArray.count >= 5) {
            for (int i = 0; i < 5; i++){
                NSDictionary *tempDic = [memberArray objectAtIndex:i];
                UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(80 + i*33, 16.5, 27, 27)];
                [headImage  sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[tempDic objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                headImage.layer.masksToBounds = YES;
                headImage.layer.cornerRadius = 13.5;
                [cell addSubview:headImage];
            }
        }
        else {
            for (int i = 0; i < memberArray.count; i++){
                NSDictionary *tempDic = [memberArray objectAtIndex:i];
                UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(80 + i*33, 16.5, 27, 27)];
                [headImage  sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[tempDic objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
                headImage.layer.masksToBounds = YES;
                headImage.layer.cornerRadius = 13.5;
                [cell addSubview:headImage];
            }
        }
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 70, 60)];
        if (![Util isEmpty:memberCount]) {
            countLabel.text = [NSString stringWithFormat:@"%ld人", (long)[memberCount integerValue] + 1];
            countLabel.font = SMALLFONT_14;
            countLabel.textColor = WHITE_CLOCLOR;
            countLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:countLabel];
        }
        
    }
    else if (indexPath.row == 1){
        UILabel *introLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 30, 60)];
        introLabel.text = @"简介";
        introLabel.textColor = WHITE_CLOCLOR;
        introLabel.font = SMALLFONT_14;
        [cell addSubview:introLabel];
    }
    else {
        UILabel *creamAddLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 60)];
        creamAddLabel.text = @"添加精选";
        creamAddLabel.textColor = WHITE_CLOCLOR;
        creamAddLabel.font = SMALLFONT_14;
        [cell addSubview:creamAddLabel];
    }
    UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, 22.5, 15, 15)];
    rightImage.image = [UIImage imageNamed:@"club_member_right"];
    [cell addSubview:rightImage];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 59.5, SCREEN_WIDTH - 10, 0.5)];
    line.backgroundColor = LINE_COLOR_GARG;
    [cell addSubview:line];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ClubMemberViewController *controller = [[ClubMemberViewController alloc] init];
        controller.clubID = self.clubID;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.row == 1){
        ActivityWebViewController *controller = [[ActivityWebViewController alloc] init];
        controller.urlString = self.introUrl;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        CreateActivityViewController *controller = [[CreateActivityViewController alloc] init];
        controller.type = @"1";
        controller.club_id = self.clubID;
        [self.navigationController pushViewController:controller animated:YES];
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
