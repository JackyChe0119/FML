//
//  CurrencySectionView.m
//  FML
//
//  Created by apple on 2018/8/15.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "CurrencySectionView.h"
#import "UIButton+EdgeInset.h"

@implementation CurrencySectionView {
    
    __weak IBOutlet UIButton *_selectBtn;
    __weak IBOutlet UIButton *_btn1;
    __weak IBOutlet UIButton *_btn2;
    __weak IBOutlet UIButton *_btn3;
    __weak IBOutlet UIButton *_btn4;

    UIButton* _lastBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    _lastBtn = _btn1;
    
    
    [self layerUnSelect:_btn1];
    [self layerUnSelect:_btn2];
    [self layerUnSelect:_btn3];
    [self layerUnSelect:_btn4];
    [self layerUnSelect:self._btn5];
    [self layerUnSelect:self._btn6];
    
    [_btn1 addTarget:self action:@selector(clickSender:) forControlEvents:UIControlEventTouchUpInside];
    [_btn2 addTarget:self action:@selector(clickSender:) forControlEvents:UIControlEventTouchUpInside];
    [_btn3 addTarget:self action:@selector(clickSender:) forControlEvents:UIControlEventTouchUpInside];
    [_btn4 addTarget:self action:@selector(clickSender:) forControlEvents:UIControlEventTouchUpInside];
    [__btn5 addTarget:self action:@selector(clickSender:) forControlEvents:UIControlEventTouchUpInside];
    [__btn6 addTarget:self action:@selector(clickSender:) forControlEvents:UIControlEventTouchUpInside];
    
    [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_selectBtn setTitleColor:colorWithHexString(@"#828599") forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"currency_icon_un_select"] forState:UIControlStateNormal];
    [_selectBtn setTitleColor:ColorBlue forState:UIControlStateSelected];
    [_selectBtn setImage:[UIImage imageNamed:@"currency_icon_select"] forState:UIControlStateSelected];
    _selectBtn.backgroundColor = ColorWhite;
    [_selectBtn exchangeImageAndTitle];
}

- (void)clickSender:(UIButton *)sender {
    [self layerUnSelect:_lastBtn];
    _lastBtn = sender;
    [self layerSelect:_lastBtn];
    if (_currencySelectIndex) {
        _currencySelectIndex(sender.tag - 10000);
    }
}

- (void)selectBtnClick {
    _selectBtn.selected = !_selectBtn.selected;
    if (_openHander) {
        _openHander();
    }
}

- (void)layerSelect:(UIButton *)style {
    style.layer.cornerRadius = 4;
    style.layer.borderWidth = 0;
    style.backgroundColor = [UIColor colorWithRed:188.0f/255.0f green:195.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
    [style setTitleColor:ColorWhite forState:UIControlStateNormal];
}

- (void)layerUnSelect:(UIButton *)style {
    style.layer.cornerRadius = 4;
    style.layer.borderColor = [[UIColor colorWithRed:130.0f/255.0f green:133.0f/255.0f blue:153.0f/255.0f alpha:1.0f] CGColor];
    style.layer.borderWidth = 0.5;
    style.backgroundColor = [UIColor clearColor];
    [style setTitleColor:[UIColor colorWithRed:130.0f/255.0f green:133.0f/255.0f blue:153.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
}
@end
