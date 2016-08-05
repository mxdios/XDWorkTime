//
//  HXTextField.m
//  hanxin
//
//  Created by 苗晓东 on 15/11/28.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "HXTextField.h"

@implementation HXTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *vie = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 1)];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.leftView = vie;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.textColor = [UIColor whiteColor];
        self.font = NTFont(15);
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = frame.size.height * 0.5;
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}
@end
