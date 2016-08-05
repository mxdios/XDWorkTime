//
//  HXCommonTool.h
//  nursetime
//
//  Created by 苗晓东 on 15/12/13.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXCommonTool : NSObject
/**
 *  获取用户id 未登录返回nil
 */
+ (NSString *)getUserId;

/** 获取时间戳 */
+ (NSString *)setupTimePoke;

/** 返回带节日的农历列表 */
+ (NSString *)setupFeastMoonYear:(int)wCurYear Month:(int)wCurMonth Day:(int)wCurDay;

/** 获取农历 */
+ (NSString *)LunarForSolarYear:(int)wCurYear Month:(int)wCurMonth Day:(int)wCurDay;

/** 返回日历文字颜色 */
+ (UIColor *)setupTextColorWith:(UILabel *)label;
/**
 *  适配屏幕
 */
+ (CGFloat)setupLayoutLocationWith:(CGFloat)consult distances:(NSArray *)distances;
/**
 *  正则判断是否为邮箱
 */
+(BOOL)isValidateEmail:(NSString *)email;

@end
