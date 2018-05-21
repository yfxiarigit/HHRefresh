//
//  HHCustomFooterView.m
//  net
//
//  Created by yfxiari on 2018/5/18.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "HHCustomFooterView.h"

@interface HHCustomFooterView()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation HHCustomFooterView

- (void)prepare {
    [super prepare];
    _label = [[UILabel alloc] init];
    _label.backgroundColor = [UIColor greenColor];
    _label.text = @"上拉加载";
//    [self addSubview:_label];
    NSLog(@"上拉加载");
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.animationImages = refreshingImages;
    _imageView.animationDuration = animationTime;
    [self addSubview:_imageView];
    _imageView.hidden = YES;
}

- (void)refreshWillPull {
    [super refreshWillPull];
    _label.text = @"松开加载";
    NSLog(@"松开加载");
}

- (void)refreshEndPull {
    [super refreshEndPull];
    _label.text = @"上拉刷新";
    NSLog(@"上拉刷新");
}


- (void)didBeginRefresh {
    [super didBeginRefresh];
    _label.text = @"正在加载";
    NSLog(@"正在加载");
    _imageView.hidden = NO;
    [_imageView startAnimating];
}

- (void)willEndRefresh {
    [super willEndRefresh];
    _label.text = @"结束刷新";
    NSLog(@"结束刷新");
}

- (void)didEndRefresh {
    [super didEndRefresh];
    if (self.isEndRefreshingWithNoMoreData) {
        _label.text = @"没有更多数据了。";
    }else {
        _label.text = @"上拉加载";
    }
    NSLog(@"上拉加载");
    _imageView.hidden = YES;
    [_imageView stopAnimating];
}

+ (CGFloat)refreshHeight {
    return 44;
}

- (void)placeSubviews {
    [super placeSubviews];
    _label.frame = self.bounds;
    _imageView.frame = self.bounds;
}

- (void)refreshPullingWithPercent:(CGFloat)percent {
    [super refreshPullingWithPercent:percent];
}

@end

