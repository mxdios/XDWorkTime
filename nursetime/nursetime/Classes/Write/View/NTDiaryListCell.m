//
//  NTDiaryListCell.m
//  nursetime
//
//  Created by inspiry on 15/12/18.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "NTDiaryListCell.h"

@implementation NTDiaryListCell
{
    UILabel *_time;
    UILabel *_content;
    UIView *_line;
    UILabel *_createdTime;
    UILabel *_updatedTime;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView;
{
    static NSString *ID = @"NTDiaryListCell";
    NTDiaryListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NTDiaryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //        添加页面内容视图
        [self setupSelfView];
    }
    return self;
}
- (void)setupSelfView
{
    _time = [[UILabel alloc] init];
    _time.textColor = [UIColor grayColor];
    _time.font = NTFont(18);
    [self.contentView addSubview:_time];
    
    _content = [[UILabel alloc] init];
    _content.textColor = [UIColor blackColor];
    _content.font = NTFont(18);
    _content.numberOfLines = 0;
    [self.contentView addSubview:_content];
    
    _createdTime = [[UILabel alloc] init];
    _createdTime.textColor = [UIColor grayColor];
    _createdTime.font = NTFont(10);
    [self.contentView addSubview:_createdTime];
    
    _updatedTime = [[UILabel alloc] init];
    _updatedTime.textColor = [UIColor grayColor];
    _updatedTime.font = NTFont(10);
    [self.contentView addSubview:_updatedTime];
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor lightGrayColor];
    _line.alpha = 0.5;
    [self.contentView addSubview:_line];
}
- (void)setBmobObject:(BmobObject *)bmobObject
{
    _bmobObject = bmobObject;
    _time.text = [NSString stringWithFormat:@"事项时间: %@",[bmobObject objectForKey:@"addtime"]];
    _time.frame = CGRectMake(10, 10, NTViewWidth - 20, 20);
    _content.text = [bmobObject objectForKey:@"content"];
    _content.x = 10;
    _content.y = _time.bottom + 10;
    _content.width = NTViewWidth - 20;
    [_content sizeToFit];
    
    _createdTime.text = [NSString stringWithFormat:@"记录时间: %@",[bmobObject objectForKey:@"createdAt"]];
    _createdTime.y = _content.bottom + 10;
    [_createdTime sizeToFit];
    _createdTime.x = NTViewWidth - _createdTime.width - 10;
    
    if ([[bmobObject objectForKey:@"createdAt"] isEqualToString:[bmobObject objectForKey:@"updatedAt"]]) {
        _updatedTime.hidden = YES;
        _line.frame = CGRectMake(0, _createdTime.bottom + 10, NTViewWidth, 0.5);
    } else {
        _updatedTime.hidden = NO;
        _updatedTime.text = [NSString stringWithFormat:@"更新时间: %@",[bmobObject objectForKey:@"updatedAt"]];
        _updatedTime.y = _createdTime.bottom + 5;
        [_updatedTime sizeToFit];
        _updatedTime.x = NTViewWidth - _updatedTime.width - 10;
        _line.frame = CGRectMake(0, _updatedTime.bottom + 10, NTViewWidth, 0.5);
    }
    
    self.height = _line.bottom;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.isEditing) {
        [self sendSubviewToBack:self.contentView];
    }
}
@end
