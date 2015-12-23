//
//  MyInfoViewController.m
//  Health
//
//  Created by cheng on 15/3/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MineDetailInfoViewCell.h"
#import "MyRequest/MyInfoRequest.h"
#import "RMDateSelectionViewController.h"
#import "WriteIntrduceViewController.h"
#import <TuSDK/TuSDK.h>

#define IS_IOS7 [[UIDevice currentDevice].systemVersion  isEqual: @"7.0"]
@interface MyInfoViewController ()<UIActionSheetDelegate,TuSDKPFCameraDelegate,RMDateSelectionViewControllerDelegate>{
    NSArray* itemArray;
    NSArray* itemValueArray;
    UIView* blackview;
    UILabel *altlabel;
    // 自定义系统相册组件
    TuSDKCPAlbumComponent *_albumComponent;
    
    // 图片编辑组件
    TuSDKCPPhotoEditComponent *_photoEditComponent;
    
    TuSDKPFEditEntryOptions *_editEntryOptions;
    TuSDKPFEditCuterOptions *_editCuterOptions;
}

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] init];
//    leftButtonItem.title = @"";
//    self.navigationItem.backBarButtonItem = leftButtonItem;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"save_myinfo_image.png"] style:UIBarButtonItemStylePlain target:self action:@selector(modifyInfo)];
    NSLog(@"%@",[UIDevice currentDevice].systemVersion);
    
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(bClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(SCREEN_WIDTH - 50, 20, 44, 44);
    [saveButton setImage:[UIImage imageNamed:@"save_myinfo_image.png"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(modifyInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];


    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"个人资料"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:titleLabel];
    
    itemArray = [[NSArray alloc]init];
//    itemArray= @[@"头像",@"昵称",@"性别",@"生日",@"身高",@"体重",@"签名",@"所在地"];
    itemArray= @[@"头像",@"昵称",@"性别",@"生日",@"身高",@"体重",@"签名",@"手机号"];
    UserData *userdata = [UserData shared];
    UserInfo *userInfo = userdata.userInfo;
    if ([userInfo.usertype intValue] == 1) {
//        itemArray= @[@"头像",@"昵称",@"性别",@"生日",@"身高",@"体重",@"签名",@"所在地",@"擅长项目"];
        itemArray= @[@"头像",@"昵称",@"性别",@"生日",@"身高",@"体重",@"签名",@"手机号",@"擅长项目"];
    }
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 50)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    //self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.separatorColor = LINE_COLOR_GARG;
    self.tableview.backgroundColor = TABLEVIEWCELL_COLOR;
    [self.view addSubview:self.tableview];
    self.tableview.tableFooterView = [[UIView alloc]init];
    [self getInfoData];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:MAIN_COLOR_YELLOW];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    btn.titleLabel.font = BOLDFONT_18;
    [btn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)bClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loginOut{
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"usertoken"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"rongyunid"];
    [[RCIM sharedRCIM] disconnect:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Login" object:nil];
}

- (void)getInfoData {
    UserData *userdata = [UserData shared];
    UserInfo *userInfo = userdata.userInfo;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken", nil];
    [MyInfoRequest myDetailInfoWithParam:dic success:^(id response) {
        [self.tableview reloadData];
    } failure:^(NSError *error) {
    }];
}

- (void)modifyInfo{
    
    UserData *userdata = [UserData shared];
    UserInfo *userInfo = userdata.userInfo;
    //usernickname usersex userheadportrait userheightpubilc userweightpublic userintrduce userbirtday goodat
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:userInfo.userid forKey:@"userid"];
    [dic setObject:userInfo.usertoken forKey:@"usertoken"];
    if ([Util isEmpty:userInfo.username]) {
        [dic setObject:@"" forKey:@"usernickname"];
    }else{
        [dic setObject:userInfo.username forKey:@"usernickname"];
    }
    if ([Util isEmpty:userInfo.userintrduce]) {
        [dic setObject:@"" forKey:@"userintroduce"];
    }else{
        [dic setObject:userInfo.userintrduce forKey:@"userintroduce"];
    }
    if ([Util isEmpty:userInfo.userweight]) {
        [dic setObject:@"0" forKey:@"userweight"];
    }else{
        [dic setObject:userInfo.userweight forKey:@"userweight"];
    }
    
    if ([Util isEmpty:userInfo.usertelphone]) {
        [dic setObject:@"" forKey:@"tel"];
    }else{
        [dic setObject:userInfo.usertelphone forKey:@"tel"];
    }

    if ([Util isEmpty:userInfo.userheight]) {
        [dic setObject:@"0" forKey:@"userheight"];
    }else{
        [dic setObject:userInfo.userheight forKey:@"userheight"];
    }
    if ([Util isEmpty:userInfo.userbirthday]) {
        [dic setObject:[CustomDate getBirthDayString:[NSDate date]] forKey:@"userbirthday"];
    }else{
        [dic setObject:userInfo.userbirthday forKey:@"userbirthday"];
    }
    if ([Util isEmpty:userInfo.usersex]) {
        [dic setObject:@"1" forKey:@"usersex"];
    }else{
        [dic setObject:userInfo.usersex forKey:@"usersex"];
    }
    if ([userInfo.usertype intValue] == 1) {
        if ([Util isEmpty:userInfo.goodat]) {
            [dic setObject:@"" forKey:@"goodat"];
        }else{
            [dic setObject:userInfo.goodat forKey:@"goodat"];
        }
    }
