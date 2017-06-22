//
//  KYChartRenderView.m
//  KYChart
//
//  Created by kangyi on 2017/6/12.
//  Copyright © 2017年 kangyi. All rights reserved.
//

#import "KYCurveRenderView.h"
#import "KYPlot.h"
#import "KYAxis.h"
#import "KYChartDefine.h"
#import "KYTipView.h"

@interface KYCurveRenderView ()
@property (nonatomic,strong)CAShapeLayer *maskAnimationLayer;
@property (nonatomic,strong)NSMutableDictionary *animationLayersDic;
@property (nonatomic,assign)CGRect preBounds;
@property (nonatomic,strong)KYTipView *tipView;
@end

@implementation KYCurveRenderView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefault];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefault];
    }
    return self;
}

- (void)setupDefault{
    self.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:recognizer];
}

- (void)tap:(UIGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:self];
    NSInteger index = point.x / self.xAxis.nodeGap;
    NSInteger maxCount = 0;
    for (KYPlot *plot in self.plots) {
        if (plot.points.count > maxCount) {
            maxCount = plot.points.count;
        }
    }
    if (index >= maxCount) {
        [self.tipView removeFromSuperview];
        return;
    }

    CGPoint basePoint = CGPointMake(self.xAxis.nodeGap * (index + 0.5), 0);
    if (self.tipView == nil) {
        self.tipView = [[KYTipView alloc] init];
    }
    NSMutableString *text = [[NSMutableString alloc]init];
    for (int i = 0; i < self.plots.count; i++) {
        KYPlot *plot = self.plots[i];
        NSString *value = [plot descriptionAtIndex:index];
        if (_yAxis.showPercentage) {
            CGPoint point = [plot.points[index] CGPointValue];
            value = [NSString stringWithFormat:@"%@ : %.0f%%",plot.markString,point.y * 100];
        }
        if (i > 0) {
            [text appendString:@"\n"];
        }
        [text appendString:value];
    }
    self.tipView.text = text;
    [self.tipView showTipInView:self AtPoint:basePoint];
}

- (CGSize)contentSize{
    return CGSizeMake((self.xAxis.nodeCount + 0) * self.xAxis.nodeGap > self.superview.bounds.size.width ? (self.xAxis.nodeCount + 0) * self.xAxis.nodeGap : self.superview.bounds.size.width, self.superview.bounds.size.height);
}

- (CGPoint)convertPointValueToLocation:(CGPoint)point{
    CGPoint pointInView = CGPointMake(self.xAxis.nodeGap / 2 + point.x * self.xAxis.nodeGap,
                                      self.bounds.size.height  -((point.y - self.yAxis.minYNodeValue)/ self.yAxis.nodesDeltaValue) * [self nodeGap]-pointRadius);
    return pointInView;
}
-
(void)layoutSubviews{
    [super layoutSubviews];
    // 大小未改变，不显示动画的时候，不需要重置动画
    if (!CGRectEqualToRect(self.preBounds, self.bounds) && self.showAnimation) {
        [self refreshAnimationForPlots:_plots];
    }
    self.preBounds = self.bounds;
}

- (void)pointsInViewForPlot:(KYPlot *)plot outPoints:(CGPoint *)points{
    CGPoint beginPoint = [plot.points[0] CGPointValue];
    CGPoint pointInView = CGPointMake(self.xAxis.nodeGap / 2,
                                      self.bounds.size.height  -((beginPoint.y - self.yAxis.minYNodeValue)/ self.yAxis.nodesDeltaValue) * [self nodeGap] -pointRadius);

    points[0] = pointInView;
    for (int i = 1; i < plot.points.count; i++) {
        CGPoint point = [plot.points[i] CGPointValue];
        pointInView = CGPointMake(self.xAxis.nodeGap / 2 + i * self.xAxis.nodeGap,
                                  self.bounds.size.height  -((point.y - self.yAxis.minYNodeValue)/ self.yAxis.nodesDeltaValue) * [self nodeGap]-pointRadius);
        points[i] = pointInView;
    }
}

