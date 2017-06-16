//
//  KYYAxisView.m
//  KYChart
//
//  Created by kangyi on 2017/6/13.
//  Copyright © 2017年 kangyi. All rights reserved.
//

#import "KYYAxisView.h"
#import "KYChartDefine.h"


#define YTitleWidth 40

#define yTitleheight 20

@implementation KYYAxisView

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
    _showYAxis = NO;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.showYAxis) {
        [self drawYAxisWithContext:context];
    }
    
    [self drawNodeTitlesWithContext:context];
}


- (void)drawYAxisWithContext:(CGContextRef)context{
    if (self.yAxis.nodeTitles.count < 1) {
        return;
    }
    CGContextSaveGState(context);
    
    CGContextSetStrokeColorWithColor(context, self.yAxis.axisColor.CGColor);
    CGContextMoveToPoint(context, self.bounds.size.width - 2, KYChartTopMargin);
    CGContextAddLineToPoint(context, self.bounds.size.width - 2, self.bounds.size.height - defaultXAxisHeight);
    CGContextSetLineWidth(context, 1.0/[UIScreen mainScreen].scale);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)drawNodeTitlesWithContext:(CGContextRef)context{
    CGContextSaveGState(context);
    CGFloat nodeGap = (self.bounds.size.height - KYChartTopMargin - defaultXAxisHeight) / (self.yAxis.nodeCount - 1);
    for (int i = 0; i < self.yAxis.nodeTitles.count; i++) {
        CGRect titleFrame = CGRectMake(0,
                                       self.bounds.size.height - defaultXAxisHeight - nodeGap * i - yTitleheight / 2,
                                       self.bounds.size.width - margin,
                                       yTitleheight);
        CGContextSetTextDrawingMode(context,kCGTextFill);
        NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [self.yAxis.nodeTitles[i] drawInRect:titleFrame withAttributes:@{NSFontAttributeName:self.yAxis.nodeTitleFont,NSForegroundColorAttributeName:self.yAxis.nodeTitlesColor,NSParagraphStyleAttributeName:paragraphStyle}];
    }
    CGContextRestoreGState(context);
}


- (void)reloadData{
    [self setNeedsDisplay];
}
@end
