//
//  YGGifPreviewController.h
//  YGMediaTool
//
//  Created by HYG on 2018/6/6.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGPhotoAsset;
@interface YGGifPreviewController : UIViewController
- (instancetype)initWithAssetModel:(YGPhotoAsset *)assetModel;
@property (nonatomic,assign) BOOL isPreview;
@end
