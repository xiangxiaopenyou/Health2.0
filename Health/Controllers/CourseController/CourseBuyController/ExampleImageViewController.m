//
//  ExampleImageViewController.m
//  Health
//
//  Created by 成 on 15/3/11.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ExampleImageViewController.h"

#define UIIMAGEVIEW_WIDTH 250
#define UIIMAGEVIEW_HEIGHT 320

@interface ExampleImageViewController ()

@end

@implementation ExampleImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_LABEL_X, TITLE_LABEL_Y, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"图片示例"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    [self addScrollView];
    
}

- (void)addScrollView{
    UIImageView *imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-UIIMAGEVIEW_WIDTH)/2, 0, UIIMAGEVIEW_WIDTH, UIIMAGEVIEW_HEIGHT)];
    imageview1.image = [UIImage imageNamed:@"example_zhenmian_image.png"];
    [self.scrollview addSubview:imageview1];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-UIIMAGEVIEW_WIDTH)/2, UIIMAGEVIEW_HEIGHT+10, UIIMAGEVIEW_WIDTH, 60)];
    label.backgroundColor  = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = @"拍正面照的时候，保持身体笔直，正视前方";
    label.numberOfLines = 0;
    [self.scrollview addSubview:label];
    
    UIImageView *imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-UIIMAGEVIEW_WIDTH)/2, UIIMAGEVIEW_HEIGHT + 80, UIIMAGEVIEW_WIDTH, UIIMAGEVIEW_HEIGHT)];
    imageview2.image = [UIImage imageNamed:@"example_cemian_image.png"];
    [self.scrollview addSubview:imageview2];
    
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-UIIMAGEVIEW_WIDTH)/2, UIIMAGEVIEW_HEIGHT*2+90, UIIMAGEVIEW_WIDTH, 60)];
    label1.backgroundColor  = [UIColor clearColor];
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:14.0];
    label1.text = @"拍侧面照的时候，双手自然下垂，保持身体笔直";
    label1.numberOfLines = 0;
    [self.scrollview addSubview:label1];
    
    [self.scrollview setContentSize:CGSizeMake(SCREEN_WIDTH, (UIIMAGEVIEW_HEIGHT+80)*2)];
    
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
