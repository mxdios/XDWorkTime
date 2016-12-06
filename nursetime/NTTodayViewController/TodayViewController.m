//
//  TodayViewController.m
//  NTTodayViewController
//
//  Created by miaoxiaodong on 16/10/8.
//  Copyright © 2016年 inspiry. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "NTTodayCalendarView.h"
#import "NTWeekView.h"
#import "UIView+Frame.h"

@interface TodayViewController () <NCWidgetProviding>
{
    NTTodayCalendarView *_calendarView;
    NTWeekView *_weekView;
}
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _calendarView = [[NTTodayCalendarView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_calendarView];
    
    _weekView = [[NTWeekView alloc] initWithFrame:CGRectMake(0, 60, self.view.width, 60)];
    _weekView.hidden = YES;
    [self.view addSubview:_weekView];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openApp)];
    [_calendarView addGestureRecognizer:tap];
    [self.view addGestureRecognizer:tap];

    
#ifdef __IPHONE_10_0 //因为是iOS10才有的，还请记得适配
    //如果需要折叠
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
#endif
    
//    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 400);

}
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        _weekView.hidden = NO;
        _calendarView.height = 70;
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 120);
    } else {
        _weekView.hidden = YES;
        _calendarView.height = 500;
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 350);
    }
    _calendarView.clipsToBounds = YES;
}
//
- (void)openApp
{
    [self.extensionContext openURL:[NSURL URLWithString:@"paibanapp://"] completionHandler:^(BOOL success) {
        NSLog(@"successs = %d", success);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
