//
//  TabbarViewController.m
//  Health
//
//  Created by cheng on 15/1/24.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "TabbarViewController.h"
#import "RCConversation.h"
#import "AppDelegate.h"

@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.tintColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0];
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:43.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:1.0],NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
    [self.tabBar setTranslucent:NO];
//    if (SCREEN_WIDTH == 375) {
//        self.tabBar.backgroundImage = [UIImage imageNamed:@"background_tabbar_667.png"];
//    }else{
    self.tabBar.backgroundImage = [UIImage imageNamed:@"background_tabbar.png"];
//    }
    self.tabBar.backgroundColor = [UIColor clearColor];
    NSLog(@"tab bar height %f %f",self.tabBar.frame.size.width,self.tabBar.frame.size.height);
//    [self.tabBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]]];
    [self.tabBar setShadowImage:[self createImageWithColor:[UIColor clearColor]]];
    [self setSelectedIndex:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNotReadNotification) name:GETALLMESSAGE object:nil];
    
}

- (void)getNotReadNotification{
    UITabBarItem *item = [self.tabBar.items objectAtIndex:3];
    UserData *userdata = [UserData shared];
    NSInteger unreadCount = 0;
    NSArray *chatListArray = [[RCIM sharedRCIM]getConversationList:[NSArray arrayWithObjects:[NSNumber numberWithInt:ConversationType_PRIVATE], nil]];//只需要单聊的有未读消息
    for (int i = 0 ; i < chatListArray.count; i ++ ) {
        RCConversation *conversation = [chatListArray objectAtIndex:i];
        if (conversation.unreadMessageCount > 0) {
            unreadCount = unreadCount+conversation.unreadMessageCount;
        }
    }
    unreadCount = unreadCount + userdata.favoriteNum.intValue + userdata.replyNum.intValue;
    if (unreadCount != 0) {
        item.badgeValue = [NSString stringWithFormat:@"%ld", (long)unreadCount];
    }else{
        item.badgeValue = nil;
    }
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    AppDelegate *appDeledate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDeledate.rootNavigationController = nil;
    appDeledate.rootNavigationController = viewController.navigationController;
}
- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];

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
- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
@end
