//
//  KYXAxisView.h
//  KYChart
//
//  Created by kangyi on 17/6/14.
//  Copyright © 2017年 kangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYAxis.h"

@interface KYXAxisView : UIView
@property (nonatomic,strong)KYXAxis *xAxis;

- (void)reloadData;
@end
