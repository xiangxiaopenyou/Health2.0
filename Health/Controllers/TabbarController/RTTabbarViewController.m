//
//  RTTabbarViewController.m
//  RTHealth
//
//  Created by cheng on 14-10-15.
//  Copyright (c) 2014年 realtech. All rights reserved.
//

#import "RTTabbarViewController.h"
#import "RTTabbarItem.h"
#import "ShowHomeViewController.h"
#import "SquareHomeViewController.h"
#import "MessageHomeViewController.h"
#import "MyHomeViewController.h"
#import "ClockInViewController.h"
#import "ShowTrendsViewController.h"
#import "RCConversation.h"

@interface RTTabbarViewController (){
    UIView *chooseView;
    
    UILabel *messageLabel;
    
    UIView *tipView;
    UIView *chooseTipView;
}

@end

@implementation RTTabbarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        curItemType = 6;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotReadNotification) name:GETALLMESSAGE object:nil];
    
    // init 5 view controllers
    ShowHomeViewController *trendController = [[ShowHomeViewController alloc] init];
    SquareHomeViewController *squareController = [[SquareHomeViewController alloc]init];
    MessageHomeViewController *messageController = [[MessageHomeViewController alloc]init];
    MyHomeViewController *myController = [[MyHomeViewController alloc]init];
    
    //    tempController.tabBarDelegate = self;
    // ...add more
    
    
    tabBarItems = [NSArray arrayWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:@"show_not_selected.png",@"TabBarImages",@"show_selected.png",@"TabBarImages1", @"Show",@"TabBarTitle",trendController, @"viewController", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"square_not_selected.png",@"TabBarImages",@"square_selected.png",@"TabBarImages1", @"广场",@"TabBarTitle", squareController, @"viewController", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"message_not_selected.png",@"TabBarImages",@"message_selected.png",@"TabBarImages1", @"消息",@"TabBarTitle", messageController, @"viewController", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"self_not_selected.png",@"TabBarImages",@"self_selected.png",@"TabBarImages1", @"我",@"TabBarTitle", myController, @"viewController", nil],
                    nil];
    
    // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
//    UIImage* tabBarGradient = [UIImage imageNamed:@"tabmenubackground.png"];
    
    // Create a custom tab bar passing in the number of items, the size of each item and setting ourself as the delegate
    tabBar = [[RTTabbarItem alloc] initWithItemCount:tabBarItems.count
                                            itemSize:CGSizeMake(self.view.frame.size.width/(tabBarItems.count+1),TABBAR_HEIGHT)
                                                 tag:0
                                            delegate:self];
    // Place the tab bar at the bottom of our view
    tabBar.frame = CGRectMake(0,
                              SCREEN_HEIGHT-TABBAR_HEIGHT,
                              self.view.frame.size.width,
                              TABBAR_HEIGHT);
    [self.view addSubview:tabBar];
    
    messageLabel =[[UILabel alloc] initWithFrame:CGRectMake(3*SCREEN_WIDTH/4 - 8, 2, 18, 18)];
    messageLabel.layer.masksToBounds = YES;
    messageLabel.layer.cornerRadius = 9;
    messageLabel.backgroundColor = [UIColor redColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = SMALLFONT_12;
    messageLabel.textColor = WHITE_CLOCLOR;
    [tabBar addSubview:messageLabel];
    messageLabel.hidden = YES;
    // Select the first tab
    [tabBar selectItemAtIndex:0];
    [self touchDownAtItemAtIndex:0];
    
    chooseView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];;
    [chooseView setBackgroundColor:TABLEVIEWCELL_COLOR];
    [self.view addSubview:chooseView];
    
    UIImageView *showWords = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 101.5, 70, 203, 80)];
    showWords.image = [UIImage imageNamed:@"show_words"];
    [chooseView addSubview:showWords];
    
    UIButton *closeChooseViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeChooseViewButton.frame = CGRectMake(SCREEN_WIDTH/2 - 24, SCREEN_HEIGHT - 56, 48, 48);
    [closeChooseViewButton setImage:[UIImage imageNamed:@"show_cancel"] forState:UIControlStateNormal];
    [closeChooseViewButton addTarget:self action:@selector(closeChooseViewClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseView addSubview:closeChooseViewButton];
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = CGRectMake(40, 220, 84, 84);
    [photoButton setImage:[UIImage imageNamed:@"show_camera"] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(photoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseView addSubview:photoButton];
    
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 314, 84, 30)];
    photoLabel.text = @"拍照";
    photoLabel.textColor = [UIColor whiteColor];
    photoLabel.textAlignment = NSTextAlignmentCenter;
    photoLabel.font = SMALLFONT_16;
    [chooseView addSubview:photoLabel];
    
    UIButton *clockinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clockinButton.frame = CGRectMake(SCREEN_WIDTH - 124, 220, 84, 84);
    [clockinButton setImage:[UIImage imageNamed:@"show_clockin"] forState:UIControlStateNormal];
    [clockinButton addTarget:self action:@selector(clockinButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseView addSubview:clockinButton];
    
    UILabel *clockinLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 124, 314, 84, 30)];
    clockinLabel.text = @"打卡";
    clockinLabel.textColor = [UIColor whiteColor];
    clockinLabel.textAlignment = NSTextAlignmentCenter;
    clockinLabel.font = SMALLFONT_16;
    [chooseView addSubview:clockinLabel];
    
    [self getNotReadNotification];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstTipClockin"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstTipClockin"];
        [self setupTipView];
    }
    else {
    }
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstTipClockinChoose"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstTipClockinChoose"];
        [self setupChooseTipView];
    }
}

