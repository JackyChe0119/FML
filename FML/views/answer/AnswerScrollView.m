//
//  AnswerScrollView.m
//  FML
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "AnswerScrollView.h"

@implementation AnswerScrollView {
    UIScrollView* _scrollView;
    UIView*       _contentView;
    UIView*       _bottomView;
    NSMutableArray<AnswerView *>* _items;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _items = [NSMutableArray array];
        _score = 0;
        [self setView];
    }
    return self;
}

- (void)setView {
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = ColorWhite;
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    UIView * contentView = [[UIView alloc] init];
    contentView.backgroundColor = ColorWhite;
    [scrollView addSubview:contentView];
    _contentView = contentView;

    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
        make.height.greaterThanOrEqualTo(@0.f);//此处保证容器View高度的动态变化 大于等于0.f的高度
    }];
    
}

- (void)showView {
    if (!(_answerArray.count == _titles.count)) {
        NSAssert(0, @"数组有问题");
    }
    
    AnswerView* lastItem;
    for (int i = 0; i < _titles.count; i++) {
        AnswerView* item = [[AnswerView alloc] initWithArray:_answerArray[i]];
        item.titleLB.text = _titles[i];
        [_contentView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contentView);
            if (i == 0) {
                make.top.equalTo(_contentView);
            } else {
                make.top.equalTo(lastItem.mas_bottom);
            }
        }];
        lastItem = item;
        [_items addObject:item];
    }
    
    _bottomView = [UIView new];
    [_contentView addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contentView);
        make.top.equalTo(lastItem.mas_bottom).offset(10);
        make.height.mas_offset(50);
        make.bottom.equalTo(_contentView).offset(-10);
    }];
    
    if (_isHaveNext) {
        [self haveNext];
    } else {
        [self finish];
    }
}

- (void)haveNext {
    UIButton* _btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn0 setTitle:@"上一页" forState:UIControlStateNormal];
    [_btn0 addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _btn0.layer.cornerRadius = 5;
    _btn0.backgroundColor = Color1D;
    _btn0.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [_bottomView addSubview:_btn0];
    [_btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView).offset(40);
        make.height.mas_equalTo(50);
        make.top.equalTo(_bottomView);
    }];
    
    UIButton* _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn1 setTitle:@"下一页" forState:UIControlStateNormal];
    [_btn1 addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    _btn1.layer.cornerRadius = 5;
    _btn1.backgroundColor = ColorBlue;
    _btn1.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [_bottomView addSubview:_btn1];
    [_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_btn0.mas_right).offset(20);
        make.right.equalTo(_bottomView).offset(-40);
        make.height.mas_equalTo(50);
        make.top.equalTo(_bottomView);
        make.width.equalTo(_btn0);
    }];
}

- (void)finish {
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:@"提交" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(clickFinish) forControlEvents:UIControlEventTouchUpInside];
    _btn.layer.cornerRadius = 5;
    _btn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _btn.backgroundColor = ColorBlue;
    [_bottomView addSubview:_btn];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView).offset(40);
        make.right.equalTo(_bottomView).offset(-40);
        make.height.mas_equalTo(50);
        make.top.equalTo(_bottomView);
    }];
}

- (void)next {
    for (AnswerView* item in _items) {
        if (item.score == 0) {
            [(MJBaseViewController *)self.viewController showToastHUD:@"还有未选项"];
            return;
        }
        _score += item.score;
    }
    if (_nextHandler) {
        _nextHandler();
    }
}

- (void)back {
    if (_backHandler) {
        _backHandler();
    }
}

- (void)clickFinish {
    _score = 0;
    for (AnswerView* item in _items) {
        if (item.score == 0) {
            [(MJBaseViewController *)self.viewController showToastHUD:@"还有未选项"];
            return;
        }
        _score += item.score;
    }
    NSDictionary *dict = [UserSingle sharedUser].infoDic;
    if ([UserSingle sharedUser].isLogin) {
        [[UserSingle sharedUser] setLoginInfo:dict];
    }else {
        [[UserSingle sharedUser] setResInfo:dict];
    }
    [UserSingle sharedUser].isAnswer = YES;
    [[NSUserDefaults standardUserDefaults] setObject:@"isLogin" forKey:@"isLogin"];
    if (_finishHandler) {
        _finishHandler();
    }
}

@end
