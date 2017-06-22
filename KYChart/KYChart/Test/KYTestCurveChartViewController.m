//
//  KYTestCurveChartViewController.m
//  KYChart
//
//  Created by kangyi on 17/6/14.
//  Copyright © 2017年 kangyi. All rights reserved.
//

#import "KYTestCurveChartViewController.h"
#import "KYCurveChartView.h"
#import "KYAxis.h"
#import "KYPlot.h"

@interface KYTestCurveChartViewController ()

@property (nonatomic,weak)IBOutlet KYCurveChartView *chartView;
@property (nonatomic,strong)KYPlot *plot;
@property (nonatomic,strong)KYPlot *plot1;
@property (nonatomic,strong)KYPlot *percentagePlot;
@end

@implementation KYTestCurveChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (IBAction)twoPlot:(id)sender{
    [self.chartView removeAllPlots];
    NSArray *values = @[[NSValue valueWithCGPoint:CGPointMake(0, 30)],
                        [NSValue valueWithCGPoint:CGPointMake(1, 200)],
                        [NSValue valueWithCGPoint:CGPointMake(2, 1000)],
                        [NSValue valueWithCGPoint:CGPointMake(3, 50)],
                        [NSValue valueWithCGPoint:CGPointMake(4, 300)],
                        [NSValue valueWithCGPoint:CGPointMake(5, 608)],
                        [NSValue valueWithCGPoint:CGPointMake(6, 5)],
                        [NSValue valueWithCGPoint:CGPointMake(7, 800)]];
    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i < values.count; i++) {
        CGPoint point = [values[i] CGPointValue];
        [titles addObject:[NSString stringWithFormat:@"%.0f天",point.x]];
    }
    KYXAxis *xAxis = [[KYXAxis alloc] initWithNodeTitles:titles];
    KYYAxis *yAxis = [[KYYAxis alloc] initWithMaxValue:1000 minValue:5];
    self.chartView.showAnimation = YES;
    self.chartView.xAxis = xAxis;
    self.chartView.yAxis = yAxis;
    self.chartView.yAxisWidth = 50;
    
    self.plot = [[KYPlot alloc] initWithMark:@"2017年" points:values];
    self.plot.lineColor = [UIColor blueColor];
    self.plot.showCurve = YES;
    
    NSArray *values1 = @[[NSValue valueWithCGPoint:CGPointMake(0, 234)],
                         [NSValue valueWithCGPoint:CGPointMake(1, 533)],
                         [NSValue valueWithCGPoint:CGPointMake(2, 33)],
                         [NSValue valueWithCGPoint:CGPointMake(3, 363)],
                         [NSValue valueWithCGPoint:CGPointMake(4, 133)],
                         [NSValue valueWithCGPoint:CGPointMake(5, 533)],
                         [NSValue valueWithCGPoint:CGPointMake(6, 63)],
                         [NSValue valueWithCGPoint:CGPointMake(7, 937)]];
    
    self.plot1 = [[KYPlot alloc] initWithMark:@"2016年" points:values1];
    self.plot1.lineColor = [UIColor blueColor];
    self.plot1.showCurve = YES;
    self.plot1.trendLineColor = [UIColor greenColor];
    self.plot1.lineColor = [UIColor orangeColor];
    
    [self.chartView addPlot:self.plot];
    [self.chartView addPlot:self.plot1];
    [self.chartView reloadPlots];
}

- (IBAction)onePlot:(id)sender{
    [self.chartView removeAllPlots];
    NSArray *values = @[[NSValue valueWithCGPoint:CGPointMake(0, 0.00234343434)],
                         [NSValue valueWithCGPoint:CGPointMake(1, 0.00533434343)],
                         [NSValue valueWithCGPoint:CGPointMake(2, 0.00633434343)],
                         [NSValue valueWithCGPoint:CGPointMake(3, 0.00333434343)],
                         [NSValue valueWithCGPoint:CGPointMake(4, 0.00833434343)],
                         [NSValue valueWithCGPoint:CGPointMake(5, 0.00533434343)],
                         [NSValue valueWithCGPoint:CGPointMake(6, 0.00633434343)],
                         [NSValue valueWithCGPoint:CGPointMake(7, 0.00933434343)]];
    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i < values.count; i++) {
        CGPoint point = [values[i] CGPointValue];
        [titles addObject:[NSString stringWithFormat:@"%.0f天",point.x]];
    }
    KYXAxis *xAxis = [[KYXAxis alloc] initWithNodeTitles:titles];
    KYYAxis *yAxis = [[KYYAxis alloc] initWithMaxValue:0.00933434343 minValue:0.00234343434];
    self.chartView.xAxis = xAxis;
    self.chartView.yAxis = yAxis;
    self.chartView.yAxisWidth = 100;
    self.chartView.showAnimation = YES;
    yAxis.showPercentage = YES;

    self.plot = [[KYPlot alloc] initWithMark:@"2017年" points:values];
    self.plot.lineColor = [UIColor blueColor];
    self.plot.showTrendLine = YES;
    self.plot.showCurve = YES;
    [self.chartView addPlot:self.plot];
    [self.chartView reloadPlots];
}

- (IBAction)persentage:(id)sender{
    [self.chartView removeAllPlots];
    NSArray *values = @[[NSValue valueWithCGPoint:CGPointMake(0, .300000000)],
                        [NSValue valueWithCGPoint:CGPointMake(1, .200000000)],
                        [NSValue valueWithCGPoint:CGPointMake(2, .100000000)],
                        [NSValue valueWithCGPoint:CGPointMake(3, .500000000)],
                        [NSValue valueWithCGPoint:CGPointMake(4, .600000000)],
                        [NSValue valueWithCGPoint:CGPointMake(5, .500000000)],
                        [NSValue valueWithCGPoint:CGPointMake(6, .900000000)]];
    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i < values.count; i++) {
        CGPoint point = [values[i] CGPointValue];
        [titles addObject:[NSString stringWithFormat:@"%.0f天",point.x]];
    }
    KYXAxis *xAxis = [[KYXAxis alloc] initWithNodeTitles:titles];
    KYYAxis *yAxis = [[KYYAxis alloc] initWithMaxValue:0.9 minValue:0];
    yAxis.showPercentage = YES;
    self.chartView.showAnimation = YES;
    self.chartView.xAxis = xAxis;
    self.chartView.yAxis = yAxis;
    self.chartView.yAxisWidth = 40;
    
    KYPlot *plot = [[KYPlot alloc] initWithMark:@"2017年" points:values];
    plot.lineColor = [UIColor blueColor];
    plot.showCurve = YES;
    
    [self.chartView addPlot:plot];
    [self.chartView reloadPlots];
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
