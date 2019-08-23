//
//  UIImage+HYGExtension.m
//  HYGToolKit
//
//  Created by 胡亚刚 on 2017/7/11.
//  Copyright © 2017年 hu yagang. All rights reserved.
//

#import "UIImage+HYGExtension.h"

@implementation UIImage (HYGExtension)

- (UIImage *)hyg_imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);

    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(ctx,path.CGPath);
    CGContextClip(ctx);
    [self drawInRect:rect];
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)hyg_imageWithColor:(UIColor *)color {

    CGRect rect = CGRectMake(0, 0, 3, 3);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//生成缩略图
+ (UIImage *)hyg_image:(UIImage *)image fillSize:(CGSize)viewSize
{
    CGSize size = image.size;

    CGFloat scaleX = viewSize.width / size.width;
    CGFloat scaleY = viewSize.height / size.height;
    CGFloat scale = MAX(scaleX, scaleY);

    UIGraphicsBeginImageContext(viewSize);

    CGFloat width = size.width * scale;
    CGFloat height = size.height * scale;

    float dWidth = ((viewSize.width - width) / 2.0f);
    float dHeight = ((viewSize.height - height) / 2.0f);

    CGRect rect = CGRectMake(dWidth, dHeight, size.width * scale, size.height * scale);
    [image drawInRect:rect];

    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImg;
}

- (UIImage *)yg_imageScale:(UIImage *)image size:(CGSize)imageSize {
    if (image.size.width > imageSize.width) {
        UIGraphicsBeginImageContext(imageSize);
        [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }else {
        return image;
    }
}

@end
