//
//  ChatViewController.m
//  Health
//
//  Created by cheng on 15/3/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ChatViewController.h"
#import "RCPreviewViewController.h"

@interface ChatViewController ()<UIAlertViewDelegate>{
    AppDelegate *appDelegate;
}

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //appDelegate.rootNavigationController.navigationBar.backgroundColor = [UIColor blackColor];
    [appDelegate.rootNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"] forBarMetrics:UIBarMetricsDefault];
    appDelegate.rootNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] init];
    leftButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = leftButtonItem;
    
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"拉黑" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonItemPressed:)];
//    [rightButton setTintColor:[UIColor whiteColor]];
//    self.navigationItem.rightBarButtonItem = rightButton;
    
//    //自定义导航左右按钮
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(leftBarButtonItemPressed:)];
//    [leftButton setTintColor:[UIColor whiteColor]];
//    self.navigationItem.leftBarButtonItem = leftButton;
    
//    if (!self.enableSettings) {
//        self.navigationItem.rightBarButtonItem = nil;
//    }else{
        //自定义导航左右按钮
    [[RCIM sharedRCIM] getBlacklistStatus:self.currentTarget completion:^(int bizStatus) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bizStatus == 0) {
                UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"取消拉黑" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarCancelBlackButtonItemPressed:)];
                [rightButton setTintColor:[UIColor whiteColor]];
                self.navigationItem.rightBarButtonItem = rightButton;
            }
            else{
                UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"拉黑" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonItemPressed:)];
                [rightButton setTintColor:[UIColor whiteColor]];
                self.navigationItem.rightBarButtonItem = rightButton;
            }
            
        });

        
    } error:^(RCErrorCode status) {
        
    }];
    
//    }
    self.enablePOI = NO;
}
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    appDelegate.rootNavigationController.navigationBarHidden = NO;
//}

-(void)leftBarButtonItemPressed:(id)sender
{
    [super leftBarButtonItemPressed:sender];
    appDelegate.rootNavigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHAT object:@YES];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    appDelegate.rootNavigationController.navigationBarHidden = YES;
}
- (void)viewDidAppear:(BOOL)animated{
    appDelegate.rootNavigationController.navigationBarHidden = NO;
}

-(void)rightBarButtonItemPressed:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定拉黑吗" message:@"拉黑后将永久不能收到此人消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1;
    [alertView show];
}
- (void)rightBarCancelBlackButtonItemPressed:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定取消拉黑吗" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 2;
    [alertView show];
}

-(void)showPreviewPictureController:(RCMessage*)rcMessage{
    
    RCPreviewViewController *temp=[[RCPreviewViewController alloc]init];
    temp.rcMessage = rcMessage;
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:temp];
    
    //导航和原有的配色保持一直
    UIImage *image= [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    
    [nav.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:
            {
                NSLog(@"%@",self.currentTarget);
                [[RCIM sharedRCIM]addToBlacklist:self.currentTarget completion:^{
                    [self performSelectorOnMainThread:@selector(success:) withObject:nil waitUntilDone:YES];
                } error:^(RCErrorCode status) {
                    
                    [self performSelectorOnMainThread:@selector(failure:) withObject:nil waitUntilDone:YES];
                }];
            }
                break;
            default:
                break;
        }
    }
    else{
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:
            {
                [[RCIM sharedRCIM] removeFromBlacklist:self.currentTarget completion:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"拉黑" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonItemPressed:)];
                        [rightButton setTintColor:[UIColor whiteColor]];
                        self.navigationItem.rightBarButtonItem = rightButton;
                        
                    });
                } error:^(RCErrorCode status) {
            }];
            }
                break;
            default:
                break;
        }
    }
    
}
- (void)failure:(id)sender{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"拉黑" message:@"拉黑失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
- (void)success:(id)sender{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"取消拉黑" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarCancelBlackButtonItemPressed:)];
    [rightButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightButton;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"拉黑" message:@"拉黑成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    

}
@end
