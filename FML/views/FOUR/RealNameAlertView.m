//
//  RealNameAlertView.m
//  FML
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "RealNameAlertView.h"

@implementation RealNameAlertView

- (instancetype)initWith:(NSString *)title {
    if (self = [super init]) {
        [self setView:title];
        self.backgroundColor = ColorWhite;
        self.layer.cornerRadius = 5;
    }
    return self;
}

- (void)setView:(NSString *)str {
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"realNameCheck"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(35);
    }];
    
    UILabel* title = [[UILabel alloc] init];
    title.text = str;
    title.textColor = Color4D;
    title.font = [UIFont systemFontOfSize:16];
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(3);
        make.top.equalTo(imageView.mas_bottom).offset(18);
    }];
    
    UIButton* ok = [UIButton buttonWithType:UIButtonTypeCustom];
    [ok setTitle:@"确定" forState:UIControlStateNormal];
    [ok setTitleColor:ColorBlue forState:UIControlStateNormal];
    [ok addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:ok];
    [ok mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(title.mas_bottom).offset(35);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(55);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    ok.titleLabel.font = [UIFont systemFontOfSize:16];
    
}

- (void)closeView {
    if (_closeHandler) {
        _closeHandler();
    }
}

@end
