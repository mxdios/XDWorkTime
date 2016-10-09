//
//  LDCalendarView.m
//
//  Created by lidi on 15/9/1.
//  Copyright (c) 2015年 lidi. All rights reserved.
//

#import "LDCalendarView.h"
#import "NSDate+extend.h"

#define UNIT_WIDTH  35 * SCREEN_RAT

//行 列 每小格宽度 格子总数
static const NSInteger kRow = 7;
static const NSInteger kCol = 7;
static const NSInteger kTotalNum = (kRow - 1) * kCol;

@interface LDCalendarView()<UIAlertViewDelegate>
{
    UIView *_dateBgView;//日期的背景
    UIView  *_contentBgView;
    NSMutableArray *newDutyArray;
    NSMutableArray *newTagsArray;
    NSMutableArray *_moonArray;
    NSArray *_lastMoonArray;
}
@property (nonatomic, assign)int32_t month;
@property (nonatomic, assign)int32_t year;
@property (nonatomic, assign)int32_t day;
@property (nonatomic, strong)UILabel *titleLab;//标题
@property (nonatomic, strong)NSDate *today; //今天0点的时间
@end

@implementation LDCalendarView
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
        NTLog(@"当前时间 = %@", _today);
    }
    return _today;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgAlphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgAlphaView.backgroundColor = [UIColor clearColor];
        [self addSubview:bgAlphaView];
        _moonArray = [NSMutableArray array];
        _lastMoonArray = [NSArray arrayWithObjects:@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十", nil];
        //内容区的背景
        _contentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, NTViewWidth, NTViewHeight)];
        _contentBgView.userInteractionEnabled = YES;
        _contentBgView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentBgView];
        
        UIImageView *leftImage = [UIImageView new];
        leftImage.image = [UIImage imageNamed:@"com_arrows_right"];
        leftImage.transform=CGAffineTransformMakeRotation(M_PI);
        [_contentBgView addSubview:leftImage];
        leftImage.frame = CGRectMake(CGRectGetWidth(_contentBgView.frame)/3.0 - 8 - 10, (60-20)/2.0, 8, 20);
        
        UIImageView *rightImage = [UIImageView new];
        rightImage.image = [UIImage imageNamed:@"com_arrows_right"];
        [_contentBgView addSubview:rightImage];
        rightImage.frame = CGRectMake(CGRectGetWidth(_contentBgView.frame)*2/3.0 + 8, (60-20)/2.0, 8, 20);
    
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_contentBgView.frame), 60)];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.userInteractionEnabled = YES;
        [_contentBgView addSubview:_titleLab];
        
        UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchMonthTap:)];
        [_titleLab addGestureRecognizer:titleTap];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLab.frame) - 0.5, CGRectGetWidth(_contentBgView.frame), 0.5)];
        line.backgroundColor = NTBlue;
        [_contentBgView addSubview:line];
        
        _dateBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLab.frame), CGRectGetWidth(_contentBgView.frame), NTViewWidth)];
        _dateBgView.backgroundColor = [UIColor clearColor];
        
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [_dateBgView addGestureRecognizer:swipeGesture];
        
        UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [_dateBgView addGestureRecognizer:swipeGestureLeft];
        
        [_contentBgView addSubview:_dateBgView];
        
        //初始化数据
        [self initData];

    }
    return self;
}

-(void)swipeGesture:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft){
        [self rightSwitch];
    } else if (sender.direction == UISwipeGestureRecognizerDirectionRight){
        [self leftSwitch];
    }
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

- (void)switchMonthTap:(UITapGestureRecognizer *)tap
{
    CGPoint loc =  [tap locationInView:_titleLab];
    CGFloat titleLabWidth = CGRectGetWidth(_titleLab.frame);
    if (loc.x <= titleLabWidth/3.0) {
        //左
        [self leftSwitch];
    }else if(loc.x >= titleLabWidth/3.0*2.0){
        //右
        [self rightSwitch];
    }
}

- (void)leftSwitch{
    //左
    if (self.month > 1) {
        self.month -= 1;
    }else {
        self.month = 12;
        self.year -= 1;
    }
    
    [self showDateView:nil andSelectDayStr:nil andTags:nil];
}

