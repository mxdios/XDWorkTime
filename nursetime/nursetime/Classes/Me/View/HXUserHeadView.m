//
//  HXUserHeadView.m
//  nursetime
//
//  Created by inspiry on 15/12/16.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "HXUserHeadView.h"

@implementation HXUserHeadView
{
    UIButton *_userBtn;
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
    self.backgroundColor = NTBlue;
    _userBtn = [[UIButton alloc] init];
    [_userBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _userBtn.titleLabel.font = NTFont(18);
    [_userBtn addTarget:self action:@selector(userBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_userBtn];
}
- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    [_userBtn setTitle:userName forState:UIControlStateNormal];
    [_userBtn sizeToFit];
    _userBtn.centerX = self.width * 0.5;
    _userBtn.centerY = self.height * 0.5;
}
- (void)userBtnClick:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@"未登录,点击登录"]) {//未登录
        self.loginBlock();
    } else {
        
    }
}
- (void)dealloc
{
    self.loginBlock = nil;
}
@end
