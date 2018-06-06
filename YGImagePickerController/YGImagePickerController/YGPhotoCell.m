//
//  YGPhotoCell.m
//  YGMediaTool
//
//  Created by HYG on 2018/3/30.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import "YGPhotoCell.h"
#import "YGPhotoConfig.h"
@interface YGPhotoCell ()
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UIView * typeView;
@property (nonatomic,strong) UILabel * typeLabel;
@property (nonatomic,strong) UIButton * selectButton;
@end

@implementation YGPhotoCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _imageView = [UIImageView new];
    _imageView.frame = self.bounds;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    [self addSubview:_imageView];
    

    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectButton setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    _selectButton.size = CGSizeMake(30, 30);
    _selectButton.top = 0;
    _selectButton.right = _imageView.width;
    [_imageView addSubview:_selectButton];
    [_selectButton addTarget:self action:@selector(selectedAction) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void)selectedAction {
    if (self.selectAction) {
        self.selectAction(_selectButton.selected,_selectButton);
    }
}

- (void)setAssetModel:(YGPhotoAsset *)assetModel {
    _assetModel = assetModel;
    [[YGPhotoManager manager] fetchPhotoWithAsset:assetModel.asset photoWidth:_imageView.width completion:^(UIImage *image, NSDictionary *info) {
        if (image) {
            _imageView.image = image;
        }
    }];
    [self addTypeViewWithType:assetModel.type];

    if (assetModel.type == YGPhotoAssetTypeGIF || assetModel.type == YGPhotoAssetTypeVideo) {
        if (assetModel.type == YGPhotoAssetTypeGIF) {
            _typeLabel.text = @"GIF";
        }
        if (assetModel.type == YGPhotoAssetTypeVideo) {
            _typeLabel.text = [self formatTimeInterval:_assetModel.asset.duration];
        }
        _selectButton.hidden = YES;
    }else {
        _selectButton.hidden = NO;
    }

    BOOL showTypeView = NO;
    if (assetModel.type == YGPhotoAssetTypeImage || assetModel.type == YGPhotoAssetTypeUnknow) {
        showTypeView = NO;
    }else {
        showTypeView = YES;
    }
    if (_typeView) {
        _typeView.hidden = !showTypeView;
    }
    _selectButton.selected = assetModel.isSelected;
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
