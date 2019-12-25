//
//  MyAliPayQRCodeViewController.m
//  FML
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MyAliPayQRCodeViewController.h"

@interface MyAliPayQRCodeViewController ()

@end

@implementation MyAliPayQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:@"我的支付宝二维码" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    
    [self setView];
}

- (void)setView {
    UIImageView* imageView = [[UIImageView alloc] initWithImage:_image];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavHeight);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(self.view.width);
        make.height.equalTo(self.view.width * _image.size.height / _image.size.width);
    }];
}
@end
