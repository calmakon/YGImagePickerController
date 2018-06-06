//
//  YGPreviewView.h
//  YGMediaTool
//
//  Created by HYG on 2018/4/2.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YG_Gif)
+ (UIImage *)yg_gifImageWithData:(NSData *)imageData;
@end

@interface UIView (YG_Gif)
- (void)pauseLayer;
- (void)resumeLayer;
@end

//@class YGPhotoAsset;
@interface YGPreviewView : UICollectionViewCell
@property (nonatomic,strong) id assetModel;
@property (nonatomic,weak) UIViewController * controller;
@property (nonatomic,strong,readonly) UIImage * gifImage;
@end
