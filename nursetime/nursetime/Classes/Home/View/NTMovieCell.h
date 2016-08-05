//
//  NTMovieCell.h
//  nursetime
//
//  Created by 苗晓东 on 15/12/13.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTMovieCell : UITableViewCell

@property (nonatomic, strong)NSDictionary *dataDict;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
