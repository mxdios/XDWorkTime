//
//  NTCommon.h
//  nursetime
//
//  Created by inspiry on 15/10/21.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"
#import "UIBarButtonItem+DZ.h"
#import "UIView+Frame.h"
#import "UIImage+AC.h"
#import "MBProgressHUD+MJ.h"
#import "HXSetBgColorBtn.h"
#import "HXCommonTool.h"
#import <BmobSDK/Bmob.h>


//bmob后端云服务appid
#define kBmobAppID @"ee98d948e524bd8e74457652b0606dd4"
//蒲公英的appid
#define kPGYAPP_ID @"879698c78325df811d43fc47c72ef6af"
//笑话大全的key
#define kJestAppKey @"66bc50e255f30a0ad5ea0225297f4a03"
//笑话大全接口
#define kJestList @"http://japi.juhe.cn/joke/content/list.from"
//电影资讯appkey
#define kMovieAppKey @"f2047ce5aebd5615b9118d34f3327d64"
//电影资讯
#define kMovie @"http://op.juhe.cn/onebox/movie/pmovie"
//天气预报APPkey
#define kWeatherAppKey @"38b9e8f3558e34bf7e587862e43f0f5e"
//天气预报接口
#define kWeather @"http://op.juhe.cn/onebox/weather/query"
//天气地点保存到本地
#define keyWeather @"weatherKey"
//显示或隐藏农历
#define keyMoonShowHidden @"MoonShowHidden"
//登录或注册成功的通知
#define keyLoginNot @"login"
//警示框是否多次出现的
#define keyAlertStr @"alertView"
//md5
#define keyMD5 @"md5mxdAIwcxlove"

//设备的uuid
#define kDeviceUUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
//app用的最多的蓝色
#define NTBlue [UIColor colorWithRed:0.13f green:0.65f blue:1.00f alpha:1.00f]
//随机色
#define randomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0]
//设置颜色
#define setColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//设置带透明度的颜色
#define setAlpColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//设置字号
#define NTFont(a) [UIFont systemFontOfSize:a]

//系统版本号
#define NTDeviceNum [UIDevice currentDevice].systemVersion

//判断是iOS7
#define iOS7 ([UIDevice currentDevice].systemVersion.doubleValue < 8.0)

//3.5屏幕
#define NTThirty_FiveInch ([UIScreen mainScreen].bounds.size.height == 480.0)
//4.0屏幕
#define NTFour_ZeroInch ([UIScreen mainScreen].bounds.size.height == 568.0)
//4.7屏幕
#define NTFour_SevenInch ([UIScreen mainScreen].bounds.size.height == 667.0)
//5.5屏幕
#define NTFive_FiveInch ([UIScreen mainScreen].bounds.size.height == 736.0)


//view的宽度
#define NTViewWidth [UIScreen mainScreen].bounds.size.width
//view的宽度
#define NTViewHeight [UIScreen mainScreen].bounds.size.height

// 3.自定义Log
#ifdef DEBUG
#define NTLog(...) NSLog(__VA_ARGS__)
#else
#define NTLog(...)
#endif

