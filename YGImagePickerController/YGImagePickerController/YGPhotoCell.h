//
//  YGPhotoCell.h
//  YGMediaTool
//
//  Created by HYG on 2018/3/30.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGPhotoAsset;
typedef void (^SelectBlock)(BOOL isSelected,UIButton *seleBtn);
@interface YGPhotoCell : UICollectionViewCell
@property (nonatomic,strong) YGPhotoAsset * assetModel;
@property (nonatomic,copy) SelectBlock selectAction;
@end
