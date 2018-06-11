//
//  HHRefresh.h
//  net
//
//  Created by yfxiari on 2018/5/18.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RefreshState) {
    /** 闲置状态 */
    RefreshStateIdle,
    /** 松开刷新 */
    RefreshStatePulling,
    /** 将要进入刷新中 */
    RefreshStateWillRefreshing,
    /** 刷新中 */
    RefreshStateDidBeginRefreshing,
    /** 将要结束刷新 */
    RefreshStateWillEndRefreshing,
    /** 结束刷新中 */
    RefreshStateEndRefresh,
};

static NSTimeInterval animationTime = 0.6;
typedef void (^HHRefreshComponentRefreshingBlock)(void);

@interface HHRefreshComponent : UIControl

@property (nonatomic, weak, readonly) UIScrollView *scrollView;
@property (nonatomic, assign) RefreshState refreshState;
@property (nonatomic, assign) UIEdgeInsets originalInsets;
@property (nonatomic, assign) CGFloat pullingPercent;
@property (nonatomic, copy) HHRefreshComponentRefreshingBlock refreshingBlock;

- (instancetype)initWithTarget:(id)target action:(SEL)action;
- (void)beginRefresh;
- (void)endRefresh;
#pragma mark - 需要子类实现
/** 添加子控件 */
- (void)prepare NS_REQUIRES_SUPER;
/** 刷新控件的高度 */
- (CGFloat)refreshHeight;
/** kvo contentSize 改变回调 */
- (void)scrollViewContentSizeDidChange:(CGSize)contentSize NS_REQUIRES_SUPER;
/** kvo contentOffset 改变回调 */
- (void)scrollViewContentOffsetDidChange:(CGPoint)contentOffset NS_REQUIRES_SUPER;
/** 将要进入刷新，这里设置insets */
- (void)willBeginRefresh NS_REQUIRES_SUPER;
/** 已经进入刷新，刷新动画可以写在这里 */
- (void)didBeginRefresh NS_REQUIRES_SUPER;
/** 即将结束刷新，结束刷新动画可以写在这里 */
- (void)willEndRefresh NS_REQUIRES_SUPER;
/** 已经结束刷新，还原初始值，关闭结束刷新动画可以写在这里 */
- (void)didEndRefresh NS_REQUIRES_SUPER;
/** 即将进入松开刷新 */
- (void)refreshWillPull NS_REQUIRES_SUPER;
/** 结束松开刷新，进入限制状态 */
- (void)refreshEndPull NS_REQUIRES_SUPER;
/** 子控件布局 */
- (void)placeSubviews NS_REQUIRES_SUPER;
/** 拖拽的比例，在非刷新状态时，回调。 */
- (void)refreshPullingWithPercent:(CGFloat)percent NS_REQUIRES_SUPER;
@end