- (UIBezierPath *)maskPathForPlot:(KYPlot *)plot{
    CGPoint points[plot.points.count];
    [self pointsInViewForPlot:plot outPoints:points];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint begin = CGPointMake(self.xAxis.nodeGap / 2, self.bounds.size.height - pointRadius);
    CGPathMoveToPoint(path, nil, begin.x, begin.y);

    CGPoint pointInView = points[0];
    CGPoint prePoint = points[0];
    CGPathAddLineToPoint(path, nil, pointInView.x, pointInView.y);
    for (int i = 1; i < plot.points.count; i++) {
        pointInView = points[i];
        if (plot.showCurve) {
            CGPathAddCurveToPoint(path, nil, (pointInView.x-prePoint.x)/2+prePoint.x, prePoint.y, (pointInView.x-prePoint.x)/2+prePoint.x, pointInView.y, pointInView.x, pointInView.y);
        }else{
            CGPathAddLineToPoint(path, nil, pointInView.x, pointInView.y);
            prePoint = pointInView;
        }
        prePoint = pointInView;
    }
    CGPoint end = CGPointMake(self.xAxis.nodeGap *(plot.points.count -.5), self.bounds.size.height - pointRadius);
    CGPathAddLineToPoint(path, nil, end.x, end.y);

    UIBezierPath *retPath = [UIBezierPath bezierPathWithCGPath:path];
    CGPathRelease(path);
    return retPath;
}

- (UIBezierPath *)pathForPlot:(KYPlot *)plot{
    CGPoint points[plot.points.count];
    [self pointsInViewForPlot:plot outPoints:points];
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPoint pointInView = points[0];
    CGPoint prePoint = points[0];
    CGPathMoveToPoint(path, nil, pointInView.x+pointRadius, pointInView.y);
    for (int i = 1; i < plot.points.count; i++) {
        pointInView = points[i];
        if (plot.showCurve) {
            CGPathAddCurveToPoint(path, nil, (pointInView.x-prePoint.x)/2+prePoint.x, prePoint.y, (pointInView.x-prePoint.x)/2+prePoint.x, pointInView.y, pointInView.x-pointRadius, pointInView.y);
        }else{
            CGPathAddLineToPoint(path, nil, pointInView.x-pointRadius, pointInView.y);
            prePoint = pointInView;
        }
        CGPathMoveToPoint(path, nil, pointInView.x + pointRadius, pointInView.y);
        prePoint = pointInView;
    }
    UIBezierPath *retPath = [UIBezierPath bezierPathWithCGPath:path];
    CGPathRelease(path);
    return retPath;
}

// y坐标刻度间距
- (CGFloat)nodeGap{
    CGFloat nodeGap = (self.bounds.size.height - KYChartTopMargin) / (self.yAxis.nodeCount - 1);
    return nodeGap;
}

#pragma mark - public method

- (void)addPlot:(KYPlot *)plot{
    if (self.plots == nil) {
        self.plots = [NSMutableArray array];
    }
    [self.plots addObject:plot];
}

- (void)removePlot:(KYPlot *)plot{
    [self.plots removeObject:plot];
    CALayer *layer = [self.animationLayersDic objectForKey:@(plot.hash)];
    [layer removeFromSuperlayer];
}

- (void)remvoeAllPlots{
    [self.plots removeAllObjects];

    for (CALayer *layer in [self.animationLayersDic allValues]) {
        [layer removeFromSuperlayer];
    }
    [self.animationLayersDic removeAllObjects];
    [self setNeedsDisplay];
}

- (void)reloadData{
    if (self.showAnimation) {
        [self setupLayerForPlots:self.plots];
        [self refreshAnimationForPlots:self.plots];
    }
    if (self.plots.count < 1) {
        [self remvoeAllPlots];
    }
    [self.tipView removeFromSuperview];
    [self setNeedsDisplay];
}

#pragma mark - animation