//    if (![JDStatusBarNotification isVisible]) {
//        [JDStatusBarNotification showWithStatus:@"正在上传..."];
//    }
//    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    [MyInfoRequest modifyMyInfoWithParam:dic success:^(id response) {
        if ([[response objectForKey:@"state"] intValue] == 1000) {
            //[JDStatusBarNotification showWithStatus:@"修改成功" dismissAfter:1.0];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            //[JDStatusBarNotification showWithStatus:@"修改失败" dismissAfter:1.0];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        //[JDStatusBarNotification showWithStatus:@"修改失败" dismissAfter:1.0];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
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
    UserData *userdata = [UserData shared];
    UserInfo *userInfo = userdata.userInfo;
    if ([userInfo.usertype intValue] == 1) {
        return 9;
    }
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *mineDetailInfo = @"MineDetailInfo";
    MineDetailInfoViewCell *cell = [[MineDetailInfoViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mineDetailInfo];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.item.text = [itemArray objectAtIndex:indexPath.row];
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    switch (indexPath.row) {
        case 0:{
            cell.item.frame = CGRectMake(15, 25, 100, 30);
            [cell addSubview:cell.portrait];
            [cell.portrait sd_setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:userinfo.userphoto]]];
        }break;
        case 1:{
            cell.itemValue.text = userinfo.username;
        }break;
        case 2:{
            if ([userinfo.usersex integerValue] == 1) {
                cell.itemValue.text =@"男";
            } else {
                cell.itemValue.text = @"女";
            }
        }break;
        case 3:{
            if (![Util isEmpty:userinfo.userbirthday]) {
                cell.itemValue.text = userinfo.userbirthday;
            } else {
                cell.itemValue.text = @"保密";
            }
        }break;
        case 4:{
            if (![Util isEmpty:userinfo.userheight]) {
                cell.itemValue.text = userinfo.userheight;
            } else {
                cell.itemValue.text = @"保密";
            }
        }break;
        case 5:{
            if (![Util isEmpty:userinfo.userweight]) {
                cell.itemValue.text = userinfo.userweight;
            } else {
                cell.itemValue.text = @"保密";
            }
        }break;
            
        case 7:{
            if (![Util isEmpty:userinfo.usertelphone]) {
                NSRange range = NSMakeRange(3, 4);
//                NSString *strRang = [userinfo.usertelphone substringWithRange:range];
//                NSRange rang = [userinfo.usertelphone rangeOfString:strRang];
                
                cell.itemValue.text = [userinfo.usertelphone stringByReplacingCharactersInRange:range withString:@"****"];
            } else {
                cell.itemValue.text = @"无";
            }
        }break;
        case 6:{
            NSString *strText = userinfo.userintrduce;
            UIFont *font = [UIFont systemFontOfSize:17.0f];
            CGSize size = [strText boundingRectWithSize:CGSizeMake(cell.itemValue.frame.size.width, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : font} context:nil].size;
#ifdef __IPHONE_7_0
            
#else
        CGSize size = [strText sizeWithFont:font constrainedToSize:CGSizeMake(cell.itemValue.frame.size.width, NSIntegerMax) lineBreakMode:NSLineBreakByCharWrapping];     
#endif
//            if (IS_IOS7) {
//                 CGSize size = [strText sizeWithFont:font constrainedToSize:CGSizeMake(cell.itemValue.frame.size.width, NSIntegerMax) lineBreakMode:NSLineBreakByCharWrapping];
//            }

//            CGSize size = [strText sizeWithFont:font constrainedToSize:CGSizeMake(cell.itemValue.frame.size.width, NSIntegerMax) lineBreakMode:NSLineBreakByCharWrapping];
           
            cell.itemValue.frame = CGRectMake(cell.itemValue.frame.origin.x, cell.itemValue.frame.origin.y, SCREEN_WIDTH - 120, size.height);
            cell.itemValue.text = userinfo.userintrduce;
        }break;
//        case 7:{
//            cell.itemValue.text = userinfo.userarea;
//        }break;
        case 8:{
            NSString *strText = userinfo.goodat;
            UIFont *font = [UIFont systemFontOfSize:17.0f];
            CGSize size = [strText boundingRectWithSize:CGSizeMake(cell.itemValue.frame.size.width, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : font} context:nil].size;
#ifdef __IPHONE_7_0
            
#else
         CGSize size = [strText sizeWithFont:font constrainedToSize:CGSizeMake(cell.itemValue.frame.size.width, NSIntegerMax) lineBreakMode:NSLineBreakByCharWrapping];
#endif
//            CGSize size = [strText sizeWithFont:font constrainedToSize:CGSizeMake(cell.itemValue.frame.size.width, NSIntegerMax) lineBreakMode:NSLineBreakByCharWrapping];
            cell.itemValue.frame = CGRectMake(cell.itemValue.frame.origin.x, cell.itemValue.frame.origin.y, SCREEN_WIDTH - 120, size.height);
            cell.itemValue.text = userinfo.goodat;
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
        UserData *userdata = [UserData shared];
        UserInfo *userInfo = userdata.userInfo;
        NSString *strText = userInfo.userintrduce;
        UIFont *font = [UIFont systemFontOfSize:17.0f];
        CGSize size = [strText boundingRectWithSize:CGSizeMake(cell.itemValue.frame.size.width, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : font} context:nil].size;
#ifdef __IPHONE_7_0
        
#else
       CGSize size = [strText sizeWithFont:font constrainedToSize:CGSizeMake(cell.itemValue.frame.size.width, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
#endif
        return size.height+40;
    }else if (indexPath.row == 8){
        static NSString *mineDetailInfo = @"MineDetailInfo";
        MineDetailInfoViewCell *cell = [[MineDetailInfoViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mineDetailInfo];
        UserData *userdata = [UserData shared];
        UserInfo *userInfo = userdata.userInfo;
        NSString *strText = userInfo.goodat;
        UIFont *font = [UIFont systemFontOfSize:17.0f];
        CGSize size = [strText boundingRectWithSize:CGSizeMake(cell.itemValue.frame.size.width, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : font} context:nil].size;
#ifdef __IPHONE_7_0
        
#else
       CGSize size = [strText sizeWithFont:font constrainedToSize:CGSizeMake(cell.itemValue.frame.size.width, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
#endif

        return size.height+40;
    }else {
        return 60;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册选择", nil];
            actionSheet.tag = 0;
            [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews]lastObject]];
        }break;
        case 1:{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alert.tag = 1;
            UITextField *textfield = [alert textFieldAtIndex:0];
            textfield.placeholder = @"请输入";
            [alert show];
        }break;
        case 2:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
            actionSheet.tag = 2;
            [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews]lastObject]];
        }break;
        case 3:{
            [self datePicker];
        }break;
        case 4:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alert.tag = 4;
            UITextField *textfield = [alert textFieldAtIndex:0];
            textfield.placeholder = @"请输入";
            textfield.keyboardType = UIKeyboardTypeNumberPad;
            [alert show];
        }break;
        case 5:{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alert.tag = 5;
            UITextField *textfield = [alert textFieldAtIndex:0];
            textfield.placeholder = @"请输入";
            textfield.keyboardType = UIKeyboardTypeNumberPad;
            [alert show];
        }break;
        case 7:{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alert.tag = 50;
            UITextField *textfield = [alert textFieldAtIndex:0];
            textfield.placeholder = @"请输入手机号";
            textfield.keyboardType = UIKeyboardTypeNumberPad;
            [alert show];
        }break;
        case 6:
        {
            UserData *userdata = [UserData shared];
            UserInfo *userInfo = userdata.userInfo;
            WriteIntrduceViewController *controller = [[WriteIntrduceViewController alloc]init];
            controller.title = @"个人介绍";
            controller.content = userInfo.userintrduce;
            [controller returnText:^(NSString *showText) {
                userInfo.userintrduce = showText;
                [self.tableview reloadData];
            }];
            [self.navigationController pushViewController:controller animated:YES];
        }break;
        case 8:{
            UserData *userdata = [UserData shared];
            UserInfo *userInfo = userdata.userInfo;
            WriteIntrduceViewController *controller = [[WriteIntrduceViewController alloc]init];
            controller.title = @"擅长项目";
            controller.content = userInfo.goodat;
            [controller returnText:^(NSString *showText) {
                userInfo.goodat = showText;
                [self.tableview reloadData];
            }];
            [self.navigationController pushViewController:controller animated:YES];
        }break;
            
        default:
            break;
    }
}

