//
//  NTDiaryListCell.h
//  nursetime
//
//  Created by inspiry on 15/12/18.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTDiaryListCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)BmobObject *bmobObject;
@end
