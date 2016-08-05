//
//  NTDiaryListViewController.m
//  nursetime
//
//  Created by inspiry on 15/12/17.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "NTDiaryListViewController.h"
#import "NTDiaryListCell.h"
#import "NTWriteDiaryViewController.h"

@interface NTDiaryListViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    UITableView *_diaryList;
    NSMutableArray *_diaryListArray;
    CGFloat _cellH;
}
@end

@implementation NTDiaryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"事项列表";
    _diaryList = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _diaryList.separatorStyle = UITableViewCellSeparatorStyleNone;
    _diaryList.delegate = self;
    _diaryList.dataSource = self;
    _diaryList.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [self.view addSubview:_diaryList];
    [self setupLoadData];
    
    HXSetBgColorBtn *back = [[HXSetBgColorBtn alloc] initWithFrame:CGRectMake(0, NTViewHeight - 44, NTViewWidth, 44)];
    [back setBackgroundColor:[UIColor colorWithRed:0.13f green:0.65f blue:1.00f alpha:1.00f] forState:UIControlStateNormal];
    [back setBackgroundColor:[UIColor colorWithRed:0.13f green:0.65f blue:1.00f alpha:0.50f] forState:UIControlStateHighlighted];
    [back setTitleColor:setAlpColor(255, 255, 255, 1.0) forState:UIControlStateNormal];
    [back setTitleColor:setAlpColor(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
    back.titleLabel.font = NTFont(15);
    [back setTitle:@"返回首页,点击日历添加记录事项" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
}
- (void)backBtnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)setupLoadData
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Diary"];
    bquery.limit = 1000;//暂时写1000条，后期加分页
    [bquery whereKey:@"userid" equalTo:[HXCommonTool getUserId]];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            [MBProgressHUD showText:@"读取列表失败"];
        } else if (array.count){
            _diaryListArray = [NSMutableArray arrayWithArray:array];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(deleteBtnClick:)];
            [_diaryList reloadData];
        } else {
            [MBProgressHUD showText:@"暂无数据"];
        }
    }];
}
- (void)deleteBtnClick:(UIBarButtonItem *)btnItem
{
    [btnItem.title isEqualToString:@"编辑"] ? (btnItem.title = @"完成" , [_diaryList setEditing:YES animated:YES]) : (btnItem.title = @"编辑", [_diaryList setEditing:NO animated:YES]);
}
#pragma mark - tableview代理数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _diaryListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NTDiaryListCell *cell = [NTDiaryListCell cellWithTableView:tableView];
    cell.bmobObject = _diaryListArray[indexPath.row];
    _cellH = cell.height;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iOS7) {
        [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return _cellH;
    }
    return _cellH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了 = %ld", indexPath.row);
    NTWriteDiaryViewController *writeD = [[NTWriteDiaryViewController alloc] init];
    writeD.bmobObject = _diaryListArray[indexPath.row];
    __weak typeof(self) weakSelf = self;
    writeD.upDataRefreshListBlock = ^(){
        [weakSelf setupLoadData];
    };
    [self.navigationController pushViewController:writeD animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确定要删除这条记录事项吗?(此操作不可撤销)" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定删除" otherButtonTitles:nil];
    sheet.tag = indexPath.row;
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        BmobObject *bmobObject = _diaryListArray[actionSheet.tag];
        [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [MBProgressHUD showText:@"删除成功"];
                [_diaryListArray removeObjectAtIndex:actionSheet.tag];
                [_diaryList reloadData];
            } else{
                [MBProgressHUD showText:@"删除失败"];
            }
        }];
    }
}

@end
