//
//  NTPaibanViewController.m
//  nursetime
//
//  Created by inspiry on 15/10/21.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "NTPaibanViewController.h"
#import "NTSelectDutyView.h"
#import "NTSelectTimeView.h"

@interface NTPaibanViewController ()

@end

@implementation NTPaibanViewController
{
    NTSelectDutyView *_selectDutyView;
    NTSelectTimeView *_selectTimeView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"排班";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(savePaiban)];
    [self setupSelfView];
}
- (void)setupSelfView
{
    _selectDutyView = [[NTSelectDutyView alloc] initWithFrame:CGRectMake(0, 64, NTViewWidth, (NTViewHeight - 64) / 2)];
    [self.view addSubview:_selectDutyView];
    
    _selectTimeView = [[NTSelectTimeView alloc] initWithFrame:CGRectMake(0, _selectDutyView.bottom, NTViewWidth, _selectDutyView.height)];
    [self.view addSubview:_selectTimeView];
}
- (void)savePaiban
{
    if ([self.delegate respondsToSelector:@selector(selectDutyTime:andButy:andTag:)]) {
        [self.delegate selectDutyTime:_selectTimeView.timeLabel.text andButy:_selectDutyView.selectDutyArray andTag:_selectDutyView.selectTagArray];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc
{
    self.delegate = nil;
}
@end
