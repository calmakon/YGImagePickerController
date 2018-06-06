//
//  YGSelectedView.m
//  YGMediaTool
//
//  Created by HYG on 2018/4/21.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import "YGSelectedView.h"
#import "YGPhotoConfig.h"

@interface YGSelectedView ()
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UIView * typeView;
@property (nonatomic,strong) UILabel * typeLabel;
@end

@implementation YGSelectedView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _imageView = [UIImageView new];
    _imageView.frame = self.bounds;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    [self addSubview:_imageView];

    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
}

- (void)setAssetModel:(id)assetModel {
    _assetModel = assetModel;
    PHAsset * asset = nil;
    YGPhotoAssetType type = YGPhotoAssetTypeUnknow;
    if ([assetModel isKindOfClass:[YGPhotoAsset class]]) {
        asset = [(YGPhotoAsset *)assetModel asset];
        type = [(YGPhotoAsset *)assetModel type];
    }
    if ([assetModel isKindOfClass:[PHAsset class]]) {
        asset = (PHAsset *)assetModel;
        type = [[YGPhotoManager manager] getTypeWithAsset:asset];
    }
    if (!_image) {
        [[YGPhotoManager manager] fetchPhotoWithAsset:asset photoWidth:_imageView.width completion:^(UIImage *image, NSDictionary *info) {
            if (image) {
                self->_imageView.image = image;
            }
        }];
    }
    [self addTypeViewWithType:type];

    if (type == YGPhotoAssetTypeGIF) {
        _typeLabel.text = @"GIF";
    }
    if (type == YGPhotoAssetTypeVideo) {
        _typeLabel.text = [self formatTimeInterval:asset.duration];
    }

    BOOL showTypeView = NO;
    if (type == YGPhotoAssetTypeImage || type == YGPhotoAssetTypeUnknow) {
        showTypeView = NO;
    }else {
        showTypeView = YES;
    }
    if (_typeView) {
        _typeView.hidden = !showTypeView;
    }
}

- (void)addTypeViewWithType:(YGPhotoAssetType)type {
    if (_typeView) {
        return;
    }
    if (type == YGPhotoAssetTypeImage) {
        return;
    }
    UIView * typeView = [HYGUIKit viewWithBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    typeView.size = CGSizeMake(self.width, 20);
    typeView.left = 0;
    typeView.bottom = self.height;
    [self addSubview:typeView];
    _typeView = typeView;

    UILabel * label = [HYGUIKit labelWithFont:[UIFont systemFontOfSize:13] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter numberOfLines:1 text:@""];
    label.frame = typeView.bounds;
    [typeView addSubview:label];
    _typeLabel = label;
}

- (NSString*)formatTimeInterval:(NSTimeInterval)interval {
    NSUInteger totalMinutes = (NSUInteger)interval / 60;
    NSUInteger leftSeconds  = (NSUInteger)interval % 60;

    NSUInteger totalHours   = totalMinutes / 60;
    NSUInteger leftMinutes  = totalMinutes % 60;

    NSMutableString* string = [NSMutableString string];
    if (totalHours != 0) {
        [string appendFormat:@"%lu:", (unsigned long)totalHours];
    }

    if (totalMinutes != 0) {
        [string appendFormat:@"%02lu:", (unsigned long)leftMinutes];
    } else {
        [string appendString:@"00:"];
    }

    [string appendFormat:@"%02lu", (unsigned long)leftSeconds];

    return string;
}

@end
