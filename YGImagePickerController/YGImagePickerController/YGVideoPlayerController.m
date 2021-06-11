//
//  YGVideoPlayerController.m
//  YGMediaTool
//
//  Created by HYG on 2018/4/2.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import "YGVideoPlayerController.h"
#import "YGPhotoConfig.h"
#import "YGImagePickerController.h"
#import <AVFoundation/AVFoundation.h>
@interface YGVideoPlayerController ()
@property (nonatomic,strong) AVPlayer * player;
@property (nonatomic,strong) AVPlayerLayer * playerLayer;
@property (nonatomic,strong) UIImage * cover;
@property (nonatomic,strong) UIButton * playBtn;
@property (nonatomic,strong) UIProgressView * progressView;
@property (nonatomic,strong) YGPhotoAsset * asset;
@property (nonatomic,strong) YGPhotoBottomBar * bottomBar;
@end

@implementation YGVideoPlayerController

- (instancetype)initWithAsset:(YGPhotoAsset *)asset {
    self = [super init];
    _asset = asset;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.

    [self configPlayer];
}

- (void)viewDidLayoutSubviews {
    _playBtn.size = CGSizeMake(self.view.width, self.view.width * 1.2);
    _playBtn.center = self.view.center;

    if (self.isPreview)return;

    _bottomBar = [[YGPhotoBottomBar alloc] initWithCollection:NO];
    _bottomBar.assetType = YGPhotoAssetTypeVideo;
    _bottomBar.bottom = self.view.height;
    _bottomBar.left = 0;
    [self.view addSubview:_bottomBar];

    __weak typeof(self) weakSelf = self;
    __weak typeof(_cover) weakCover = _cover;
    [_bottomBar setConfirmBlock:^{
        YGImagePickerController * picker = (YGImagePickerController *)weakSelf.navigationController;
        [picker dismissViewControllerAnimated:YES completion:^{
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            if (picker.didSelectedVideo) {
                picker.didSelectedVideo(weakCover, weakSelf.asset.asset);
            }
        }];
    }];
}

- (void)configPlayer {
    if (!_asset) return;
    [[YGPhotoManager manager] fetchPhotoWithAsset:_asset.asset completion:^(UIImage *image, NSDictionary *info) {
        self.cover = image;
    }];
    [[YGPhotoManager manager] fetchVideoWithAsset:_asset.asset completion:^(AVPlayerItem *item, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.player = [AVPlayer playerWithPlayerItem:item];
            self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
            self.playerLayer.frame = self.view.bounds;
            [self.view.layer addSublayer:self.playerLayer];
            [self addProgressObserver];
            [self configPlayButton];

            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
        });
    }];
}

- (void)moviePlayDidEnd:(NSNotification *)notification {
    [_playBtn setImage:[UIImage imageNamed:@"play_icon@2x"] forState:UIControlStateNormal];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)configPlayButton {
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setImage:[UIImage imageNamed:@"play_icon@2x"] forState:UIControlStateNormal];
    //[_playBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _playBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    //[_playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [_playBtn setImage:[UIImage imageNamed:@"play_icon@2x"] forState:UIControlStateHighlighted];
    [_playBtn addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playBtn];
}

- (void)playButtonClick {
    CMTime currentTime = _player.currentItem.currentTime;
    CMTime durationTime = _player.currentItem.duration;
    if (_player.rate == 0.0f) {
        if (currentTime.value == durationTime.value) [_player.currentItem seekToTime:CMTimeMake(0, 1) completionHandler:nil];
        [_player play];
        [self.navigationController setNavigationBarHidden:YES];
        [_playBtn setImage:nil forState:UIControlStateNormal];
    } else {
        [_player pause];
        [_playBtn setImage:[UIImage imageNamed:@"play_icon@2x"] forState:UIControlStateNormal];
        [self.navigationController setNavigationBarHidden:NO];
    }
}

- (void)addProgressObserver {
    AVPlayerItem *playerItem = _player.currentItem;
    UIProgressView *progress = _progressView;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([playerItem duration]);
        if (current) {
            [progress setProgress:(current/total) animated:YES];
        }
    }];
}

- (void)dealloc {
    _player = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
