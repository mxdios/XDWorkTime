//
//  NTWriteDiaryViewController.h
//  nursetime
//
//  Created by inspiry on 15/12/17.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTWriteDiaryViewController : UIViewController
/**
 *  事项时间，添加事项的时候才有
 */
@property (nonatomic, copy)NSString *timeStr;
/**
 *  事项数据，更新数据才传进来
 */
@property (nonatomic, strong)BmobObject *bmobObject;
/**
 *  刷新列表的block
 */
@property (nonatomic, copy)void (^upDataRefreshListBlock)();
@end
