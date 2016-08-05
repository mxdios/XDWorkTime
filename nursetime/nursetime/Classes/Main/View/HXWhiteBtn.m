//
//  HXWhiteBtn.m
//  hanxinkehu
//
//  Created by inspiry on 15/12/4.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "HXWhiteBtn.h"

@implementation HXWhiteBtn


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor colorWithRed:0.31f green:0.69f blue:0.98f alpha:1.00f] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:0.31f green:0.69f blue:0.98f alpha:0.50f] forState:UIControlStateHighlighted];
        [self setBackgroundColor:setAlpColor(255, 255, 255, 1.0) forState:UIControlStateNormal];
        [self setBackgroundColor:setAlpColor(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
        self.titleLabel.font = NTFont(18);
        self.layer.cornerRadius = self.height * 0.5;
    }
    return self;
}


@end
