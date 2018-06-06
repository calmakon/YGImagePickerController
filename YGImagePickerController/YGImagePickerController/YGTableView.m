//
//  YGTableView.m
//  YGMediaTool
//
//  Created by HYG on 2018/3/30.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import "YGTableView.h"

@implementation YGTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delaysContentTouches = NO;
        self.canCancelContentTouches = YES;
        //self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor lightGrayColor];

        // Remove touch delay (since iOS 8)
        UIView *wrapView = self.subviews.firstObject;
        // UITableViewWrapperView
        if (wrapView && [NSStringFromClass(wrapView.class) hasSuffix:@"WrapperView"]) {
            for (UIGestureRecognizer *gesture in wrapView.gestureRecognizers) {
                // UIScrollViewDelayedTouchesBeganGestureRecognizer
                if ([NSStringFromClass(gesture.class) containsString:@"DelayedTouchesBegan"] ) {
                    gesture.enabled = NO;
                    break;
                }
            }
        }
    }
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ( [view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end
