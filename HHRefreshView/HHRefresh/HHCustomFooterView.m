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
@end

@implementation HHCustomFooterView

- (void)prepare {
    [super prepare];
    _label = [[UILabel alloc] init];
    _label.backgroundColor = [UIColor greenColor];
    _label.text = @"上拉加载";
    [self addSubview:_label];
}

- (void)refreshWillPull {
    [super refreshWillPull];
    _label.text = @"松开加载";
}

- (void)refreshEndPull {
    [super refreshEndPull];
    _label.text = @"上拉刷新";
}


- (void)didBeginRefresh {
    [super didBeginRefresh];
    _label.text = @"正在加载";
}

- (void)willEndRefresh {
    [super willEndRefresh];
    _label.text = @"结束刷新";
}

- (void)didEndRefresh {
    [super didEndRefresh];
    if (self.isEndRefreshingWithNoMoreData) {
        _label.text = @"没有更多数据了。";
    }else {
        _label.text = @"上拉加载";
    }
}

+ (CGFloat)refreshHeight {
    return 44;
}

- (void)placeSubviews {
    [super placeSubviews];
    _label.frame = self.bounds;
}

- (void)refreshPullingWithPercent:(CGFloat)percent {
    [super refreshPullingWithPercent:percent];
}

@end
