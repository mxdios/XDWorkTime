//
//  NTMovieViewController.m
//  nursetime
//
//  Created by 苗晓东 on 15/12/13.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "NTMovieViewController.h"
#import "AFNetworking.h"
#import "NTMovieCell.h"

@interface NTMovieViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_movieTv;
    NSMutableArray *_dataArray;
    CGFloat _cellH;
    MBProgressHUD *_hud;
}
@end

@implementation NTMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"近期影讯";
    _movieTv = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _movieTv.delegate = self;
    _movieTv.dataSource = self;
    [self.view addSubview:_movieTv];
    [self setupLoadData];
}
- (void)setupLoadData
{
    _hud = [MBProgressHUD showMessage:nil];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"key"] = kMovieAppKey;
    dict[@"city"] = @"北京";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kMovie parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NTLog(@"电影  = %@", responseObject);
        [_hud hide:YES];
        if (![responseObject[@"error_code"] integerValue]) {
            _dataArray = [NSMutableArray arrayWithArray:[responseObject[@"result"][@"data"] firstObject][@"data"]];
            [_dataArray addObjectsFromArray:[NSMutableArray arrayWithArray:[responseObject[@"result"][@"data"] lastObject][@"data"]]];
            [_movieTv reloadData];
        } else {
            [MBProgressHUD showText:@"暂无电影资讯"];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NTLog(@"电影失败 = %@", error);
        [MBProgressHUD showText:@"暂无电影咨询"];
        [_hud hide:YES];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NTMovieCell *cell = [NTMovieCell cellWithTableView:tableView];
    cell.dataDict = _dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _cellH = cell.height;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellH;
}
@end
