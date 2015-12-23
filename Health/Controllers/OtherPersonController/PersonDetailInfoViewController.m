//
//  PersonDetailInfoViewController.m
//  Health
//
//  Created by cheng on 15/3/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PersonDetailInfoViewController.h"
#import "MineDetailInfoViewCell.h"
#import "PersonRequest.h"

@interface PersonDetailInfoViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray* itemArray;
    NSArray* itemValueArray;
    UIView* blackview;
}

@end

@implementation PersonDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"个人资料"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:titleLabel];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    itemArray = [[NSArray alloc]init];
    itemArray= @[@"头像",@"昵称",@"性别",@"生日",@"身高",@"体重",@"签名"];
//    itemArray= @[@"头像",@"昵称",@"性别",@"生日",@"身高",@"体重",@"签名",@"所在地"];
    if ([self.personInfo.isTeacher intValue] == 1) {
//        itemArray= @[@"头像",@"昵称",@"性别",@"生日",@"身高",@"体重",@"签名",@"所在地",@"擅长项目"];
        itemArray= @[@"头像",@"昵称",@"性别",@"生日",@"身高",@"体重",@"签名",@"擅长项目"];
    }
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    //self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.separatorColor =[UIColor whiteColor];
    self.tableview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.tableview];
    self.tableview.tableFooterView = [[UIView alloc]init];
    [self getInfoData];

}
- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getInfoData {
    
    [PersonRequest personDetailInfoWith:self.personInfo success:^(id response) {
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ([self.personInfo.isTeacher intValue] == 1) {
        return 8;
    }
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *mineDetailInfo = @"MineDetailInfo";
    MineDetailInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineDetailInfo];
    if (cell == nil) {
        cell = [[MineDetailInfoViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mineDetailInfo];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.item.text = [itemArray objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:{
            cell.item.frame = CGRectMake(15, 25, 100, 30);
            [cell addSubview:cell.portrait];
            [cell.portrait sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:self.personInfo.photo]]];
        }break;
        case 1:{
            cell.itemValue.text = self.personInfo.name;
        }break;
        case 2:{
            if ([self.personInfo.sex integerValue] == 1) {
                cell.itemValue.text =@"男";
            } else {
                cell.itemValue.text = @"女";
            }
        }break;
        case 3:{
            if (![Util isEmpty:self.personInfo.birthday]) {
                cell.itemValue.text = self.personInfo.birthday;
            } else {
                cell.itemValue.text = @"保密";
            }
        }break;
        case 4:{
            if (![Util isEmpty:self.personInfo.height]) {
                cell.itemValue.text = self.personInfo.height;
            } else {
                cell.itemValue.text = @"保密";
            }
        }break;
        case 5:{
            if (![Util isEmpty:self.personInfo.weight]) {
                cell.itemValue.text = self.personInfo.weight;
            } else {
                cell.itemValue.text = @"保密";
            }
        }break;
        case 6:{
            NSString *strText = self.personInfo.introduce;
            UIFont *font = [UIFont systemFontOfSize:17.0f];
            CGSize size = [strText sizeWithFont:font constrainedToSize:CGSizeMake(cell.itemValue.frame.size.width, NSIntegerMax) lineBreakMode:NSLineBreakByCharWrapping];
            cell.itemValue.frame = CGRectMake(cell.itemValue.frame.origin.x, cell.itemValue.frame.origin.y, SCREEN_WIDTH - 120, size.height);
            cell.itemValue.text = self.personInfo.introduce;
        }break;
//        case 7:{
//            cell.itemValue.text = self.personInfo.address;
//        }break;
        case 7:{
            NSString *strText = self.personInfo.goodAt;
            UIFont *font = [UIFont systemFontOfSize:17.0f];
            CGSize size = [strText sizeWithFont:font constrainedToSize:CGSizeMake(cell.itemValue.frame.size.width, NSIntegerMax) lineBreakMode:NSLineBreakByCharWrapping];
            cell.itemValue.frame = CGRectMake(cell.itemValue.frame.origin.x, cell.itemValue.frame.origin.y, SCREEN_WIDTH - 120, size.height);
            cell.itemValue.text = self.personInfo.goodAt;
        }break;
        default:
            break;
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80;
    } else if (indexPath.row == 6) {
        static NSString *mineDetailInfo = @"MineDetailInfo";
        MineDetailInfoViewCell *cell = [[MineDetailInfoViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mineDetailInfo];
        NSString *strText = self.personInfo.introduce;
        if ([Util isEmpty:strText]) {
            strText = @"1";
        }
        UIFont *font = [UIFont systemFontOfSize:17.0f];
        CGSize size = [strText sizeWithFont:font constrainedToSize:CGSizeMake(cell.itemValue.frame.size.width, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
        return size.height+40;
    }else if (indexPath.row == 7){
        static NSString *mineDetailInfo = @"MineDetailInfo";
        MineDetailInfoViewCell *cell = [[MineDetailInfoViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mineDetailInfo];
        NSString *strText = self.personInfo.goodAt;
        if ([Util isEmpty:strText]) {
            strText = @"1";
        }
        UIFont *font = [UIFont systemFontOfSize:17.0f];
        CGSize size = [strText sizeWithFont:font constrainedToSize:CGSizeMake(cell.itemValue.frame.size.width, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
        return size.height+40;
    }else {
        return 60;
    }
}


@end
