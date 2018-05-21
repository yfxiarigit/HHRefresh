//
//  HHRefresh.m
//  net
//
//  Created by yfxiari on 2018/5/18.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "HHRefreshComponent.h"

@interface HHRefreshComponent()
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation HHRefreshComponent

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    if (self = [super init]) {
        [self addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepare];
    }
    return self;
}

- (void)prepare {
    CGRect frame = self.frame;
    frame.size.height = [self refreshHeight];
    frame.origin.y = - [self refreshHeight];
    self.frame = frame;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) { // 新的父控件
        _scrollView = (UIScrollView *)newSuperview;
        _scrollView.alwaysBounceVertical = YES;
        // 设置宽度
        CGRect frame = self.frame;
        frame.size.width = newSuperview.bounds.size.width;
        frame.origin.x = - _scrollView.contentInset.left;
        // 设置位置
        self.frame = frame;
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        _originalInsets = _scrollView.contentInset;
        
        // 添加监听
        [self addObservers];
    }
}

- (void)removeObservers {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [_scrollView removeObserver:self forKeyPath:@"contentInset"];
}

- (void)addObservers {
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        _scrollView = (UIScrollView *)self.superview;
        if (self.hidden) {
            return;
        }
        if ([keyPath isEqualToString:@"contentSize"]) {
            [self scrollViewContentSizeDidChange:_scrollView.contentSize];
        }
        if ([keyPath isEqualToString:@"contentOffset"]) {
            [self scrollViewContentOffsetDidChange:_scrollView.contentOffset];
        }
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent {
    if (self.refreshState == RefreshStateIdle || self.refreshState == RefreshStatePulling) {
        _pullingPercent = pullingPercent;
        [self refreshPullingWithPercent:pullingPercent];
    }else {
        _pullingPercent = 1;
    }
}


- (void)scrollViewContentSizeDidChange:(CGSize)contentSize {}

- (void)scrollViewContentOffsetDidChange:(CGPoint)contentOffset {}

- (void)beginRefresh {
    if (self.refreshState == RefreshStateDidBeginRefreshing || self.refreshState == RefreshStateWillRefreshing || self.refreshState == RefreshStateWillEndRefreshing) return;
    [self willBeginRefresh];
}

- (void)endRefresh {
    [self willEndRefresh];
}

- (void)willBeginRefresh {
    self.refreshState = RefreshStateWillRefreshing;
}

- (void)didBeginRefresh {
    self.refreshState = RefreshStateDidBeginRefreshing;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    if (self.refreshingBlock) {
        self.refreshingBlock();
    }
}

- (void)willEndRefresh {
    self.refreshState = RefreshStateWillEndRefreshing;
}

- (void)didEndRefresh {
    self.refreshState = RefreshStateDidEndRefreshing;
}

- (void)refreshWillPull {
    self.refreshState = RefreshStatePulling;
}
- (void)refreshEndPull {
    self.refreshState = RefreshStateIdle;
}

- (CGFloat)refreshHeight { return 56; }

- (void)layoutSubviews {
    [super layoutSubviews];
    [self placeSubviews];
}

- (void)placeSubviews {}

- (void)refreshPullingWithPercent:(CGFloat)percent {}

@end

