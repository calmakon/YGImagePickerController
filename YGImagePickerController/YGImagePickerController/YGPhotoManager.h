//
//  YGPhotoManager.h
//  YGMediaTool
//
//  Created by HYG on 2018/3/30.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YGPhotoAsset.h"
@class YGPhotoAlbum,PHAsset,PHFetchResult,AVPlayerItem,PHPhotoLibrary;
@interface YGPhotoManager : NSObject
+ (YGPhotoManager *)manager;

@property (nonatomic,assign) CGFloat photoWidth;
@property (nonatomic,assign) CGFloat maxPreviewPhotoWidth;

- (BOOL)isAuthorizationAvailable;
- (void)requestAuthorizationCompletion:(void(^)(NSUInteger status))completion;
- (NSArray *)fetchAllAlbums;

- (void)fetchImageWithAlbum:(YGPhotoAlbum *)album completion:(void(^)(UIImage *image))completion;
- (void)fetchPhotoDataWithAsset:(PHAsset *)asset completion:(void(^)(NSData *imageData,NSDictionary *info))completion;
- (void)fetchPhotoWithAsset:(PHAsset *)asset completion:(void(^)(UIImage *image,NSDictionary *info))completion;
- (void)fetchPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void(^)(UIImage *image,NSDictionary *info))completion;
- (void)fetchPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth comletion:(void(^)(UIImage *image,NSDictionary *info))completion netWorkAllowed:(BOOL)netWorkAllowed;

- (YGPhotoAssetType)getTypeWithAsset:(PHAsset *)asset;
- (YGPhotoAsset *)getYGAssetWithPHAsset:(PHAsset *)asset;

- (void)fetchAssetsFromResult:(PHFetchResult *)result completion:(void (^)(NSArray<YGPhotoAsset *> *assets))completion;

- (void)fetchVideoWithAsset:(PHAsset *)asset completion:(void(^)(AVPlayerItem *item,NSDictionary *info))completion;
- (void)getVideoOutputPathWithAsset:(PHAsset *)asset presetName:(NSString *)presetName success:(void (^)(NSString *outputPath))success failure:(void (^)(NSString *errorMessage, NSError *error))failure;
@end
