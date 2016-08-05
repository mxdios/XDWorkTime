//
//  NTWeatherView.m
//  nursetime
//
//  Created by inspiry on 15/12/14.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "NTWeatherView.h"

@implementation NTWeatherView
{
    NSArray *_weekArray;
    UIImageView *_weatherImg;
    UILabel *_weatherTitle;
    UILabel *_city;
    UILabel *_time;
    UILabel *_moon;
    UILabel *_wendu;
    UILabel *_feng;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSelfView];
    }
    return self;
}
- (void)setupSelfView
{
    _weekArray = [NSArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六",nil];
    self.backgroundColor = [UIColor colorWithRed:0.16 green:0.66 blue:0.77 alpha:0.5];
    _weatherImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.height / 2, self.height / 2)];
    [self addSubview:_weatherImg];
    
    _weatherTitle = [[UILabel alloc] initWithFrame:CGRectMake(_weatherImg.right + 10, _weatherImg.y, 0, 18)];
    _weatherTitle.font = NTFont(18);
    _weatherTitle.textColor = [UIColor whiteColor];
    [self addSubview:_weatherTitle];
    
    _city = [[UILabel alloc] initWithFrame:CGRectMake(0, _weatherImg.y, 0, 18)];
    _city.font = NTFont(18);
    _city.textColor = [UIColor whiteColor];
    [self addSubview:_city];
    
    _wendu = [[UILabel alloc] initWithFrame:CGRectMake(_weatherImg.right + 10, _city.bottom + 5, 0, 15)];
    _wendu.font = NTFont(15);
    _wendu.textColor = [UIColor whiteColor];
    [self addSubview:_wendu];
    
    _feng = [[UILabel alloc] initWithFrame:CGRectMake(0, _city.bottom + 5, 0, 15)];
    _feng.font = NTFont(15);
    _feng.textColor = [UIColor whiteColor];
    [self addSubview:_feng];
    
    _time = [[UILabel alloc] initWithFrame:CGRectMake(10, _weatherImg.bottom + 5, 200, 13)];
    _time.font = NTFont(13);
    _time.textColor = [UIColor whiteColor];
    [self addSubview:_time];
    
    _moon = [[UILabel alloc] initWithFrame:CGRectMake(10, _time.bottom + 5, 200, 13)];
    _moon.font = NTFont(13);
    _moon.textColor = [UIColor whiteColor];
    [self addSubview:_moon];
    
    [self setupBtn:CGRectMake(self.width - 90, (self.height - 60 - 5) / 2, 80, 30) tag:0 title:@"更新天气"];
    [self setupBtn:CGRectMake(self.width - 90, (self.height - 60 - 5) / 2 + 35, 80, 30) tag:1 title:@"切换城市"];
}
- (void)setupBtn:(CGRect)frame tag:(NSInteger)tag title:(NSString *)titleStr
{
    HXSetBgColorBtn *shuaxin = [[HXSetBgColorBtn alloc] initWithFrame:frame];
    shuaxin.tag = tag;
    [shuaxin setBackgroundColor:[UIColor colorWithRed:0.13f green:0.65f blue:1.00f alpha:1.00f] forState:UIControlStateNormal];
    [shuaxin setBackgroundColor:[UIColor colorWithRed:0.13f green:0.65f blue:1.00f alpha:0.50f] forState:UIControlStateHighlighted];
    [shuaxin setTitleColor:setAlpColor(255, 255, 255, 1.0) forState:UIControlStateNormal];
    [shuaxin setTitleColor:setAlpColor(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
    shuaxin.titleLabel.font = NTFont(13);
    shuaxin.layer.cornerRadius = 2;
    [shuaxin addTarget:self action:@selector(shuaxinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shuaxin setTitle:titleStr forState:UIControlStateNormal];
    [self addSubview:shuaxin];
}
- (void)setWeatherDict:(NSDictionary *)weatherDict
{
    _weatherDict = weatherDict;
    NSDictionary *dict = weatherDict[@"realtime"];
    switch ([dict[@"weather"][@"img"] integerValue]) {
        case 0:
            _weatherImg.image = [UIImage imageNamed:@"qing"];
            break;
        case 1:case 2:
            _weatherImg.image = [UIImage imageNamed:@"yun"];
            break;
        case 3:case 4:case 5:case 6:case 7:case 8:case 9:case 10:case 11:case 12: case 21:case 22:case 23:case 24:case 25:
            _weatherImg.image = [UIImage imageNamed:@"yu"];
            break;
        case 13:case 14:case 15:case 16:case 17:case 26:case 27:case 28:
            _weatherImg.image = [UIImage imageNamed:@"xue"];
            break;
        case 18:case 19:case 20:case 29:case 30:case 31:case 33:
            _weatherImg.image = [UIImage imageNamed:@"mai"];
            break;
        default:
            break;
    }
    _weatherTitle.text = dict[@"weather"][@"info"];
    [_weatherTitle sizeToFit];
    
    _city.text = dict[@"city_name"];
    _city.x = _weatherTitle.right + 10;
    [_city sizeToFit];
    
    _wendu.text = [NSString stringWithFormat:@"温度: %@℃", dict[@"weather"][@"temperature"]];
    [_wendu sizeToFit];
    
    _feng.text = [NSString stringWithFormat:@"%@ %@", dict[@"wind"][@"direct"], dict[@"wind"][@"power"]];
    _feng.x = _wendu.right + 10;
    [_feng sizeToFit];
    
    _time.text = [NSString stringWithFormat:@"发布时间: %@ %@", dict[@"date"],dict[@"time"]];
    if ([dict[@"week"] integerValue] >= 0 && [dict[@"week"] integerValue] <= 6) {
        _moon.text = [NSString stringWithFormat:@"农历:%@ 星期%@", dict[@"moon"], _weekArray[[dict[@"week"] integerValue]]];
    }
}
- (void)shuaxinBtnClick:(HXSetBgColorBtn *)btn
{
    if (btn.tag) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入城市" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView show];
    } else {
        [self diaoyongDelegate:nil];
    }
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self endEditing:YES];
    if (buttonIndex == 1 && [[[alertView textFieldAtIndex:0] text] length]) {
        [self diaoyongDelegate:[[alertView textFieldAtIndex:0] text]];
    }
}
- (void)diaoyongDelegate:(NSString *)chengshi
{
    if ([self.delegate respondsToSelector:@selector(gengxinTianqi:)]) {
        [self.delegate gengxinTianqi:chengshi];
    }
}
- (void)dealloc
{
    self.delegate = nil;
}
@end
