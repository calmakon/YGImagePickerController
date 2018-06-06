//
//  YGPhotoPreviewController.h
//  YGMediaTool
//
//  Created by HYG on 2018/4/2.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGPhotoAsset;
@interface YGPhotoPreviewController : UIViewController
- (instancetype)initWithPhotos:(NSArray *)photos currentIndex:(NSInteger)currentIndex;
@end
