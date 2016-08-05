//
//  NTAboutViewController.m
//  nursetime
//
//  Created by 苗晓东 on 15/12/5.
//  Copyright © 2015年 inspiry. All rights reserved.
//

#import "NTAboutViewController.h"

@interface NTAboutViewController ()

@end

@implementation NTAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于我们";
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width - 150)/2, 80, 150, 150)];
    img.image = [UIImage imageNamed:@"erweima"];
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.clipsToBounds = YES;
    [self.view addSubview:img];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, img.bottom, self.view.width, 20)];
    label1.font = NTFont(15);
    label1.textColor = [UIColor blackColor];
    label1.text = @"扫码二维码下载app";
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, label1.bottom + 20, self.view.width - 40, 100)];
    label.textColor = [UIColor blackColor];
    label.font = NTFont(15);
    label.text = @"亲爱的用户您好，这个爱屁屁是我做给女朋友排班表用的(程序猿还有女朋友...喜欢程序猿的女孩都是好女孩...)\n\n相信还有很多很多人上班时间并不是像我们程序猿那样996，各种早中晚班让人不胜其烦，不得不标记在日历上，现在这个爱屁屁能帮你记录下乱七八糟的上班点了，让你不再纠结上班不定点。\n\n希望大家用着方便。";
    label.numberOfLines = 0;
    [label sizeToFit];
    [self.view addSubview:label];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height - 50, self.view.width, 20)];
    label2.font = NTFont(12);
    label2.textColor = [UIColor lightGrayColor];
    label2.text = @"V1.0  wángdúndún猫小懂©";
    label2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label2];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width - 150) / 2, label2.y - 50, 150, 30)];
    [btn setTitle:@"用着不爽,邮件吐槽" forState:UIControlStateNormal];
    [btn setTitleColor:NTBlue forState:UIControlStateNormal];
    btn.titleLabel.font = NTFont(15);
    btn.layer.borderColor = NTBlue.CGColor;
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 2;
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClick
{
    NSMutableString *mailUrl = [[NSMutableString alloc]init];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject:@"mxdios@163.com"];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}
@end
