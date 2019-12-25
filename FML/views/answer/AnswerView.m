//
//  AnswerView.m
//  FML
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "AnswerView.h"

@implementation AnswerView {
    NSMutableArray<AnswerItemView*>* _items;
}

- (NSArray *)A_B_C {
    return @[@"A.", @"B.", @"C.", @"D.", @"E.", @"F", @"G"];
}

- (instancetype)initWithArray:(NSArray *)answerArray {
    if (self = [super init]) {
        _score = 0;
        _items = [NSMutableArray array];
        _answerArray = answerArray;
        [self setView];
    }
    return self;
}

- (void)setView {
    _titleLB = [UILabel new];
    _titleLB.numberOfLines = 0;
    _titleLB.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [self addSubview:_titleLB];
    [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self).offset(35);
    }];
    
    AnswerItemView* lastItem;
    for (int i = 0; i < _answerArray.count; i++) {
        AnswerItemView* item = [AnswerItemView new];
        item.leftLB.text = self.A_B_C[i];
        item.rightLB.text = _answerArray[i];
        NSArray* arr = [item.rightLB.text componentsSeparatedByString:@"（"];
        NSString* str = [arr[1] componentsSeparatedByString:@"分"][0];
        item.rightLB.text = arr[0];
        item.btn.tag = str.integerValue;
        [item.btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_titleLB);
            if (i == 0) {
                make.top.equalTo(_titleLB.mas_bottom).offset(10);
            } else {
                make.top.equalTo(lastItem.mas_bottom).offset(10);
            }
            if (i == _answerArray.count - 1) {
                make.bottom.equalTo(self).offset(-10);
            }
        }];
        lastItem = item;
        [_items addObject:item];
    }
}


- (void)selectBtn:(UIButton *)btn {
    [self noSelect_];
    btn.selected = YES;
    _score = btn.tag;
    for (AnswerItemView* item in _items) {
        if (item.btn.selected) {
            item.checkIV.image = [UIImage imageNamed:@"checked"];
        } else {
            item.checkIV.image = [UIImage imageNamed:@"meiyou"];
        }
    }
}

- (void)noSelect_ {
    for (AnswerItemView* item in _items) {
        item.btn.selected = NO;
    }
}

@end

@implementation AnswerItemView

- (instancetype)init {
    if (self = [super init]) {
        [self setView];
    }
    return self;
}

- (void)setView {
    
    self.clipsToBounds = YES;
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setImage:[UIImage imageNamed:@"btn_select_"] forState:UIControlStateSelected];
    [_btn setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [self addSubview:_btn];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_offset(100);
    }];
    
    _leftLB = [UILabel new];
    _leftLB.font = [UIFont systemFontOfSize:16];
    [self addSubview:_leftLB];
    [_leftLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(10);
        make.width.mas_offset(17);
    }];

    _rightLB = [UILabel new];
    _rightLB.font = [UIFont systemFontOfSize:14];
    _rightLB.textColor = Color4D;
    _rightLB.numberOfLines = 0;
    [self addSubview:_rightLB];
    [_rightLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftLB.mas_right).offset(5);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(_leftLB);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    _checkIV = [UIImageView new];
    [self addSubview:_checkIV];
    [_checkIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
    }];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3;
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    _btn.selected = isSelect;
}

@end
