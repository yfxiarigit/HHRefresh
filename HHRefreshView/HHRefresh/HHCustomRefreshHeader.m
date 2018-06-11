//
//  HHCustomRefreshHeader.m
//  net
//
//  Created by yfxiari on 2018/5/18.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "HHCustomRefreshHeader.h"

@interface HHCustomRefreshHeader()
@end

@implementation HHCustomRefreshHeader

- (void)prepare {
    [super prepare];
    
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
        [idleImages addObject:image];
    }
    [self setAnimationImages:idleImages forState:RefreshStatePulling];
    
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setAnimationImages:refreshingImages forState:RefreshStateDidBeginRefreshing];
}

    


@end

