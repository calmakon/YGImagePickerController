//
//  UIImage+HYGExtension.h
//  HYGToolKit
//
//  Created by 胡亚刚 on 2017/7/11.
//  Copyright © 2017年 hu yagang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HYGExtension)
/*
 生成带圆角的图片
 radius 圆角大小
 size 图片大小
 */
- (UIImage *)hyg_imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size;
/*!
 @brief 颜色生成图片
 @param color 颜色
 */
+ (UIImage *)hyg_imageWithColor:(UIColor *)color;
/*!
 @brief 缩放图片 （生成缩略图）
 @param image 要生成缩略图的图片
 @param viewsize 大小
 */
+ (UIImage *)hyg_image: (UIImage *)image fillSize: (CGSize)viewsize;
- (UIImage *)yg_imageScale:(UIImage *)image size:(CGSize)imageSize;
@end
