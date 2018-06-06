//
//  YGGifPreviewController.m
//  YGMediaTool
//
//  Created by HYG on 2018/6/6.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import "YGGifPreviewController.h"
#import "YGPhotoConfig.h"
#import "YGImagePickerController.h"
#import "YGPreviewView.h"
@interface YGGifPreviewController ()
@property (nonatomic,strong) YGPhotoAsset * assetModel;
@property (nonatomic,strong) YGPhotoBottomBar * bottomBar;
@property (nonatomic,strong) YGPreviewView * previewView;
@end

@implementation YGGifPreviewController

- (instancetype)initWithAssetModel:(YGPhotoAsset *)assetModel {
    self = [super init];
    _assetModel = assetModel;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self configPreviewView];

    _previewView.assetModel = _assetModel;
}

- (void)configPreviewView {
    _previewView = [[YGPreviewView alloc] initWithFrame:self.view.bounds];
    _previewView.controller = self;
    [self.view addSubview:_previewView];

    if (self.isPreview)return;

    _bottomBar = [[YGPhotoBottomBar alloc] initWithCollection:NO];
    _bottomBar.assetType = YGPhotoAssetTypeVideo;
    _bottomBar.bottom = self.view.height;
    _bottomBar.left = 0;
    [self.view addSubview:_bottomBar];

    __weak typeof(self) weakSelf = self;
    __weak typeof(_previewView) weakView = _previewView;
    [_bottomBar setConfirmBlock:^{
        YGImagePickerController * picker = (YGImagePickerController *)weakSelf.navigationController;
        [picker dismissViewControllerAnimated:YES completion:^{
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            if (picker.didSelectedGifImage) {
                picker.didSelectedGifImage(weakView.gifImage, weakSelf.assetModel.asset);
            }
        }];
    }];
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
