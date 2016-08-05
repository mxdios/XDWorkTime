//
//  NTPaibanViewController.h
//  nursetime
//
//  Created by inspiry on 15/10/21.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NTPaibanViewControllerDelegate <NSObject>

/** 排版选时间和班表 */
- (void)selectDutyTime:(NSString *)time andButy:(NSMutableArray *)buty andTag:(NSMutableArray *)tags;

@end

@interface NTPaibanViewController : UIViewController

@property (nonatomic, weak)id<NTPaibanViewControllerDelegate> delegate;
@end
