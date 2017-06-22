//
//  KYCurveChartView.m
//  KYChart
//
//  Created by kangyi on 2017/6/9.
//  Copyright © 2017年 kangyi. All rights reserved.
//

#import "KYCurveChartView.h"
#import "KYCurveRenderView.h"
#import "KYYAxisView.h"
#import "KYXAxisView.h"
#import "KYChartDefine.h"

@interface KYCurveChartView ()
@property (nonatomic,strong)KYXAxisView *xAxisView;
@property (nonatomic,strong)KYYAxisView *yAxisView;
@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)KYCurveRenderView *renderView;
/// 曲线数组，可包含多条
@property (nonatomic,strong)NSMutableArray<KYPlot *> *plots;

@property (nonatomic,strong)NSLayoutConstraint *yWidthConstraint;
@end

@implementation KYCurveChartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark -
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
    _yAxisWidth = defaultYAxisWidth;
    [self addSubview:self.yAxisView];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.renderView];
    [self.scrollView addSubview:self.xAxisView];
    [self setupConstraints];
}

- (void)setupConstraints{
    [self.yAxisView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];

    NSLayoutConstraint *constraintTop = [NSLayoutConstraint constraintWithItem:_yAxisView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem:_yAxisView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *constraintLeft = [NSLayoutConstraint constraintWithItem:_yAxisView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        _yWidthConstraint = [NSLayoutConstraint constraintWithItem:_yAxisView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.yAxisWidth];
    [self addConstraint:constraintTop];
    [self addConstraint:constraintBottom];
    [self addConstraint:constraintLeft];
    [self addConstraint:_yWidthConstraint];
    
    NSLayoutConstraint *constraintTop1 = [NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *constraintBottom1 = [NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *constraintLeft1 = [NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_yAxisView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *constraintRight = [NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self addConstraint:constraintTop1];
    [self addConstraint:constraintBottom1];
    [self addConstraint:constraintLeft1];
    [self addConstraint:constraintRight];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //计算renderView大小和scrollview的contentsize
    CGSize size = [self.renderView contentSize];
    self.scrollView.contentSize = size;
    self.renderView.frame = CGRectMake(0, 0, size.width, size.height - defaultXAxisHeight);
    self.xAxisView.frame = CGRectMake(0, self.scrollView.bounds.size.height - defaultXAxisHeight, size.width, defaultXAxisHeight);
}
#pragma mark - property
- (KYXAxisView *)xAxisView{
    if (_xAxisView == nil) {
        _xAxisView = [[KYXAxisView alloc] init];
    }
    return _xAxisView;
}

- (KYYAxisView *)yAxisView{
    if (_yAxisView == nil) {
        _yAxisView = [[KYYAxisView alloc] init];
    }
    return _yAxisView;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (KYCurveRenderView *)renderView{
    if (_renderView == nil) {
        _renderView  = [[KYCurveRenderView alloc] init];
    }
    return _renderView;
}

- (NSMutableArray *)plots{
    if (_plots == nil) {
        _plots = [NSMutableArray array];
    }
    return _plots;
}

- (void)setShowAnimation:(BOOL)showAnimation{
    _showAnimation = showAnimation;
    self.renderView.showAnimation = showAnimation;
}

- (void)setXAxis:(KYXAxis *)xAxis{
    _xAxis = xAxis;
    self.renderView.xAxis = xAxis;
    self.xAxisView.xAxis = xAxis;
}

- (void)setYAxis:(KYYAxis *)yAxis{
    _yAxis = yAxis;
    self.renderView.yAxis = yAxis;
    self.yAxisView.yAxis = yAxis;
}

- (void)setYAxisWidth:(CGFloat)yAxisWidth{
    _yAxisWidth = yAxisWidth;
    self.yWidthConstraint.constant = yAxisWidth;
    [self setNeedsUpdateConstraints];
}

#pragma mark -

- (void)addPlot:(KYPlot *)plot{
    if (_plots == nil) {//首次添加曲线
        self.renderView.plots = self.plots;
    }
    [self.renderView addPlot:plot];
    [self.renderView reloadData];
}

/// 移除曲线
- (void)removePlot:(KYPlot *)plot{
    [self.renderView removePlot:plot];
    [self.renderView reloadData];
}

/// 移除所有曲线
- (void)removeAllPlots{
    [self.renderView remvoeAllPlots];
    [self.renderView reloadData];
}

/// 显示
- (void)reloadPlots{
    self.yAxisView.yAxis = self.yAxis;
    self.xAxisView.xAxis = self.xAxis;

    self.renderView.xAxis = self.xAxis;
    self.renderView.yAxis = self.yAxis;
    
    [self setNeedsLayout];
    [self.yAxisView reloadData];
    [self.xAxisView reloadData];
    [self.renderView reloadData];
}
@end
