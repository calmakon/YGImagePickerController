# YGImagePickerController
1.轻量级相册访问框架，支持照片多选，单选GIF，单选视频，可定制导航样式、设置多大选择数。
2.底层库PhotoKit,仅支持iOS 8之后
3.支持CocoaPods导入

## 最近更新
1.适配x、12系列
2.支持Dark Mode
3.适配iOS 11以上
## 使用
```
YGImagePickerController * picker = [YGImagePickerController new];
picker.barBgColor = [UIColor redColor];
picker.barTitleColor = [UIColor whiteColor];
picker.barTitleFont = [UIFont systemFontOfSize:18];
picker.maxSelectedCount = 4;
[self presentViewController:picker animated:YES completion:nil];

//选择照片
[picker setDidSelectedPhotos:^(NSArray *photos, NSArray *infos, NSArray *assets) {
NSLog(@"已选择：%@-----：%@-----：%@",photos,infos,assets);

}];

//选择视频
[picker setDidSelectedVideo:^(UIImage *cover, id asset) {
NSLog(@"已选择：%@-----：%@",cover,asset);
PHAsset * ass = (PHAsset *)asset;

}];

//选择GIF
[picker setDidSelectedGifImage:^(UIImage *gifImage, id asset) {
NSLog(@"已选择：%@-----：%@",gifImage,asset);
PHAsset * ass = (PHAsset *)asset;

}];
```
