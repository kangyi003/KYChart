//
//  KYPlot.h
//  KYChart
//
//  Created by kangyi on 2017/6/9.
//  Copyright © 2017年 kangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYPlot : NSObject

@property (nonatomic,strong)NSArray<NSValue *> *points;

@property (nonatomic,strong)UIColor *lineColor;

@property (nonatomic,strong)UIColor *pointColor;

@property (nonatomic,strong)UIColor *trendLineColor;

/// 区分不同的plot
@property (nonatomic,strong)NSString *markString;

/// 是否显示圆滑
@property (nonatomic,assign)BOOL showCurve;

/// 是否显示趋势线
@property (nonatomic,assign)BOOL showTrendLine;

- (instancetype)initWithMark:(NSString *)mark points:(NSArray<NSValue *> *)points;

/// 趋势线的起止两个点
- (NSArray *)trendLinePoints;

/// 第index个点的描述
- (NSString *)descriptionAtIndex:(NSInteger)index;
@end
