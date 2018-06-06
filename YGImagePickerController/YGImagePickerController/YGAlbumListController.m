//
//  YGAlbumListController.m
//  YGMediaTool
//
//  Created by HYG on 2018/4/2.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import "YGAlbumListController.h"
#import "YGTableView.h"
#import "YGPhotoConfig.h"
#import "YGAlbumCell.h"
#import "YGPhotoPickerController.h"
@interface YGAlbumListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) YGTableView * tableView;
@property (nonatomic,copy) NSArray * albums;

@end

@implementation YGAlbumListController
- (instancetype)init {
    self = [super init];
    _albums = [[YGPhotoManager manager] fetchAllAlbums];
    return self;
}

- (void)refreshDatas {
    if (!_albums || _albums.count == 0) {
        _albums = [[YGPhotoManager manager] fetchAllAlbums];
    }
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"相册列表";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutViews];
}

- (void)layoutViews {
    UIBarButtonItem * cancleItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissVc)];
    self.navigationItem.rightBarButtonItem = cancleItem;

    _tableView = [[YGTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.backgroundView.backgroundColor = self.view.backgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_albums.count > 0 && [_albums[0] resource].count > 0) {
            YGPhotoPickerController * list = [[YGPhotoPickerController alloc] initWithAlbum:_albums[0]];
            [self.navigationController pushViewController:list animated:NO];
        }
    });
}

#pragma mark -delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YGAlbumCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YGAlbumCell class])];
    if (!cell) {
        cell = [[YGAlbumCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([YGAlbumCell class])];
    }
    YGPhotoAlbum * album = _albums[indexPath.row];
    cell.album = album;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YGPhotoAlbum * album = _albums[indexPath.row];

    YGPhotoPickerController * list = [[YGPhotoPickerController alloc] initWithAlbum:album];
    [self.navigationController pushViewController:list animated:YES];
}

- (void)dismissVc {
    [self dismissViewControllerAnimated:YES completion:nil];
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
