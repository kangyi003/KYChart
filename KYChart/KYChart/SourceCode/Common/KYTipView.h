//
//  KYTipView.h
//  KYChart
//
//  Created by kangyi on 2017/6/15.
//  Copyright © 2017年 kangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYTipView : UIView

@property (nonatomic,strong)NSString *text;

@property (nonatomic,strong)UIColor *bgColor;
@property (nonatomic,strong)UIColor *textColor;

@property (nonatomic,assign)BOOL showAtLeft;

- (instancetype)initWithText:(NSString *)text;

- (void)showTipInView:(UIView *)view AtPoint:(CGPoint)point;
@end
