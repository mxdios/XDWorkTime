//
//  NTWeatherView.h
//  nursetime
//
//  Created by inspiry on 15/12/14.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NTWeatherViewDelegate <NSObject>
/** 更新天气 */
- (void)gengxinTianqi:(NSString *)chengshi;

@end

@interface NTWeatherView : UIView <UIAlertViewDelegate>
@property (nonatomic, strong)NSDictionary *weatherDict;
@property (nonatomic, weak) id<NTWeatherViewDelegate> delegate;
@end