- (void)setupTipView{
    tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tipView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:tipView];
    
    UIButton *centerButton =[UIButton buttonWithType:UIButtonTypeCustom];
    centerButton.frame = CGRectMake(SCREEN_WIDTH/2 - 23, SCREEN_HEIGHT - 47.5, 46, 46);
    [centerButton setBackgroundImage:[UIImage imageNamed:@"center"] forState:UIControlStateNormal];
    [centerButton addTarget:self action:@selector(tipCenterClick) forControlEvents:UIControlEventTouchUpInside];
    [tipView addSubview:centerButton];
    
    UIImageView *tipImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 67, SCREEN_HEIGHT - 152, 134, 102)];
    tipImage.image = [UIImage imageNamed:@"tip_01"];
    [tipView addSubview:tipImage];
    
    UIButton *knownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    knownButton.frame = CGRectMake(170, SCREEN_HEIGHT - 200, 70, 30);
    [knownButton setBackgroundImage:[UIImage imageNamed:@"known"] forState:UIControlStateNormal];
    [knownButton addTarget:self action:@selector(knownClick) forControlEvents:UIControlEventTouchUpInside];
    [tipView addSubview:knownButton];
    
}
- (void)tipCenterClick{
    [tipView removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        chooseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)knownClick{
    [tipView removeFromSuperview];
}

- (void)setupChooseTipView{
    chooseTipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    chooseTipView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [chooseView addSubview:chooseTipView];
    
    UIButton *clockinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clockinButton.frame = CGRectMake(SCREEN_WIDTH - 124, 220, 84, 84);
    [clockinButton setImage:[UIImage imageNamed:@"show_clockin"] forState:UIControlStateNormal];
    [clockinButton addTarget:self action:@selector(chooseClockinButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseTipView addSubview:clockinButton];
    
    UILabel *clockinLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 124, 314, 84, 30)];
    clockinLabel.text = @"打卡";
    clockinLabel.textColor = [UIColor whiteColor];
    clockinLabel.textAlignment = NSTextAlignmentCenter;
    clockinLabel.font = SMALLFONT_16;
    [chooseTipView addSubview:clockinLabel];
    
    UIImageView *tipImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 200, 320, 155, 104)];
    tipImage.image = [UIImage imageNamed:@"tip_02"];
    [chooseTipView addSubview:tipImage];
    
    UIButton *knownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    knownButton.frame = CGRectMake(SCREEN_WIDTH - 100, 440, 70, 30);
    [knownButton setBackgroundImage:[UIImage imageNamed:@"known"] forState:UIControlStateNormal];
    [knownButton addTarget:self action:@selector(chooseKnownClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseTipView addSubview:knownButton];
}
- (void)chooseKnownClick{
    [chooseTipView removeFromSuperview];
}
- (void)chooseClockinButtonClick{
    [chooseTipView removeFromSuperview];
    ClockInViewController *clockinController = [[ClockInViewController alloc] init];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate.rootNavigationController pushViewController:clockinController animated:YES];
    chooseView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)getNotReadNotification{
    UserData *userdata  = [UserData shared];
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
        messageLabel.hidden = NO;
        messageLabel.text = [NSString stringWithFormat:@"%ld", (long)unreadCount];
    }
    else {
        messageLabel.hidden = YES;
        messageLabel.text = nil;
    }
}

