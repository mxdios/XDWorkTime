//
//  NTTodayCalendarView.m
//  nursetime
//
//  Created by miaoxiaodong on 16/10/9.
//  Copyright © 2016年 inspiry. All rights reserved.
//

#import "NTTodayCalendarView.h"
#import "UIView+Frame.h"
#import "NSDate+extend.h"


#define UNIT_WIDTH  35 * SCREEN_RAT
//view的宽度
#define NTViewWidth [UIScreen mainScreen].bounds.size.width
//view的宽度
#define NTViewHeight [UIScreen mainScreen].bounds.size.height

#define NTBlue [UIColor colorWithRed:0.13f green:0.65f blue:1.00f alpha:1.00f]

#define setColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


//行 列 每小格宽度 格子总数
static const NSInteger kRow = 7;
static const NSInteger kCol = 7;
static const NSInteger kTotalNum = (kRow - 1) * kCol;

@interface NTTodayCalendarView()
{
    UIView *_dateBgView;//日期的背景
    UIView  *_contentBgView;
    NSMutableArray *newDutyArray;
    NSMutableArray *newTagsArray;
}
@property (nonatomic, assign)int32_t month;
@property (nonatomic, assign)int32_t year;
@property (nonatomic, assign)int32_t day;
@property (nonatomic, strong)UILabel *titleLab;//标题
@property (nonatomic, strong)NSDate *today; //今天0点的时间
@end

@implementation NTTodayCalendarView

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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //内容区的背景
        _contentBgView = [[UIView alloc] initWithFrame:self.bounds];
        _contentBgView.userInteractionEnabled = YES;
        _contentBgView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentBgView];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_contentBgView.frame), 30)];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.backgroundColor = NTBlue;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.userInteractionEnabled = YES;
        [_contentBgView addSubview:_titleLab];
        
        _dateBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLab.frame), self.width - 20, self.width - 50)];
        _dateBgView.backgroundColor = [UIColor clearColor];
        
        [_contentBgView addSubview:_dateBgView];
        
        //初始化数据
        [self initData];
        
    }
    return self;
}

- (void)initData
{
    //获取当前年月
    NSDate *currentDate = [NSDate date];
    self.month = (int32_t)currentDate.month;
    self.year = (int32_t)currentDate.year;
    self.day = (int32_t)currentDate.day;
    //    设置标题，设置日历内容
    [self showDateView:nil andSelectDayStr:nil andTags:nil];
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
    
    _titleLab.text = [NSString stringWithFormat:@"%@年%@月%@日",@(self.year),@(self.month),@(self.day)];
    
    //移除之前子视图
    [_dateBgView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    CGFloat offX = 0.0;
    CGFloat offY = 0.0;
    CGFloat w = (CGRectGetWidth(_dateBgView.frame)) / kCol;
    CGFloat h = (CGRectGetHeight(_dateBgView.frame)) / kRow;
    CGRect baseRect = CGRectMake(offX,offY, w, h);
    NSArray *tmparr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    for(NSInteger i = 0; i < 7; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:baseRect];
        lab.textColor = [UIColor blackColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:18];
        lab.text = [tmparr objectAtIndex:i];
        [_dateBgView addSubview:lab];
        
        baseRect.origin.x += baseRect.size.width;
    }
    
    //字符串转换为日期
    //实例化一个NSDateFormatter对象
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *firstDay =[dateFormat dateFromString:[NSString stringWithFormat:@"%@-%@-%@",@(self.year),@(self.month),@(1)]];
    
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
        
        if (tags.count) {
            
            NSArray *tagsArray1 = [tags objectsAtIndexes:indexSet];
            NSArray *tagsArray2 = [tags objectsAtIndexes:indexSet2];
            newTagsArray = [NSMutableArray arrayWithArray:tagsArray2];
            [newTagsArray addObjectsFromArray:tagsArray1];
        }
    }
    
    NSInteger startDayIndex = [NSDate acquireWeekDayFromDate:firstDay];
    NSLog(@"startdayindex = %ld", startDayIndex);
    //第一天是今天，特殊处理
    if (startDayIndex == 1) {
        //星期天（对应一）
        startDayIndex = 6;
    } else {
        //周一到周六（对应2-7）
        startDayIndex -= 2;
    }
    
    baseRect.origin.x = w * startDayIndex;
    baseRect.origin.y += (baseRect.size.height);
    NSInteger baseTag = 100;
    for(NSInteger i = startDayIndex; i < kTotalNum;i++) {
        if (i % kCol == 0 && i!= 0) {
            baseRect.origin.y += (baseRect.size.height);
            baseRect.origin.x = offX;
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = baseTag + i;
        btn.userInteractionEnabled = NO;
        [btn setFrame:CGRectMake(baseRect.origin.x, baseRect.origin.y, baseRect.size.width, baseRect.size.height)];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, baseRect.size.height / 3 * 2, 0);
        btn.backgroundColor = [UIColor clearColor];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [_dateBgView addSubview:btn];
        [_dateBgView sendSubviewToBack:btn];
        
        //在下面标班表
        UILabel *monthLab = [[UILabel alloc] initWithFrame:CGRectMake(baseRect.origin.x, btn.y + baseRect.size.height / 3, baseRect.size.width, baseRect.size.height / 3)];
        monthLab.backgroundColor = [UIColor clearColor];
        monthLab.textAlignment = NSTextAlignmentCenter;
        monthLab.font = [UIFont systemFontOfSize:15];
        monthLab.textColor = [UIColor blackColor];
        [_dateBgView addSubview:monthLab];
        
        if (newDutyArray.count) {
            monthLab.text = newDutyArray[(i - startDayIndex) % newDutyArray.count];
            if (newTagsArray.count) {
                monthLab.tag = [newTagsArray[(i - startDayIndex) % newTagsArray.count] integerValue];
            } else {
                monthLab.tag = 100;
            }
        } else {
            monthLab.hidden = YES;
        }
        
        NSDate * date = [firstDay dateByAddingTimeInterval:(i - startDayIndex) *24*60*60];
        
        NSString *title = INTTOSTR(date.day);
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
        
        baseRect.origin.x += (baseRect.size.width);
    }
}
- (UIColor *)setupTextColorWith:(UILabel *)label
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
@end
