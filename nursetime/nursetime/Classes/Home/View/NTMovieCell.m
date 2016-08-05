//
//  NTMovieCell.m
//  nursetime
//
//  Created by 苗晓东 on 15/12/13.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "NTMovieCell.h"
#import "UIImageView+WebCache.h"

@implementation NTMovieCell
{
    UIImageView *_movieImg;
    UILabel *_movieTitle;
    UILabel *_movieBrief;
    UILabel *_movieType;
    UILabel *_movieGrade;
    UILabel *_movieDirector;
    UILabel *_movieStar;
    UILabel *_movieDate;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"NTMovieCell";
    NTMovieCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NTMovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    _movieImg = [[UIImageView alloc] init];
    [self.contentView addSubview:_movieImg];
    
    _movieTitle = [[UILabel alloc] init];
    _movieTitle.font = NTFont(20);
    _movieTitle.textColor = [UIColor blackColor];
    [self.contentView addSubview:_movieTitle];
    
    _movieType = [[UILabel alloc] init];
    _movieType.font = NTFont(15);
    _movieType.textColor = [UIColor colorWithRed:0.04f green:0.64f blue:1.00f alpha:1.00f];
    [self.contentView addSubview:_movieType];
    
    _movieGrade = [[UILabel alloc] init];
    _movieGrade.font = NTFont(15);
    _movieGrade.textColor = [UIColor orangeColor];
    [self.contentView addSubview:_movieGrade];
    
    _movieDirector = [[UILabel alloc] init];
    _movieDirector.font = NTFont(15);
    _movieDirector.textColor = [UIColor blackColor];
    [self.contentView addSubview:_movieDirector];
    
    _movieStar = [[UILabel alloc] init];
    _movieStar.font = NTFont(15);
    _movieStar.textColor = [UIColor blackColor];
    [self.contentView addSubview:_movieStar];
    
    _movieDate = [[UILabel alloc] init];
    _movieDate.font = NTFont(15);
    _movieDate.textColor = [UIColor blackColor];
    [self.contentView addSubview:_movieDate];
    
    _movieBrief = [[UILabel alloc] init];
    _movieBrief.numberOfLines = 0;
    _movieBrief.font = NTFont(18);
    _movieBrief.textColor = [UIColor grayColor];
    [self.contentView addSubview:_movieBrief];
}
- (void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    [_movieImg sd_setImageWithURL:[NSURL URLWithString:dataDict[@"iconaddress"]]];
    _movieImg.frame = CGRectMake(10, 10, 100, 130);
    _movieTitle.text = dataDict[@"tvTitle"];
    _movieTitle.frame = CGRectMake(_movieImg.right + 10, 10, NTViewWidth - 130, 20);
    
    NSMutableString *typeStr = [NSMutableString stringWithString:@"类型: "];
    for (NSDictionary *typeDict in [dataDict[@"type"][@"data"] allValues]) {
        [typeStr appendString:[NSString stringWithFormat:@"%@/",typeDict[@"name"]]];
    }
    [typeStr deleteCharactersInRange:NSMakeRange(typeStr.length-1, 1)];
    _movieType.text = typeStr;
    _movieType.frame = CGRectMake(_movieTitle.x, _movieTitle.bottom + 5, _movieTitle.width, 15);
    
    NSMutableString *gradeStr = [NSMutableString stringWithFormat:@"评分: "];
    if ([dataDict[@"grade"] length]) {
        [gradeStr appendString:[NSString stringWithFormat:@"%@%@", dataDict[@"grade"], dataDict[@"gradeNum"]]];
    } else {
        [gradeStr appendString:@"暂无评分"];
    }
    _movieGrade.text = gradeStr;
    _movieGrade.frame = CGRectMake(_movieTitle.x, _movieType.bottom + 5, _movieTitle.width, 15);

    _movieDirector.text = [NSString stringWithFormat:@"导演: %@", dataDict[@"director"][@"data"][@"1"][@"name"]];
    _movieDirector.frame = CGRectMake(_movieTitle.x, _movieGrade.bottom + 5, _movieTitle.width, 15);
    
    NSMutableString *starStr = [NSMutableString stringWithFormat:@"演员: "];
    for (NSDictionary *starDict in [dataDict[@"star"][@"data"] allValues]) {
        if ([starDict[@"name"] length]) {
            [starStr appendString:[NSString stringWithFormat:@"%@/", starDict[@"name"]]];
        }
    }
    [starStr deleteCharactersInRange:NSMakeRange(starStr.length - 1, 1)];
    _movieStar.text = starStr;
    _movieStar.frame = CGRectMake(_movieTitle.x, _movieDirector.bottom + 5, _movieTitle.width, 15);
    
    _movieDate.text = [NSString stringWithFormat:@"上映时间: %@", dataDict[@"playDate"][@"data2"]];
    _movieDate.frame = CGRectMake(_movieTitle.x, _movieStar.bottom + 5, _movieTitle.width, 15);
    
    _movieBrief.text = dataDict[@"story"][@"data"][@"storyBrief"];
    _movieBrief.frame = CGRectMake(10, _movieImg.bottom + 10, NTViewWidth - 20, 0);
    [_movieBrief sizeToFit];
    self.height = _movieBrief.bottom + 10;
}
@end
