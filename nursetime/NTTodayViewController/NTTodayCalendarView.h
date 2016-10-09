//
//  NTTodayCalendarView.h
//  nursetime
//
//  Created by miaoxiaodong on 16/10/9.
//  Copyright © 2016年 inspiry. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_RAT (SCREEN_WIDTH/320.0f)
#define INTTOSTR(intNum)         [@(intNum) stringValue]

@interface NTTodayCalendarView : UIView

- (id)initWithFrame:(CGRect)frame;

@end
