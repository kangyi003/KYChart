//
//  KYCurveRenderView.h
//  KYChart
//
//  Created by kangyi on 2017/6/12.
//  Copyright © 2017年 kangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KYPlot,KYXAxis,KYYAxis;

@interface KYCurveRenderView : UIView

/// x轴信息
@property (nonatomic,strong)KYXAxis *xAxis;
/// y轴信息
@property (nonatomic,strong)KYYAxis *yAxis;
/// 曲线信息
@property (nonatomic,strong)NSMutableArray *plots;

/// 是否实线显示 y=0
@property (nonatomic,assign)BOOL showXAxis;

/// 是否显示动画
@property (nonatomic,assign)BOOL showAnimation;

///是否显示实心点
@property (nonatomic,assign)BOOL showSolidPoint;

- (CGSize)contentSize;


/// 添加曲线
- (void)addPlot:(KYPlot *)plot;

/// 移除曲线
- (void)removePlot:(KYPlot *)plot;


- (void)remvoeAllPlots;

- (void)reloadData;
@end
