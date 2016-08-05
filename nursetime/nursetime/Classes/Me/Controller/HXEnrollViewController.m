//
//  HXEnrollViewController.m
//  hanxin
//
//  Created by 苗晓东 on 15/11/28.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "HXEnrollViewController.h"
#import "HXTextField.h"
#import "HXWhiteBtn.h"
#import "NSString+Hash.h"

@interface HXEnrollViewController ()<UITextFieldDelegate>
{
    HXTextField *_phoneNum;
    HXTextField *_nameText;
    HXTextField *_passWord;
    HXTextField *_affirmPassWord;
}
@end

@implementation HXEnrollViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self setupSelfView];
}
- (void)setupSelfView
{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:bg];
    
    _nameText = [[HXTextField alloc] initWithFrame:CGRectMake(60,100, NTViewWidth - 120, 40)];
    _nameText.placeholder = @"用户名";
    //    [_nameText addTarget:self action:@selector(inputTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_nameText];
    
    _phoneNum = [[HXTextField alloc] initWithFrame:CGRectMake(60, _nameText.bottom + 15, NTViewWidth - 120, 40)];
    _phoneNum.placeholder = @"邮箱";
    _phoneNum.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:_phoneNum];
    
    _passWord = [[HXTextField alloc] initWithFrame:CGRectMake(60, _phoneNum.bottom + 15, NTViewWidth - 120, 40)];
    _passWord.secureTextEntry = YES;
    _passWord.delegate = self;
    _passWord.placeholder = @"密码";
    [self.view addSubview:_passWord];
    //
    _affirmPassWord = [[HXTextField alloc] initWithFrame:CGRectMake(60, _passWord.bottom + 15, NTViewWidth - 120, 40)];
    _affirmPassWord.placeholder = @"再次输入密码";
    _affirmPassWord.delegate = self;
    _affirmPassWord.secureTextEntry = YES;
    [self.view addSubview:_affirmPassWord];
    
    HXWhiteBtn *btn = [[HXWhiteBtn alloc] initWithFrame:CGRectMake(60, _affirmPassWord.bottom + 15, NTViewWidth - 120, 40)];
    [btn setTitle:@"立即注册" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(enrollBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)enrollBtnClick
{
    [self.view endEditing:YES];
    if (!_nameText.text.length) {
        [MBProgressHUD showText:@"用户名不能为空"];
        return;
    }
    if (![HXCommonTool isValidateEmail:_phoneNum.text]) {
        [MBProgressHUD showError:@"请输入正确的邮箱"];
        return;
    }
    if (_passWord.text.length < 6) {
        [MBProgressHUD showText:@"密码至少为6位"];
        return;
    }
    if (![_passWord.text isEqualToString:_affirmPassWord.text]) {
        [MBProgressHUD showText:@"两次输入的密码不相同"];
        return;
    }
    
    BmobUser *bUser = [[BmobUser alloc] init];
    bUser.username = _nameText.text;
    bUser.password = [[NSString stringWithFormat:@"%@%@",_passWord.text, keyMD5] md5String];
    NTLog(@"加密 = %@", [[NSString stringWithFormat:@"%@%@",_passWord.text, keyMD5] md5String]);
    bUser.email = _phoneNum.text;
    [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        NTLog(@"is  %d  错误 = %@ 错误码= %ld", isSuccessful, error, error.code);
        if (isSuccessful) {
            [MBProgressHUD showText:@"注册成功"];
            [BmobUser loginInbackgroundWithAccount:_nameText.text andPassword:[[NSString stringWithFormat:@"%@%@",_passWord.text, keyMD5] md5String] block:^(BmobUser *user, NSError *error) {
                NTLog(@"登录 = %@", error);
                [self.navigationController popToRootViewControllerAnimated:YES];
                if (error) {
                    [MBProgressHUD showText:@"请登录"];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:keyLoginNot object:nil];
                }
            }];
        } else if (202 == error.code) {
            [MBProgressHUD showText:@"此用户名已存在"];
        } else if (203 == error.code) {
            [MBProgressHUD showText:@"此邮箱已注册"];
        }
    }];
}
- (void)inputTextField:(HXTextField *)textField
{
    if (textField == _phoneNum && textField.text.length > 11){
        textField.text = [textField.text substringToIndex:11];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (NTThirty_FiveInch) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -70);
        }];
    }
}
- (void)keyboardWillHide:(NSNotification *)not
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
