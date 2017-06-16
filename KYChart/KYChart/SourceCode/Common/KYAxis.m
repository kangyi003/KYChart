//
//  KYAxis.m
//  KYChart
//
//  Created by kangyi on 2017/6/9.
//  Copyright © 2017年 kangyi. All rights reserved.
//

#import "KYAxis.h"
#import "KYChartDefine.h"

#define defaultaxisColor [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1]
#define defaultNodeTitleColor [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1]
#define defaultNodeTitleFont [UIFont systemFontOfSize:13]

@interface KYAxisBase ()
- (void)setupDefault;
@end

@implementation KYAxisBase
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupDefault];
    }
    return self;
}

- (void)setupDefault{
    self.axisColor = defaultaxisColor;
    self.nodeTitlesColor = defaultNodeTitleColor;
    self.nodeTitleFont = defaultNodeTitleFont;
}
@end

@implementation KYXAxis
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupDefault];
    }
    return self;
}

- (instancetype)initWithNodeTitles:(NSArray<NSString *> *)titles;
{
    self = [self init];
    if (self) {
        _nodeTitles = titles;
        self.nodeCount = titles.count;
        self.nodeGap = defaultXNodeGap;
    }
    return self;
}

@end

@implementation KYYAxis

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupDefault];
    }
    return self;
}

- (instancetype)initWithMaxValue:(CGFloat)max minValue:(CGFloat)min
{
    self = [self init];
    if (self) {
        _maxValue = max;
        _minValue = min;
        self.nodeCount = defaultYNodeCount;
        [self caculateYNodeValue];
    }
    return self;
}

- (void)caculateYNodeValue{
    if (self.minValue < 0 && self.maxValue > 0) {// 最大值为正，最小值为负
        CGFloat delta = MAX(self.maxValue, fabs(self.minValue)) / (self.nodeCount - 1);
        [self adjustYAxisNodeData:delta];
        _maxYNodeValue = _minYNodeValue + _nodesDeltaValue * self.nodeCount ;
    }else{// 最大最小值同为正或者同为负
        CGFloat delta = fabs(self.maxValue - self.minValue) /(self.nodeCount - 1);
        [self adjustYAxisNodeData:delta];
        _maxYNodeValue = _minYNodeValue + _nodesDeltaValue *(self.nodeCount - 1);
    }
}

- (NSArray *)nodeTitles{
    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i < self.nodeCount; i++) {
        if (self.nodesDeltaValue > 10) {
            if (_showPercentage) {
                [titles addObject:[NSString stringWithFormat:@"%.0f%%",(self.minYNodeValue + _nodesDeltaValue*i) * 100]];
            }else
            [titles addObject:[NSString stringWithFormat:@"%.0f",self.minYNodeValue + _nodesDeltaValue*i]];
        }else{
            if (_showPercentage) {
                [titles addObject:[NSString stringWithFormat:@"%.0f%%",(self.minYNodeValue + _nodesDeltaValue*i) * 100]];
            }else
            [titles addObject:[NSString stringWithFormat:@"%.2f",self.minYNodeValue + _nodesDeltaValue*i]];
        }
    }
    return [titles copy];
}

- (void)adjustYAxisNodeData:(CGFloat)delta{
    NSInteger newDelta = delta * 1000000;
    NSString *str = [NSString stringWithFormat:@"%ld",newDelta];
    NSInteger length = (str.length - 6);
    
    // 计算刻度差值
    NSInteger baseNum = [str substringToIndex:3].integerValue;
    double power = pow(10,length - 1);
    if (baseNum % 100 <= 50) {
        _nodesDeltaValue = (((int)(baseNum / 100) + 0.5)) * power;//进0.5
    }else
        _nodesDeltaValue = ((int)(baseNum / 100 + 1)) * power;//最大位进1
    // 计算最小坐标刻度值
    NSString *minValue = [NSString stringWithFormat:@"%.0f",fabs(self.minValue)];
    _minYNodeValue = (int)((minValue.integerValue) / _nodesDeltaValue) * _nodesDeltaValue;
    _minYNodeValue = self.minValue >= 0 ? _minYNodeValue : - _minYNodeValue - _nodesDeltaValue;
    self.nodeCount = (self.maxValue - self.minYNodeValue) / _nodesDeltaValue + 2;
}

@end
