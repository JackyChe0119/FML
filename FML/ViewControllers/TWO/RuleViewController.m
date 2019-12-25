//
//  RuleViewController.m
//  FML
//
//  Created by 车杰 on 2018/9/8.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "RuleViewController.h"

@interface RuleViewController ()

@end

@implementation RuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:_navTitle Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    [self layoutUI];
}
- (void)layoutUI {
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:RECT(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    [webView setScalesPageToFit:YES];
    [self.view addSubview:webView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
