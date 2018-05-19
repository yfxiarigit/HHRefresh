//
//  HHRefreshHeader.h
//  net
//
//  Created by yfxiari on 2018/5/18.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "HHRefreshComponent.h"

@interface HHRefreshHeader : HHRefreshComponent
+ (instancetype)headerWithRefreshingBlock:(HHRefreshComponentRefreshingBlock)block;
+ (instancetype)headerWithRefreshingTarget:(id)target action:(SEL)action;
@end
