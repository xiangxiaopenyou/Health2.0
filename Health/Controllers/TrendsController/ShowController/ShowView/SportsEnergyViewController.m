//
//  SportsEnergyViewController.m
//  Health
//
//  Created by realtech on 15/4/17.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "SportsEnergyViewController.h"
#import "SelectedSportsViewController.h"

@interface SportsEnergyViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
    UITableView *sportsTableView;
    NSMutableArray *sportsArray;
    NSInteger selectedRow;
    NSString *selectedTime;
    NSString *selectedName;
    UIView *tipView;
    
    UILabel *sportsCountLabel;
    UILabel *sportsEnergyLabel;
    
    BOOL selectedViewShow;
    UserInfo *userInfo;
    
    UITextField *searchText;
    UIImageView *searchImage;
    UILabel *searchLabel;
    UIButton *searchButton;
    
}

@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *ensureButton;

@end

@implementation SportsEnergyViewController
@synthesize selectedSportsArray, selectedArray, selectDic, countEnergy;
@synthesize selectedView, picker, cancelButton, ensureButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    // Do any additional setup after loading the view from its nib.
    sportsArray = [[NSMutableArray alloc] init];
    if (selectedSportsArray.count == 0) {
        selectedSportsArray = [[NSMutableArray alloc] init];
    }
    if (selectedArray.count == 0) {
        selectedArray = [[NSMutableArray alloc] init];
    }
    if (selectDic == nil) {
        selectDic = [[NSMutableDictionary alloc] init];
    }
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"运动计算"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 20, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *saveButton =[UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(SCREEN_WIDTH - 50, 22, 40, 40);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:MAIN_COLOR_YELLOW forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    self.view.backgroundColor = TABLEVIEW_BACKGROUNDCOLOR;
    
    [self setupHeaderView];
    
    sportsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT + 40, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 88)];
    sportsTableView.delegate = self;
    sportsTableView.dataSource = self;
    sportsTableView.showsVerticalScrollIndicator = NO;
    sportsTableView.backgroundColor = CLEAR_COLOR;
    sportsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:sportsTableView];
    
    
    tipView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 48, SCREEN_WIDTH, 48)];
    tipView.backgroundColor = CLEAR_COLOR;
    tipView.userInteractionEnabled = YES;
    [tipView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipViewPress:)]];
    [self.view addSubview:tipView];
    //tipView.hidden = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 50, 48)];
    label.text = @"已消耗:";
    label.font = SMALLFONT_14;
    label.textColor = [UIColor whiteColor];
    [tipView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 140, 0, 20, 48)];
    label1.text = @"项";
    label1.font = SMALLFONT_14;
    label1.textColor = WHITE_CLOCLOR;
    [tipView addSubview:label1];
    
    sportsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 165, 0, 20, 48)];
    sportsCountLabel.font = SMALLFONT_16;
    sportsCountLabel.textColor = MAIN_COLOR_YELLOW;
    sportsCountLabel.textAlignment = NSTextAlignmentRight;
    
    [tipView addSubview:sportsCountLabel];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 0, 28, 48)];
    label2.text = @"大卡";
    label2.textColor = WHITE_CLOCLOR;
    label2.font = SMALLFONT_14;
    [tipView addSubview:label2];
    
    sportsEnergyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 118, 0, 50, 48)];
    sportsEnergyLabel.textColor = MAIN_COLOR_YELLOW;
    sportsEnergyLabel.font = SMALLFONT_16;
    sportsEnergyLabel.textAlignment = NSTextAlignmentRight;
    [tipView addSubview:sportsEnergyLabel];
    
    UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, 16.5, 15, 15)];
    rightImage.image = [UIImage imageNamed:@"club_member_right"];
    [tipView addSubview:rightImage];
    
    [self setupTipView];
    
    [self getSportsList];
    
    [self setupSelectedView];
}