- (void)rightSwitch {
    if (self.month < 12) {
        self.month += 1;
    }else {
        self.month = 1;
        self.year += 1;
    }
    
    [self showDateView:nil andSelectDayStr:nil andTags:nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NTLog(@"先想想");
    } else if (buttonIndex == 2){
        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        [userD setBool:YES forKey:keyAlertStr];
        [userD synchronize];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"泣血上谏" message:@"去排班吧!去排班吧!去排班吧!\n这个APP就是用来排班的,\n你不排班还用个蛋蛋啊!\n排班又不让你登录,表再墨迹了啊!\n去排班吧!去排班吧!去排班吧!\n重要的事情说三遍\n我over后,你要点导航栏右上角去排班啊!\n去排班吧!\n排班吧!\n班吧!\n吧!\n..." delegate:nil cancelButtonTitle:@"滚" otherButtonTitles:nil];
        [alertView show];
    } else {
        if ([self.delegate respondsToSelector:@selector(goPaiban)]) {
            [self.delegate goPaiban];
        }
    }
}
/** 创建日历内容 */
- (void)showDateView:(NSMutableArray *)dutyArray andSelectDayStr:(NSString *)selectDayStr andTags:(NSMutableArray *)tags
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (dutyArray.count && selectDayStr.length) {//第一次排班
        [userDefaults setValue:dutyArray forKey:@"dutyArrayKey"];
        [userDefaults setValue:selectDayStr forKey:@"selectDayStrKey"];
        [userDefaults setValue:tags forKey:@"selectTagArrayKey"];
        [userDefaults synchronize];
        
        NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.inspriy.nursetime"];
        [shared setObject:[NSDictionary dictionaryWithObjectsAndKeys:dutyArray, @"dutyArrayKey", selectDayStr, @"selectDayStrKey", tags, @"selectTagArrayKey", nil] forKey:@"todayViewShared"];
        [shared synchronize];
        
    } else {
        //在本地找
        dutyArray = [userDefaults mutableArrayValueForKey:@"dutyArrayKey"];
        selectDayStr = [userDefaults stringForKey:@"selectDayStrKey"];
        tags = [userDefaults mutableArrayValueForKey:@"selectTagArrayKey"];
        if (!(dutyArray.count && selectDayStr.length)) {//没排班了
            if (![userDefaults boolForKey:keyAlertStr]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"你还没有排班呢~去排班吧~" delegate:self cancelButtonTitle:@"虚心纳谏前往" otherButtonTitles:@"容朕思索一番",@"别再哔哔没完", nil];
                [alertView show];
            }
        }
    }
    _titleLab.text = [NSString stringWithFormat:@"%@年-%@月",@(self.year),@(self.month)];
    
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
    for(int i = 0 ;i < 7; i++)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:baseRect];
        lab.textColor = NTBlue;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont boldSystemFontOfSize:22];
        lab.backgroundColor = [UIColor clearColor];
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
    NTLog(@"startdayindex = %ld", startDayIndex);
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
        [btn setFrame:CGRectMake(baseRect.origin.x, baseRect.origin.y, baseRect.size.width, baseRect.size.height)];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, baseRect.size.height / 3 * 2, 0);
        btn.backgroundColor = [UIColor clearColor];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [btn addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_dateBgView addSubview:btn];
        [_dateBgView sendSubviewToBack:btn];
        
        //在下面标班表
        UILabel *monthLab = [[UILabel alloc] initWithFrame:CGRectMake(baseRect.origin.x, btn.y + baseRect.size.height / 3, baseRect.size.width, baseRect.size.height / 3)];
        monthLab.backgroundColor = [UIColor clearColor];
        monthLab.textAlignment = NSTextAlignmentCenter;
        monthLab.font = [UIFont systemFontOfSize:15];
        monthLab.textColor = [UIColor blackColor];
        [_dateBgView addSubview:monthLab];
        
        UILabel *moonLab = [[UILabel alloc] initWithFrame:CGRectMake(baseRect.origin.x, monthLab.bottom, baseRect.size.width, baseRect.size.height / 3)];
        moonLab.backgroundColor = [UIColor clearColor];
        moonLab.textAlignment = NSTextAlignmentCenter;
        moonLab.font = [UIFont systemFontOfSize:8];
        moonLab.textColor = [UIColor grayColor];
        moonLab.hidden = [[NSUserDefaults standardUserDefaults] boolForKey:keyMoonShowHidden];
        [_dateBgView addSubview:moonLab];
        
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
            moonLab.hidden = YES;
        } else if ([date isToday]) {//是今天
            title = @"今天";
            UIView *dayView = [[UIView alloc] initWithFrame:baseRect];
            dayView.y -= 2;
            dayView.backgroundColor = setColor(31, 146, 254);
            dayView.layer.cornerRadius = 2;
            [_dateBgView addSubview:dayView];
            [_dateBgView sendSubviewToBack:dayView];
        }
        if (i - date.day <= 6) {
            [_moonArray addObject:moonLab];
        }
        
        [btn setTitle:title forState:UIControlStateNormal];
        
        NSString *moonStr = [HXCommonTool setupFeastMoonYear:self.year Month:self.month Day:INTTOSTR(date.day).intValue];
        moonLab.text = moonStr;
        NSString *lastMoon = [moonStr substringFromIndex:moonStr.length - 1];
        if (![_lastMoonArray containsObject:lastMoon]) {
            moonLab.textColor = [UIColor orangeColor];
        }
        
        if ([self.today compare:date] <= 0) {
            //时间比今天大,同时是当前月
            [btn setTitleColor:[HXCommonTool setupTextColorWith:monthLab] forState:UIControlStateNormal];
            monthLab.textColor = btn.titleLabel.textColor;
        }else {
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            monthLab.textColor = [UIColor grayColor];
            moonLab.textColor = [UIColor grayColor];
        }
        
        baseRect.origin.x += (baseRect.size.width);
    }
}
- (void)timeBtnClick:(UIButton *)btn
{
    NTLog(@"点击 = %@  %ld",btn.titleLabel.text, btn.tag);
    if (btn.titleLabel.text) {
        NSString *timeStr;
        if ([btn.titleLabel.text isEqualToString:@"今天"]) {
            timeStr = [NSString stringWithFormat:@"%d-%02d-%02d", self.year, self.month, self.day];
        } else {
            timeStr = [NSString stringWithFormat:@"%d-%02d-%02d", self.year, self.month, [btn.titleLabel.text intValue]];
        }
        if ([self.delegate respondsToSelector:@selector(goWriteDiary:)]) {
            [self.delegate goWriteDiary:timeStr];
        }
    }
}
/** 显示或隐藏农历 */
- (void)setupMoonShowHidden
{
//    moonLab.hidden = !moonLab.hidden;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    for (UILabel *moonL in _moonArray) {
        moonL.hidden = !moonL.hidden;
    }
    [user setBool:((UILabel *)_moonArray[0]).hidden forKey:keyMoonShowHidden];
    [user synchronize];
}
- (void)dealloc
{
    self.delegate = nil;
}
@end
