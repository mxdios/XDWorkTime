//
//  NTSelectTimeView.m
//  nursetime
//
//  Created by inspiry on 15/10/22.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "NTSelectTimeView.h"
#import "NSDate+extend.h"

@implementation NTSelectTimeView
{
    UIDatePicker *datePickerView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSelfView];
    }
    return self;
}

- (void)setupSelfView
{
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, NTViewWidth / 2, 44)];
    _timeLabel.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld", [NSDate date].year, [NSDate date].month, [NSDate date].day];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.backgroundColor = NTBlue;
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = NTFont(20);
    [self addSubview:_timeLabel];
    
    HXSetBgColorBtn *back = [[HXSetBgColorBtn alloc] initWithFrame:CGRectMake(_timeLabel.right, 0, NTViewWidth / 2, 44)];
    [back setBackgroundColor:[UIColor colorWithRed:0.13f green:0.65f blue:1.00f alpha:1.00f] forState:UIControlStateNormal];
    [back setBackgroundColor:[UIColor colorWithRed:0.13f green:0.65f blue:1.00f alpha:0.50f] forState:UIControlStateHighlighted];
    [back setTitleColor:setAlpColor(255, 255, 255, 1.0) forState:UIControlStateNormal];
    [back setTitleColor:setAlpColor(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
    back.titleLabel.font = NTFont(20);
    [back setTitle:@"返回今天" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:back];

    
    datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, NTViewWidth, 200)];
    datePickerView.datePickerMode = UIDatePickerModeDate;
    NSString *minDateStr = @"1900-01-01";
    NSString *maxDateStr = @"2099-01-01";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *minDate = [dateFormat dateFromString:minDateStr];
    NSDate *maxDate = [dateFormat dateFromString:maxDateStr];
//    NSDate *maxDate = [NSDate date];
    datePickerView.minimumDate = minDate;
    datePickerView.maximumDate = maxDate;
    [datePickerView addTarget:self action:@selector(datePickerViewChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:datePickerView];
}
- (void)datePickerViewChange:(UIDatePicker *)datePicker
{
    NSDate *selected = [datePicker date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:selected];

    _timeLabel.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld", [comps year], [comps month], [comps day]];
    
}
- (void)backBtnClick
{
    [datePickerView setDate:[NSDate date] animated:YES];
    _timeLabel.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld", [NSDate date].year, [NSDate date].month, [NSDate date].day];
}
@end
