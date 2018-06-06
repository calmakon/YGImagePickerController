//
//  YGPhotoAlbum.h
//  YGMediaTool
//
//  Created by HYG on 2018/3/30.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PHFetchResult;
@interface YGPhotoAlbum : NSObject
@property (nonatomic,copy) NSString * title;
@property (nonatomic,assign) NSUInteger count;
@property (nonatomic,strong) PHFetchResult * resource;
@end
