//
//  HHCustomRefreshHeader.h
//  net
//
//  Created by yfxiari on 2018/5/18.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "HHRefreshHeader.h"

@interface HHCustomRefreshHeader : HHRefreshHeader
+ (instancetype)footerWithRefreshingBlock:(HHRefreshComponentRefreshingBlock)block;
+ (instancetype)footerWithRefreshingTarget:(id)target action:(SEL)action;
@end
