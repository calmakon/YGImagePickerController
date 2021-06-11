//
//  YGPhotoPickerController.m
//  YGMediaTool
//
//  Created by HYG on 2018/4/2.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import "YGPhotoPickerController.h"
#import "YGPhotoCell.h"
#import "UIImage+HYGExtension.h"
#import "YGPhotoConfig.h"
#import "YGVideoPlayerController.h"
#import "YGPhotoPreviewController.h"
#import "YGGifPreviewController.h"
#import "YGPhotoBottomBar.h"
#import "YGImagePickerController.h"
@interface YGPhotoPickerController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray <YGPhotoAsset *>*_selectedPhotos;
}
@property (nonatomic,strong) YGPhotoAlbum * album;
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) YGPhotoBottomBar * bottomBar;
@property (nonatomic,copy) NSArray * datas;

@end

@implementation YGPhotoPickerController
- (instancetype)initWithAlbum:(YGPhotoAlbum *)album {
    self = [super init];
    _album = album;
    [[YGPhotoManager manager] fetchAssetsFromResult:album.resource completion:^(NSArray<YGPhotoAsset *> *assets) {
        if (assets) {
            self->_datas = assets;
            self->_selectedPhotos = [NSMutableArray array];
        }
    }];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _album.title;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [HYGUIKit dynamicColorLight:[UIColor whiteColor] dark:[UIColor blackColor]]?:[UIColor whiteColor];

    [self layoutViews];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self->_collectionView.contentSize.height > self.view.height) {
            [self->_collectionView setContentOffset:CGPointMake(0, self->_collectionView.contentSize.height - self->_collectionView.frame.size.height) animated:NO];
        }
    });
}

- (void)layoutViews {
    UIBarButtonItem * cancleItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissVc)];
    self.navigationItem.rightBarButtonItem = cancleItem;

    CGFloat width = (self.view.width - (5 * 5)) / 4.0f;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake(width, width);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 44) collectionViewLayout:layout];
    _collectionView.backgroundColor = self.view.backgroundColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];

    [_collectionView registerClass:[YGPhotoCell class] forCellWithReuseIdentifier:NSStringFromClass([YGPhotoCell class])];

    _bottomBar = [[YGPhotoBottomBar alloc] initWithCollection:YES];
    _bottomBar.bottom = self.view.height;
    _bottomBar.left = 0;
    [self.view addSubview:_bottomBar];

    //预览
    __weak typeof(self) weakSelf = self;
    __weak typeof(_selectedPhotos) weakSelectPhotos = _selectedPhotos;
    [_bottomBar setPreviewBlock:^{
        YGPhotoPreviewController * preview = [[YGPhotoPreviewController alloc] initWithPhotos:weakSelectPhotos currentIndex:0];
        [weakSelf.navigationController pushViewController:preview animated:YES];
    }];
    //确定已选的图片
    [_bottomBar setConfirmBlock:^{
        YGImagePickerController * picker = (YGImagePickerController *)weakSelf.navigationController;
        NSMutableArray * assets = [NSMutableArray array];
        NSMutableArray * photos = [NSMutableArray array];
        NSMutableArray * infos = [NSMutableArray array];
        for (NSInteger i = 0; i < weakSelectPhotos.count; i++) {
            [photos addObject:@1];
            [assets addObject:@1];
            [infos addObject:@1];
        }
        for (int i = 0; i < weakSelectPhotos.count; i++) {
            YGPhotoAsset * model = weakSelectPhotos[i];
            [[YGPhotoManager manager] fetchPhotoWithAsset:model.asset completion:^(UIImage *image, NSDictionary *info) {
                if (image) {
                    image = [image yg_imageScale:image size:CGSizeMake(picker.photoWidth, (int)(picker.photoWidth * image.size.height / image.size.width))];
                    [photos replaceObjectAtIndex:i withObject:image];
                }
                if (info) {
                    [infos replaceObjectAtIndex:i withObject:info];
                }
                [assets replaceObjectAtIndex:i withObject:model.asset];

                for (id item in photos) {
                    if ([item isKindOfClass:[NSNumber class]]) {
                        return;
                    }
                }
            }];
        }
        [picker dismissViewControllerAnimated:YES completion:^{
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            if (picker.didSelectedPhotos) {
                picker.didSelectedPhotos(photos.copy, infos.copy, assets.copy);
            }
        }];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YGPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YGPhotoCell class]) forIndexPath:indexPath];
    YGPhotoAsset * assetModel = _datas[indexPath.item];
    //cell.assetModel = _datas[indexPath.row];

    __weak typeof(self) weakSelf = self;
    __weak typeof(_selectedPhotos) weakSelectPhotos = _selectedPhotos;
    YGImagePickerController * picker = (YGImagePickerController *)self.navigationController;
    [cell setSelectAction:^(BOOL isSelected,UIButton *seleBtn) {
        if (isSelected) {
            seleBtn.selected = NO;
            assetModel.selected = NO;
            [weakSelectPhotos removeObject:assetModel];
        }else {
            if (weakSelectPhotos.count < picker.maxSelectedCount) {
                seleBtn.selected = YES;
                assetModel.selected = YES;
                [weakSelectPhotos addObject:assetModel];
            }else {
                //提示
                NSString * msg = [NSString stringWithFormat:@"选择最多不超过%lu张",(unsigned long)picker.maxSelectedCount];
                UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
                [alertVc addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil]];
                [weakSelf.navigationController presentViewController:alertVc animated:YES completion:nil];
                return;
            }
        }
        [weakSelf.bottomBar updateSelectedNum:weakSelectPhotos.count];
    }];
    cell.assetModel = assetModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YGPhotoAsset * model = _datas[indexPath.row];
    if (model.type == YGPhotoAssetTypeVideo) {
        YGVideoPlayerController * player = [[YGVideoPlayerController alloc] initWithAsset:model];
        [self.navigationController pushViewController:player animated:YES];
    }else if (model.type == YGPhotoAssetTypeGIF) {
        YGGifPreviewController * preview = [[YGGifPreviewController alloc] initWithAssetModel:model];
        [self.navigationController pushViewController:preview animated:YES];
    }else if (model.type == YGPhotoAssetTypeImage) {
        YGPhotoPreviewController * preview = [[YGPhotoPreviewController alloc] initWithPhotos:_datas currentIndex:indexPath.item];
        [self.navigationController pushViewController:preview animated:YES];
    }
}

- (void)dismissVc {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.navigationController.viewControllers.count > 0) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }];
}

- (void)dealloc {
    _selectedPhotos = nil;
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
