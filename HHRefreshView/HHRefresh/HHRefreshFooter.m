//
//  HHRefreshFooter.m
//  net
//
//  Created by yfxiari on 2018/5/18.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "HHRefreshFooter.h"

@interface HHRefreshFooter()
@property (nonatomic, assign, getter=isEndRefreshingWithNoMoreData) BOOL endRefreshingWithNoMoreData;
@end

@implementation HHRefreshFooter

+ (instancetype)footerWithRefreshingBlock:(HHRefreshComponentRefreshingBlock)block {
    HHRefreshFooter *header = [[self alloc] init];
    header.refreshingBlock = block;
    return header;
}

+ (instancetype)footerWithRefreshingTarget:(id)target action:(SEL)action {
    return [[self alloc] initWithTarget:target action:action];
}

- (void)scrollViewContentSizeDidChange:(CGSize)contentSize {
    [super scrollViewContentSizeDidChange:contentSize];
    
    // 设置footer的frame,其位置在滚动内容的下面，同时得满足在滚动区域的下面
    CGFloat y = MAX(contentSize.height, [self scrollHeight]);
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (void)scrollViewContentOffsetDidChange:(CGPoint)contentOffset {
    [super scrollViewContentOffsetDidChange:contentOffset];
    
    // 无数据了，不允许再刷新了。
    if (self.isEndRefreshingWithNoMoreData == YES) {
        return;
    }
    
    // 设置上拉进度，只记录 footer 能够显示后的进度， >0
    CGFloat outFooterTopH = self.scrollView.contentOffset.y + self.originalInsets.top - (self.scrollView.contentSize.height - [self scrollHeight]);
    if (outFooterTopH >= 0) {
        self.pullingPercent = outFooterTopH / [self refreshHeight];
    }
    
    // 下拉刷新时，避免再次刷新。
    if (self.refreshState == RefreshStateWillRefreshing || self.refreshState == RefreshStateDidBeginRefreshing || self.refreshState == RefreshStateWillEndRefreshing) {
        return;
    }
    
    // 上拉 footer 完全显示时：
    CGFloat moveUpH = self.scrollView.contentOffset.y + self.originalInsets.top;
    CGFloat outFooterH = 0;
    
    if (self.scrollView.contentSize.height < [self scrollHeight]) {
        outFooterH = moveUpH - [self refreshHeight];
    }else {
        outFooterH = moveUpH - (self.scrollView.contentSize.height + [self refreshHeight] - [self scrollHeight]);
    }
    if (outFooterH > 0) {
        //拖动中：将状态设为 松手刷新. 这是使用isTracking 而不是isdragging，因为isDradding在结束
        if (self.scrollView.isTracking) {
            // 避免重复设置
            if (self.refreshState != RefreshStatePulling) {
                [self refreshWillPull];
            }
        }
        //松手： 开始刷新
        else {
            [self beginRefresh];
        }
        
    }else {
        //footer 没有完全显示时，将状态设为 闲置。 避免重复设置
        if (self.refreshState != RefreshStateIdle) {
            [self refreshEndPull];
        }
    }
}

- (void)willBeginRefresh {
    [super willBeginRefresh];
    // 进入刷新状态，将insets设置为 footer完全显示时的insets； 滚动footer至完全显示出来。
    __block CGFloat inset = self.originalInsets.bottom + self.bounds.size.height;
    __block UIEdgeInsets insets = self.scrollView.contentInset;
    insets.bottom = inset;
    [UIView animateWithDuration:animationTime animations:^{
        self.scrollView.contentInset = insets;
        [self showFooter];
    } completion:^(BOOL finished) {
        [self didBeginRefresh];
    }];
}

- (void)showFooter {
    //滚动footer至完全显示出来
    CGFloat offsetY = 0;
    CGFloat offsetX = self.scrollView.contentOffset.x;
    if (self.scrollView.contentSize.height < [self scrollHeight]) {
        offsetY = - self.originalInsets.top + [self refreshHeight];
    }else {
        offsetY = -self.originalInsets.top + self.scrollView.contentSize.height + [self refreshHeight] - [self scrollHeight];
    }
    [self.scrollView setContentOffset:CGPointMake(offsetX, offsetY) animated:NO];
}

- (void)willEndRefresh {
    [super willEndRefresh];
    // 还原之前的 insets bottom; 不能直接还原insets因为可能上拉和下拉同时在进行中。
    [UIView animateWithDuration:animationTime animations:^{
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.bottom = self.originalInsets.bottom;
        self.scrollView.contentInset = insets;
    } completion:^(BOOL finished) {
        [self didEndRefresh];
    }];
}

- (CGFloat)scrollHeight {
    // 滚动区域的大小
    return self.scrollView.bounds.size.height - self.originalInsets.top - self.originalInsets.bottom;
}

- (CGFloat)refreshHeight {
    return 44;
}

- (void)endRefreshingWithNoMoreData {
    self.endRefreshingWithNoMoreData = YES;
    [self willEndRefresh];
}

- (void)resetNoMoreData {
    self.endRefreshingWithNoMoreData = NO;
    [self didEndRefresh];
}
@end
