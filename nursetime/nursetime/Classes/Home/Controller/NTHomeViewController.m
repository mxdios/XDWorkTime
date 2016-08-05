//
//  NTHomeViewController.m
//  nursetime
//
//  Created by inspiry on 15/10/21.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "NTHomeViewController.h"
#import "LDCalendarView.h"
#import "NSDate+extend.h"
#import "NTPaibanViewController.h"
#import "NTSettingViewController.h"
#import <PgyUpdate/PgyUpdateManager.h>
#import "AFNetworking.h"
#import "NTWeatherView.h"
#import "NTWriteDiaryViewController.h"
#import "HXLoginViewController.h"

@interface NTHomeViewController ()<LDCalendarViewDelegate, NTPaibanViewControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NTWeatherViewDelegate,UIAlertViewDelegate>

@end

@implementation NTHomeViewController
{
    LDCalendarView *_calendarView;
    UIImageView *_imageInn;
    NTWeatherView *_weatherView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSelfTimeView];
    if (!NTThirty_FiveInch) {
        [self setupLoadWeather:nil];
    }
}

- (void)setupSelfTimeView
{
    self.title = @"首页";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(settingBtnClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"排班" style:UIBarButtonItemStylePlain target:self action:@selector(paibanClick)];
    
    _imageInn = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageInn.contentMode = UIViewContentModeScaleAspectFill;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData* imageData = [user objectForKey:@"bgImg"];
    _imageInn.image = [UIImage imageWithData:imageData];
    [self.view addSubview:_imageInn];
    
    UIView *bgV = [[UIView alloc] initWithFrame:self.view.bounds];
    bgV.backgroundColor = [UIColor whiteColor];
    bgV.alpha = 0.7;
    [self.view addSubview:bgV];
    
    _calendarView = [[LDCalendarView alloc] initWithFrame:self.view.bounds];
    _calendarView.delegate = self;
    [self.view addSubview:_calendarView];
    
    [self setupBtnWithFrame:CGRectMake(0, NTViewHeight - 44, NTViewWidth / 2 - 1, 44) title:[[NSUserDefaults standardUserDefaults] boolForKey:keyMoonShowHidden] ? @"显示阴历" : @"隐藏阴历" tag:0];
    [self setupBtnWithFrame:CGRectMake(NTViewWidth / 2 + 1, NTViewHeight - 44, NTViewWidth / 2 - 1, 44) title:@"返回今天" tag:1];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTableviewCellLongPressed:)];
    longPress.minimumPressDuration = 0.5;
    [_calendarView addGestureRecognizer:longPress];
    
    if (!NTThirty_FiveInch) {
        _weatherView = [[NTWeatherView alloc] initWithFrame:CGRectMake(0, NTViewHeight - 150, NTViewWidth, 100)];
        _weatherView.delegate = self;
        [self.view addSubview:_weatherView];
    }
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kPGYAPP_ID];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
}
- (void)setupBtnWithFrame:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag
{
    HXSetBgColorBtn *about = [[HXSetBgColorBtn alloc] initWithFrame:frame];
    about.tag = tag;
    [about setBackgroundColor:[UIColor colorWithRed:0.13f green:0.65f blue:1.00f alpha:1.00f] forState:UIControlStateNormal];
    [about setBackgroundColor:[UIColor colorWithRed:0.13f green:0.65f blue:1.00f alpha:0.50f] forState:UIControlStateHighlighted];
    [about setTitleColor:setAlpColor(255, 255, 255, 1.0) forState:UIControlStateNormal];
    [about setTitleColor:setAlpColor(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
    about.titleLabel.font = NTFont(15);
    [about addTarget:self action:@selector(nowDay:) forControlEvents:UIControlEventTouchUpInside];
    [about setTitle:title forState:UIControlStateNormal];
    [self.view addSubview:about];
}
- (void)gengxinTianqi:(NSString *)chengshi
{
    [self setupLoadWeather:chengshi];
}
- (void)setupLoadWeather:(NSString *)chengshi
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *city = [user objectForKey:keyWeather];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"key"] = kWeatherAppKey;
    if (chengshi) {
        dict[@"cityname"] = chengshi;
    } else if (city.length) {
        dict[@"cityname"] = city;
    } else {
        dict[@"cityname"] = @"北京";
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kWeather parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NTLog(@"天气  = %@", responseObject);
        if (![responseObject[@"error_code"] integerValue]) {
            [MBProgressHUD showText:@"获取天气预报成功"];
            _weatherView.weatherDict = responseObject[@"result"][@"data"];
            if (chengshi) {
                [user setObject:chengshi forKey:keyWeather];
                [user synchronize];
            }
        } else {
            [MBProgressHUD showText:responseObject[@"reason"]];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NTLog(@"天气失败 = %@", error);
        [MBProgressHUD showText:@"天气预报获取失败"];
    }];

}
- (void)handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        UIActionSheet *sheet;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            sheet  = [[UIActionSheet alloc] initWithTitle:@"选择背景图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        } else {
            sheet = [[UIActionSheet alloc] initWithTitle:@"选择背景图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
        }
        sheet.tag = 255;
        [sheet showInView:self.view];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = 0;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                    
                case 2:
                    // 取消
                    return;
                    break;
            }
        } else {
            if (buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            } else {
                return;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
//        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:UIImagePNGRepresentation(image) forKey:@"bgImg"];
    [user synchronize];
    _imageInn.image = image;
}
- (void)settingBtnClick
{
    NTSettingViewController *settingVc = [[NTSettingViewController alloc] init];
    settingVc.block = ^(){
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user removeObjectForKey:@"bgImg"];
        _imageInn.image = nil;
        [MBProgressHUD showText:@"清空背景成功"];
    };
    [self.navigationController pushViewController:settingVc animated:YES];
}
- (void)goPaiban
{
    [self paibanClick];
}
- (void)goWriteDiary:(NSString *)timeStr
{
    BmobUser *bUser = [BmobUser getCurrentUser];
    if (bUser) {
        NTWriteDiaryViewController *writeVc = [[NTWriteDiaryViewController alloc] init];
        writeVc.timeStr = timeStr;
        [self.navigationController pushViewController:writeVc animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"记录%@的事项", timeStr] message:@"使用记录事项功能,需要登录" delegate:self cancelButtonTitle:@"暂不需要" otherButtonTitles:@"去登录", nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self.navigationController pushViewController:[[HXLoginViewController alloc] init] animated:YES];
    }
}
- (void)paibanClick
{
    NTPaibanViewController *paibanVc = [[NTPaibanViewController alloc] init];
    paibanVc.delegate = self;
    [self.navigationController pushViewController:paibanVc animated:YES];
}
- (void)nowDay:(HXSetBgColorBtn *)btn
{
    if (btn.tag) {//返回今天
        [_calendarView initData];
    } else {//显示阴历
        [_calendarView setupMoonShowHidden];
        [btn.titleLabel.text isEqualToString:@"显示阴历"] ? [btn setTitle:@"隐藏阴历" forState:UIControlStateNormal] : [btn setTitle:@"显示阴历" forState:UIControlStateNormal];
    }
}

- (void)selectDutyTime:(NSString *)time andButy:(NSMutableArray *)buty andTag:(NSMutableArray *)tags
{
    [_calendarView showDateView:buty andSelectDayStr:time andTags:tags];
}
@end
