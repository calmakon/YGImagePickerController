//
//  YGPhotoBottomBar.m
//  YGMediaTool
//
//  Created by HYG on 2018/4/9.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import "YGPhotoBottomBar.h"
#import "extension/UIView+HYGExtension.h"

#define kAnimateDuration 0.2f
#define kAnimatedScale 1.2f
#define kAnimatedSmallScale 0.9f

@interface YGPhotoBottomBar ()
@property (nonatomic,strong) UIButton * previewButton;
@property (nonatomic,strong) UILabel * numLabel;
@property (nonatomic,strong) UIButton * confirmButton;
@end

@implementation YGPhotoBottomBar

- (instancetype)initWithCollection:(BOOL)isCollection {
    self = [super init];
    self.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 44);
    if (isCollection) {
        self.backgroundColor = [UIColor whiteColor];
        CALayer * topLine = [[CALayer alloc] init];
        topLine.frame = CGRectMake(0, 0, self.width, 1);
        topLine.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1].CGColor;
        [self.layer addSublayer:topLine];
    }else {
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        CALayer * topLine = [[CALayer alloc] init];
        topLine.frame = CGRectMake(0, 0, self.width, 1);
        topLine.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8].CGColor;
        [self.layer addSublayer:topLine];
    }

    _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _previewButton.size = CGSizeMake(50, self.height);
    _previewButton.left = 0;
    _previewButton.top = 0;
    [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
    _previewButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    _previewButton.enabled = NO;
    [_previewButton addTarget:self action:@selector(previewClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_previewButton];

    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.size = CGSizeMake(50, self.height);
    _confirmButton.right = self.width;
    _confirmButton.top = 0;
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_confirmButton setTitleColor:[UIColor colorWithRed:0.24 green:0.65 blue:0.32 alpha:1] forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor colorWithRed:0.46 green:0.77 blue:0.44 alpha:1] forState:UIControlStateDisabled];
    [_confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton.enabled = NO;
    [self addSubview:_confirmButton];

    _numLabel = [UILabel new];
    _numLabel.size = CGSizeMake(22, 22);
    _numLabel.centerY = self.height / 2.0f;
    _numLabel.right = _confirmButton.left;
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.textColor = [UIColor whiteColor];
    _numLabel.backgroundColor = [UIColor colorWithRed:0.24 green:0.65 blue:0.32 alpha:1];
    _numLabel.font = [UIFont systemFontOfSize:14];
    _numLabel.layer.cornerRadius = _numLabel.height / 2.0f;
    _numLabel.layer.masksToBounds = YES;
    _numLabel.hidden = YES;
    [self addSubview:_numLabel];
    return self;
}

- (void)setAssetType:(YGPhotoAssetType)assetType {
    _assetType = assetType;
    if (assetType == YGPhotoAssetTypeVideo) {
        _previewButton.hidden = YES;
        _numLabel.hidden = YES;
        _confirmButton.enabled = YES;
    }else if (assetType == YGPhotoAssetTypeImage || YGPhotoAssetTypeGIF) {
        _previewButton.hidden = NO;
        _numLabel.hidden = NO;
    }
}

- (void)updateSelectedNum:(NSInteger)num {
    if (num > 0) {
        _numLabel.hidden = NO;
        _previewButton.enabled = YES;
        _confirmButton.enabled = YES;
        _numLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
        [self animatedView:_numLabel];
    }else {
        _numLabel.hidden = YES;
        _previewButton.enabled = NO;
        _confirmButton.enabled = NO;
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
