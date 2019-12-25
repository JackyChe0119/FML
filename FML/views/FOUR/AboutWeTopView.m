//
//  AboutWeTopView.m
//  FML
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "AboutWeTopView.h"

@interface AboutWeTopView()

@property (nonatomic, strong) UIImageView* logo;

@end

@implementation AboutWeTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setView];
    }
    return self;
}

- (void)setView {
    
    [self addSubview:self.logo];
    
    UILabel* appname = [[UILabel alloc] initWithFrame:CGRectMake(0, self.logo.bottom + 15, ScreenWidth, 20)];
    appname.text = @"数钱钱";
    appname.textAlignment = NSTextAlignmentCenter;
    appname.font = [UIFont systemFontOfSize:16];
    appname.textColor = Color1D;
    [self addSubview:appname];
    
    UILabel* localVersion = [[UILabel alloc] initWithFrame:CGRectMake(0, appname.bottom + 10, ScreenWidth, 15)];
    localVersion.textAlignment = NSTextAlignmentCenter;
    localVersion.font = [UIFont systemFontOfSize:12];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = infoDictionary[@"CFBundleShortVersionString"];
    localVersion.text = version;
    localVersion.textColor = colorWithHexString(@"#b8bbcc");
    [self addSubview:localVersion];
}

- (UIImageView *)logo {
    if (!_logo) {
        _logo = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 45, 25, 90, 89.5)];
        _logo.image = [UIImage imageNamed:@"logo_background"];
        
        UIImageView* logo = [[UIImageView alloc] initWithFrame:CGRectMake(7,6.5, 76, 76)];
        logo.image = [UIImage imageNamed:@"logo"];
        logo.layer.cornerRadius = 16;
        logo.layer.masksToBounds = YES;
        [_logo addSubview:logo];
    }
    return _logo;
}

@end
