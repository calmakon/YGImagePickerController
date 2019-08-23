//
//  YGPhotoManager.m
//  YGMediaTool
//
//  Created by HYG on 2018/3/30.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import "YGPhotoManager.h"
#import "YGPhotoConfig.h"
#import "UIImage+HYGExtension.h"
@interface YGPhotoManager ()
{
    CGFloat _kScreenWidth;
    CGFloat _kScreenScale;
}
@end

@implementation YGPhotoManager

+ (YGPhotoManager *)manager {
    static YGPhotoManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
        [manager configWidth];
    });
    return manager;
}

- (void)requestAuthorizationCompletion:(void (^)(NSUInteger status))completion {
    //请求权限
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status && completion) {
                completion(status);
            }
        });
    }];
}

- (BOOL)isAuthorizationAvailable {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    BOOL res = status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied;
    return res;
}

- (void)configWidth {
    _kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    _kScreenScale = 2.0f;
    if (_kScreenWidth > 700) {
        _kScreenScale = 1.5;
    }
}

- (void)setPhotoWidth:(CGFloat)photoWidth {
    _photoWidth = photoWidth;
    _kScreenWidth = photoWidth / 2.0f;
}

- (void)setMaxPreviewPhotoWidth:(CGFloat)maxPreviewPhotoWidth {
    _maxPreviewPhotoWidth = maxPreviewPhotoWidth;
}

//获取所有的相册，包括系统相册，自定义相册
- (NSArray *)fetchAllAlbums {
    if ([[YGPhotoManager manager] isAuthorizationAvailable]) {
        return nil;
    }
    NSMutableArray * albums = [NSMutableArray array];

    //系统相册
    PHFetchResult * systemAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //NSLog(@"智能相册个数：%lu",(unsigned long)systemAlbums.count);
    //自定义相册
    PHFetchResult * customAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    //NSLog(@"用户相册个数：%lu",(unsigned long)customAlbums.count);

    [systemAlbums enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection * col = (PHAssetCollection *)obj;
        YGPhotoAlbum * album = [YGPhotoAlbum new];
        PHFetchResult * res = [PHAsset fetchAssetsInAssetCollection:col options:nil];
        if (res.count != 0 && (![col.localizedTitle containsString:@"Deleted"] || ![col.localizedTitle containsString:@"最近删除"] || ![col.localizedTitle containsString:@"Hidden"] || ![col.localizedTitle containsString:@"已隐藏"])) {
            album.resource = res;
            album.title = col.localizedTitle;
            album.count = res.count;
            [albums addObject:album];
        }
    }];

    [albums enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YGPhotoAlbum * album = (YGPhotoAlbum *)obj;
        if ([album.title containsString:@"Camera Roll"] ||
            [album.title containsString:@"相机胶卷"]) {
            YGPhotoAlbum * album0 = albums[0];
            albums[0] = album;
            albums[idx] = album0;
            *stop = YES;
        }
    }];

    [customAlbums enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection * col = (PHAssetCollection *)obj;
        YGPhotoAlbum * album = [YGPhotoAlbum new];
        PHFetchResult * res = [PHAsset fetchAssetsInAssetCollection:col options:nil];
        if (res.count != 0) {
            album.resource = res;
            album.title = col.localizedTitle;
            album.count = res.count;
            [albums addObject:album];
        }
    }];
    NSLog(@"相册个数:%lu",(unsigned long)albums.count);
    return albums.copy;
}

- (void)fetchImageWithAlbum:(YGPhotoAlbum *)album completion:(void (^)(UIImage *image))completion {
    PHAsset * asset = [album.resource lastObject];
//    if (!self.sortAscendingByModificationDate) {
//        asset = [model.result firstObject];
//    }
    [[YGPhotoManager manager] fetchPhotoWithAsset:asset photoWidth:80 completion:^(UIImage *image, NSDictionary *info) {
        if (completion) {
            completion(image);
        }
    }];
}

