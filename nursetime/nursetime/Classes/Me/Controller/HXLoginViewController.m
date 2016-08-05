//
//  HXMeViewController.m
//  hanxin
//
//  Created by inspiry on 15/11/20.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "HXLoginViewController.h"
#import "HXEnrollViewController.h"
#import "HXTextField.h"
#import "HXWhiteBtn.h"
#import "NSString+Hash.h"

@interface HXLoginViewController ()
{
    HXTextField *_phoneNum;
    HXTextField *_passWord;
    UIButton *_goEnroll;
}
@end

@implementation HXLoginViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [self setupSelfView];
}
- (void)setupSelfView
{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:bg];
    
    _phoneNum = [[HXTextField alloc] initWithFrame:CGRectMake(60, 150, NTViewWidth - 120, 40)];
    _phoneNum.placeholder = @"用户名/注册邮箱";
    _phoneNum.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:_phoneNum];
    
    _passWord = [[HXTextField alloc] initWithFrame:CGRectMake(60, _phoneNum.bottom + 15, NTViewWidth - 120, 40)];
    _passWord.placeholder = @"密码";
    _passWord.secureTextEntry = YES;
    [self.view addSubview:_passWord];
    
    HXWhiteBtn *btn = [[HXWhiteBtn alloc] initWithFrame:CGRectMake(60, _passWord.bottom + 15, NTViewWidth - 120, 40)];
    [btn setTitle:@"立即登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    _goEnroll = [[UIButton alloc] initWithFrame:CGRectMake(80, btn.bottom + 10, NTViewWidth - 160, 15)];
    [_goEnroll setTitle:@"还没有账号? | 立即注册" forState:UIControlStateNormal];
    _goEnroll.titleLabel.font = NTFont(15);
    [_goEnroll setTitleColor:setAlpColor(255, 255, 255, 1.0) forState:UIControlStateNormal];
    [_goEnroll setTitleColor:setAlpColor(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
    [_goEnroll addTarget:self action:@selector(goEnrollBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_goEnroll];
    
}
- (void)loginBtnClick
{
    if (!_phoneNum.text.length) {
        [MBProgressHUD showText:@"请输入用户名或注册邮箱"];
        return;
    }
    if (_passWord.text.length < 6) {
        [MBProgressHUD showText:@"密码至少为6位"];
        return;
    }
    
    [BmobUser loginInbackgroundWithAccount:_phoneNum.text andPassword:[[NSString stringWithFormat:@"%@%@",_passWord.text, keyMD5] md5String] block:^(BmobUser *user, NSError *error) {
        if (error) {
            NTLog(@"错误 = %@， %ld", error, error.code);
            if (101 == error.code) {
                [MBProgressHUD showText:@"用户名/邮箱或密码错误"];
            }
        } else {
            [MBProgressHUD showText:@"登录成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:keyLoginNot object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    
}
- (void)goEnrollBtnClick
{
    [self.navigationController pushViewController:[[HXEnrollViewController alloc] init] animated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
