//
//  HHCustomRefreshHeader.m
//  net
//
//  Created by yfxiari on 2018/5/18.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "HHCustomRefreshHeader.h"

@interface HHCustomRefreshHeader()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation HHCustomRefreshHeader


+ (instancetype)footerWithRefreshingBlock:(HHRefreshComponentRefreshingBlock)block {
    HHCustomRefreshHeader *header = [[self alloc] init];
    header.refreshingBlock = block;
    return header;
}

+ (instancetype)footerWithRefreshingTarget:(id)target action:(SEL)action {
    return [[self alloc] initWithTarget:target action:action];
}

- (void)prepare {
    [super prepare];
    
    _label = [[UILabel alloc] init];
    _label.backgroundColor = [UIColor redColor];
    _label.text = @"下拉刷新";
    //    [self addSubview:_label];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.animationDuration = animationTime;
    [self addSubview: _imageView];
    
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
        [idleImages addObject:image];
    }
    _imageView.animationImages = idleImages;
}

    
    
    // 设置普通状态的动画图片
//    NSMutableArray *idleImages = [NSMutableArray array];
//    for (NSUInteger i = 1; i<=60; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
//        [idleImages addObject:image];
//    }
//    [self setImages:idleImages forState:MJRefreshStateIdle];
//
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    NSMutableArray *refreshingImages = [NSMutableArray array];
//    for (NSUInteger i = 1; i<=3; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
//        [refreshingImages addObject:image];
//    }
//    [self setImages:refreshingImages forState:MJRefreshStatePulling];
//
//    // 设置正在刷新状态的动画图片
//    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];

- (void)placeSubviews {
    [super placeSubviews];
    _label.frame = self.bounds;
    CGSize size = [UIImage imageNamed:@"common_refresh"].size;
    _imageView.frame = CGRectMake(0, 0, size.width, size.height);
    _imageView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
}

- (void)refreshWillPull {
    [super refreshWillPull];
    _label.text = @"松开刷新";
    NSLog(@"松开刷新");
}

- (void)refreshEndPull {
    [super refreshEndPull];
    _label.text = @"下拉刷新";
}

- (void)willBeginRefresh {
    [super willBeginRefresh];
    _label.text = @"正在刷新";
    NSLog(@"正在刷新");
}

- (void)didBeginRefresh {
    [super didBeginRefresh];
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    _imageView.animationImages = refreshingImages;
    [_imageView startAnimating];
}

- (void)willEndRefresh {
    [super willEndRefresh];
    _label.text = @"结束刷新";
    NSLog(@"结束刷新");
}

- (void)didEndRefresh {
    [super didEndRefresh];
    _label.text = @"下拉刷新";
//    [_imageView.layer removeAllAnimations];
    NSLog(@"下拉刷新");
    [_imageView stopAnimating];
    
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
        [idleImages addObject:image];
    }
    _imageView.animationImages = idleImages;
    
}


- (void)refreshPullingWithPercent:(CGFloat)percent {
    [super refreshPullingWithPercent:percent];
    _label.text = [NSString stringWithFormat:@"松开刷新%.2f", percent];
    if (percent > 1) {
        percent = 1;
    }
    NSInteger count = _imageView.animationImages.count;
    if (count > 0) {
        NSInteger index = (int)(count-1) * percent;
        _imageView.image = _imageView.animationImages[index];
    }
}

@end