- (void)datePicker
{
    [RMDateSelectionViewController setLocalizedTitleForCancelButton:@"取消"];
    [RMDateSelectionViewController setLocalizedTitleForSelectButton:@"确定"];
    [RMDateSelectionViewController setLocalizedTitleForNowButton:@"现在"];
    RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    dateSelectionVC.delegate = self;
    dateSelectionVC.titleLabel.text = @"";
    dateSelectionVC.hideNowButton = YES;
    
    //You can enable or disable blur, bouncing and motion effects
    dateSelectionVC.disableBouncingWhenShowing = NO;
    dateSelectionVC.disableMotionEffects = NO;
    dateSelectionVC.disableBlurEffects = YES;
    
    dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDate;
    dateSelectionVC.datePicker.minuteInterval = 5;
    dateSelectionVC.datePicker.date = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    
    UserData *userdata = [UserData shared];
    UserInfo *userInfo = userdata.userInfo;
    if (userInfo.userbirthday) {
        dateSelectionVC.datePicker.date = [CustomDate getBirthdayDate:userInfo.userbirthday];
    }
    
    
    //The example project is universal. So we first need to check whether we run on an iPhone or an iPad.
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [dateSelectionVC show];
    } else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [dateSelectionVC showFromRect:self.view.frame inView:self.view];
    }
    
}
#pragma mark RMDateSelection delegate
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    UserData *userdata = [UserData shared];
    UserInfo *userInfo = userdata.userInfo;
    userInfo.userbirthday = [CustomDate getBirthDayString:aDate];
    [self.tableview reloadData];
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    NSLog(@"Date selection was canceled");
}

