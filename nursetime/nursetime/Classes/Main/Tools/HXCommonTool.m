//
//  HXCommonTool.m
//  nursetime
//
//  Created by 苗晓东 on 15/12/13.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "HXCommonTool.h"

@implementation HXCommonTool
//返回用户id
+ (NSString *)getUserId
{
    BmobUser *bUser = [BmobUser getCurrentUser];
    if (bUser) {
        return [NSString stringWithFormat:@"%ld", [[bUser objectForKey:@"userid"] integerValue]];
    }else{
        return nil;
    }
}
//时间戳
+ (NSString *)setupTimePoke
{
    return [NSString stringWithFormat:@"%ld",time(NULL)];
}
//判断输入的是否是邮箱
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//屏幕适配
+ (CGFloat)setupLayoutLocationWith:(CGFloat)consult distances:(NSArray *)distances
{
    if (NTThirty_FiveInch) { // 3.5
        return consult + [distances[0] floatValue];
    } else if (NTFour_ZeroInch) { // 4.0
        return consult + [distances[1] floatValue];
    } else if(NTFour_SevenInch) {// 4.7
        return consult + [distances[2] floatValue];
    } else if(NTFive_FiveInch) {// 5.5
        return consult + [distances[3] floatValue];
    }
    return 0;
}
//返回文字颜色
+ (UIColor *)setupTextColorWith:(UILabel *)label
{
    if (0 == label.tag || [label.text isEqualToString:@"早"]) {
        return setColor(255, 48, 48);
    } else if (1 == label.tag || [label.text isEqualToString:@"午"]) {
        return setColor(255, 127, 80);
    } else if (2 == label.tag || [label.text isEqualToString:@"晚"]) {
        return setColor(60, 179, 113);
    } else if (3 == label.tag || [label.text isEqualToString:@"夜"]) {
        return setColor(46, 139, 87);
    } else if (4 == label.tag || [label.text isEqualToString:@"休"]) {
        return setColor(32, 178, 170);
    } else {
        return [UIColor blackColor];
    }
}
//返回带节日的农历
+ (NSString *)setupFeastMoonYear:(int)wCurYear Month:(int)wCurMonth Day:(int)wCurDay
{
    NSString *moonStr = [self LunarForSolarYear:wCurYear Month:wCurMonth Day:wCurDay];
    
    NSArray *moonStrArray = [moonStr componentsSeparatedByString:@"-"];
    if([moonStrArray[0]isEqualToString:@"正月"] && [moonStrArray[1]isEqualToString:@"初一"]){
        moonStr = @"春节";
    }else if([moonStrArray[0]isEqualToString:@"正月"] &&[moonStrArray[1]isEqualToString:@"十五"]){
        moonStr = @"元宵节";
    }else if([moonStrArray[0]isEqualToString:@"五月"] && [moonStrArray[1]isEqualToString:@"初五"]){
        moonStr = @"端午节";
    }else if([moonStrArray[0]isEqualToString:@"七月"] && [moonStrArray[1]isEqualToString:@"初七"]){
        moonStr = @"七夕节";
    }else if([moonStrArray[0]isEqualToString:@"八月"] && [moonStrArray[1]isEqualToString:@"十五"]){
        moonStr = @"中秋节";
    }else if([moonStrArray[0]isEqualToString:@"九月"] && [moonStrArray[1]isEqualToString:@"初九"]){
        moonStr = @"重阳节";
    }else if([moonStrArray[0]isEqualToString:@"腊月"] && [moonStrArray[1]isEqualToString:@"初八"]){
        moonStr = @"腊八节";
    }else if([moonStrArray[0]isEqualToString:@"腊月"] && [moonStrArray[1]isEqualToString:@"三十"]){
        moonStr = @"除夕";
    }
    
    if (wCurMonth == 1 && wCurDay == 1) {
        moonStr = @"元旦";
    } else if (wCurMonth == 2 && wCurDay == 14) {
        moonStr = @"情人节";
    }else if (wCurMonth == 3 && wCurDay == 12) {
        moonStr = @"植树节";
    }else if (wCurMonth == 4 && wCurDay == 1) {
        moonStr = @"愚人节";
    }else if (wCurMonth == 5 && wCurDay == 1) {
        moonStr = @"劳动节";
    }else if (wCurMonth == 5 && wCurDay == 4) {
        moonStr = @"青年节";
    }else if (wCurMonth == 5 && wCurDay == 12) {
        moonStr = @"护士节";
    }else if (wCurMonth == 6 && wCurDay == 1) {
        moonStr = @"儿童节";
    }else if (wCurMonth == 8 && wCurDay == 1) {
        moonStr = @"建军节";
    }else if (wCurMonth == 9 && wCurDay == 10) {
        moonStr = @"教师节";
    }else if (wCurMonth == 10 && wCurDay == 1) {
        moonStr = @"国庆节";
    }else if (wCurMonth == 12 && wCurDay == 24) {
        moonStr = @"平安夜";
    }else if (wCurMonth == 12 && wCurDay == 25) {
        moonStr = @"圣诞节";
//    }else if (wCurMonth == 6 && wCurDay == 17) {
//        moonStr = @"纪念日";
//    }else if (wCurMonth == 1 && wCurDay == 21) {
//        moonStr = @"男神生日";
//    }else if (wCurMonth == 9 && wCurDay == 27) {
//        moonStr = @"女神生日";
    }
    return moonStr;
}

//获取农历
+ (NSString *)LunarForSolarYear:(int)wCurYear Month:(int)wCurMonth Day:(int)wCurDay
{
    //农历日期名
    NSArray *cDayName =  [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    //农历月份名
    NSArray *cMonName =  [NSArray arrayWithObjects:@"*",@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"冬月",@"腊月",nil];
    //公历每月前面的天数
    const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    //农历数据
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
        ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
        ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
        ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
        ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
        ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
        ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
        ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
        ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
        ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    static int nTheDate,nIsEnd,m,k,n,i,nBit;
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38;
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        nTheDate = nTheDate + 1;
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1) {
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0) {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            for(i=1;i<n+1;i++)
                nBit = nBit/2;
            nBit = nBit % 2;
            
            if (nTheDate <= (29 + nBit)) {
                nIsEnd = 1;
                break;
            }
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
    if (k == 12) {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            wCurMonth = 1 - wCurMonth;
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
    }
    //生成农历月
    NSString *szNongliMonth;
    if (wCurMonth < 1) {
        szNongliMonth = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];
    }else{
        szNongliMonth = (NSString *)[cMonName objectAtIndex:wCurMonth];
    }
    //生成农历日
    NSString *szNongliDay = [cDayName objectAtIndex:wCurDay];
    //合并
    NSString *lunarDate = [NSString stringWithFormat:@"%@-%@",szNongliMonth,szNongliDay];
    return lunarDate;
}
@end
