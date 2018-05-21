//
//  HHRefreshGifFooter.m
//  HHRefreshView
//
//  Created by yfxiari on 2018/5/21.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "HHRefreshGifHeader.h"

@interface HHRefreshGifHeader()
@property (nonatomic, strong) NSMutableDictionary *stateImagesDict;
@property (nonatomic, strong) NSMutableDictionary *stateDurationsDict;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation HHRefreshGifHeader

- (void)prepare {
    [super prepare];
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:_imageView];
}

- (void)setAnimationImages:(NSArray<UIImage *> *)animationImages forState:(RefreshState)refreshState {
    [self setAnimationImages:animationImages duration:animationImages.count * 0.1 forState:refreshState];
}

- (void)setAnimationImages:(NSArray<UIImage *> *)animationImages duration:(NSTimeInterval)duration forState:(RefreshState)refreshState {
    if (animationImages == nil || animationImages.count <= 0) {
        return;
    }
    self.stateImagesDict[@(refreshState)] = animationImages;
    self.stateDurationsDict[@(refreshState)] = @(duration);
    /* 根据图片设置控件的高度 */
    UIImage *image = [animationImages firstObject];
    if (image.size.height > [self refreshHeight]) {
        CGRect frame = self.frame;
        frame.size.height = image.size.height;
        self.frame = frame;
    }
}

#pragma mark - super

- (void)refreshPullingWithPercent:(CGFloat)percent {
    [super refreshPullingWithPercent:percent];
    [self.imageView stopAnimating];
    NSArray *images = self.stateImagesDict[@(RefreshStatePulling)];
    NSInteger count = images.count;
    if (count > 0 && percent > 0.3) {
        if (percent > 1.3) {
            percent = 1.3;
        }
        NSInteger index = (count - 1) * (percent - 0.3);
        self.imageView.image = images[index];
    }
}

- (void)didBeginRefresh {
    [super didBeginRefresh];
    NSArray *images = self.stateImagesDict[@(RefreshStateDidBeginRefreshing)];
    NSTimeInterval duration = [self.stateDurationsDict[@(RefreshStateDidBeginRefreshing)] floatValue];
    self.imageView.animationImages = images;
    self.imageView.animationDuration = duration;
    [self.imageView startAnimating];
}

- (void)didEndRefresh {
    [super didEndRefresh];
    [self.imageView stopAnimating];
}

- (void)placeSubviews {
    [super placeSubviews];
    _imageView.frame = self.bounds;
}

#pragma mark - get

- (NSMutableDictionary *)stateImagesDict {
    if (!_stateImagesDict) {
        self.stateImagesDict = [NSMutableDictionary dictionary];
    }
    return _stateImagesDict;
}

- (NSMutableDictionary *)stateDurationsDict {
    if (!_stateDurationsDict) {
        self.stateDurationsDict = [NSMutableDictionary dictionary];
    }
    return _stateDurationsDict;
}


@end
