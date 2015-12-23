//
//  ClubStarsViewController.m
//  Health
//
//  Created by realtech on 15/5/21.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClubStarsViewController.h"

#define cell_color [UIColor colorWithRed:53/255.0 green:52/255.0 blue:68/255.0 alpha:1.0]

@interface ClubStarsViewController ()<UITableViewDataSource, UITableViewDelegate>{
    UserInfo *userInfo;
    
    NSMutableArray *starsArray;
}

@end

@implementation ClubStarsViewController
@synthesize firstHeadImage, firstNickname, secondHeadImage, secondNickname, thirdHeadImage, thirdNickname;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"明星"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    starsArray = [[NSMutableArray alloc] init];
    
    starsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    starsTableView.delegate = self;
    starsTableView.dataSource = self;
    starsTableView.backgroundColor = CLEAR_COLOR;
    starsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:starsTableView];
    
    [self setupHeaderView];
    
    [self getClubStars];
}
- (void)setupHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
    headerView.backgroundColor = cell_color;
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3 - 0.5, 0, 1, 140)];
    line1.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    [headerView addSubview:line1];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(2*SCREEN_WIDTH/3 - 0.5, 0, 1, 140)];
    line2.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    [headerView addSubview:line2];
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, 12, 26, 42)];
    image1.image = [UIImage imageNamed:@"star_rank1"];
    [headerView addSubview:image1];
    
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6 - 40, 30, 26, 42)];
    image2.image = [UIImage imageNamed:@"star_rank2"];
    [headerView addSubview:image2];
    
    UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(5*SCREEN_WIDTH/6 - 40, 30, 26, 42)];
    image3.image = [UIImage imageNamed:@"star_rank3"];
    [headerView addSubview:image3];
    
    firstHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 22.5, 40, 45, 45)];
    firstHeadImage.layer.masksToBounds = YES;
    firstHeadImage.layer.cornerRadius = 22.5;
    
    [headerView addSubview:firstHeadImage];
    
    firstNickname = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - SCREEN_WIDTH/6, 100, SCREEN_WIDTH/3, 16)];
    firstNickname.textColor = WHITE_CLOCLOR;
    firstNickname.font = SMALLFONT_14;
    firstNickname.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:firstNickname];
    
    secondHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6 - 22.5, 60, 45, 45)];
    secondHeadImage.layer.masksToBounds = YES;
    secondHeadImage.layer.cornerRadius = 22.5;
    [headerView addSubview:secondHeadImage];
    
    secondNickname = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH/3, 16)];
    secondNickname.textColor = WHITE_CLOCLOR;
    secondNickname.font = SMALLFONT_14;
    secondNickname.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:secondNickname];
    
    thirdHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake(5*SCREEN_WIDTH/6 - 22.5, 60, 45, 45)];
    thirdHeadImage.layer.masksToBounds = YES;
    thirdHeadImage.layer.cornerRadius = 22.5;
    [headerView addSubview:thirdHeadImage];
    
    thirdNickname = [[UILabel alloc] initWithFrame:CGRectMake(2*SCREEN_WIDTH/3, 120, SCREEN_WIDTH/3, 16)];
    thirdNickname.textColor = WHITE_CLOCLOR;
    thirdNickname.font = SMALLFONT_14;
    thirdNickname.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:thirdNickname];
    
    starsTableView.tableHeaderView = headerView;
}
- (void) setHeaderData{
    if (starsArray.count == 0) {
        firstNickname.text = @"虚席以待...";
        secondNickname.text = @"虚席以待...";
        thirdNickname.text = @"虚席以待...";
        firstNickname.textColor = TIME_COLOR_GARG;
        secondNickname.textColor = TIME_COLOR_GARG;
        thirdNickname.textColor = TIME_COLOR_GARG;
    }
    else if (starsArray.count == 1) {
        NSDictionary *tempDic = [starsArray objectAtIndex:0];
        [firstHeadImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[tempDic objectForKey:@"portrait"]]]];
        firstHeadImage.layer.borderWidth = 2;
        firstHeadImage.layer.borderColor = [UIColor colorWithRed:253/255.0 green:98/255.0 blue:78/255.0 alpha:1.0].CGColor;
        firstHeadImage.userInteractionEnabled = YES;
        [firstHeadImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstHeadPress:)]];
        firstNickname.text = [tempDic objectForKey:@"name"];
        secondNickname.text = @"虚席以待...";
        thirdNickname.text = @"虚席以待...";
        secondNickname.textColor = TIME_COLOR_GARG;
        thirdNickname.textColor = TIME_COLOR_GARG;
    }
    else if (starsArray.count == 2) {
        NSDictionary *tempDic1 =[starsArray objectAtIndex:0];
        NSDictionary *tempDic2 = [starsArray objectAtIndex:1];
        [firstHeadImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[tempDic1 objectForKey:@"portrait"]]]];
        [secondHeadImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[tempDic2 objectForKey:@"portrait"]]]];
        firstHeadImage.layer.borderWidth = 2;
        firstHeadImage.layer.borderColor = [UIColor colorWithRed:253/255.0 green:98/255.0 blue:78/255.0 alpha:1.0].CGColor;
        firstHeadImage.userInteractionEnabled = YES;
        [firstHeadImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstHeadPress:)]];
        secondHeadImage.layer.borderWidth = 2;
        secondHeadImage.layer.borderColor = [UIColor colorWithRed:230/255.0 green:187/255.0 blue:13/255.0 alpha:1.0].CGColor;
        secondHeadImage.userInteractionEnabled = YES;
        [secondHeadImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondHeadPress:)]];
        firstNickname.text = [tempDic1 objectForKey:@"name"];
        secondNickname.text = [tempDic2 objectForKey:@"name"];
        thirdNickname.text = @"虚席以待";
        thirdNickname.textColor = TIME_COLOR_GARG;
    }
    else {
        NSDictionary *tempDic1 =[starsArray objectAtIndex:0];
        NSDictionary *tempDic2 = [starsArray objectAtIndex:1];
        NSDictionary *tempDic3 = [starsArray objectAtIndex:2];
        [firstHeadImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[tempDic1 objectForKey:@"portrait"]]]];
        [secondHeadImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[tempDic2 objectForKey:@"portrait"]]]];
        [thirdHeadImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[tempDic3 objectForKey:@"portrait"]]]];
        firstHeadImage.layer.borderWidth = 2;
        firstHeadImage.layer.borderColor = [UIColor colorWithRed:253/255.0 green:98/255.0 blue:78/255.0 alpha:1.0].CGColor;
        firstHeadImage.userInteractionEnabled = YES;
        [firstHeadImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstHeadPress:)]];
        secondHeadImage.layer.borderWidth = 2;
        secondHeadImage.layer.borderColor = [UIColor colorWithRed:230/255.0 green:187/255.0 blue:13/255.0 alpha:1.0].CGColor;
        secondHeadImage.userInteractionEnabled = YES;
        [secondHeadImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondHeadPress:)]];
        thirdHeadImage.layer.borderWidth = 2;
        thirdHeadImage.layer.borderColor = [UIColor colorWithRed:85/255.0 green:140/255.0 blue:190/255.0 alpha:1.0].CGColor;
        thirdHeadImage.userInteractionEnabled = YES;
        [thirdHeadImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdHeadPress:)]];
        firstNickname.text = [tempDic1 objectForKey:@"name"];
        secondNickname.text = [tempDic2 objectForKey:@"name"];
        thirdNickname.text = [tempDic3 objectForKey:@"name"];
    }
}
- (void)getClubStars {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    [dic setObject:self.club_id forKey:@"clubid"];
    [ClubRequest clubStarsListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            starsArray = [response objectForKey:@"data"];
            [self setHeaderData];
            [starsTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)firstHeadPress:(UITapGestureRecognizer*)gesture {
    NSDictionary *tempD = [starsArray objectAtIndex:0];
    [self jumpPersonController:[tempD objectForKey:@"userid"]];
}
- (void)secondHeadPress:(UITapGestureRecognizer*)gesture {
    NSDictionary *tempD = [starsArray objectAtIndex:1];
    [self jumpPersonController:[tempD objectForKey:@"userid"]];
}
- (void)thirdHeadPress:(UITapGestureRecognizer*)gesture {
    NSDictionary *tempD = [starsArray objectAtIndex:2];
    [self jumpPersonController:[tempD objectForKey:@"userid"]];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (starsArray.count < 4) {
        return 0;
    }
    else {
        return starsArray.count - 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"StarCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *tempDic = [starsArray objectAtIndex:indexPath.row + 3];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row%2  == 0) {
        cell.backgroundColor = CLEAR_COLOR;
    }
    else {
        cell.backgroundColor = [UIColor colorWithRed:53/255.0 green:52/255.0 blue:68/255.0 alpha:1.0];
    }
    UIImageView *headImage =[[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
    [headImage sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:[tempDic objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE_STRING]];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 20;
    [cell addSubview:headImage];
    
    UILabel *nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 200, 60)];
    nicknameLabel.text = [tempDic objectForKey:@"name"];
    nicknameLabel.textColor = WHITE_CLOCLOR;
    nicknameLabel.font = SMALLFONT_14;
    [cell addSubview:nicknameLabel];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dictionary = [starsArray objectAtIndex:indexPath.row + 3];
    [self jumpPersonController:[dictionary objectForKey:@"userid"]];
    
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