#pragma  mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *textfield = [alertView textFieldAtIndex:0];
        
        switch (alertView.tag) {
            case 1:{
                UserData *userdata = [UserData shared];
                UserInfo *userInfo = userdata.userInfo;
                userInfo.username = textfield.text;
            }break;
            case 4:{
                UserData *userdata = [UserData shared];
                UserInfo *userInfo = userdata.userInfo;
                userInfo.userheight = textfield.text;
            }break;
            case 5:{
                UserData *userdata = [UserData shared];
                UserInfo *userInfo = userdata.userInfo;
                userInfo.userweight = textfield.text;
            }break;
            case 50:{
                NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"^(134|135|136|137|138|139|147|150|151|152|157|158|159|182|187|188|130|131|132|155|156|185|186|133|153|180|189|177|178|176)\\d{8}$" options:NSRegularExpressionCaseInsensitive error:nil];
                NSArray *match = [reg matchesInString:textfield.text options:NSMatchingReportCompletion range:NSMakeRange(0, [textfield.text length])];
                if (match && match.count > 0) {
                    UserData *userdata = [UserData shared];
                    UserInfo *userInfo = userdata.userInfo;
                    userInfo.usertelphone = textfield.text;
                }
                else{
                    if (!altlabel) {
                        altlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 20)];
                        altlabel.text = @"手机号码格式错误";
                        altlabel.textAlignment = NSTextAlignmentCenter;
                        altlabel.textColor = [UIColor whiteColor];
                        [self.view addSubview:altlabel];
                    }
                    else{
                        altlabel.alpha = 1;
                    }
                    
                    [self performSelector:@selector(afterDelay) withObject:nil afterDelay:2];
                }
                
            }break;
            default:
                break;
        }
    }
    [self.tableview reloadData];
}