- (void)closeChooseViewClick{
    [UIView animateWithDuration:0.5 animations:^{
        chooseView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)photoButtonClick{
    ShowTrendsViewController *showController = [[ShowTrendsViewController alloc] init];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.rootNavigationController pushViewController:showController animated:YES];
    chooseView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
}
- (void)clockinButtonClick{
    ClockInViewController *clockinController = [[ClockInViewController alloc] init];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate.rootNavigationController pushViewController:clockinController animated:YES];
    chooseView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[[NSNotificationCenter defaultCenter]postNotificationName:VIEWSHOULDLOAD object:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */
#pragma mark JHTabBarDelegate

- (NSString*)titleFor:(RTTabbarItem*)tabBar atIndex:(NSUInteger)itemIndex
{
    NSDictionary* data = [tabBarItems objectAtIndex:itemIndex];
    return [data objectForKey:@"TabBarTitle"];
}

- (UIImage*)imageFor:(RTTabbarItem*)tabBar atIndex:(NSUInteger)itemIndex
{
    // Get the right data
    NSDictionary* data = [tabBarItems objectAtIndex:itemIndex];
    return [UIImage imageNamed:[data objectForKey:@"TabBarImages1"]];
    // Return the image for this tab bar item
    //    UIGraphicsBeginImageContext(CGSizeMake(16, 16));
    //    [[UIImage imageNamed:[data objectForKey:@"TabBarImages"]] drawInRect:CGRectMake(0,0, 16, 16)];
    //    UIImage *modify = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    return modify;
}
- (UIImage*)imageforSelected:(RTTabbarItem*)tabBar atIndex:(NSUInteger)itemIndex
{
    // Get the right data
    NSDictionary* data = [tabBarItems objectAtIndex:itemIndex];
    return [UIImage imageNamed:[data objectForKey:@"TabBarImages"]];
    // Return the image for this tab bar item
    //    UIGraphicsBeginImageContext(CGSizeMake(16, 16));
    //    [[UIImage imageNamed:[data objectForKey:@"TabBarImages"]] drawInRect:CGRectMake(0,0, 16, 16)];
    //    UIImage *modify = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    return modify;
}
- (UIImage*)imageForLighted:(RTTabbarItem*)tabBar atIndex:(NSUInteger)itemIndex
{
    // Get the right data
    NSDictionary* data = [tabBarItems objectAtIndex:itemIndex];
    return [UIImage imageNamed:[data objectForKey:@"TabBarImages1"]];
    // Return the image for this tab bar item
    //    UIGraphicsBeginImageContext(CGSizeMake(16, 16));
    //    [[UIImage imageNamed:[data objectForKey:@"TabBarImages"]] drawInRect:CGRectMake(0,0, 16, 16)];
    //    UIImage *modify = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    return modify;
}

- (UIImage*)backgroundImage
{
    // The tab bar's width is the same as our width
    CGFloat width = self.view.frame.size.width;
    // Get the image that will form the top of the background
    //    UIImage* topImage = [UIImage imageNamed:@"tabbarbackground.png"];
    //    UIImage* topImage = [UIImage imageNamed:@"footer_80.png"];
    UIImage* topImage = [UIImage imageNamed:@"tabmenubackground.png"];
    // Create a new image context
    //  UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, topImage.size.height*2), NO, 0.0);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, topImage.size.height), NO, 0.0);
    
    // Create a stretchable image for the top of the background and draw it
    UIImage* stretchedTopImage = [topImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [stretchedTopImage drawInRect:CGRectMake(0, 0, width, topImage.size.height)];
    
    // Draw a solid black color for the bottom of the background
    [[UIColor whiteColor] set];
    //  CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, topImage.size.height, width, topImage.size.height));
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 55, width, 55));
    
    // Generate a new image
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

// This is the blue background shown for selected tab bar items
- (UIImage*)selectedItemBackgroundImage
{
    //  return [UIImage imageNamed:@"TabBarItemSelectedBackground.png"];
    return nil;
}

// This is the glow image shown at the bottom of a tab bar to indicate there are new items
- (UIImage*)glowImage
{
    //  UIImage* tabBarGlow = [UIImage imageNamed:@"TabBarGlow.png"];
    //
    //  // Create a new image using the TabBarGlow image but offset 4 pixels down
    //  UIGraphicsBeginImageContextWithOptions(CGSizeMake(tabBarGlow.size.width, tabBarGlow.size.height-4.0), NO, 0.0);
    //
    //  // Draw the image
    //  [tabBarGlow drawAtPoint:CGPointZero];
    //
    //  // Generate a new image
    //  UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    //  UIGraphicsEndImageContext();
    //
    //  return resultImage;
    return nil;
}

// This is the embossed-like image shown around a selected tab bar item
- (UIImage*)selectedItemImage
{
    // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
    UIImage* tabBarGradient = [UIImage imageNamed:@"itemChosen.png"];
    //  CGSize tabBarItemSize = CGSizeMake(self.view.frame.size.width/tabBarItems.count, tabBarGradient.size.height*2);
    //  UIGraphicsBeginImageContextWithOptions(tabBarItemSize, NO, 0.0);
    //
    //  // Create a stretchable image using the TabBarSelection image but offset 4 pixels down
    //  [[[UIImage imageNamed:@"TabBarSelection.png"] stretchableImageWithLeftCapWidth:4.0 topCapHeight:0] drawInRect:CGRectMake(0, 4.0, tabBarItemSize.width, tabBarItemSize.height-4.0)];
    //
    //  // Generate a new image
    //  UIImage* selectedItemImage = UIGraphicsGetImageFromCurrentImageContext();
    //  UIGraphicsEndImageContext();
    //
    //  return selectedItemImage;
    return tabBarGradient;
}

- (UIImage*)tabBarArrowImage
{
    //  return [UIImage imageNamed:@"TabBarNipple.png"];
    return nil;
}

- (void)touchDownAtMidItem
{
    NSLog(@"点击中间的button");
//    RTNewTrendsViewController *newTrendsView = [[RTNewTrendsViewController alloc] init];
//    [self.navigationController pushViewController:newTrendsView animated:YES];
    [UIView animateWithDuration:0.5 animations:^{
        chooseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
    }];
    
}
- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
    if(curItemType != itemIndex)
    {
        curItemType = itemIndex;
        // Remove the current view controller's view
        UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
        [currentView removeFromSuperview];
        
        // Get the right view controller
        NSDictionary* data = [tabBarItems objectAtIndex:itemIndex];
        UIViewController* viewController = [data objectForKey:@"viewController"];
        
        // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
        //UIImage* tabBarGradient = [UIImage imageNamed:@"TabBarGradientpng"];
        
        // Set the view controller's frame to account for the tab bar
        viewController.view.frame = CGRectMake(0, 0,
                                               self.view.frame.size.width,
                                               self.view.frame.size.height-50);
        
        // Se the tag so we can find it later
        viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
        
        // Add the new view controller's view
        [self.view insertSubview:viewController.view belowSubview:tabBar];
        [viewController viewWillAppear:YES];
        //    CATransition *animation = [CATransition animation];
        //    animation.delegate = self;
        //    animation.duration = 0;
        //    animation.timingFunction = UIViewAnimationCurveEaseInOut;
        //    animation.fillMode = kCAFillModeForwards;
        //    animation.type = kCATransitionFade;
        //    animation.subtype = kCATransitionFromBottom;
        //    [self.view.layer addAnimation:animation forKey:@"animation"];
        
        // In 0.3 second glow the selected tab
        //    [NSTimer scheduledTimerWithTimeInterval:0
        //                                     target:self
        //                                   selector:@selector(addGlowTimerFireMethod:)
        //                                   userInfo:[NSNumber numberWithInteger:itemIndex]
        //                                    repeats:NO];
    }
}

- (void)addGlowTimerFireMethod:(NSTimer*)theTimer
{
    // Remove the glow from all tab bar items
    for (NSUInteger i = 0 ; i < tabBarItems.count ; i++)
    {
        [tabBar removeGlowAtIndex:i];
    }
    
    // Then add it to this tab bar item
    [tabBar glowItemAtIndex:[[theTimer userInfo] integerValue]];
}


@end
