//
//  SelectedSportsViewController.m
//  Health
//
//  Created by realtech on 15/4/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "SelectedSportsViewController.h"

@interface SelectedSportsViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation SelectedSportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"已消耗"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 20, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    [self setupTipView];
    
    selectedTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 48)];
    selectedTableview.delegate = self;
    selectedTableview.dataSource = self;
    selectedTableview.backgroundColor = [UIColor clearColor];
    selectedTableview.showsVerticalScrollIndicator = NO;
    selectedTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:selectedTableview];
    
}
- (void)setupTipView{
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 48, SCREEN_WIDTH, 48)];
    tipView.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    [self.view addSubview:tipView];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 130, 0, 15, 48)];
    label2.text = @"项";
    label2.font = SMALLFONT_14;
    label2.textColor = [UIColor whiteColor];
    [tipView addSubview:label2];
    
    UILabel *sportsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150, 0, 20, 48)];
    sportsCountLabel.font = SMALLFONT_16;
    sportsCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.sportsArray.count];
    sportsCountLabel.textColor = MAIN_COLOR_YELLOW;
    sportsCountLabel.textAlignment = NSTextAlignmentRight;
    [tipView addSubview:sportsCountLabel];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 0, 30, 48)];
    label3.text = @"大卡";
    label3.font = SMALLFONT_14;
    label3.textColor = [UIColor whiteColor];
    [tipView addSubview:label3];
    
    UILabel *sportsEnergyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110, 0, 40, 48)];
    sportsEnergyLabel.textColor = MAIN_COLOR_YELLOW;
    sportsEnergyLabel.text = [NSString stringWithFormat:@"%ld", (long)self.energyCount];
    sportsEnergyLabel.font = SMALLFONT_16;
    sportsEnergyLabel.textAlignment = NSTextAlignmentRight;
    [tipView addSubview:sportsEnergyLabel];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableview Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sportsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *selectedCellIdentifier = @"selectedCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:selectedCellIdentifier];
    NSDictionary *dic = [self.sportsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"sportsname"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@大卡/60分钟", [dic objectForKey:@"perenergy"]];
    cell.detailTextLabel.textColor = TIME_COLOR_GARG;
    
    UILabel *enLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 16, 84, 20)];
    enLabel.font = SMALLFONT_14;
    enLabel.textColor = [UIColor whiteColor];
    enLabel.textAlignment = NSTextAlignmentRight;
    enLabel.text = [NSString stringWithFormat:@"%@大卡", [dic objectForKey:@"energy"]];
    [cell addSubview:enLabel];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 36, 84, 15)];
    timeLabel.font = SMALLFONT_12;
    timeLabel.text = [NSString stringWithFormat:@"%@分钟", [dic objectForKey:@"selectedtime"]];
    timeLabel.textColor = TIME_COLOR_GARG;
    timeLabel.textAlignment = NSTextAlignmentRight;
    [cell addSubview:timeLabel];
    cell.backgroundColor = TABLEVIEWCELL_COLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = TABLEVIEWCELL_COLOR;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 65.5, SCREEN_WIDTH - 10, 0.5)];
    line.backgroundColor = LINE_COLOR_GARG;
    [cell addSubview:line];
    return cell;
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
