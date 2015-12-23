//
//  MyTableViewController.m
//  Health
//
//  Created by 王杰 on 15/1/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MyTableViewController.h"
#import "MineInfoCell.h"
#import "PicAndTrainCell.h"
#import "trainCell.h"
#import "PicTableViewCell.h"
#import "ActionLeftView.h"
#import "MyRequest/MyInfoRequest.h"
#import "MyTrend.h"

#define RIGHTVIEW_Y 64
#define RIGHTVIEW_WIDTH 250

static NSString* home = @"Home";
static NSString* picAndEx = @"PicAndEx";
static NSString* train = @"Train";
static NSString* pic = @"Pic";

@interface MyTableViewController ()<PicAndTrainCellDelegate, MineInfoCellDelegate, ActionLeftViewDelegate>{
    NSInteger currentModel;
    ActionLeftView *leftView;
    NSMutableArray *trendArray;
}

@property (nonatomic, assign)Boolean *who; //0是自己，1是教练
@property (nonatomic,strong)NSString* balance;
@property (nonatomic,strong)NSString* myfollow;
@property (nonatomic, strong)NSString* nickname;

@property (nonatomic, strong)MyTrend* mineTrendleft;
@property (nonatomic, strong)MyTrend* mineTrendright;

@end


@implementation MyTableViewController

- (void)viewDidAppear:(BOOL)animated {
    [self getInfoData];
    [self getPicdata];
    [self getCoursedata];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    trendArray = [[NSMutableArray alloc]init];
        self.who = (int)0;
    if (!self.who) {
        self.infoArray = @[@"健身积分",@"优惠券",@"收藏",@"课程订单",@"待评价",@"待付款"];
        self.imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"credit"],
                           [UIImage imageNamed:@"coupon"], [UIImage imageNamed:@"collect"],
                           [UIImage imageNamed:@"order"],[UIImage imageNamed:@"assess"],[UIImage imageNamed:@"charge"],nil];
    } else {
        self.infoArray = @[@"账户余额",@"课程",@"学员",@"全部订单",@"待收款"];
        self.imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"credit"],
                           [UIImage imageNamed:@"coupon"], [UIImage imageNamed:@"collect"],
                           [UIImage imageNamed:@"order"],[UIImage imageNamed:@"charge"],nil];
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor whiteColor]];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    customLab.text = @"我的主页";
    
    [self.tableView registerClass:[MineInfoCell class] forCellReuseIdentifier:home];
    [self.tableView registerClass:[PicAndTrainCell class] forCellReuseIdentifier:picAndEx];
    [self.tableView registerClass:[TrainCell class] forCellReuseIdentifier:train];
    [self.tableView registerClass:[PicTableViewCell class] forCellReuseIdentifier:pic];

    leftView = [[ActionLeftView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH, 0, RIGHTVIEW_WIDTH, SCREEN_HEIGHT-RIGHTVIEW_Y) InfoSub:self.infoArray ImageSub:self.imageArray];
    [self.view addSubview:leftView];
    leftView.delegate =self;
    
//    [self getInfoData];
    
}

- (void)getInfoData{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;

    NSDictionary *dicInfo = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid, @"userid", userinfo.usertoken, @"usertoken", nil];
    [MyInfoRequest myInfoWithParam:dicInfo success:^(id response) {
        [self.tableView reloadData];
    } failure:^(NSError *error) {

    }];
}

