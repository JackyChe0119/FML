//
//  FMLTextField.m
//  FML
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "FMLTextField.h"

@implementation FMLTextField

- (instancetype)init {
    if (self = [super init]) {
        [self setView];
    }
    return self;
}

- (void)setView {
    
    _textfield = [UITextField new];
    _textfield.borderStyle = UITextBorderStyleNone;
    [self addSubview:_textfield];
    
    _eyesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_eyesBtn setImage:[UIImage imageNamed:@"eyes"] forState:UIControlStateNormal];
    [_eyesBtn setImage:[UIImage imageNamed:@"eyes_sel"] forState:UIControlStateSelected];
    [_eyesBtn addTarget:self action:@selector(changeTextType) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_eyesBtn];
    
    [_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(_eyesBtn.mas_left).offset(-5);
    }];
    
    [_eyesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(_textfield);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(21);
    }];
}

- (void)changeTextType {
    _eyesBtn.selected = !_eyesBtn.selected;
    _textfield.secureTextEntry = _eyesBtn.selected;
}

- (void)setSelect:(BOOL)select {
    _select = select;
    _eyesBtn.selected = _select;
    _textfield.secureTextEntry = _select;
}

@end
