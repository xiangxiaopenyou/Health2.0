//
//  PNTestViewController.m
//  lineChart
//
//  Created by pincution on 14-7-15.
//  Copyright (c) 2014年 pincution@gmail.com. All rights reserved.
//

#import "PNTestViewController.h"
#import "PNLineChartView.h"
#import "PNPlot.h"
#import "ChartData.h"
#import "ChartRequest.h"
@interface PNTestViewController ()
@property (strong, nonatomic) PNLineChartView *lineChartView;
@property (nonatomic,strong)NSMutableArray *chartArray;
@property (nonatomic,strong)PNPlot *plot1 ;
@property (nonatomic,copy)NSString *lastStr;
@property (nonatomic,strong)NSMutableArray *dayArray;
@property (nonatomic,strong)NSMutableArray *monthArray;

@end

@implementation PNTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _lineChartView=[[PNLineChartView alloc]init];
    _lineChartView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_lineChartView];

    
    self.view.backgroundColor= TABLEVIEW_BACKGROUNDCOLOR;
    UIImageView *navigation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navigation.image = [UIImage imageNamed:@"navigationbar"];
    [self.view addSubview:navigation];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"体重曲线"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:customLab];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(0, 20, 44, 44);
    [bButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
    // test line chart
   
//    
//    NSMutableArray* yAxisValues = [@[] mutableCopy];
//    for (int i=0; i<6; i++) {
//        NSString* str = [NSString stringWithFormat:@"%lf",40+i*5.0 ];
//        [yAxisValues addObject:str];
//    }
    
       [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addData:) name:@"addData" object:nil];
//    [self performSelector:@selector(delay) withObject:self afterDelay:2];
    
    // Do any additional setup after loading the view from its nib.
    
    _chartArray=[[NSMutableArray alloc]init];
    _dayArray=[[NSMutableArray alloc]init];
    _monthArray=[[NSMutableArray alloc]init];
    [ChartRequest success:^(id response) {
        NSArray *dataArray=[response objectForKey:@"data"];
        for (int i=0; i<dataArray.count; i++) {
            NSDictionary *dic=dataArray[i];
            ChartData *chartData=[[ChartData alloc]init];
            chartData.day=[dic objectForKey:@"day"];
            chartData.weight=[dic objectForKey:@"weight"];
            [_chartArray addObject:chartData.weight];
            NSArray *dayStr=[chartData.day componentsSeparatedByString:@"-"];
            [_dayArray addObject:dayStr[2]];
            [_monthArray addObject:dayStr[1]];
        }
        
        if (response) {
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_async(mainQueue, ^
                           {
                               [self addChartView];
                           });
        }
        //                self.lineChartView.xAxisValues =_dayArray;
        // //               self.lineChartView.yAxisValues = yAxisValues;
        //                self.lineChartView.axisLeftLineWidth = 39;
        //
        //
        //                _plot1.plottingValues = _chartArray;
        //                _plot1.lineColor = [UIColor blueColor];
        //                _plot1.lineWidth = 0.5;
        //                [self.lineChartView addPlot:_plot1];
        
    } failure:^(NSError *error) {
        
    }];
}
//- (void)delay
//{
//    [self addChartView];
//}

- (void)addChartView
{
    _weghtLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 90, 100, 20)];
    self.weghtLabel.text=[NSString stringWithFormat:@"目标体重 :"];
    self.weghtLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:_weghtLabel];
    _kgLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 90, 100, 20)];
    self.kgLabel.text=[NSString stringWithFormat:@"%.1f% @%",[self.goalWeight integerValue]*1.0,@"kg"];
    self.kgLabel.textColor=[UIColor yellowColor];
    [self.view addSubview:_kgLabel];
    UILabel *titteabel=[[UILabel alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT-250-100, 100, 20)];
    titteabel.text=@"体重(kg)";
    titteabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titteabel];
    UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, SCREEN_HEIGHT-120, 60, 20)];
    dateLabel.text=@"日期";
    dateLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:dateLabel];

    self.lineChartView.max = 100;
    self.lineChartView.min = 0;
    self.lineChartView.interval = (self.lineChartView.max-self.lineChartView.min)/5;
    
    self.lineChartView.frame=CGRectMake(10, SCREEN_HEIGHT-250-70, SCREEN_WIDTH, 250);
    NSMutableArray* yAxisValues = [@[] mutableCopy];
    for (int i=0; i<6; i++) {
        NSString* str = [NSString stringWithFormat:@"%.2f",i*20.0];
        [yAxisValues addObject:str];
    }
    
    self.lineChartView.xAxisValues = _dayArray;
    self.lineChartView.yAxisValues = yAxisValues;
    self.lineChartView.axisLeftLineWidth = 39;
    
    
    PNPlot *plot1 = [[PNPlot alloc] init];
    plot1.plottingValues = _chartArray;
    
    plot1.lineColor = [UIColor yellowColor];
    plot1.lineWidth = 0.5;
    [self.lineChartView addPlot:plot1];
        self.lineChartView.max = 100;
    self.lineChartView.min = 0;
    
    
    self.lineChartView.interval = (self.lineChartView.max-self.lineChartView.min)/5;
    
//    [self.lineChartView layoutIfNeeded];
        [self.lineChartView setNeedsDisplay];
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addData:(NSNotification *)notity
{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    
    static float i=0;
    NSString *dayStr=_dayArray[0];
    if ([[dayStr substringFromIndex:0]isEqualToString:@"0"]) {
        NSString *dayStr1=[dayStr substringFromIndex:1];
        i=([dayStr1 intValue]-1)*1.0;
        if (i==0.0) {
            return;
        }
      // NSString *monthStr=_monthArray[0];
       //month=[monthStr integerValue]*1.0;
//        if (i==0.0) {
//            NSString *monthStr=_monthArray[0];
//            if ([monthStr  substringFromIndex:0]isEqualToString:@"0"]) {
//                month=([[monthStr substringFromIndex:1] integerValue]-1)*1.0;
//            }
//            else
//            {
//                ;
//            }
//        }
    }
    else
    {
        i=([dayStr integerValue]-1)*1.0;
    }
    
    NSString*timeStr=[NSString stringWithFormat:@"2015-%@-%02.f",_monthArray[_monthArray.count-1],i];
   
    if ([_lastStr isEqualToString:timeStr]) {
        return;
    }
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken",timeStr,@"time",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_CHART_DATA];
    [NetWorking post:url params:parameter success:^(id response) {
        
        NSArray *dataArray=[response objectForKey:@"data"];
        {
            
        }
        for (int i=0; i<dataArray.count; i++) {
            NSDictionary *dic=dataArray[i];
            ChartData *chartData=[[ChartData alloc]init];
            chartData.day=[dic objectForKey:@"day"];
            chartData.weight=[dic objectForKey:@"weight"];
            NSLog(@"))))%@",chartData.weight);
            NSArray *dayStr=[chartData.day componentsSeparatedByString:@"-"];
            [_dayArray insertObject:dayStr[2] atIndex:i];
            [_chartArray insertObject:chartData.weight atIndex:i];
        }

        
        

        self.lineChartView.xAxisValues = _dayArray;
        self.lineChartView.axisLeftLineWidth = 39;
        
        
        _plot1.plottingValues = _chartArray;
    } failure:^(NSError *error) {
        
    }];
    _lastStr=timeStr;

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
