//
//  KYCuuveChartDefine.h
//  KYChart
//
//  Created by kangyi on 2017/6/13.
//  Copyright © 2017年 kangyi. All rights reserved.
//

#ifndef KYCuuveChartDefine_h
#define KYCuuveChartDefine_h

typedef NS_ENUM(NSInteger,KYChartType) {
    KYChartTypeCurve,
    KYChartTypeBar,
    KYChartTypeCircle
};

// 间距
#define margin 8
// X轴默认高度
#define defaultXAxisHeight 50

// Y轴默认宽度
#define defaultYAxisWidth 50

// 图表距上边界距离
#define KYChartTopMargin 30

// y轴刻度点数，如果正负值都有，就是值比较大的一端的刻度数
#define defaultYNodeCount 5

/// 曲线图x轴刻度默认间距
#define defaultXNodeGap 40

// 数据点的半半径
#define pointRadius 4

#endif /* KYCuuveChartDefine_h */