- (void)setupLayerForPlots:(NSArray *)plots{
    NSArray *array = [self.animationLayersDic allKeys];
    for (NSObject *obj in array) {
        BOOL include = NO;
        for (KYPlot *plot in plots) {
            if ([obj isEqual:@(plot.hash)]) {
                include = YES;
                break;
            }
        }
        if (!include) {
            [self.animationLayersDic[obj] removeFromSuperlayer];
            [self.animationLayersDic removeObjectForKey:obj];
        }
    }
    for (KYPlot *plot in plots) {
        [self configAnimationLayerForPlot:plot];
    }
}

- (void)configAnimationLayerForPlot:(KYPlot *)plot{
    CALayer *baseLayer = [self.animationLayersDic objectForKey:@(plot.hash)];
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"bounds";
    animation.duration = plot.points.count/2;
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.frame.size.width*2, self.frame.size.height)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    
    UIBezierPath *path = [self maskPathForPlot:plot];

    if (baseLayer == nil) {
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = path.CGPath;
        maskLayer.fillColor = [UIColor greenColor].CGColor;
        //渐变图层
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 0, self.frame.size.height - pointRadius);
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.colors = @[(__bridge id)[plot.lineColor colorWithAlphaComponent:0.6].CGColor,(__bridge id)([plot.lineColor colorWithAlphaComponent:0.1].CGColor)];
        gradientLayer.locations = @[@(0.5f)];
        [gradientLayer addAnimation:animation forKey:@"bounds"];
        
        baseLayer = [CALayer layer];
        baseLayer.frame = CGRectMake(0, 0, 200, 200);
        [baseLayer insertSublayer:gradientLayer atIndex:0];
        [baseLayer setMask:maskLayer];
        
        [self.layer addSublayer:baseLayer];
        if (self.animationLayersDic == nil) {
            self.animationLayersDic = [NSMutableDictionary dictionary];
        }
        [self.animationLayersDic setObject:baseLayer forKey:@(plot.hash)];
    }
}

- (void)refreshAnimationForPlots:(NSArray *)plots{
    for (KYPlot *plot in plots) {
        CALayer *baseLayer = [self.animationLayersDic objectForKey:@(plot.hash)];
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.keyPath = @"bounds";
        animation.duration = plot.points.count/2;
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.frame.size.width*2, self.frame.size.height-pointRadius)];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.fillMode = kCAFillModeForwards;
        animation.autoreverses = NO;
        animation.removedOnCompletion = NO;
        
        UIBezierPath *path = [self maskPathForPlot:plot];

        CAGradientLayer *gradientLayer = (CAGradientLayer *)[baseLayer sublayers].firstObject;
        gradientLayer.colors = @[(__bridge id)[plot.lineColor colorWithAlphaComponent:0.6].CGColor,(__bridge id)([plot.lineColor colorWithAlphaComponent:0.1].CGColor)];

        [gradientLayer removeAnimationForKey:@"bounds"];
        [gradientLayer addAnimation:animation forKey:@"bounds"];
        gradientLayer.frame = CGRectMake(0, 0, 0, self.frame.size.height);
        CAShapeLayer *maskLayer = (CAShapeLayer *)[baseLayer mask];
        maskLayer.path = path.CGPath;
    }
}
#pragma mark - draw
- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self drawXAxisWithContext:ctx];
    [self drawCoordinateLineWithContext:ctx];
    [self drawPlotsWithContext:ctx];
}

// 绘制X轴，y = 0的轴
- (void)drawXAxisWithContext:(CGContextRef)context{
    
}

// 绘制Y坐标虚线
- (void)drawCoordinateLineWithContext:(CGContextRef)context{
    for (int i = 0; i < self.yAxis.nodeCount; i++) {
        CGContextSaveGState(context);
        CGContextSetLineWidth(context, 0.5f);
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.28 alpha:0.3].CGColor);
        CGContextSetLineDash(context, 0, (CGFloat[]){4, 4},2);
        CGFloat nodeGap = (self.bounds.size.height - KYChartTopMargin ) / (self.yAxis.nodeCount - 1);
        CGContextMoveToPoint(context,0,KYChartTopMargin + i * nodeGap -pointRadius);
        CGContextAddLineToPoint(context,self.bounds.size.width,KYChartTopMargin + i * nodeGap-pointRadius);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
    }
}

