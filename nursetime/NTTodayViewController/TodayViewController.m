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

@interface TodayViewController () <NCWidgetProviding>
{
    NTTodayCalendarView *_calendarView;
}
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
//    _contentView = [[UIButton alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:_contentView];
//    [_contentView addTarget:self action:@selector(openApp) forControlEvents:UIControlEventTouchUpInside];
    
    
    _calendarView = [[NTTodayCalendarView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_calendarView];

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
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
    } else {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 400);
    }
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
