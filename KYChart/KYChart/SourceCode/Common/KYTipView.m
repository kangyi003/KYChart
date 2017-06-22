//
//  KYTipView.m
//  KYChart
//
//  Created by kangyi on 2017/6/15.
//  Copyright © 2017年 kangyi. All rights reserved.
//

#import "KYTipView.h"
#import "KYChartDefine.h"

@interface KYTipView ()

@property (nonatomic,strong)UIFont *textFont;

@property (nonatomic,assign)CGPoint basePoint;
@end

@implementation KYTipView

- (instancetype)initWithText:(NSString *)text{
    self = [super init];
    if (self) {
        _text = text;
    }
    return self;
}

- (void)showTipInView:(UIView *)view AtPoint:(CGPoint)point
{
    if (!self.superview) {
        [view addSubview:self];
    }
    self.basePoint = point;
    CGSize textSize = [_text sizeWithAttributes:@{NSFontAttributeName:self.textFont}];
    CGSize size = CGSizeMake(textSize.width + margin, view.bounds.size.height);
    if (point.x + size.width > view.bounds.size.width) {
        self.showAtLeft = YES;
    }else{
        self.showAtLeft = NO;
    }
    if (self.showAtLeft) {
        self.frame = CGRectMake(point.x - size.width, 0, size.width, size.height);

    }else
        self.frame = CGRectMake(point.x, 0, size.width, size.height);
    [self setNeedsDisplay];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    if (self) {
        [self initDefault];
    }
    return self;
}

- (void)initDefault{
    self.backgroundColor = [UIColor clearColor];
    
    self.bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    self.textColor = [UIColor whiteColor];
    
    self.showAtLeft = NO;
    
    self.textFont = [UIFont systemFontOfSize:13];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)tap:(id)recognizer{
    [self removeFromSuperview];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGSize textSize = [_text sizeWithAttributes:@{NSFontAttributeName:self.textFont}];
        CGRect validRect = CGRectMake(0, 0, textSize.width + margin, textSize.height + margin);
    if (CGRectContainsPoint(validRect, point)) {
        return self;
    }
    return nil;
}

- (void)setText:(NSString *)text{
    _text = text;
    [self sizeToFit];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawBackGroundWithContext:context];
    [self drawTextWithContext:context];
}

- (void)drawBackGroundWithContext:(CGContextRef)context{
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, self.bgColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.bgColor.CGColor);
    CGContextSetLineDash(context, 0, (CGFloat[]){4, 4},2);
    CGContextSetLineWidth(context, 0.25);
    CGContextAddPath(context, [self getDrawPath].CGPath);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);
}

- (UIBezierPath *)getDrawPath
{
    CGFloat radius = 3.0;
    CGSize textSize = [_text sizeWithAttributes:@{NSFontAttributeName:self.textFont}];
    CGSize size = CGSizeMake(textSize.width +  margin, textSize.height +  margin);
    CGMutablePathRef path = CGPathCreateMutable();
    if (self.showAtLeft) {
        CGPathMoveToPoint(path, nil, self.bounds.size.width, self.bounds.size.height);
        CGPathAddArcToPoint(path, nil, self.bounds.size.width, self.bounds.size.height, self.bounds.size.width, 0, radius);
        CGPathAddArcToPoint(path, nil, self.bounds.size.width, 0, 0, 0, radius);
        CGPathAddArcToPoint(path, nil, 0, 0, 0, size.height, radius);
        CGPathAddArcToPoint(path, nil, 0, size.height, size.width - 5, size.height, radius);
        CGPathAddLineToPoint(path, nil, size.width - 5, size.height);
        CGPathAddLineToPoint(path, nil, size.width, size.height + 5);

    }else{
        CGPathMoveToPoint(path, nil, 0, self.bounds.size.height);
        CGPathAddLineToPoint(path, nil, 0, size.height);
        CGPathAddArcToPoint(path, nil, 0, 0, self.bounds.size.width, 0, radius);
        CGPathAddArcToPoint(path, nil, self.bounds.size.width, 0, self.bounds.size.width, size.height, radius);
        CGPathAddArcToPoint(path, nil, self.bounds.size.width, size.height,5, size.height, radius);
        CGPathAddLineToPoint(path, nil, 5, size.height);
        CGPathAddLineToPoint(path, nil, 0, size.height + 5);
    }
    CGPathCloseSubpath(path);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithCGPath:path];
    CGPathRelease(path);
    return bezierPath;
}

- (void)drawTextWithContext:(CGContextRef)context{
    CGContextSaveGState(context);
    CGSize textSize = [_text sizeWithAttributes:@{NSFontAttributeName:self.textFont}];
    
    [_text drawInRect:CGRectMake(margin/2, margin/2, textSize.width, textSize.height) withAttributes:@{NSFontAttributeName:self.textFont,NSForegroundColorAttributeName:_textColor}];

    CGContextRestoreGState(context);
}

@end
