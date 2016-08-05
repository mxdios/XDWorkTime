//
//  NTWriteDiaryViewController.m
//  nursetime
//
//  Created by inspiry on 15/12/17.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "NTWriteDiaryViewController.h"
#import "NTTextView.h"

@interface NTWriteDiaryViewController ()
{
    NTTextView *_textView;
    HXSetBgColorBtn *_upDataBtn;
}
@end

@implementation NTWriteDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (NTThirty_FiveInch) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    }
    if (self.bmobObject) {
        self.title = @"更新事项";
    } else {
        self.title = @"记录事项";
    }
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, NTViewWidth, 20)];
    time.text = [NSString stringWithFormat:@"事项时间: %@",self.timeStr ? self.timeStr : [self.bmobObject objectForKey:@"addtime"]];
    time.font = NTFont(20);
    time.textColor = [UIColor grayColor];
    time.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:time];
    
    _textView = [[NTTextView alloc] initWithFrame:CGRectMake(10, time.bottom + 10, self.view.width - 20, 200)];
    if (self.bmobObject) {
        _textView.text = [self.bmobObject objectForKey:@"content"];
    }
    _textView.font = NTFont(15);
    _textView.placeStr = @"输入您要记录的事项";
    [_textView becomeFirstResponder];
    [self.view addSubview:_textView];
    
    
    _upDataBtn = [[HXSetBgColorBtn alloc] init];
    [_upDataBtn setBackgroundColor:[UIColor colorWithRed:0.13f green:0.65f blue:1.00f alpha:1.00f] forState:UIControlStateNormal];
    [_upDataBtn setBackgroundColor:[UIColor colorWithRed:0.13f green:0.65f blue:1.00f alpha:0.50f] forState:UIControlStateHighlighted];
    [_upDataBtn setTitleColor:setAlpColor(255, 255, 255, 1.0) forState:UIControlStateNormal];
    [_upDataBtn setTitleColor:setAlpColor(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
    _upDataBtn.titleLabel.font = NTFont(15);
    [_upDataBtn setTitle:self.bmobObject ? @"更新记录" : @"添加记录" forState:UIControlStateNormal];
    [_upDataBtn addTarget:self action:@selector(upDataBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _upDataBtn.width = 200;
    _upDataBtn.height = 40;
    _upDataBtn.layer.cornerRadius = 4;
    _upDataBtn.centerX = self.view.width * 0.5;
    _upDataBtn.y = _textView.bottom + 10;
    [self.view addSubview:_upDataBtn];
    
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _textView.height = self.view.height - kbSize.height - _textView.y;
    _upDataBtn.y = _textView.bottom + 10;
}
- (void)upDataBtnClick
{
    if (!_textView.text.length) {
        [MBProgressHUD showText:@"请输入内容"];
        return;
    }
    [self.view endEditing:YES];
    if (self.timeStr) {
        BmobUser *bUser = [BmobUser getCurrentUser];
        BmobObject  *gameScore = [BmobObject objectWithClassName:@"Diary"];
        [gameScore setObject:[bUser objectForKey:@"username"] forKey:@"username"];
        [gameScore setObject:[NSString stringWithFormat:@"%ld", [[bUser objectForKey:@"userid"] integerValue]] forKey:@"userid"];
        [gameScore setObject:[bUser objectForKey:@"email"] forKey:@"email"];
        [gameScore setObject:self.timeStr forKey:@"addtime"];
        [gameScore setObject:_textView.text forKey:@"content"];
        [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [MBProgressHUD showText:@"记录成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [MBProgressHUD showText:@"记录失败"];
            }
        }];
    } else {
        [self.bmobObject setObject:_textView.text forKey:@"content"];
        [self.bmobObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [MBProgressHUD showText:@"更新成功"];
                if (self.upDataRefreshListBlock) {
                    self.upDataRefreshListBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [MBProgressHUD showText:@"更新失败"];
            }
        }];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.upDataRefreshListBlock = nil;
}
@end
