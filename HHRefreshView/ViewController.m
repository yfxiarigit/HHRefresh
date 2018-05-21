//
//  ViewController.m
//  HHRefreshView
//
//  Created by yfxiari on 2018/5/17.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "ViewController.h"
#import "HHCustomRefreshHeader.h"
#import "HHCustomFooterView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HHCustomRefreshHeader *header;
@property (nonatomic, strong) HHCustomFooterView *footer;
@end
@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    [self configTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)configTableView {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (screenSize.height == 812) {
        insets.top = 88;
        insets.bottom = 34;
    }else {
        insets.top = 64;
        insets.bottom = 0;
    }
    
    _tableView = [[UITableView alloc] init];
    _tableView.contentInset = insets;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.frame = self.view.frame;
    _tableView.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:_tableView];
    
    _header = [HHCustomRefreshHeader headerWithRefreshingBlock:^{
        [self loadData];
//        [_footer resetNoMoreData];
    }];
    [_tableView addSubview:_header];
    
    _footer = [HHCustomFooterView footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    [_tableView addSubview:_footer];
    
    UIButton *refresh = [[UIButton alloc] init];
    [refresh addTarget:self action:@selector(beginRefresh) forControlEvents:UIControlEventTouchUpInside];
    refresh.frame = CGRectMake(100, 200, 100, 40);
    refresh.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:refresh];
}

- (void)beginRefresh {
    [_header beginRefresh];
}

- (void)loadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_header endRefresh];
        _footer.hidden = NO;
    });
}

- (void)loadMore {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_footer endRefresh];
        _footer.hidden = YES;
    });
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"aa";
    return cell;
}
@end
