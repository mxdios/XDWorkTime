//
//  NTDutyView.m
//  nursetime
//
//  Created by inspiry on 15/10/22.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "NTSelectDutyView.h"

@implementation NTSelectDutyView
{
    NSMutableArray *_dutys;
    NSMutableArray *_selectDutys;
    UIButton *_backBtn;
    UILabel *_promptText;
    UIButton *_changeBtnInn;
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
    _selectDutys = [NSMutableArray array];
    _selectDutyArray = [NSMutableArray array];
    _selectTagArray = [NSMutableArray array];
    _dutys = [NSMutableArray arrayWithObjects:@"早", @"午", @"晚", @"夜", @"休", nil];
    
    NSArray *colorArray = [NSArray arrayWithObjects:setColor(255, 48, 48),setColor(255, 127, 80),setColor(60, 179, 113),setColor(46, 139, 87),setColor(32, 178, 170), nil];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.5, self.width, 0.5)];
    lineView.backgroundColor = NTBlue;
    [self addSubview:lineView];
    
    _backBtn = [[UIButton alloc] init];
    _backBtn.hidden = YES;
    [_backBtn setTitle:@"←回撤←" forState:UIControlStateNormal];
    _backBtn.titleLabel.font = NTFont(15);
    _backBtn.width = 100;
    _backBtn.height = 30;
    _backBtn.centerX = self.width * 0.5;
    _backBtn.centerY = self.height * 0.25;
    _backBtn.layer.cornerRadius = 3;
    _backBtn.clipsToBounds = YES;
    _backBtn.backgroundColor = [UIColor orangeColor];
    [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn];
    
    _promptText = [[UILabel alloc] init];
    _promptText.textAlignment = NSTextAlignmentCenter;
    _promptText.text = @"点击下面班名排班,长按可自定义班名";
    _promptText.textColor = NTBlue;
    _promptText.font = NTFont(15);
    _promptText.width = self.width;
    _promptText.height = 30;
    _promptText.x = 0;
    _promptText.centerY = self.height * 0.5;
    [self addSubview:_promptText];
    
    for (NSInteger i = 0; i < _dutys.count; i ++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        [btn setTitle:_dutys[i] forState:UIControlStateNormal];
        btn.titleLabel.font = NTFont(20);
        [btn setBackgroundColor:colorArray[i]];
        btn.width = 50;
        btn.height = 50;
        CGFloat gap = (NTViewWidth - btn.width * _dutys.count) / (_dutys.count + 1);
        btn.x = gap * (i + 1) + btn.width * i;
        btn.y = self.height - btn.height - 20;
        btn.layer.cornerRadius = 25;
        btn.clipsToBounds = YES;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(benLongPress:)];
        longPress.minimumPressDuration = 0.5; //定义按的时间
        [btn addGestureRecognizer:longPress];
    }
}
- (void)benLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(UIGestureRecognizerStateBegan == gestureRecognizer.state) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入自定义班名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        _changeBtnInn = (UIButton *)gestureRecognizer.view;
        [alertView textFieldAtIndex:0].text = _changeBtnInn.titleLabel.text;
        [alertView show];
    }
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self endEditing:YES];
    if (buttonIndex == 1 && [[[alertView textFieldAtIndex:0] text] length]) {
        if (1 == [[[alertView textFieldAtIndex:0] text] length]) {
            [_changeBtnInn setTitle:[[alertView textFieldAtIndex:0] text] forState:UIControlStateNormal];
        } else {
            [MBProgressHUD showText:@"班名只允许一个汉字,请重新修改"];
        }
    }
}
- (void)btnClick:(UIButton *)btn
{
    _backBtn.hidden = NO;
    _promptText.hidden = YES;
    
    if (_selectDutys.count > 6) {
        [MBProgressHUD showText:@"话说你的班有辣么复杂吗?~~"];
        return;
    }
    UIButton *selectBtn = [[UIButton alloc] init];
    selectBtn.tag = btn.tag;
    [selectBtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    selectBtn.titleLabel.font = NTFont(18);
    selectBtn.backgroundColor = NTBlue;
    selectBtn.width = 40;
    selectBtn.height = 40;
    selectBtn.layer.cornerRadius = 3;
    [_selectDutys addObject:selectBtn];
    
    [self setupSelectBtnsFrame];
}
- (void)setupSelectBtnsFrame
{
    [_selectDutyArray removeAllObjects];
    [_selectTagArray removeAllObjects];
    CGFloat gap = 10;
    CGFloat liftGap = (self.width - (_selectDutys.count * ((UIButton *)_selectDutys.firstObject).width + gap * (_selectDutys.count - 1))) / 2;
    for (NSInteger i = 0; i < _selectDutys.count; i ++) {
        UIButton *btn = _selectDutys[i];
        btn.x = (gap + btn.width) * i + liftGap;
        btn.centerY = self.height * 0.5;
        [self addSubview:btn];
        [_selectDutyArray addObject:btn.titleLabel.text];
        [_selectTagArray addObject:[NSString stringWithFormat:@"%ld", btn.tag]];
    }
}
- (void)backBtnClick
{
    UIButton *btn = _selectDutys.lastObject;
    [btn removeFromSuperview];
    [_selectDutys removeLastObject];
    [self setupSelectBtnsFrame];
    
    _backBtn.hidden = !_selectDutys.count;
    _promptText.hidden = _selectDutys.count;
}
@end
