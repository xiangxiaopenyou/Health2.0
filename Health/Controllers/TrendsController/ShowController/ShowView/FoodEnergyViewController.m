//
//  FoodEnergyViewController.m
//  Health
//
//  Created by realtech on 15/4/17.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "FoodEnergyViewController.h"
#import "SelectedFoodViewController.h"

@interface FoodEnergyViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
    UITableView *foodTableView;
    
    NSMutableArray *foodArray;
    
    NSInteger selectedRow;
    NSString *selectedWeight;
    
    UIView *tipView;
    
    UILabel *foodCountLabel;
    UILabel *foodEnergyLabel;
    
    BOOL selectedViewShow;
    
    UserInfo *userInfo;
    NSString *selectedName;
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

@implementation FoodEnergyViewController
@synthesize selectDic, selectedArray, selectedFoodArray, countEnergy;
@synthesize selectedView, picker, cancelButton, ensureButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UserData *userData = [UserData shared];
    userInfo = userData.userInfo;
    
    foodArray = [[NSMutableArray alloc] init];
    if (selectedFoodArray.count == 0) {
        selectedFoodArray = [[NSMutableArray alloc] init];
    }
    if (selectedArray.count == 0){
        selectedArray = [[NSMutableArray alloc] init];
    }
    if (selectDic == nil) {
        selectDic=[[NSMutableDictionary alloc]init];
    }
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"饮食计算"];
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
    
    foodTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT + 40, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 88)];
    foodTableView.delegate = self;
    foodTableView.dataSource = self;
    foodTableView.showsVerticalScrollIndicator = NO;
    foodTableView.backgroundColor = CLEAR_COLOR;
    foodTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:foodTableView];
    
    tipView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 48, SCREEN_WIDTH, 48)];
    tipView.backgroundColor = CLEAR_COLOR;
    tipView.userInteractionEnabled = YES;
    [tipView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipViewPress:)]];
    [self.view addSubview:tipView];
    //tipView.hidden = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 50, 48)];
    label.text = @"已摄入:";
    label.font = SMALLFONT_14;
    label.textColor = [UIColor whiteColor];
    [tipView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 140, 0, 20, 48)];
    label1.text = @"项";
    label1.font = SMALLFONT_14;
    label1.textColor = WHITE_CLOCLOR;
    [tipView addSubview:label1];
    
    foodCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 165, 0, 20, 48)];
    foodCountLabel.font = SMALLFONT_16;
    foodCountLabel.textColor = MAIN_COLOR_YELLOW;
    foodCountLabel.textAlignment = NSTextAlignmentRight;
    
    [tipView addSubview:foodCountLabel];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 0, 28, 48)];
    label2.text = @"大卡";
    label2.textColor = WHITE_CLOCLOR;
    label2.font = SMALLFONT_14;
    [tipView addSubview:label2];
    
    foodEnergyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 118, 0, 50, 48)];
    foodEnergyLabel.textColor = MAIN_COLOR_YELLOW;
    foodEnergyLabel.font = SMALLFONT_16;
    foodEnergyLabel.textAlignment = NSTextAlignmentRight;
    [tipView addSubview:foodEnergyLabel];
    
    UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 25, 16.5, 15, 15)];
    rightImage.image = [UIImage imageNamed:@"club_member_right"];
    [tipView addSubview:rightImage];

    [self setupTipView];
    [self getFoodList];
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
    searchText.layer.masksToBounds = YES;
    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchText.layer.cornerRadius = 2;
    searchText.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [headerView addSubview:searchText];
    
    searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5.5, 15, 15)];
    searchImage.image = [UIImage imageNamed:@"clockin_search"];
    [searchText addSubview:searchImage];
    
    searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, 0, 150, 26)];
    searchLabel.text = @"快速搜索食物名称";
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
    minutesLabel.text = @"克";
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
    selectedWeight = [NSString stringWithFormat:@"%ld", [picker selectedRowInComponent:0]*5];
    NSDictionary *foodDic = [foodArray objectAtIndex:selectedRow];
    if ([selectedFoodArray containsObject:[foodDic objectForKey:@"name"]]){
        [selectDic removeObjectForKey:selectedName];
        [selectedFoodArray removeObject:[foodDic objectForKey:@"name"]];
        for (NSDictionary *tempDic in selectedArray){
            if ([[tempDic objectForKey:@"id"] isEqualToString:[foodDic objectForKey:@"id"]]) {
                
                countEnergy = countEnergy - [[tempDic objectForKey:@"foodenergy"] integerValue];
                
                NSInteger energyInt = [Util getFoodEnergy:[selectedWeight integerValue] withPerEnergy:[[foodDic objectForKey:@"calorie"] integerValue]];
                NSString *energyString = [NSString stringWithFormat:@"%ld", (long)energyInt];
                countEnergy  = countEnergy + [energyString integerValue];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:[foodDic objectForKey:@"name"] forKey:@"foodname"];
                [dic setObject:[foodDic objectForKey:@"calorie"] forKey:@"foodperenergy"];
                [dic setObject:[foodDic objectForKey:@"id"] forKey:@"id"];
                [dic setObject:selectedWeight forKey:@"selectedweight"];
                [dic setObject:energyString forKey:@"foodenergy"];
                [selectedArray removeObject:tempDic];
                
                
                [selectedArray addObject:dic];
                break;
                
            }
        }
        
        [selectedFoodArray addObject:[foodDic objectForKey:@"name"]];
        [selectDic setObject:selectedWeight forKey:selectedName];
    }
    else{
        
        [selectedFoodArray addObject:[foodDic objectForKey:@"name"]];
        [selectDic setObject:selectedWeight forKey:selectedName];
        NSInteger energyInt = [Util getFoodEnergy:[selectedWeight integerValue] withPerEnergy:[[foodDic objectForKey:@"calorie"] integerValue]];
        NSString *energyString = [NSString stringWithFormat:@"%ld", (long)energyInt];
        countEnergy  = countEnergy + [energyString integerValue];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[foodDic objectForKey:@"name"] forKey:@"foodname"];
        [dic setObject:[foodDic objectForKey:@"calorie"] forKey:@"foodperenergy"];
        [dic setObject:[foodDic objectForKey:@"id"] forKey:@"id"];
        [dic setObject:selectedWeight forKey:@"selectedweight"];
        [dic setObject:energyString forKey:@"foodenergy"];
        [selectedArray addObject:dic];
        
    }
    [foodTableView reloadData];
    [self setupTipView];
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

