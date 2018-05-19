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
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_refresh"]];
    _imageView.contentMode = UIViewContentModeCenter;
    [self addSubview: _imageView];
}

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
- (void)willBeginRefresh {
    [super willBeginRefresh];
    _label.text = @"正在刷新";
    NSLog(@"正在刷新");
    [_imageView.layer removeAllAnimations];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = animationTime;
    animation.repeatCount = 1000;
    animation.fromValue = @(0);
    animation.toValue = @(M_PI * 2);
    [_imageView.layer addAnimation:animation forKey:@"rotation"];
}

- (void)willEndRefresh {
    [super willEndRefresh];
    _label.text = @"结束刷新";
    NSLog(@"结束刷新");
}

- (void)didEndRefresh {
    [super didEndRefresh];
    _label.text = @"下拉刷新";
    [_imageView.layer removeAllAnimations];
    NSLog(@"下拉刷新");
}

- (void)refreshEndPull {
    [super refreshEndPull];
    _label.text = @"下拉刷新";
}

- (void)refreshPullingWithPercent:(CGFloat)percent {
    [super refreshPullingWithPercent:percent];
    _label.text = [NSString stringWithFormat:@"松开刷新%.2f", percent];
    _imageView.transform = CGAffineTransformMakeRotation(percent * M_PI * 2);
}

@end

