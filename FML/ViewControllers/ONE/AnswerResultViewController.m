//
//  AnswerResultViewController.m
//  FML
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "AnswerResultViewController.h"
#import "MainViewController.h"
#import "UserSingle.h"
@interface AnswerResultViewController ()


@end

@implementation AnswerResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:@"投资者风险问卷调查" Color:Color1D];
    [self setView];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)setView {
    NSString* str;
    if (_score < 41) {
        str = @"score_1";
    } else if (_score < 61) {
        str = @"score_2";
    } else if (_score < 81) {
        str = @"score_3";
    } else if (_score < 101) {
        str = @"score_4";
    }
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:str]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.customNavView);
        make.top.equalTo(self.customNavView.mas_bottom);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(20, ScreenHeight - 70, ScreenWidth - 40, 50);
    closeBtn.layer.cornerRadius = 5;
    closeBtn.layer.masksToBounds = YES;
    [self.view addSubview:closeBtn];
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint = CGPointMake(0, 0.5);
    layer.endPoint = CGPointMake(1, 0.5);
    layer.colors = [NSArray arrayWithObjects:(id)colorWithHexString(@"#569dfa").CGColor, (id)colorWithHexString(@"#5172fa").CGColor, nil];
    layer.locations = @[@0.0, @0.5];
    layer.frame = closeBtn.bounds;
    [closeBtn.layer addSublayer:layer];
    
    [closeBtn setTitle:@"开启钱包新体验" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)dismissVC {
    [UIApplication sharedApplication].delegate.window.rootViewController = [[MainViewController alloc]init];
}

@end
