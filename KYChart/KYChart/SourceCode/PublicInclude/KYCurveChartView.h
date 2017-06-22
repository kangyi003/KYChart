//
//  KYCurveChartView.h
//  KYChart
//
//  Created by kangyi on 2017/6/9.
//  Copyright © 2017年 kangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KYPlot,KYXAxis,KYYAxis;

@interface KYCurveChartView : UIView

/// x轴数据对象
@property (nonatomic,strong)KYXAxis *xAxis;

/// y轴数据对象
@property (nonatomic,strong)KYYAxis *yAxis;

/// y轴宽度
@property (nonatomic,assign)CGFloat yAxisWidth;

/// 是否显示动画
@property (nonatomic,assign)BOOL showAnimation;

///是否显示实心点
@property (nonatomic,assign)BOOL showSolidPoint;
/// 添加曲线
- (void)addPlot:(KYPlot *)plot;

/// 移除曲线
- (void)removePlot:(KYPlot *)plot;

/// 移除所有曲线
- (void)removeAllPlots;

/// 显示
- (void)reloadPlots;

@end
