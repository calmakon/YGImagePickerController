//
//  YGPhotoPreviewController.m
//  YGMediaTool
//
//  Created by HYG on 2018/4/2.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import "YGPhotoPreviewController.h"
#import "YGPhotoConfig.h"
#import "YGPreviewView.h"
@interface YGPhotoPreviewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    NSInteger _currentIndex;
    NSArray <YGPhotoAsset *>*_photos;
    BOOL _isShowBar;
}
@property (nonatomic,strong) UICollectionView * collectionView;
@end

@implementation YGPhotoPreviewController

- (instancetype)initWithPhotos:(NSArray *)photos currentIndex:(NSInteger)currentIndex {
    self = [super init];
    _photos = photos;
    _currentIndex = currentIndex;
    _isShowBar = YES;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(self.view.width + 20, self.view.height);

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, self.view.width + 20, self.view.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.contentSize = CGSizeMake(_photos.count * (self.view.width + 20), 0);
    [self.view addSubview:_collectionView];

    if (@available (iOS 11, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    [_collectionView registerClass:[YGPreviewView class] forCellWithReuseIdentifier:NSStringFromClass([YGPreviewView class])];

    if (_currentIndex) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YGPreviewView * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YGPreviewView class]) forIndexPath:indexPath];
    cell.assetModel = _photos[indexPath.row];
    cell.controller = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

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
