//
//  UIColor+HYGExtension.h
//  HYGToolKit
//
//  Created by 胡亚刚 on 2017/7/11.
//  Copyright © 2017年 hu yagang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HYGExtension)
/*!
 @brief 十六进制颜色
 @param hex 色值
 */
+(UIColor *)hyg_colorWithHex:(NSInteger)hex;
/*!
 @brief 十六进制颜色
 @param hex 色值
 @param alpha 透明度
 */
+(UIColor *)hyg_colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;
@end