// 绘制点线
- (void)drawPlotsWithContext:(CGContextRef)context{
    for (KYPlot *plot in self.plots) {
        [self drawPlot:plot withContext:context];
        if (!_showAnimation) {// 不显示动画就直接绘制曲线
            [self drawLineWithPlot:plot context:context];
        }
        if (plot.showTrendLine) {// 趋势线
            [self drawTrendLineForPlot:plot withContext:context];
        }
    }
}

// 绘制趋势线
- (void)drawTrendLineForPlot:(KYPlot *)plot withContext:(CGContextRef)context{
    NSArray *trendLineArray = [plot trendLinePoints];
    if (trendLineArray.count >= 2) {
        CGContextSaveGState(context);
        CGContextSetLineWidth(context, 0.5f);
        CGContextSetLineDash(context, 0, (CGFloat[]){3.0,1.0}, 0);
        CGContextSetStrokeColorWithColor(context, plot.trendLineColor.CGColor);
        CGContextSetShouldAntialias(context, YES);
        
        CGPoint p1 = [trendLineArray.firstObject CGPointValue];
        CGContextMoveToPoint(context,
                             self.xAxis.nodeGap / 2,
                             self.bounds.size.height -((p1.y - self.yAxis.minYNodeValue)/ self.yAxis.nodesDeltaValue) * [self nodeGap] - pointRadius);
        for (int i = 1; i < trendLineArray.count; i++) {
            CGPoint point = [trendLineArray[i] CGPointValue];
            CGPoint pointInView = CGPointMake(self.xAxis.nodeGap / 2 + i * self.xAxis.nodeGap,
                                              self.bounds.size.height  -((point.y - self.yAxis.minYNodeValue)/ self.yAxis.nodesDeltaValue) * [self nodeGap]-pointRadius);
            CGContextAddLineToPoint(context,pointInView.x,pointInView.y);
        }
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
    }
}

// 绘制点，不显示动画的话同时画线
- (void)drawPlot:(KYPlot *)plot withContext:(CGContextRef)context{
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, plot.pointColor.CGColor);
    CGContextSetFillColorWithColor(context, plot.pointColor.CGColor);
    CGContextSetLineWidth(context, 1);
    CGPoint beginPoint = [plot.points[0] CGPointValue];
    CGPoint pointInView = CGPointMake(self.xAxis.nodeGap / 2,
                                      self.bounds.size.height  -((beginPoint.y - self.yAxis.minYNodeValue)/ self.yAxis.nodesDeltaValue) * [self nodeGap] -pointRadius);
    //绘制点
    if (_showSolidPoint) {
        CGContextFillEllipseInRect(context, CGRectMake(pointInView.x - pointRadius, pointInView.y - pointRadius, pointRadius * 2, pointRadius * 2));
    }else{
        CGContextStrokeEllipseInRect(context, CGRectMake(pointInView.x - pointRadius, pointInView.y - pointRadius, pointRadius * 2, pointRadius * 2));
    }
    for (int i = 1; i < plot.points.count; i++) {
        CGPoint point = [plot.points[i] CGPointValue];
        pointInView = CGPointMake(self.xAxis.nodeGap / 2 + i * self.xAxis.nodeGap,
                                  self.bounds.size.height  -((point.y - self.yAxis.minYNodeValue)/ self.yAxis.nodesDeltaValue) * [self nodeGap]-pointRadius);
        if (_showSolidPoint) {
            CGContextFillEllipseInRect(context, CGRectMake(pointInView.x - pointRadius, pointInView.y - pointRadius, pointRadius * 2, pointRadius * 2));
        }else{
            CGContextStrokeEllipseInRect(context, CGRectMake(pointInView.x - pointRadius, pointInView.y - pointRadius, pointRadius * 2, pointRadius * 2));
        }
    }
    CGContextRestoreGState(context);
}

- (void)drawLineWithPlot:(KYPlot*)plot context:(CGContextRef)context{
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, plot.lineColor.CGColor);
    CGContextSetLineWidth(context, 0.5);
    UIBezierPath *path = [self pathForPlot:plot];
    CGContextAddPath(context, path.CGPath);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end
