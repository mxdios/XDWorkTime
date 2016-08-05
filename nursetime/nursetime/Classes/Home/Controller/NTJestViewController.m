//
//  NTJestViewController.m
//  nursetime
//
//  Created by 苗晓东 on 15/12/13.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "NTJestViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"

@interface NTJestViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_jestTv;
    NSMutableArray *_dataArray;
    CGFloat _cellH;
    NSString *_pageno;
    MBProgressHUD *_hud;
}
@end

@implementation NTJestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"笑话大全";
    _jestTv = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _jestTv.delegate = self;
    _jestTv.dataSource = self;
    _jestTv.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    ((MJRefreshStateHeader *)_jestTv.header).lastUpdatedTimeLabel.hidden = YES;
    _jestTv.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMove)];
    [self.view addSubview:_jestTv];
    [self setupLoadData:@"1"];
}
- (void)loadNew
{
    [self setupLoadData:@"1"];
}
- (void)loadMove
{
    _pageno = [NSString stringWithFormat:@"%ld", _pageno.integerValue + 1];
    [self setupLoadData:_pageno];
}
- (void)setupLoadData:(NSString *)page
{
    _hud = [MBProgressHUD showMessage:nil];
    _pageno = page;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"key"] = kJestAppKey;
    dict[@"page"] = page;
    dict[@"sort"] = @"desc";
    dict[@"pagesize"] = @"20";
    dict[@"time"] = [HXCommonTool setupTimePoke];
    NTLog(@"参数 = %@", dict);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kJestList parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NTLog(@"笑话  = %@", responseObject);
        [_jestTv.header endRefreshing];
        [_jestTv.footer endRefreshing];
        [_hud hide:YES];
        if (![responseObject[@"error_code"] integerValue]) {
            if (page.integerValue > 1) {
                [_dataArray addObjectsFromArray:responseObject[@"result"][@"data"]];
            } else {
                _dataArray = [NSMutableArray arrayWithArray:responseObject[@"result"][@"data"]];
            }
            [_jestTv reloadData];
        } else {
            [MBProgressHUD showText:@"暂无笑话"];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NTLog(@"笑话失败 = %@", error);
        [MBProgressHUD showText:@"暂无笑话"];
        [_jestTv.header endRefreshing];
        [_jestTv.footer endRefreshing];
        [_hud hide:YES];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"goodsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = _dataArray[indexPath.row][@"content"];
    cell.detailTextLabel.text = _dataArray[indexPath.row][@"updatetime"];
    [cell sizeToFit];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _cellH = cell.height;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellH + 10;
}
@end
