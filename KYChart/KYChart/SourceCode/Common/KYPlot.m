//
//  KYPlot.m
//  KYChart
//
//  Created by kangyi on 2017/6/9.
//  Copyright © 2017年 kangyi. All rights reserved.
//

#import "KYPlot.h"
#import "KYLineFitter.h"

#define defaultPlotColor [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1]
#define defaultTrendColor [UIColor redColor]

@implementation KYPlot

- (instancetype)initWithMark:(NSString *)mark points:(NSArray<NSValue *> *)points{
    self  = [self init];
    if (self) {
        _points = points;
        _markString = mark;
    }
    return self;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupDefault];
    }
    return self;
}

- (void)setupDefault{
    self.lineColor = defaultPlotColor;
    self.pointColor = defaultPlotColor;
    self.trendLineColor = defaultTrendColor;
}


- (NSArray *)trendLinePoints{
    NSArray *trendLineArray = beelineFitting(self.points);
    return trendLineArray;
}

- (NSString *)descriptionAtIndex:(NSInteger)index{
    CGPoint point = [self.points[index] CGPointValue];
    NSString *value = [NSString stringWithFormat:@"%@ : %.2f",self.markString,point.y];
    return value;
}

@end
