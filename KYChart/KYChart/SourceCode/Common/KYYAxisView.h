//
//  KYYAxisView.h
//  KYChart
//
//  Created by kangyi on 2017/6/13.
//  Copyright © 2017年 kangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYAxis.h"

@interface KYYAxisView : UIView

/// 是否显示Y轴线，默认为NO不显示
@property (nonatomic,assign)BOOL showYAxis;

/// Y轴信息
@property (nonatomic,strong)KYYAxis *yAxis;

- (void)reloadData;
@end
