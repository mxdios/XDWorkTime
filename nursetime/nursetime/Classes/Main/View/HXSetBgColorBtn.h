//
//  HXSetBgColorBtn.h
//  hanxin
//
//  Created by 苗晓东 on 15/11/28.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSetBgColorBtn : UIButton
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
- (UIColor *)backgroundColorForState:(UIControlState)state;
@end
