//
//  HHRefreshHeader.m
//  net
//
//  Created by yfxiari on 2018/5/18.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "HHRefreshHeader.h"
@interface HHRefreshHeader()
@end

@implementation HHRefreshHeader

+ (instancetype)headerWithRefreshingBlock:(HHRefreshComponentRefreshingBlock)block {
    HHRefreshHeader *header = [[self alloc] init];
    header.refreshingBlock = block;
    return header;
}

+ (instancetype)headerWithRefreshingTarget:(id)target action:(SEL)action {
    return [[self alloc] initWithTarget:target action:action];
}

- (void)scrollViewContentOffsetDidChange:(CGPoint)contentOffset {
    [super scrollViewContentOffsetDidChange:contentOffset];
    
    // 设置下拉比例，只记录大于0 的值
    CGFloat moveDownH = - (self.scrollView.contentOffset.y + self.originalInsets.top);
    if (moveDownH >= 0) {
        self.pullingPercent = moveDownH / [self refreshHeight];
    }
    
    // 如果将要进入刷新状态, 或将要结束刷新状态，这里时insets回复原始值的时候，不要在这里修改insets
    if (self.refreshState == RefreshStateWillRefreshing || self.refreshState == RefreshStateWillEndRefreshing) {
        return;
    }
    // 刷新过程中，滑动scrollView只需修改contentInsets，解决header停留问题
    if (self.refreshState == RefreshStateDidBeginRefreshing) {
        [self setupRefreshingContentInsets];
        return;
    }
    
    // 当header完全显示的时候：
    if (self.scrollView.contentOffset.y <= -(self.scrollView.contentInset.top + self.bounds.size.height)) {
        //如果是拖动中，进入了松手刷新状态：
        if (self.scrollView.isDragging) {
            // 避免松手刷新一直调用
            if (self.refreshState != RefreshStatePulling) {
                [self refreshWillPull];
            }
        }
        // 如果松手了，就进入了正在刷新状态
        else {
            [self beginRefresh];
        }
    }
    // 当header没有完全显示，就进入了闲置状态
    else {
        // 避免进入闲置状态 一直调用
        if (self.refreshState != RefreshStateIdle) {
            [self refreshEndPull];
        }
    }
}

- (void)setupRefreshingContentInsets {
    // 正在刷新时：滑动中，insets 不是固定的，是在一定的范围内，使得不会当向上滑动时，会回弹到header完全显示的位置。  范围：header未显示时的insets ～ header 完全显示时的insets
    CGFloat insetTop = self.scrollView.contentInset.top;
    CGFloat insetTop1 = self.bounds.size.height + self.originalInsets.top;
    if (-self.scrollView.contentOffset.y > self.originalInsets.top && -self.scrollView.contentOffset.y < insetTop1) {
        insetTop = -self.scrollView.contentOffset.y;
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.top = insetTop;
        self.scrollView.contentInset = insets;
    }
}

- (void)willBeginRefresh {
    [super willBeginRefresh];
    // 进入刷新状态，将insets设置为 header完全显示时的insets; 滚动header至完全显示出来。
    __block CGFloat inset = self.originalInsets.top + self.bounds.size.height;
    __block UIEdgeInsets insets = self.scrollView.contentInset;
    insets.top = inset;
    [UIView animateWithDuration:animationTime animations:^{
        self.scrollView.contentInset = insets;
        [self showHeader];
    } completion:^(BOOL finished) {
        [self didBeginRefresh];
    }];
}

- (void)showHeader {
    // 滚动header至完全显示出来。
    CGPoint offset = self.scrollView.contentOffset;
    offset.y = - (self.originalInsets.top + self.bounds.size.height);
    [self.scrollView setContentOffset:offset animated:NO];
}

- (void)willEndRefresh {
    [super willEndRefresh];
    // 还原之前的 insets top; 不能直接还原insets因为可能上拉和下拉同时在进行中。
    [UIView animateWithDuration:animationTime animations:^{
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.top = self.originalInsets.top;
        self.scrollView.contentInset = insets;
    } completion:^(BOOL finished) {
        [self didEndRefresh];
    }];
}

- (CGFloat)refreshHeight {
    return 56;
}

- (void)placeSubviews {
    [super placeSubviews];
}
@end


