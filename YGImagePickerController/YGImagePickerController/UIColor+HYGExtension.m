//
//  UIColor+HYGExtension.m
//  HYGToolKit
//
//  Created by 胡亚刚 on 2017/7/11.
//  Copyright © 2017年 hu yagang. All rights reserved.
//

#import "UIColor+HYGExtension.h"

@implementation UIColor (HYGExtension)

+ (UIColor *)hyg_colorWithHex:(NSInteger)hex {

    return [UIColor colorWithRed : ((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hex & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hex & 0xFF)) / 255.0 alpha : 1.0];
}

+ (UIColor *)hyg_colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha {

    return [UIColor colorWithRed : ((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hex & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hex & 0xFF)) / 255.0 alpha : alpha];
}

@end
