//
//  NTSettingViewController.m
//  nursetime
//
//  Created by 苗晓东 on 15/12/13.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "NTSettingViewController.h"
#import "NTAboutViewController.h"
#import "NTJestViewController.h"
#import "NTMovieViewController.h"
#import "HXUserHeadView.h"
#import "HXLoginViewController.h"
#import "NTDiaryListViewController.h"
#import <PgyUpdate/PgyUpdateManager.h>

@interface NTSettingViewController ()<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate, UIAlertViewDelegate>
{
    NSMutableArray *_sectionOne;
    NSMutableArray *_sectionTwo;
    UITableView *_settingTv;
    HXUserHeadView *_headView;
    UIView *_logoutView;
}
@end

@implementation NTSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:keyLoginNot object:nil];
    
    _sectionOne = [NSMutableArray arrayWithObjects:@"事项列表",@"笑话大全",@"近期影讯", nil];
    _sectionTwo = [NSMutableArray arrayWithObjects:@"清空背景图片",@"检测更新",@"关于我们", nil];
    _settingTv = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _settingTv.dataSource = self;
    _settingTv.delegate = self;
    [self.view addSubview:_settingTv];
    
    _headView = [[HXUserHeadView alloc] initWithFrame:CGRectMake(0, 0, NTViewWidth, 150)];
    __weak typeof(self) weakSelf = self;
    _headView.loginBlock = ^{
        [weakSelf.navigationController pushViewController:[[HXLoginViewController alloc] init] animated:YES];
    };
    _settingTv.tableHeaderView = _headView;

    _logoutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NTViewWidth, 100)];
    HXSetBgColorBtn *logoutBtn = [[HXSetBgColorBtn alloc] init];
    [logoutBtn setBackgroundColor:[UIColor colorWithRed:0.99 green:0.37 blue:0.38 alpha:1] forState:UIControlStateNormal];
    [logoutBtn setBackgroundColor:[UIColor colorWithRed:0.99 green:0.37 blue:0.38 alpha:0.5] forState:UIControlStateHighlighted];
    [logoutBtn setTitleColor:setAlpColor(255, 255, 255, 1.0) forState:UIControlStateNormal];
    [logoutBtn setTitleColor:setAlpColor(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
    logoutBtn.titleLabel.font = NTFont(15);
    [logoutBtn setTitle:@"注销登录" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    logoutBtn.width = 200;
    logoutBtn.height = 40;
    logoutBtn.layer.cornerRadius = 4;
    logoutBtn.centerX = _logoutView.width * 0.5;
    logoutBtn.centerY = _logoutView.height * 0.5;
    [_logoutView addSubview:logoutBtn];
    _settingTv.tableFooterView = _logoutView;
    
    [self getUserInfo];
    
}
- (void)logoutBtnClick
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确定要注销当前登录账号吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定注销" otherButtonTitles:nil];
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        [BmobUser logout];
        _headView.userName = @"未登录,点击登录";
        _logoutView.hidden = YES;
    }
}
- (void)getUserInfo
{
    BmobUser *bUser = [BmobUser getCurrentUser];
    if (bUser) {
        //进行操作
        NTLog(@"buser = %@", bUser);
        _headView.userName = [bUser objectForKey:@"username"];
    }else{
        _headView.userName = @"未登录,点击登录";
        _logoutView.hidden = YES;
    }
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section) {
        return _sectionTwo.count;
    }
    return _sectionOne.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"goodsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (indexPath.section) {
        cell.textLabel.text = _sectionTwo[indexPath.row];
    } else {
        cell.textLabel.text = _sectionOne[indexPath.row];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section) {
        return @"设置与关于";
    }
    return @"记事与娱乐";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section) {
        switch (indexPath.row) {
            case 0:
                _block();
                break;
            case 1:
                [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
                break;
            case 2:
                [self.navigationController pushViewController:[[NTAboutViewController alloc] init] animated:YES];
                break;
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
            {
                BmobUser *bUser = [BmobUser getCurrentUser];
                if (bUser) {
                    [self.navigationController pushViewController:[[NTDiaryListViewController alloc] init] animated:YES];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"使用记录事项功能,需要登录" message:nil delegate:self cancelButtonTitle:@"暂不需要" otherButtonTitles:@"去登录", nil];
                    [alert show];
                }
            }
                break;
            case 1:
                [self.navigationController pushViewController:[[NTJestViewController alloc] init] animated:YES];
                break;
            case 2:
                [self.navigationController pushViewController:[[NTMovieViewController alloc] init] animated:YES];
                break;
            default:
                break;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self.navigationController pushViewController:[[HXLoginViewController alloc] init] animated:YES];
    }
}
- (void)updateMethod:(NSDictionary *)dict
{
    if ([NSStringFromClass(dict.class) isEqualToString:@"__NSCFDictionary"] && dict.count) {
        [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kPGYAPP_ID];
        [[PgyUpdateManager sharedPgyManager] checkUpdate];
    } else {
        [MBProgressHUD showText:@"当前为最新版本"];
    }
}
- (void)dealloc
{
    self.block = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