- (void)setupHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 40)];
    headerView.backgroundColor = CLEAR_COLOR;
    [self.view addSubview:headerView];
    
    searchText = [[UITextField alloc] initWithFrame:CGRectMake(16, 7, SCREEN_WIDTH - 76, 26)];
    searchText.delegate = self;
    searchText.font = SMALLFONT_13;
    searchText.returnKeyType = UIReturnKeyDone;
    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchText.layer.masksToBounds = YES;
    searchText.layer.cornerRadius = 2;
    searchText.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [headerView addSubview:searchText];
    
    searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5.5, 15, 15)];
    searchImage.image = [UIImage imageNamed:@"clockin_search"];
    [searchText addSubview:searchImage];
    
    searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, 0, 150, 26)];
    searchLabel.text = @"快速搜索运动项目";
    searchLabel.textColor = [UIColor colorWithRed:191/255.0 green:192/255.0 blue:192/255.0 alpha:1.0];
    searchLabel.font = SMALLFONT_13;
    [searchText addSubview:searchLabel];
    
    searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(SCREEN_WIDTH - 50, 5, 50, 30);
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton setTitleColor:WHITE_CLOCLOR forState:UIControlStateNormal];
    searchButton.titleLabel.font = SMALLFONT_14;
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:searchButton];
}
- (void)setupSelectedView {
    selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    selectedView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    selectedView.userInteractionEnabled = YES;
    [selectedView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelectView)]];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2 - 100, SCREEN_WIDTH - 60, 162)];
    picker.delegate = self;
    picker.dataSource = self;
    picker.backgroundColor = [UIColor colorWithRed:238/255.0 green:244/255.0 blue:251/255.0 alpha:1.0];
    picker.layer.masksToBounds = YES;
    picker.layer.cornerRadius = 5;
    [selectedView addSubview:picker];
    
    CGRect pickerFrame = picker.frame;
    UILabel *minutesLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60)/2 + 30, CGRectGetHeight(pickerFrame)/2 - 15, 40, 30)];
    minutesLabel.text = @"分钟";
    minutesLabel.font = [UIFont systemFontOfSize:18];
    [picker addSubview:minutesLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 157.5, SCREEN_WIDTH - 60, 0.5)];
    line.backgroundColor = LINE_COLOR_GARG;
    [picker addSubview:line];
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(30, SCREEN_HEIGHT/2 + 58, (SCREEN_WIDTH-60)/2, 35);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor colorWithRed:238/255.0 green:244/255.0 blue:251/255.0 alpha:1.0];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [selectedView addSubview:cancelButton];
    
    ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ensureButton.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 + 58, (SCREEN_WIDTH-60)/2, 35);
    [ensureButton setTitle:@"确定" forState:UIControlStateNormal];
    [ensureButton setTitleColor:TABLEVIEW_BACKGROUNDCOLOR forState:UIControlStateNormal];
    ensureButton.backgroundColor = MAIN_COLOR_YELLOW;
    [ensureButton addTarget:self action:@selector(ensureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [selectedView addSubview:ensureButton];
    
    [self.view addSubview:selectedView];
    
    [selectedView setHidden:YES];
}
- (void)cancelButtonClick{
    [selectedView setHidden:YES];
}
- (void)ensureButtonClick{
    [selectedView setHidden:YES];
    selectedTime = [NSString stringWithFormat:@"%ld", [picker selectedRowInComponent:0] * 5];
    NSDictionary *dic = [sportsArray objectAtIndex:selectedRow];
    if ([selectedSportsArray containsObject:[dic objectForKey:@"name"]]){
        [selectedSportsArray removeObject:[dic objectForKey:@"name"]];
        [selectDic removeObjectForKey:selectedName];
        for (NSDictionary *tempDic in selectedArray){
            if ([[tempDic objectForKey:@"id"] isEqualToString:[dic objectForKey:@"id"]]) {
                countEnergy = countEnergy - [[tempDic objectForKey:@"energy"] integerValue];
                [selectedArray removeObject:tempDic];
                NSInteger energyInt = [Util getSportsEnergy:[selectedTime integerValue] withPerEnergy:[[dic objectForKey:@"calorie"] integerValue]];
                NSString *energyString = [NSString stringWithFormat:@"%ld", (long)energyInt];
                countEnergy  = countEnergy + [energyString integerValue];
                NSMutableDictionary *tDic = [[NSMutableDictionary alloc] init];
                [tDic setObject:[dic objectForKey:@"name"] forKey:@"sportsname"];
                [tDic setObject:[dic objectForKey:@"calorie"] forKey:@"perenergy"];
                [tDic setObject:[dic objectForKey:@"id"] forKey:@"id"];
                [tDic setObject:selectedTime forKey:@"selectedtime"];
                [tDic setObject:energyString forKey:@"energy"];
                
                [selectedArray addObject:tDic];
                break;
                
            }
        }
        
        [selectedSportsArray addObject:[dic objectForKey:@"name"]];
        [selectDic setObject:selectedTime forKey:selectedName];
    }
    else{
        [selectedSportsArray addObject:[dic objectForKey:@"name"]];
        [selectDic setObject:selectedTime forKey:selectedName];
        NSInteger energyInt = [Util getSportsEnergy:[selectedTime integerValue] withPerEnergy:[[dic objectForKey:@"calorie"] integerValue]];
        NSString *energyString = [NSString stringWithFormat:@"%ld", (long)energyInt];
        countEnergy  = countEnergy + [energyString integerValue];
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
        [mDic setObject:[dic objectForKey:@"name"] forKey:@"sportsname"];
        [mDic setObject:[dic objectForKey:@"calorie"] forKey:@"perenergy"];
        [mDic setObject:[dic objectForKey:@"id"] forKey:@"id"];
        [mDic setObject:selectedTime forKey:@"selectedtime"];
        [mDic setObject:energyString forKey:@"energy"];
        [selectedArray addObject:mDic];
    }
    [self setupTipView];
    [sportsTableView reloadData];
}
- (void)hideSelectView{
    [selectedView setHidden:YES];
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([@"\n" isEqualToString:string]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    searchImage.hidden = YES;
    searchLabel.hidden = YES;
}

- (void)searchButtonClick{
    [self getSportsList];
    [searchText resignFirstResponder];
}

- (void)setupTipView{
    sportsCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)selectedSportsArray.count];
    
    sportsEnergyLabel.text = [NSString stringWithFormat:@"%ld", (long)countEnergy];
}
- (void)getSportsList{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    if (![Util isEmpty:searchText.text]) {
        [dic setObject:searchText.text forKey:@"like"];
    }
    [TrendRequest sportsListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            sportsArray = [response objectForKey:@"data"];
            [sportsTableView reloadData];
        }
        else {}
    } failure:^(NSError *error) {
        
    }];
}


- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 保存数据
 */
- (void)saveButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
    if (selectedArray.count != 0) {
        [self.delegate clickSave:selectedArray withSelectedName:selectedSportsArray WithDic:selectDic withAllEnergy:countEnergy];
    }
   
}
- (void)tipViewPress:(UITapGestureRecognizer*)gesture{
    SelectedSportsViewController *controller = [[SelectedSportsViewController alloc] init];
    controller.sportsArray = selectedArray;
    controller.energyCount = countEnergy;
    [self.navigationController pushViewController:controller animated:YES];
}

//#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return sportsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    NSDictionary *tempDic = [sportsArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    cell.textLabel.text = [tempDic objectForKey:@"name"];
    cell.textLabel.textColor = WHITE_CLOCLOR;
    cell.textLabel.font = SMALLFONT_14;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@大卡/60分钟", [tempDic objectForKey:@"calorie"]];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:148/255.0 green:147/255.0 blue:161/255.0 alpha:1.0];
    cell.detailTextLabel.font = SMALLFONT_12;
    //if ([self indexPathRow:indexPath]) {
    if ([self isContained:[tempDic objectForKey:@"name"]]) {
        UILabel *energyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 15, 84, 20)];
        energyLabel.font = SMALLFONT_14;
        energyLabel.textColor = WHITE_CLOCLOR;
        energyLabel.textAlignment = NSTextAlignmentRight;
        NSInteger energyInt = [Util getSportsEnergy:[[selectDic objectForKey:[tempDic objectForKey:@"name"]] integerValue] withPerEnergy:[[tempDic objectForKey:@"calorie"] integerValue]];
        NSString *energyString = [NSString stringWithFormat:@"%ld", (long)energyInt];
        energyLabel.text = [NSString stringWithFormat:@"%@大卡", energyString];
        [cell addSubview:energyLabel];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 35, 84, 15)];
        timeLabel.text = [NSString stringWithFormat:@"%@分钟", [selectDic  objectForKey:[tempDic objectForKey:@"name"]]];
        timeLabel.textColor = [UIColor colorWithRed:148/255.0 green:147/255.0 blue:161/255.0 alpha:1.0];
        timeLabel.font = SMALLFONT_12;
        timeLabel.textAlignment = NSTextAlignmentRight;
        [cell addSubview:timeLabel];
        
    }
    else{
        UILabel *writeButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 18, 64, 30)];
        writeButtonLabel.layer.masksToBounds = YES;
        writeButtonLabel.layer.cornerRadius = 3;
        writeButtonLabel.text = @"+记录";
        writeButtonLabel.textColor = MAIN_COLOR_YELLOW;
        writeButtonLabel.textAlignment = NSTextAlignmentCenter;
        writeButtonLabel.layer.borderWidth = 1;
        writeButtonLabel.layer.borderColor = MAIN_COLOR_YELLOW.CGColor;
        [cell addSubview:writeButtonLabel];
    }
    cell.backgroundColor = TABLEVIEWCELL_COLOR;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 65.5, SCREEN_WIDTH - 10, 0.5)];
    line.backgroundColor = LINE_COLOR_GARG;
    [cell addSubview:line];
    
    
    return cell;

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [searchText resignFirstResponder];
    [selectedView setHidden:NO];
    selectedRow = indexPath.row;
    NSDictionary *tempD = [sportsArray objectAtIndex:indexPath.row];
    selectedName = [tempD objectForKey:@"name"];
   // selectIndexPath=indexPath;
    
}

#pragma mark - UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 101;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%ld", row*5];
}

- (BOOL)isContained:(NSString*)sports{
    for (NSString *tempDic in selectedSportsArray) {
        if ([sports isEqualToString:tempDic]) {
            return YES;
        }
    }
    return NO;
}
//- (BOOL)indexPathRow:(NSIndexPath *)indexPath
//{
//    for (NSIndexPath *path in selectRowArray) {
//        if (indexPath==path) {
//            return YES;
//        }
//    }
//    return NO;
//}


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
