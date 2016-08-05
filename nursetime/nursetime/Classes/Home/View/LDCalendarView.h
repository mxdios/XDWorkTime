//
//  LDCalendarView.h
//
//  Created by lidi on 15/9/1.
//  Copyright (c) 2015年 lidi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_RAT (SCREEN_WIDTH/320.0f)
#define INTTOSTR(intNum)         [@(intNum) stringValue]

@protocol LDCalendarViewDelegate <NSObject>
//警示框去排班
- (void)goPaiban;
/** 去写日记的页面 */
- (void)goWriteDiary:(NSString *)timeStr;

@end

@interface LDCalendarView : UIView

@property (nonatomic, weak) id<LDCalendarViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)initData;
/** 创建日历内容 */
- (void)showDateView:(NSMutableArray *)dutyArray andSelectDayStr:(NSString *)selectDayStr andTags:(NSMutableArray *)tags;
/** 显示或隐藏农历 */
- (void)setupMoonShowHidden;
@end
