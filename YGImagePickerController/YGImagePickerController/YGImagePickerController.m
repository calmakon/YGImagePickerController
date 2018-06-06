//
//  YGImagePickerController.m
//  YGMediaTool
//
//  Created by HYG on 2018/4/2.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import "YGImagePickerController.h"
#import "YGAlbumListController.h"
#import "YGPhotoConfig.h"
@interface YGImagePickerController ()

@end

@implementation YGImagePickerController

- (instancetype)init {
    YGAlbumListController * list = [YGAlbumListController new];
    self = [super initWithRootViewController:list];
    [self configDefualt];
    if (![[YGPhotoManager manager] isAuthorizationAvailable]) {
        [[YGPhotoManager manager] requestAuthorizationCompletion:^(NSUInteger status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [list refreshDatas];
            }
        }];
    }
    return self;
}

- (void)configDefualt {
    self.photoWidth = 828.0f;
    self.maxPreviewPhotoWidth = 600.0f;
    self.maxSelectedCount = 9;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.translucent = YES;

    UIBarButtonItem *barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[YGImagePickerController class]]];

    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [barItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
}

- (void)setBarBgColor:(UIColor *)barBgColor {
    _barBgColor = barBgColor;
    self.navigationBar.barTintColor = barBgColor;
}

- (void)setBarTitleColor:(UIColor *)barTitleColor {
    _barTitleColor = barTitleColor;
    [self reSetNaviTextAppearance];
}

- (void)setBarTitleFont:(UIFont *)barTitleFont {
    _barTitleFont = barTitleFont;
    [self reSetNaviTextAppearance];
}

- (void)setBarButtonItemTextColor:(UIColor *)barButtonItemTextColor {
    _barButtonItemTextColor = barButtonItemTextColor;
    [self reSetBarButtonItemAppearance];
}

- (void)setBarButtonItemTextFont:(UIColor *)barButtonItemTextFont {
    _barButtonItemTextFont = barButtonItemTextFont;
    [self reSetBarButtonItemAppearance];
}

- (void)reSetBarButtonItemAppearance {
    UIBarButtonItem * item = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[YGAlbumListController class]]];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = _barButtonItemTextColor;
    attrs[NSFontAttributeName] = _barButtonItemTextFont;
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    self.navigationBar.tintColor = _barButtonItemTextColor;
}

- (void)reSetNaviTextAppearance {
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    if (_barTitleColor) {
        textAttrs[NSForegroundColorAttributeName] = _barTitleColor;
    }
    if (_barTitleFont) {
        textAttrs[NSFontAttributeName] = _barTitleFont;
    }
    self.navigationBar.titleTextAttributes = textAttrs;
}

- (void)setPhotoWidth:(CGFloat)photoWidth {
    _photoWidth = photoWidth;
    [YGPhotoManager manager].photoWidth = _photoWidth;
}

- (void)setMaxPreviewPhotoWidth:(CGFloat)maxPreviewPhotoWidth {
    _maxPreviewPhotoWidth = maxPreviewPhotoWidth;
    if (maxPreviewPhotoWidth > 800) {
        _maxPreviewPhotoWidth = 800;
    }else if (maxPreviewPhotoWidth < 500) {
        _maxPreviewPhotoWidth = 500;
    }
    [YGPhotoManager manager].maxPreviewPhotoWidth = _maxPreviewPhotoWidth;
}

- (void)setMaxSelectedCount:(NSUInteger)maxSelectedCount {
    _maxSelectedCount = maxSelectedCount;
    if (maxSelectedCount <= 0) {
        _maxSelectedCount = 1;
    }
}

- (void)dealloc {
    NSLog(@"%@控制器销毁",[self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
