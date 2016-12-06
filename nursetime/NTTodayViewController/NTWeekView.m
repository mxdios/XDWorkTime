//
//  NTWeekView.m
//  nursetime
//
//  Created by miaoxiaodong on 16/12/6.
//  Copyright © 2016年 inspiry. All rights reserved.
//

#import "NTWeekView.h"
#import "NSDate+extend.h"
#import "UIView+Frame.h"
#define setColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface NTWeekView()
{
    NSMutableArray *newDutyArray;
}
@property (nonatomic, assign)int32_t month;
@property (nonatomic, assign)int32_t year;
@property (nonatomic, assign)int32_t day;
@property (nonatomic, assign)int32_t week;
@property (nonatomic, strong)NSDate *today; //今天0点的时间

@end

@implementation NTWeekView
- (NSDate *)today {
    if (!_today) {
        NSDate *currentDate = [NSDate date];
        NSInteger tYear = currentDate.year;
        NSInteger tMonth = currentDate.month;
        NSInteger tDay = currentDate.day;
        //字符串转换为日期
        //实例化一个NSDateFormatter对象
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        _today =[dateFormat dateFromString:[NSString stringWithFormat:@"%@-%@-%@",@(tYear),@(tMonth),@(tDay)]];
        NSLog(@"当前时间 = %@", _today);
    }
    return _today;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        //获取当前年月
        NSDate *currentDate = [NSDate date];
        self.month = (int32_t)currentDate.month;
        self.year = (int32_t)currentDate.year;
        self.day = (int32_t)currentDate.day;
        self.week = (int32_t)currentDate.week;
        //    设置标题，设置日历内容
        [self showDateView:nil andSelectDayStr:nil andTags:nil];
    }
    return self;
}

/** 创建日历内容 */
- (void)showDateView:(NSMutableArray *)dutyArray andSelectDayStr:(NSString *)selectDayStr andTags:(NSMutableArray *)tags
{
    //在本地找
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.inspriy.nursetime"];
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[shared objectForKey:@"todayViewShared"]];
    
    dutyArray = [NSMutableArray arrayWithArray:dict[@"dutyArrayKey"]];
    selectDayStr = dict[@"selectDayStrKey"];
    tags = [NSMutableArray arrayWithArray:dict[@"selectTagArrayKey"]];;
    if (!(dutyArray.count && selectDayStr.length)) {//没排班了
        
    }
    
    //字符串转换为日期
    //实例化一个NSDateFormatter对象
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSInteger oneweek = self.week;
    if (oneweek == 1) {
        oneweek = 6;
    } else {
        oneweek -= 2;
    }
    
    NSDate *firstDay = [dateFormat dateFromString:[NSString stringWithFormat:@"%@-%@-%@",@(self.year),@(self.month),@(self.day - oneweek)]];
    
    NSDate *selectDay = [dateFormat dateFromString:selectDayStr];
    
    
    NSInteger day = ((NSInteger)[firstDay timeIntervalSince1970] - [selectDay timeIntervalSince1970]) / 86400;
    
    NSInteger index = 0;
    if (day < 0) {
        index = (dutyArray.count - (-day % (dutyArray.count ? dutyArray.count : 1)));
    } else {
        index = (day % (dutyArray.count ? dutyArray.count : 1));
    }
    if (dutyArray.count) {
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, index)];
        NSArray *testArray1 = [dutyArray objectsAtIndexes:indexSet];
        NSIndexSet *indexSet2 = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(index, dutyArray.count - index)];
        NSArray *testArray2 = [dutyArray objectsAtIndexes:indexSet2];
        newDutyArray = [NSMutableArray arrayWithArray:testArray2];
        [newDutyArray addObjectsFromArray:testArray1];
    }
    
    NSInteger startDayIndex = [NSDate acquireWeekDayFromDate:firstDay];
//
    if (startDayIndex == 1) {
        startDayIndex = 6;
    } else {
        startDayIndex -= 2;
    }
    CGFloat w = (self.width - 20) / 7;

    for(NSInteger i = 0; i < 7; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

        btn.userInteractionEnabled = NO;
        [btn setFrame:CGRectMake(w * i, 0, w, self.height / 3 * 2)];
        btn.backgroundColor = [UIColor clearColor];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [self addSubview:btn];
        [self sendSubviewToBack:btn];
        
        //在下面标班表
        UILabel *monthLab = [[UILabel alloc] initWithFrame:CGRectMake(w * i, btn.bottom - 10, w, self.height / 3)];
        monthLab.backgroundColor = [UIColor clearColor];
        monthLab.textAlignment = NSTextAlignmentCenter;
        monthLab.font = [UIFont systemFontOfSize:15];
        monthLab.textColor = [UIColor blackColor];
        [self addSubview:monthLab];
        
        if (newDutyArray.count) {
            monthLab.text = newDutyArray[(i - startDayIndex) % newDutyArray.count];
        } else {
            monthLab.hidden = YES;
        }
        
        NSDate *date = [firstDay dateByAddingTimeInterval:(i - startDayIndex) *24*60*60];
        
        NSString *title = [NSString stringWithFormat:@"%ld", date.day];
        [btn setBackgroundColor:[UIColor clearColor]];
        if(i - date.day > 6){//是1号
            title = nil;
            monthLab.hidden = YES;
        } else if ([date isToday]) {//是今天
            title = @"今天";
        }
        
        [btn setTitle:title forState:UIControlStateNormal];
        
        if ([self.today compare:date] <= 0) {
            //时间比今天大,同时是当前月
            [btn setTitleColor:[self setupTextColorWith:monthLab] forState:UIControlStateNormal];
            monthLab.textColor = btn.titleLabel.textColor;
        }else {
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            monthLab.textColor = [UIColor grayColor];
        }
        
    }
}
- (UIColor *)setupTextColorWith:(UILabel *)label
{
    if ([label.text isEqualToString:@"早"]) {
        return setColor(255, 48, 48);
    } else if ([label.text isEqualToString:@"午"]) {
        return setColor(255, 127, 80);
    } else if ([label.text isEqualToString:@"晚"]) {
        return setColor(60, 179, 113);
    } else if ([label.text isEqualToString:@"夜"]) {
        return setColor(46, 139, 87);
    } else if ([label.text isEqualToString:@"休"]) {
        return setColor(32, 178, 170);
    } else {
        return [UIColor blackColor];
    }
}
@end
