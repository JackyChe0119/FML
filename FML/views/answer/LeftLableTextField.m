//
//  LeftLableTextField.m
//  FML
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "LeftLableTextField.h"

@implementation LeftLableTextField

- (instancetype)init {
    if (self = [super init]) {
        [self setView];
    }
    return self;
}

- (void)setView {
    _titleLB = [UILabel new];
    _titleLB.textColor = ColorGrayText;
    _titleLB.font = [UIFont systemFontOfSize:16];
    [self addSubview:_titleLB];
    [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(85);
    }];
    
    _textField = [UITextField new];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.textColor = Color1D;
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLB);
        make.left.equalTo(_titleLB.mas_right).offset(5);
        make.right.equalTo(self).offset(-20);
    }];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = ColorLine;
    [self addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLB);
        make.right.equalTo(self);
        make.top.equalTo(_titleLB.mas_bottom).offset(19.5);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self).offset(0.5);
    }];
}
- (void)setChangeFrame:(BOOL)changeFrame {
    if (changeFrame) {
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLB);
            make.left.equalTo(_titleLB.mas_right).offset(5);
            make.right.equalTo(self).offset(-50);
        }];
    }
}

@end
