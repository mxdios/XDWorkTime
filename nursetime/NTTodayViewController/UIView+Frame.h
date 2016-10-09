//
//  UIView+Frame.h
//  qbd2015
//
//  Created by caohui on 15/5/16.
//  Copyright (c) 2015年 cch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, assign)CGFloat x;
@property (nonatomic, assign)CGFloat y;
@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, assign)CGFloat centerX;
@property (nonatomic, assign)CGFloat centerY;
@property (nonatomic, assign)CGSize size;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

@end
