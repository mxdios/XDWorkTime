//
//  HXUserHeadView.h
//  nursetime
//
//  Created by inspiry on 15/12/16.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXUserHeadView : UIView

@property (nonatomic, copy)void (^loginBlock)();

@property (nonatomic, copy)NSString *userName;
@end
