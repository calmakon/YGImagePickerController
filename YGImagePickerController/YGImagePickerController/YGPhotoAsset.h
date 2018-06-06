//
//  YGPhotoAsset.h
//  YGMediaTool
//
//  Created by HYG on 2018/4/2.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,YGPhotoAssetType) {
    YGPhotoAssetTypeImage = 0,
    YGPhotoAssetTypeGIF,
    YGPhotoAssetTypeLivePhoto,
    YGPhotoAssetTypeVideo,
    YGPhotoAssetTypeAudio,
    YGPhotoAssetTypeUnknow
};

@class PHAsset;
@interface YGPhotoAsset : NSObject

@property (nonatomic,assign) YGPhotoAssetType type;
@property (nonatomic,strong) PHAsset * asset;
@property (nonatomic,assign,getter=isSelected) BOOL selected;
@end
