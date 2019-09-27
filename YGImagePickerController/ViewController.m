//
//  ViewController.m
//  YGImagePickerController
//
//  Created by HYG on 2018/6/6.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import "ViewController.h"
#import "YGImagePickerController.h"
#import "YGVideoPlayerController.h"
#import "YGPhotoPreviewController.h"
#import "HYGUIKit.h"
#import "YGSelectedView.h"
#import "YGPhotoManager.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView * _collectionView;
    NSArray * _selectAssets;
    NSArray * _selectPhotos;
    NSArray * _selectInfos;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self layoutViews];

    NSLog(@"添加一行打印");
    NSLog(@"添加第二行打印");

    NSLog(@"bugfix");
}

- (void)layoutViews {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 44);
    button.center = CGPointMake(self.view.center.x, self.view.bounds.size.height - 64);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"选择照片" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(presentImagePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];


    CGFloat width = 200.0f;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake(width, width * 1.3);
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 5, 0);

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 90, self.view.bounds.size.width, width * 1.3) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];

    [_collectionView registerClass:[YGSelectedView class] forCellWithReuseIdentifier:NSStringFromClass([YGSelectedView class])];
}

- (void)presentImagePicker {
    YGImagePickerController * picker = [YGImagePickerController new];
    picker.barBgColor = [UIColor redColor];
    picker.barTitleColor = [UIColor whiteColor];
    picker.barTitleFont = [UIFont systemFontOfSize:18];
    picker.maxSelectedCount = 4;
    [self presentViewController:picker animated:YES completion:nil];

    //选择照片
    [picker setDidSelectedPhotos:^(NSArray *photos, NSArray *infos, NSArray *assets) {
        NSLog(@"已选择：%@-----：%@-----：%@",photos,infos,assets);
        self->_selectAssets = assets;
        self->_selectInfos = infos;
        self->_selectPhotos = photos;
        [self->_collectionView reloadData];
    }];

    //选择视频
    [picker setDidSelectedVideo:^(UIImage *cover, id asset) {
        NSLog(@"已选择：%@-----：%@",cover,asset);
        PHAsset * ass = (PHAsset *)asset;
        self->_selectAssets = @[ass];
        [self->_collectionView reloadData];
    }];

    //选择GIF
    [picker setDidSelectedGifImage:^(UIImage *gifImage, id asset) {
        NSLog(@"已选择：%@-----：%@",gifImage,asset);
        PHAsset * ass = (PHAsset *)asset;
        self->_selectAssets = @[ass];
        [self->_collectionView reloadData];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YGSelectedView * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YGSelectedView class]) forIndexPath:indexPath];
    cell.image = _selectPhotos[indexPath.item];
    cell.assetModel = _selectAssets[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YGPhotoAsset * model = [[YGPhotoManager manager] getYGAssetWithPHAsset:_selectAssets[indexPath.item]];
    if (model.type == YGPhotoAssetTypeVideo) {
        YGVideoPlayerController * player = [[YGVideoPlayerController alloc] initWithAsset:model];
        player.isPreview = YES;
        [self.navigationController pushViewController:player animated:YES];
    }
    if (model.type == YGPhotoAssetTypeImage ||
        model.type == YGPhotoAssetTypeGIF) {
        YGPhotoPreviewController * preview = [[YGPhotoPreviewController alloc] initWithPhotos:_selectAssets currentIndex:indexPath.item];
        [self.navigationController pushViewController:preview animated:YES];
        NSLog(@"跳转");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