- (void)afterDelay{
    altlabel.alpha = 0;
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (actionSheet.tag) {
        case 0:{
            if (buttonIndex == 0) {
                [self cameraComponentHandler];
            }
            else if(buttonIndex == 1){
                [self editAdvancedComponentHandler];
            }
            else{
            }
        }break;
        case 2:{
            if (buttonIndex == 0) {
                UserData *userdata = [UserData shared];
                UserInfo *userInfo = userdata.userInfo;
                userInfo.usersex = @"1";
                [self.tableview reloadData];
            }
            else if(buttonIndex == 1){
                UserData *userdata = [UserData shared];
                UserInfo *userInfo = userdata.userInfo;
                userInfo.usersex = @"0";
                [self.tableview reloadData];
            }
        }break;
        default:
            break;
    }
    
}

//相机
- (void) cameraComponentHandler;
{
    // 如果不支持摄像头显示警告信息
    if ([AVCaptureDevice showAlertIfNotSupportCamera]){
        return;
    }
    
    TuSDKPFCameraOptions *opt = [TuSDKPFCameraOptions build];
    
    // 视图类 (默认:TuSDKPFCameraView, 需要继承 TuSDKPFCameraView)
    // opt.viewClazz = [TuSDKPFCameraView class];
    
    // 默认相机控制栏视图类 (默认:TuSDKPFCameraConfigView, 需要继承 TuSDKPFCameraConfigView)
    // opt.configBarViewClazz = [TuSDKPFCameraConfigView class];
    
    // 默认相机底部栏视图类 (默认:TuSDKPFCameraBottomView, 需要继承 TuSDKPFCameraBottomView)
    // opt.bottomBarViewClazz = [TuSDKPFCameraBottomView class];
    
    // 闪光灯视图类 (默认:TuSDKPFCameraFlashView, 需要继承 TuSDKPFCameraFlashView)
    // opt.flashViewClazz = [TuSDKPFCameraFlashView class];
    
    // 滤镜视图类 (默认:TuSDKPFCameraFilterView, 需要继承 TuSDKPFCameraFilterView)
    // opt.filterViewClazz = [TuSDKPFCameraFilterView class];
    
    // 聚焦触摸视图类 (默认:TuSDKICFocusTouchView, 需要继承 TuSDKICFocusTouchView)
    // opt.focusTouchViewClazz = [TuSDKICFocusTouchView class];
    
    // 摄像头前后方向 (默认为后置优先)
    // opt.avPostion = [AVCaptureDevice firstBackCameraPosition];
    
    // 设置分辨率模式
    // opt.sessionPreset = AVCaptureSessionPresetHigh;
    
    // 闪光灯模式 (默认:AVCaptureFlashModeOff)
    // opt.defaultFlashMode = AVCaptureFlashModeOff;
    
    // 是否开启滤镜支持 (默认: 关闭)
    opt.enableFilters = YES;
    
    // 默认是否显示滤镜视图 (默认: 不显示, 如果enableFilters = NO, showFilterDefault将失效)
    opt.showFilterDefault = YES;
    
    // 需要显示的滤镜名称列表 (如果为空将显示所有自定义滤镜)
    // opt.filterGroup = @[@"Normal", @"SkinTwiceMixedSigma", @"Artistic"];
    
    // 开启滤镜配置选项
    opt.enableFilterConfig = YES;
    
    // 视频视图显示比例 (默认：0， 0 <= mRegionRatio, 当设置为0时全屏显示)
    // opt.cameraViewRatio = 0.75f;
    
    // 视频视图显示比例类型 (默认:lsqRatioAll, 如果设置cameraViewRatio > 0, 将忽略ratioType)
    opt.ratioType = lsqRatioAll;
    
    // 是否开启长按拍摄 (默认: NO)
    opt.enableLongTouchCapture = YES;
    
    // 开启持续自动对焦 (默认: NO)
    opt.enableContinueFoucs = YES;
    
    // 自动聚焦延时 (默认: 5秒)
    // opt.autoFoucsDelay = 5;
    
    // 长按延时 (默认: 1.2秒)
    // opt.longTouchDelay = 1.2;
    
    // 保存到系统相册 (默认不保存, 当设置为YES时, TuSDKResult.asset)
    opt.saveToAlbum = YES;
    
    // 保存到临时文件 (默认不保存, 当设置为YES时, TuSDKResult.tmpFile)
    // opt.saveToTemp = NO;
    
    // 保存到系统相册的相册名称
    // opt.saveToAlbumName = @"TuSdk";
    
    // 照片输出压缩率 0-1 如果设置为0 将保存为PNG格式 (默认: 0.95)
    // opt.outputCompress = 0.95f;
    
    // 视频覆盖区域颜色 (默认：[UIColor clearColor])
    opt.regionViewColor = RGB(51, 51, 51);
    
    // 照片输出分辨率
    // opt.outputSize = CGSizeMake(1440, 1920);
    
    // 禁用前置摄像头自动水平镜像 (默认: NO，前置摄像头拍摄结果自动进行水平镜像)
    // opt.disableMirrorFrontFacing = YES;
    
    TuSDKPFCameraViewController *controller = opt.viewController;
    // 添加委托
    controller.delegate = self;
    [self presentModalNavigationController:controller animated:YES];
}
#pragma mark - cameraComponentHandler TuSDKPFCameraDelegate
/**
 *  获取一个拍摄结果
 *
 *  @param controller 默认相机视图控制器
 *  @param result     拍摄结果
 */
