//
//  FMLAlertView.m
//  FML
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "FMLAlertView.h"

@implementation FMLAlertView {
    UILabel*    _titleLB;
    UILabel*    _msgLB;
    UIButton*   _lastBtn;
    NSMutableDictionary*   _actions;
}

- (instancetype)initWithTitle:(NSString *)title msg:(NSString *)msg {
    if (self = [super init]) {
        _actions = [NSMutableDictionary dictionary];
        self.backgroundColor = ColorWhite;
        self.layer.cornerRadius = 5;
        [self setViewWithTitle:title msg:msg];
    }
    return self;
}

- (void)setViewWithTitle:(NSString *)title msg:(NSString *)msg {
    UILabel* titleLB = [UILabel new];
    titleLB.text = title;
    titleLB.textColor = Color1D;
    titleLB.font = [UIFont systemFontOfSize:18];
    [self addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(25);
    }];
    
    UILabel* msgLB = [UILabel new];
    msgLB.text = msg;
    msgLB.textColor = Color4D;
    msgLB.font = [UIFont systemFontOfSize:16];
    msgLB.numberOfLines = 0;
    msgLB.textAlignment = NSTextAlignmentJustified;
    [self addSubview:msgLB];
    [msgLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLB);
        make.top.equalTo(titleLB.mas_bottom).offset(22);
        make.right.equalTo(self.mas_right).offset(-25);
    }];
    
    _titleLB = titleLB;
    _msgLB = msgLB;
}

- (void)addBtn:(NSString *)title titleColor:(UIColor *)color action:(alertBlock)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    NSString* address = [NSString stringWithFormat:@"%p", btn];
    _actions[address] = action;

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(55);
        if (!_lastBtn) {
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(_msgLB.mas_bottom).offset(25);
            make.bottom.equalTo(self).offset(-5);
        } else {
            make.right.equalTo(_lastBtn.mas_left).offset(-10);
            make.top.equalTo(_lastBtn);
        }
    }];
    
    
    _lastBtn = btn;
}

- (void)addAction:(UIButton *)btn {
    NSString* address = [NSString stringWithFormat:@"%p", btn];
    if (_actions[address]) {
        alertBlock block = (alertBlock)_actions[address];
        block();
    }
}

@end