- (void)fetchPhotoDataWithAsset:(PHAsset *)asset completion:(void (^)(NSData *imageData, NSDictionary *info))completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    option.version = PHImageRequestOptionsVersionOriginal;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && imageData) {
            if (completion) completion(imageData,info);
        }
    }];
}

- (void)fetchPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *image, NSDictionary *info))completion {
    CGFloat fullScreenWidth = _kScreenWidth;
    if (fullScreenWidth > _maxPreviewPhotoWidth) {
        fullScreenWidth = _maxPreviewPhotoWidth;
    }
    return [self fetchPhotoWithAsset:asset photoWidth:fullScreenWidth comletion:completion netWorkAllowed:YES];
}

- (void)fetchPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *image, NSDictionary *info))completion {
    [self fetchPhotoWithAsset:asset photoWidth:photoWidth comletion:completion netWorkAllowed:YES];
}

- (void)fetchPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth comletion:(void(^)(UIImage *image,NSDictionary *info))completion netWorkAllowed:(BOOL)netWorkAllowed {
    CGSize imageSize;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat itemWH = (screenWidth - (5 * 5)) / 4.0f;
    CGSize assetSize = CGSizeMake(itemWH * _kScreenScale, itemWH * _kScreenScale);
    if (photoWidth < _kScreenWidth && photoWidth < _maxPreviewPhotoWidth) {
        imageSize = assetSize;
    } else {
        PHAsset *phAsset = asset;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        CGFloat pixelWidth = photoWidth * _kScreenScale * 1.5;
        // 超宽图片
        if (aspectRatio > 1.8) {
            pixelWidth = pixelWidth * aspectRatio;
        }
        // 超高图片
        if (aspectRatio < 0.2) {
            pixelWidth = pixelWidth * 0.5;
        }
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        imageSize = CGSizeMake(pixelWidth, pixelHeight);
    }

    __block UIImage *image;
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info) {
        if (result) {
            image = result;
        }
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            //result = [self fixOrientation:result];
            if (completion) completion(result,info);
        }
        // Download image from iCloud / 从iCloud下载图片
        if ([info objectForKey:PHImageResultIsInCloudKey] && !result && netWorkAllowed) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (progressHandler) {
//                        progressHandler(progress, error, stop, info);
//                    }
                });
            };
            options.networkAccessAllowed = YES;
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                resultImage = [UIImage hyg_image:resultImage fillSize:imageSize];
                if (!resultImage) {
                    resultImage = image;
                }
                //resultImage = [self fixOrientation:resultImage];
                if (completion) completion(resultImage,info);
            }];
        }
    }];
}

- (void)fetchAssetsFromResult:(PHFetchResult *)result completion:(void (^)(NSArray<YGPhotoAsset *> *))completion {
    if (!result || result.count == 0) return;
    NSMutableArray * array = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset * asset = (PHAsset *)obj;
        YGPhotoAsset * assetModel = [self getYGAssetWithPHAsset:asset];
        [array addObject:assetModel];
    }];
    if (completion) {
        completion(array.copy);
    }
}

- (void)fetchVideoWithAsset:(PHAsset *)asset completion:(void (^)(AVPlayerItem *, NSDictionary *))completion {
    PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    option.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            if (progressHandler) {
//                progressHandler(progress, error, stop, info);
//            }
        });
    };
    [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:option resultHandler:^(AVPlayerItem *playerItem, NSDictionary *info) {
        if (completion) completion(playerItem,info);
    }];
}

- (void)getVideoOutputPathWithAsset:(PHAsset *)asset presetName:(NSString *)presetName success:(void (^)(NSString *outputPath))success failure:(void (^)(NSString *errorMessage, NSError *error))failure {
    PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
        // NSLog(@"Info:\n%@",info);
        AVURLAsset *videoAsset = (AVURLAsset*)avasset;
        // NSLog(@"AVAsset URL: %@",myAsset.URL);
        [self startExportVideoWithVideoAsset:videoAsset presetName:presetName success:success failure:failure];
    }];
}