- (void)onTuSDKPFCamera:(TuSDKPFCameraViewController *)controller captureResult:(TuSDKResult *)result;
{
    //[controller dismissModalViewControllerAnimated:YES];
    [self openEditAdvancedWithController:controller result:result];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //[self editAdvancedComponentHandler];
}


#pragma mark - editAdvancedComponentHandler
- (void)editAdvancedComponentHandler;
{
    //lsqLDebug(@"editAdvancedComponentHandler");
    _albumComponent =
    [TuSDK albumCommponentWithController:self
                           callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         // 获取图片错误
         if (error) {
             [self throwWithReason:@"album reader error" userInfo:error.userInfo];
             return;
         }
         [self openEditAdvancedWithController:controller result:result];
     }];
    
    [_albumComponent showComponent];
}
/**
 *  开启图片高级编辑
 *
 *  @param controller 来源控制器
 *  @param result     处理结果
 */
- (void)openEditAdvancedWithController:(UIViewController *)controller
                                result:(TuSDKResult *)result;
{
    
    if (!controller || !result) return;
    
    _photoEditComponent =
    [TuSDK photoEditCommponentWithController:controller
                               callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         [self clearComponents];
         // 获取图片失败
         if (error) {
             [self throwWithReason:@"editAdvanced error" userInfo:error.userInfo];
             return;
         }
         [result logInfo];
         [self savePhoto:[result loadResultImage]];
         
     }];
    _photoEditComponent.options.editEntryOptions.saveToAlbum = NO;
    _photoEditComponent.options.editCuterOptions.ratioType = lsqRatio_1_1;
    _photoEditComponent.inputImage = result.image;
    _photoEditComponent.inputTempFilePath = result.imagePath;
    _photoEditComponent.inputAsset = result.imageAsset;
    // 是否在组件执行完成后自动关闭组件 (默认:NO)
    _photoEditComponent.autoDismissWhenCompelted = YES;
    [_photoEditComponent showComponent];
    
    
}

- (void)clearComponents;
{
    // 自定义系统相册组件
    _albumComponent = nil;
    
    // 图片编辑组件
    _photoEditComponent = nil;
}

- (void)onComponent:(TuSDKCPViewController *)controller result:(TuSDKResult *)result error:(NSError *)error{
    
}
- (void)savePhoto:(UIImage*)image{
    UserData *userdata = [UserData shared];
    UserInfo *userInfo = userdata.userInfo;
    
//    if (![JDStatusBarNotification isVisible]) {
//        [JDStatusBarNotification showWithStatus:@"正在上传..."];
//    }
//    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    [RTUploadImageNetWork postMulti:nil imageparams:image success:^(id response) {
        if (![Util isEmpty:response]) {
            userInfo.userphoto = [response objectForKey:@"key"];
            UserData *userdata = [UserData shared];
            UserInfo *userInfo = userdata.userInfo;
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userInfo.userid, @"userid", userInfo.usertoken, @"usertoken",userInfo.userphoto,@"userheadportrait", nil];
            [MyInfoRequest modifyMyPortraitWithParam:dic success:^(id response) {
                [self.tableview reloadData];
                //[JDStatusBarNotification showWithStatus:@"修改成功" dismissAfter:1.0];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } failure:^(NSError *error) {
                //[JDStatusBarNotification showWithStatus:@"修改失败" dismissAfter:1.0];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }];
        }else{
            //[JDStatusBarNotification showWithStatus:@"修改失败" dismissAfter:1.0];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        //[JDStatusBarNotification showWithStatus:@"发送失败" dismissAfter:1.0];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"上传失败");
    } Progress:^(NSString *key, float percent) {
        NSLog(@"percent %f", percent);
    } Cancel:^BOOL{
        return NO;
    }];

}

@end
