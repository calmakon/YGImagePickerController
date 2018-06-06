//
//  YGPhotoBottomBar.h
//  YGMediaTool
//
//  Created by HYG on 2018/4/9.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGPhotoAsset.h"
typedef void (^PreviewAction)(void);
typedef void (^ConfirmAction)(void);
@interface YGPhotoBottomBar : UIView
- (instancetype)initWithCollection:(BOOL)isCollection;
- (void)updateSelectedNum:(NSInteger)num;
@property (nonatomic,copy) PreviewAction previewBlock;
@property (nonatomic,copy) ConfirmAction confirmBlock;
@property (nonatomic,assign) YGPhotoAssetType assetType;
@end