- (void)startExportVideoWithVideoAsset:(AVURLAsset *)videoAsset presetName:(NSString *)presetName success:(void (^)(NSString *outputPath))success failure:(void (^)(NSString *errorMessage, NSError *error))failure {
    // Find compatible presets by video asset.
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];

    // Begin to compress video
    // Now we just compress to low resolution if it supports
    // If you need to upload to the server, but server does't support to upload by streaming,
    // You can compress the resolution to lower. Or you can support more higher resolution.
    if ([presets containsObject:presetName]) {
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:presetName];

        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss-SSS"];
        NSString *outputPath = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
        // NSLog(@"video outputPath = %@",outputPath);
        session.outputURL = [NSURL fileURLWithPath:outputPath];

        // Optimize for network use.
        session.shouldOptimizeForNetworkUse = true;

        NSArray *supportedTypeArray = session.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            session.outputFileType = AVFileTypeMPEG4;
        } else if (supportedTypeArray.count == 0) {
            if (failure) {
                failure(@"该视频类型暂不支持导出", nil);
            }
            NSLog(@"No supported file types 视频类型暂不支持导出");
            return;
        } else {
            session.outputFileType = [supportedTypeArray objectAtIndex:0];
        }

        if (![[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"]]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"] withIntermediateDirectories:YES attributes:nil error:nil];
        }

//        AVMutableVideoComposition *videoComposition = [self fixedCompositionWithAsset:videoAsset];
//        if (videoComposition.renderSize.width) {
//            // 修正视频转向
//            session.videoComposition = videoComposition;
//        }

        // Begin to export video to the output path asynchronously.
        [session exportAsynchronouslyWithCompletionHandler:^(void) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (session.status) {
                    case AVAssetExportSessionStatusUnknown: {
                        NSLog(@"AVAssetExportSessionStatusUnknown");
                    }  break;
                    case AVAssetExportSessionStatusWaiting: {
                        NSLog(@"AVAssetExportSessionStatusWaiting");
                    }  break;
                    case AVAssetExportSessionStatusExporting: {
                        NSLog(@"AVAssetExportSessionStatusExporting");
                    }  break;
                    case AVAssetExportSessionStatusCompleted: {
                        NSLog(@"AVAssetExportSessionStatusCompleted");
                        if (success) {
                            success(outputPath);
                        }
                    }  break;
                    case AVAssetExportSessionStatusFailed: {
                        NSLog(@"AVAssetExportSessionStatusFailed");
                        if (failure) {
                            failure(@"视频导出失败", session.error);
                        }
                    }  break;
                    case AVAssetExportSessionStatusCancelled: {
                        NSLog(@"AVAssetExportSessionStatusCancelled");
                        if (failure) {
                            failure(@"导出任务已被取消", nil);
                        }
                    }  break;
                    default: break;
                }
            });
        }];
    } else {
        if (failure) {
            NSString *errorMessage = [NSString stringWithFormat:@"当前设备不支持该预设:%@", presetName];
            failure(errorMessage, nil);
        }
    }
}

- (YGPhotoAssetType)getTypeWithAsset:(PHAsset *)asset {
    if (!asset) return YGPhotoAssetTypeUnknow;
    YGPhotoAssetType type = YGPhotoAssetTypeUnknow;
    switch (asset.mediaType) {
        case PHAssetMediaTypeImage:
            // Gif
            if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                type = YGPhotoAssetTypeGIF;
            }else {
                type = YGPhotoAssetTypeImage;
            }
            break;
        case PHAssetMediaTypeVideo:
            type = YGPhotoAssetTypeVideo;
            break;
        case PHAssetMediaTypeAudio:
            type = YGPhotoAssetTypeAudio;
            break;
        case PHAssetMediaTypeUnknown:
            type = YGPhotoAssetTypeUnknow;
            break;

        default:
            break;
    }
    return type;
}

- (YGPhotoAsset *)getYGAssetWithPHAsset:(PHAsset *)asset {
    if (!asset) return nil;
    YGPhotoAsset * assetModel = [YGPhotoAsset new];
    assetModel.type = [self getTypeWithAsset:asset];
    assetModel.asset = asset;
    return assetModel;
}

@end
