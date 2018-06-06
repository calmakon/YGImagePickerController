//
//  YGAlbumCell.m
//  YGMediaTool
//
//  Created by HYG on 2018/4/2.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import "YGAlbumCell.h"
#import "YGPhotoConfig.h"
#import "YGPhotoAlbum.h"
@interface YGAlbumCell ()
@property (nonatomic,strong) UIImageView * iconView;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * numLabel;
@end

@implementation YGAlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    _iconView = [HYGUIKit imageViewWithBackgroundColor:[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1] image:nil contentMode:UIViewContentModeScaleAspectFill];
    _iconView.clipsToBounds = YES;
    _iconView.size = CGSizeMake(kYGAlbumCellIconWidth, kYGAlbumCellIconWidth);
    _iconView.left = 12;
    _iconView.centerY = kYGAlbumCellHeight / 2.0f;
    [self.contentView addSubview:_iconView];

    _nameLabel = [HYGUIKit labelWithFont:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft numberOfLines:1 text:nil];
    _nameLabel.size = CGSizeMake(220, 20);
    _nameLabel.left = _iconView.right + 10;
    _nameLabel.top = _iconView.top;
    [self.contentView addSubview:_nameLabel];

    _numLabel = [HYGUIKit labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentLeft numberOfLines:1 text:nil];
    _numLabel.size = CGSizeMake(120, 20);
    _numLabel.left = _iconView.right + 10;
    _numLabel.top = _nameLabel.bottom + 10;
    [self.contentView addSubview:_numLabel];

    return self;
}

- (void)setAlbum:(YGPhotoAlbum *)album {
    _album = album;

    __weak typeof(self) weakSelf = self;
    [[YGPhotoManager manager] fetchImageWithAlbum:album completion:^(UIImage *image) {
        weakSelf.iconView.image = image;
    }];
    _nameLabel.text = album.title;
    _numLabel.text = [NSString stringWithFormat:@"(%lu)",(unsigned long)album.count];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

@end
