//
//  HHRefreshFooter.h
//  net
//
//  Created by yfxiari on 2018/5/18.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "HHRefreshComponent.h"

@interface HHRefreshFooter : HHRefreshComponent
/** 记录是否调用了endRefreshingWithNoMoreData方法 */
@property (nonatomic, assign, getter=isEndRefreshingWithNoMoreData, readonly) BOOL endRefreshingWithNoMoreData;
+ (instancetype)footerWithRefreshingBlock:(HHRefreshComponentRefreshingBlock)block;
+ (instancetype)footerWithRefreshingTarget:(id)target action:(SEL)action;

/** 结束刷新，在重设resetNoMoreData 之前不能再次刷新 */
- (void)endRefreshingWithNoMoreData;
/** 重设结束刷新状态为有数据 */
- (void)resetNoMoreData;
@end
