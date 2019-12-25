//
//  AnswerBaseView.m
//  FML
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "AnswerBaseView.h"

@implementation AnswerBaseView {
    LeftLableTextField* _item1;
    LeftLableTextField* _item2;
    LeftLableTextField* _item3;
    LeftLableTextField* _item4;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setView];
    }
    return self;
}

- (void)setView {
    _item1 = [LeftLableTextField new];
    _item1.titleLB.text = @"姓名";
    _item1.textField.placeholder = @"请输入姓名";
    [self addSubview:_item1];
    [_item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];
    
    _item2 = [LeftLableTextField new];
    _item2.titleLB.text = @"联系方式";
    _item2.textField.placeholder = @"请输入联系方式";
    [self addSubview:_item2];
    [_item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_item1.mas_bottom);
    }];
    
    _item3 = [LeftLableTextField new];
    _item3.titleLB.text = @"证件类型";
    _item3.textField.placeholder = @"请输入姓名";
    _item3.textField.userInteractionEnabled = NO;
    _item3.textField.text = @"身份证";
    [self addSubview:_item3];
    [_item3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_item2.mas_bottom);
    }];
    
    _item4 = [LeftLableTextField new];
    _item4.titleLB.text = @"证件号码";
    _item4.textField.placeholder = @"请输入证件号码";
    [self addSubview:_item4];
    [_item4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_item3.mas_bottom);
    }];
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:@"开始答题" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    _btn.layer.cornerRadius = 5;
    _btn.backgroundColor = ColorBlue;
    [self addSubview:_btn];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-40);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self).offset(-70);
    }];
}

- (void)click {
    if (_item2.textField.text.length == 8) {
        
    } else if (![_item2.textField.text isValidMobile]) {
        [(MJBaseViewController *)self.viewController showToastHUD:@"请输入正确的手机号码"];
        return;
    }
    if (![_item4.textField.text validateIDCardNumber]) {
        [(MJBaseViewController *)self.viewController showToastHUD:@"请输入正确的身份证号码"];
        return;
    }
    for (LeftLableTextField* item in self.subviews) {
        if ([item isKindOfClass:[LeftLableTextField class]] && (item.textField.text == nil || item.textField.text.length == 0)) {
            [(MJBaseViewController *)self.viewController showToastHUD:item.textField.placeholder];
            return;
        }
    }
    if (_baseAnswerHandler) {
        _baseAnswerHandler();
    }
}

- (void)closeW {
    [_item1.textField resignFirstResponder];
    [_item2.textField resignFirstResponder];
    [_item3.textField resignFirstResponder];
    [_item4.textField resignFirstResponder];
}


@end
