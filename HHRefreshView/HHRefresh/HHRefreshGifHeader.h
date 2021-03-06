//
//  HHRefreshGifFooter.h
//  HHRefreshView
//
//  Created by yfxiari on 2018/5/21.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "HHRefreshHeader.h"

@interface HHRefreshGifHeader : HHRefreshHeader
- (void)setAnimationImages:(NSArray<UIImage *> *)animationImages forState:(RefreshState)refreshState;
- (void)setAnimationImages:(NSArray<UIImage *> *)animationImages duration:(NSTimeInterval)duration forState:(RefreshState)refreshState;
@end
