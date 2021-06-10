//
//  YGPhotoBottomBar.m
//  YGMediaTool
//
//  Created by HYG on 2018/4/9.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import "YGPhotoBottomBar.h"
#import "UIView+HYGExtension.h"

#define kAnimateDuration 0.2f
#define kAnimatedScale 1.2f
#define kAnimatedSmallScale 0.9f

//iPhone屏幕适配
// X/XS/11Pro
#define DEVICE_IS_IPHONEX ([[UIScreen mainScreen] bounds].size.height == 812)
// XR/11(11、11Pro Max)
#define DEVICE_IS_IPHONEXR ([[UIScreen mainScreen] bounds].size.height == 896)
// 12系列
// 12/12Pro
#define DEVICE_IS_IPHONE12 ([[UIScreen mainScreen] bounds].size.height == 844)
// 12mini
#define DEVICE_IS_IPHONE12MINI ([[UIScreen mainScreen] bounds].size.height == 780)
// 12Pro Max
#define DEVICE_IS_IPHONE12PROMAX ([[UIScreen mainScreen] bounds].size.height == 926)

#define DEVICE_IS_X (DEVICE_IS_IPHONEX || DEVICE_IS_IPHONEXR || DEVICE_IS_IPHONE12 || DEVICE_IS_IPHONE12MINI || DEVICE_IS_IPHONE12PROMAX)

@interface YGPhotoBottomBar ()
@property (nonatomic,strong) UIButton * previewButton;
@property (nonatomic,strong) UIButton * confirmButton;
@end

@implementation YGPhotoBottomBar

- (instancetype)initWithCollection:(BOOL)isCollection {
    self = [super init];
    CGFloat barHeight = DEVICE_IS_X?83:49;
    self.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, barHeight);
    CALayer * topLine = [[CALayer alloc] init];
    topLine.frame = CGRectMake(0, 0, self.width, 1);
    [self.layer addSublayer:topLine];
    if (isCollection) {
        self.backgroundColor = [UIColor whiteColor];
        topLine.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1].CGColor;
    }else {
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        topLine.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8].CGColor;
    }

    CGFloat buttonHeight = 49;
    _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _previewButton.size = CGSizeMake(50, buttonHeight);
    _previewButton.left = 15;
    _previewButton.top = 0;
    [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
    _previewButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    _previewButton.enabled = NO;
    [_previewButton addTarget:self action:@selector(previewClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_previewButton];

    CGFloat confirmButtonHeight = 30;
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.size = CGSizeMake(60, confirmButtonHeight);
    _confirmButton.right = self.width - 15;
    _confirmButton.top = 10;
    _confirmButton.layer.cornerRadius = 5;
    _confirmButton.backgroundColor = [UIColor colorWithRed:0.46 green:0.77 blue:0.44 alpha:1];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateDisabled];
    [_confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton.enabled = NO;
    [self addSubview:_confirmButton];
    return self;
}

- (void)setAssetType:(YGPhotoAssetType)assetType {
    _assetType = assetType;
    if (assetType == YGPhotoAssetTypeVideo) {
        _previewButton.hidden = YES;
        _confirmButton.enabled = YES;
    }else if (assetType == YGPhotoAssetTypeImage || YGPhotoAssetTypeGIF) {
        _previewButton.hidden = NO;
    }
}

- (void)updateSelectedNum:(NSInteger)num {
    if (num > 0) {
        _previewButton.enabled = YES;
        _confirmButton.enabled = YES;
        _confirmButton.backgroundColor = [UIColor colorWithRed:0.24 green:0.65 blue:0.32 alpha:1];
        NSString *title = [NSString stringWithFormat:@"确定(%ld)",(long)num];
        CGFloat width = [title boundingRectWithSize:CGSizeMake(70, _confirmButton.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_confirmButton.titleLabel.font} context:nil].size.width;
        _confirmButton.width = width + 15;
        _confirmButton.right = self.width - 15;
        [_confirmButton setTitle:title forState:UIControlStateNormal];
    }else {
        _previewButton.enabled = NO;
        _confirmButton.enabled = NO;
        _confirmButton.backgroundColor = [UIColor colorWithRed:0.46 green:0.77 blue:0.44 alpha:1];
        _confirmButton.width = 60;
        _confirmButton.right = self.width - 15;
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    }
}

- (void)animatedView:(UIView *)view {
    [UIView animateWithDuration:kAnimateDuration animations:^{
        view.transform = CGAffineTransformMakeScale(kAnimatedScale, kAnimatedScale);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kAnimateDuration animations:^{
            view.transform = CGAffineTransformMakeScale(kAnimatedSmallScale, kAnimatedSmallScale);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:kAnimateDuration animations:^{
                view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }];
    }];
}

- (void)previewClick {
    if (self.previewBlock) {
        self.previewBlock();
    }
}

- (void)confirmClick {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

@end