- (void)setupTipView{
    foodCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)selectedFoodArray.count];
    
    foodEnergyLabel.text = [NSString stringWithFormat:@"%ld", (long)countEnergy];
}
- (void)searchButtonClick{
    [self getFoodList];
    [searchText resignFirstResponder];
}
- (void)getFoodList{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    if (![Util isEmpty:searchText.text]) {
        [dic setObject:searchText.text forKey:@"like"];
    }
    [TrendRequest foodListWith:dic success:^(id response) {
        if ([[response objectForKey:@"state"] integerValue] == 1000) {
            foodArray = [response objectForKey:@"data"];
            [foodTableView reloadData];
        }
        else {}
    } failure:^(NSError *error) {
        
    }];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
    if (selectedArray.count !=0 ) {
        [self.delegate clickFoodSave:selectedArray withSelectedName:selectedFoodArray withDic:selectDic withAllEnergy:countEnergy];
    }
    
}
- (void)tipViewPress:(UITapGestureRecognizer*)gesture{
    SelectedFoodViewController *controller = [[SelectedFoodViewController alloc] init];
    controller.foodArray = selectedArray;
    controller.energyCount = countEnergy;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return foodArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    NSDictionary *tempDic = [foodArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    cell.textLabel.text = [tempDic objectForKey:@"name"];
    cell.textLabel.textColor = WHITE_CLOCLOR;
    cell.textLabel.font = SMALLFONT_14;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@大卡/100克", [tempDic objectForKey:@"calorie"]];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:148/255.0 green:147/255.0 blue:161/255.0 alpha:1.0];
    cell.detailTextLabel.font = SMALLFONT_12;
    
    //if ([self indexPathRow:indexPath]) {
    if ([self isContained:[tempDic objectForKey:@"name"]]) {
        UILabel *energyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 15, 84, 20)];
        energyLabel.font = SMALLFONT_14;
        energyLabel.textColor = WHITE_CLOCLOR;
        energyLabel.textAlignment = NSTextAlignmentRight;
        NSInteger energyInt = [Util getFoodEnergy:[[selectDic objectForKey:[tempDic objectForKey:@"name"]] integerValue] withPerEnergy:[[tempDic objectForKey:@"calorie"] integerValue]];
        NSString *energyString = [NSString stringWithFormat:@"%ld", (long)energyInt];
        energyLabel.text = [NSString stringWithFormat:@"%@大卡", energyString];
        [cell addSubview:energyLabel];
        UILabel *weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 35, 84, 15)];
        weightLabel.text = [NSString stringWithFormat:@"%@克", [selectDic objectForKey:[tempDic objectForKey:@"name"]]];
        weightLabel.textColor = [UIColor colorWithRed:148/255.0 green:147/255.0 blue:161/255.0 alpha:1.0];
        weightLabel.font = SMALLFONT_12;
        weightLabel.textAlignment = NSTextAlignmentRight;
        [cell addSubview:weightLabel];
    }
    else {
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
    NSDictionary *tempD = [foodArray objectAtIndex:indexPath.row];
    selectedName = [tempD objectForKey:@"name"];
    
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
- (BOOL)isContained:(NSString*)food{
    for (NSString *tempDic in selectedFoodArray) {
        if ([food isEqualToString:tempDic]) {
            return YES;
        }
    }
    return NO;
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
