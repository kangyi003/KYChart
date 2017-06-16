//
//  KYAxis.h
//  KYChart
//
//  Created by kangyi on 2017/6/9.
//  Copyright © 2017年 kangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYAxisBase : NSObject

#pragma mark - 以下属性可以选择性赋值
/// 坐标轴上的坐标点数量
@property (nonatomic,assign)NSInteger nodeCount;

/// 坐标点间距,因为X轴滑动伸缩，所以在此记录
@property (nonatomic,assign)CGFloat nodeGap;

/// 坐标轴颜色
@property (nonatomic,strong)UIColor *axisColor;

/// 坐标点值颜色
@property (nonatomic,strong)UIColor *nodeTitlesColor;

/// 坐票点值的字体
@property (nonatomic,strong)UIFont *nodeTitleFont;

/// 坐标的单位
@property (nonatomic,strong)NSString *unit;

@end


@interface KYXAxis: KYAxisBase
@property (nonatomic,strong)NSArray *nodeTitles;

- (instancetype)initWithNodeTitles:(NSArray<NSString *> *)titles;
@end

@interface KYYAxis: KYAxisBase
/// y轴是否显示%比
@property (nonatomic,assign)BOOL showPercentage;

/// y最大值
@property (nonatomic,assign)CGFloat maxValue;

/// y最小值
@property (nonatomic,assign)CGFloat minValue;

/// y轴刻度最大值
@property (nonatomic,readonly)CGFloat maxYNodeValue;

/// y轴刻度最小值
@property (nonatomic,readonly)CGFloat minYNodeValue;

/// y轴刻度差值
@property (nonatomic,readonly)CGFloat nodesDeltaValue;

/// 设置了最大最小值，会自动计算出来
@property (nonatomic,readonly,strong)NSArray *nodeTitles;

- (instancetype)initWithMaxValue:(CGFloat)max minValue:(CGFloat)min;

@end