- (void)getPicdata {
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSDictionary *dicPic = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid, @"userid", userinfo.usertoken, @"usertoken", nil];
    [MyInfoRequest myPicWithParam:dicPic success:^(id response) {
        trendArray = response;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)getCoursedata {
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSDictionary *dicCourse = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid, @"userid", userinfo.usertoken, @"usertoken", nil];
    [MyInfoRequest myCourseWithParam:dicCourse success:^(id response) {
        
    } failure:^(NSError *error) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
        return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0 || section == 1) {
        return 1;
    } else {
        return trendArray.count/2 + trendArray.count%2;
    };
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    UITableViewCell* cell = nil;
    
    if (indexPath.section == 0) {
        MineInfoCell *infocell = [tableView dequeueReusableCellWithIdentifier:home forIndexPath:indexPath];
        if (infocell == nil) {
            infocell = [[MineInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:home];
        }
        if (!self.who) {
            [infocell.coarch removeFromSuperview];
        }
        UserData *userdata = [UserData shared];
        UserInfo *userinfo = userdata.userInfo;
        infocell.name.text = userinfo.username;
        NSString *fansNum = userinfo.myfeans;
        [infocell.fansNum setTitle:[NSString stringWithFormat:@"粉丝 %@",fansNum] forState:UIControlStateNormal];
        infocell.focusNum.text = [NSString stringWithFormat:@"关注 %@",userinfo.myfollow];
        [infocell.imageviewPortrait sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:userinfo.userphoto]] placeholderImage:[UIImage imageNamed:@"training"]];
        if (userinfo.usersex) {
            infocell.sex.image = [UIImage imageNamed:@"msex"];
        } else {
            infocell.sex.image = [UIImage imageNamed:@"wsex"];
        }
        infocell.delegate = self;
        return infocell;
    } else if (indexPath.section == 1) {
       PicAndTrainCell *ptcell = [tableView dequeueReusableCellWithIdentifier:picAndEx forIndexPath:indexPath];
        if (ptcell == nil) {
            ptcell = [[PicAndTrainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:picAndEx];
        }
        ptcell.delegate = self;
        return ptcell;
    } else {
        if (currentModel) {
            TrainCell *traincell = [tableView dequeueReusableCellWithIdentifier:train forIndexPath:indexPath];
            if (traincell == nil) {
                traincell = [[TrainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:train];
            }
            return traincell;
        } else {
            PicTableViewCell *piccell = [tableView dequeueReusableCellWithIdentifier:pic forIndexPath:indexPath];
            if (piccell == nil) {
                piccell = [[PicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pic];
            }
            self.mineTrendleft = [trendArray objectAtIndex:2*(indexPath.row+1)-2];
            
            [piccell.img1 sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:self.mineTrendleft.trendpiture]] placeholderImage:[UIImage imageNamed:@"training"]];
            if (trendArray.count == 1) {
                return piccell;
            } else {
                self.mineTrendright = [trendArray objectAtIndex:2*(indexPath.row+1)-1];
                [piccell.img2 sd_setImageWithURL:[NSURL URLWithString:[Util urlPhoto:self.mineTrendright.trendpiture]] placeholderImage:[UIImage imageNamed:@"training"]];
            }
            return piccell;
        }
       
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return SCREEN_WIDTH/3*2 - 46;
    } else if (indexPath.section == 1) {
        return 40;
    } else {
        return SCREEN_WIDTH/2;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
}


-(void)clickChangePic:(NSInteger)index{
    switch (index) {
        case 0:
        {
            currentModel = 0;
            [self getPicdata];
            
        }   break;
        case 1:{
            currentModel = 1;
            [self getCoursedata];
        }break;
        default:
            break;
    }
}

- (void)setLeftView {
    if (!leftView.isShow) {
        self.tabBarController.tabBar.hidden = YES;
        leftView.isShow = YES;
        [UIView animateWithDuration:0.3 animations:^{
            leftView.frame = CGRectMake(0, 0, RIGHTVIEW_WIDTH, SCREEN_HEIGHT-RIGHTVIEW_Y);
        }];
    } else {
        
        self.tabBarController.tabBar.hidden = NO;
        leftView.isShow = NO;
        [UIView animateWithDuration:0.3 animations:^{
            leftView.frame = CGRectMake(-SCREEN_WIDTH, 0, RIGHTVIEW_WIDTH, SCREEN_HEIGHT-RIGHTVIEW_Y);
        }];
    }
}

- (void)pushTOMyFun {
    [self performSegueWithIdentifier:@"MineFan" sender:self];
}

- (void)pushToMySet {
    [self performSegueWithIdentifier:@"MineSet" sender:self];
}

- (void)pushToMyCollection {
    [self performSegueWithIdentifier:@"MyCollection" sender:self];
}

@end
