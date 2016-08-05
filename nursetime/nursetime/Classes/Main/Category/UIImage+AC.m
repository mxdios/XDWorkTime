//
//  UIImage+AC.m
//  airconditioner
//
//  Created by 苗晓东 on 15/7/9.
//  Copyright (c) 2015年 miaoxiaodong. All rights reserved.
//

#import "UIImage+AC.h"

@implementation UIImage (AC)
+ (UIImage *)pullImage:(NSString *)imageName
{
    return [self pullImage:imageName leftRatio:0.5 topRatio:0.5];
}

+ (UIImage *)pullImage:(NSString *)imageName leftRatio:(CGFloat)leftratio topRatio:(CGFloat)topratio
{
    UIImage *pullImage = [UIImage imageNamed:imageName];
    CGFloat left = pullImage.size.width * leftratio;
    CGFloat top = pullImage.size.height * topratio;
    return [pullImage stretchableImageWithLeftCapWidth:left topCapHeight:top];
}

@end
