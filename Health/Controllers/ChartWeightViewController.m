//
//  ChartWeightViewController.m
//  Health
//
//  Created by 陈 on 15/6/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ChartWeightViewController.h"
#import "ChartRequest.h"
#import "ChartData.h"
#import "PNLineChartView.h"
#import "PNPlot.h"
@interface ChartWeightViewController ()
@property(nonatomic,strong)NSMutableArray *chartArray;
@property (nonatomic,strong)PNLineChartView *lineChartView;

//@property(nonatomic,strong)NSMutableArray *
@end

@implementation ChartWeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor= TABLEVIEW_BACKGROUNDCOLOR;
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@""];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    
    //NSArray* plottingDataValues2 =@[@24, @23, @22, @20,@53, @22,@33, @33, @54,@58, @43];
    
    
    
    
    
    
//    PNPlot *plot2 = [[PNPlot alloc] init];
//    
//    plot2.plottingValues = plottingDataValues2;
//    
//    plot2.lineColor = [UIColor redColor];
//    plot2.lineWidth = 1;
//    
//    [self.lineChartView  addPlot:plot2];
_lineChartView=[[PNLineChartView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT-250)];
    
//    _chartArray=[[NSMutableArray alloc]init];
//    [ChartRequest success:^(id response) {
//        NSArray *dataArray=[response objectForKey:@"data"];
//        for (int i=0; i<dataArray.count; i++) {
//            NSDictionary *dic=dataArray[i];
//            ChartData *chartData=[[ChartData alloc]init];
//            chartData.day=[dic objectForKey:@"day"];
//            chartData.weight=[dic objectForKey:@"weight"];
//            [_chartArray addObject:chartData.weight];
//        }
//        
//        self.lineChartView.max = 58;
//        self.lineChartView.min = 12;
//        
//        
//        self.lineChartView.interval = (self.lineChartView.max-self.lineChartView.min)/5;
//        
//        NSMutableArray* yAxisValues = [@[] mutableCopy];
//        for (int i=0; i<6; i++) {
//            NSString* str = [NSString stringWithFormat:@"%lf",i*20.0 ];
//            [yAxisValues addObject:str];
//        }
//        
//        self.lineChartView.xAxisValues = @[@"1", @"2", @"3",@"4", @"5", @"6",@"7", @"8", @"9",@"10", @"11",@"13",@"14"];
//        self.lineChartView.yAxisValues = yAxisValues;
//        self.lineChartView.axisLeftLineWidth = 39;
//
//        PNPlot *plot1 = [[PNPlot alloc] init];
//        plot1.plottingValues = _chartArray;
//        
//        plot1.lineColor = [UIColor blueColor];
//        plot1.lineWidth = 0.5;
//        [self.lineChartView addPlot:plot1];
//
//
//
//    } failure:^(NSError *error) {
//        
//    }];
    NSArray* plottingDataValues1 =@[@22, @33, @12, @23,@43, @32,@53, @33, @54,@55, @43];
    NSArray* plottingDataValues2 =@[@24, @23, @22, @20,@53, @22,@33, @33, @54,@58, @43];
    
    self.lineChartView.max = 58;
    self.lineChartView.min = 12;
    
    
    self.lineChartView.interval = (self.lineChartView.max-self.lineChartView.min)/5;
    
    NSMutableArray* yAxisValues = [@[] mutableCopy];
    for (int i=0; i<6; i++) {
        NSString* str = [NSString stringWithFormat:@"%lf",i*20.0 ];
        [yAxisValues addObject:str];
    }
    
    self.lineChartView.xAxisValues = @[@"1", @"2", @"3",@"4", @"5", @"6",@"7", @"8", @"9",@"10", @"11",@"13",@"14"];
    self.lineChartView.yAxisValues = yAxisValues;
    self.lineChartView.axisLeftLineWidth = 39;
    
    
    PNPlot *plot1 = [[PNPlot alloc] init];
    plot1.plottingValues = plottingDataValues1;
    
    plot1.lineColor = [UIColor blueColor];
    plot1.lineWidth = 0.5;
    
    [self.lineChartView addPlot:plot1];
    
    
    PNPlot *plot2 = [[PNPlot alloc] init];
    
    plot2.plottingValues = plottingDataValues2;
    
    plot2.lineColor = [UIColor redColor];
    plot2.lineWidth = 1;
    
    [self.lineChartView  addPlot:plot2];

   
    [self.view addSubview:_lineChartView];
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
