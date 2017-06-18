//
//  KYXAxisView.m
//  KYChart
//
//  Created by kangyi on 17/6/14.
//  Copyright © 2017年 kangyi. All rights reserved.
//

#import "KYXAxisView.h"
#import "KYChartDefine.h"
#import "KYAxis.h"

#define xAxisTitleHeight 30
@implementation KYXAxisView

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
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawXAxisWithContext:context];
    [self drawNodeTitlesWithContext:context];
}

- (void)drawXAxisWithContext:(CGContextRef)context{
    if (self.xAxis.nodeTitles.count < 1) {
        return;
    }
    CGContextSaveGState(context);
    CGPoint beginPoint = CGPointMake(0, margin);
    CGPoint endPoint = CGPointMake(self.bounds.size.width, margin);
    
    // 图表与x轴刻度间隔线
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, self.xAxis.axisColor.CGColor);
    CGContextMoveToPoint(context, beginPoint.x, beginPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);

}

- (void)drawNodeTitlesWithContext:(CGContextRef)context{
    CGPoint beginPoint = CGPointMake(0, self.bounds.size.height - defaultXAxisHeight + 20);

    CGContextSaveGState(context);
    for (int i = 0; i < self.xAxis.nodeTitles.count; i++) {
        NSString *text = self.xAxis.nodeTitles[i];
        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:self.xAxis.nodeTitleFont}];
        int lines = size.width / self.xAxis.nodeGap + 1;
        CGRect titleFrame = CGRectMake(self.xAxis.nodeGap * i,
                                       beginPoint.y + margin,//线往下8px
                                       self.xAxis.nodeGap,
                                       xAxisTitleHeight * lines);
        CGContextSetTextDrawingMode(context,kCGTextFill);
        NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [text drawInRect:titleFrame withAttributes:@{NSFontAttributeName:self.xAxis.nodeTitleFont,NSForegroundColorAttributeName:self.xAxis.nodeTitlesColor,NSParagraphStyleAttributeName:paragraphStyle}];
    }
    CGContextRestoreGState(context);
}


- (void)reloadData{
    [self setNeedsDisplay];
}
@end
