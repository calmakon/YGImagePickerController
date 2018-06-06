//
//  YGImagePickerController.h
//  YGMediaTool
//
//  Created by HYG on 2018/4/2.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectedBlock)(NSArray *photos,NSArray *infos,NSArray *assets);
typedef void (^DidSelectedVideoBlock)(UIImage *cover,id asset);
typedef void (^DidSelectedGIFImageBlock)(UIImage *gifImage,id asset);
@interface YGImagePickerController : UINavigationController
- (instancetype)init;
@property (nonatomic,strong) UIColor * barBgColor;//导航条背景色
@property (nonatomic,strong) UIColor * barTitleColor;//导航条字体颜色
@property (nonatomic,strong) UIFont * barTitleFont;//导航条字体样式
@property (nonatomic,strong) UIColor * barButtonItemTextColor;//导航按钮字体颜色
@property (nonatomic,strong) UIColor * barButtonItemTextFont;//导航按钮字体样式
@property (nonatomic,assign) NSUInteger maxSelectedCount;//允许最大选择数

@property (nonatomic,assign) CGFloat photoWidth;//导出图片的宽度，默认828像素宽
@property (nonatomic,assign) CGFloat maxPreviewPhotoWidth;//默认600像素宽

//照片、视频、GIF选择回调
@property (nonatomic,copy) DidSelectedBlock didSelectedPhotos;
@property (nonatomic,copy) DidSelectedVideoBlock didSelectedVideo;
@property (nonatomic,copy) DidSelectedGIFImageBlock didSelectedGifImage;
@end
