//
//  NTTextView.m
//  nursetime
//
//  Created by inspiry on 15/12/17.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "NTTextView.h"

@implementation NTTextView
{
    UILabel *_plaveLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _plaveLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.width, 15)];
        _plaveLabel.font = self.font;
        _plaveLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_plaveLabel];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChange) name:UITextViewTextDidChangeNotification object:self];
        self.layer.cornerRadius = 2;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1;
    }
    return self;
}
- (void)setPlaceStr:(NSString *)placeStr
{
    _placeStr = placeStr;
    _plaveLabel.text = _placeStr;
    if (self.text.length) {
        _plaveLabel.hidden = YES;
    }
}
- (void)textViewChange
{
    if (self.text.length) {
        _plaveLabel.hidden = YES;
    } else {
        _plaveLabel.hidden = NO;
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
