//
//  YGPreviewView.m
//  YGMediaTool
//
//  Created by HYG on 2018/4/2.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import "YGPreviewView.h"
#import "YGPhotoConfig.h"
#import "HYGUIKit.h"

@implementation UIImage (YG_Gif)
+ (UIImage *)yg_gifImageWithData:(NSData *)imageData {
    if (!imageData) {
        return nil;
    }
    CGImageSourceRef ref = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);

    size_t count = CGImageSourceGetCount(ref);

    UIImage * resImage;
    if (count <= 1) {
        resImage = [UIImage imageWithData:imageData];
    }else {
        CGFloat scale = 1;
        scale = [UIScreen mainScreen].scale;
        NSInteger maxCount = 200;
        NSInteger interval = MAX((count + maxCount / 2) / maxCount, 1);
        NSTimeInterval duration = 0.0f;
        NSMutableArray * imagsArr = [NSMutableArray array];
        for (size_t i = 0; i < count; i+=interval) {
            CGImageRef CGImage = CGImageSourceCreateImageAtIndex(ref, i, NULL);
            if (!CGImage) {
                continue;
            }
            duration += [self sd_frameDurationAtIndex:i source:ref] * MIN(interval, 3);
            UIImage *frameImage = [UIImage imageWithCGImage:CGImage scale:scale orientation:UIImageOrientationUp];
            [imagsArr addObject:frameImage];
            CGImageRelease(CGImage);
        }
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        resImage = [UIImage animatedImageWithImages:imagsArr.copy duration:duration];
    }
    CFRelease(ref);
    return resImage;
}

+ (float)sd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];

    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {

        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }

    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.

    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }

    CFRelease(cfFrameProperties);
    return frameDuration;
}

@end

@implementation UIView (YG_Gif)

- (void)pauseLayer {
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pausedTime;
}

- (void)resumeLayer {
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.speed = 1.0;
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] -    pausedTime;
    self.layer.beginTime = timeSincePause;
}

@end

@interface YGPreviewView ()<UIScrollViewDelegate>
{
    BOOL _isShowBar;
}
@property (nonatomic,strong) UIScrollView * containerView;
@property (nonatomic,strong) UIView * imageContentView;
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong,readwrite) UIImage * gifImage;
@end

@implementation YGPreviewView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor blackColor];
    _isShowBar = NO;

    _containerView = [UIScrollView new];
    _containerView.backgroundColor = [UIColor blackColor];
    _containerView.delegate = self;
    _containerView.showsVerticalScrollIndicator = NO;
    _containerView.showsHorizontalScrollIndicator = NO;
    _containerView.minimumZoomScale = 1.0f;
    _containerView.maximumZoomScale = 2.0f;
    [self addSubview:_containerView];

    if (@available(iOS 11.0, *)) {
        _containerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    _imageContentView = [HYGUIKit viewWithBackgroundColor:[UIColor blackColor]];
    //_imageContentView.frame = _containerView.bounds;
    _imageContentView.clipsToBounds = YES;
    _imageContentView.contentMode = UIViewContentModeScaleAspectFill;
    [_containerView addSubview:_imageContentView];

    _imageView = [HYGUIKit imageViewWithBackgroundColor:[UIColor blackColor] image:nil contentMode:UIViewContentModeScaleAspectFill];
    _imageView.clipsToBounds = YES;
    //_imageView.frame = _imageContentView.bounds;
    [_imageContentView addSubview:_imageView];
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
    return self;
}

- (void)layoutSubviews {
    _containerView.frame = CGRectMake(10, 0, self.width - 20, self.height);

    [_containerView setZoomScale:1.0f animated:NO];
    [self resizeSubviews];
}

- (void)tapClick {
    _controller.navigationController.navigationBar.hidden = !_controller.navigationController.navigationBar.isHidden;
}

- (void)setAssetModel:(id)assetModel {
    _assetModel = assetModel;
    if (_containerView.zoomScale > 1.0f) {
        _containerView.zoomScale = 1.0f;
    }
    PHAsset * asset = nil;
    __block YGPhotoAssetType type = YGPhotoAssetTypeUnknow;
    if ([assetModel isKindOfClass:[YGPhotoAsset class]]) {
        asset = [(YGPhotoAsset *)assetModel asset];
        type = [(YGPhotoAsset *)assetModel type];
    }
    if ([assetModel isKindOfClass:[PHAsset class]]) {
        asset = (PHAsset *)assetModel;
        type = [[YGPhotoManager manager] getTypeWithAsset:asset];
    }
    __weak typeof(self) weakSelf = self;
    [[YGPhotoManager manager] fetchPhotoWithAsset:asset completion:^(UIImage *image, NSDictionary *info) {
        weakSelf.imageView.image = image;
        [weakSelf resizeSubviews];
        if (type == YGPhotoAssetTypeGIF) {
            [[YGPhotoManager manager] fetchPhotoDataWithAsset:asset completion:^(NSData *imageData, NSDictionary *info) {
                weakSelf.imageView.image = [UIImage yg_gifImageWithData:imageData];
                [weakSelf resizeSubviews];
                weakSelf.gifImage = weakSelf.imageView.image;
            }];
        }
    }];
}

- (void)resizeSubviews {
    _imageContentView.origin = CGPointZero;
    _imageContentView.width = self.containerView.width;

    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.height / self.containerView.width) {
        _imageContentView.height = floor(image.size.height / (image.size.width / self.containerView.width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.containerView.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        _imageContentView.height = height;
        _imageContentView.centerY = self.height / 2;
    }
    if (_imageContentView.height > self.height && _imageContentView.height - self.height <= 1) {
        _imageContentView.height = self.height;
    }
    CGFloat contentSizeH = MAX(_imageContentView.height, self.height);
    _containerView.contentSize = CGSizeMake(self.containerView.width, contentSizeH);
    [_containerView scrollRectToVisible:self.bounds animated:NO];
    _imageView.frame = _imageContentView.bounds;
}


#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageContentView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {

}

- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_containerView.width > _containerView.contentSize.width) ? ((_containerView.width - _containerView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_containerView.height > _containerView.contentSize.height) ? ((_containerView.height - _containerView.contentSize.height) * 0.5) : 0.0;
    self.imageContentView.center = CGPointMake(_containerView.contentSize.width * 0.5 + offsetX, _containerView.contentSize.height * 0.5 + offsetY);
}

- (void)dealloc {
    self.gifImage = nil;
    self.imageView = nil;
}

@end
