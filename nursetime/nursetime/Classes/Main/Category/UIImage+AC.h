//
//  UIImage+AC.h
//  airconditioner
//
//  Created by 苗晓东 on 15/7/9.
//  Copyright (c) 2015年 miaoxiaodong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AC)
/**
 *  拉伸图片
 */
+ (UIImage *)pullImage:(NSString *)imageName;

/**
 *  拉伸图片，可指定拉伸位置
 */
+ (UIImage *)pullImage:(NSString *)imageName leftRatio:(CGFloat)leftratio topRatio:(CGFloat)topratio;

@end
