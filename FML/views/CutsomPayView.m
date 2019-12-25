//
//  CutsomPayView.m
//  FML
//
//  Created by 车杰 on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "CutsomPayView.h"

@implementation CutsomPayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.baseScrollView];
        [self addSubview:self.dismissBtn];
        [self addSubview:self.titleLabel];
        [self addSubview:self.lineView];
        [self.baseScrollView addSubview:self.priceLabel];
        [self.baseScrollView addSubview:self.typeInputView];
        [self.baseScrollView addSubview:self.payButton];
        
        //切圆角 遮罩
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
    return self;
}
- (void)createPasswordView {
    [self.baseScrollView addSubview:self.pswView];
    self.titleLabel.text = @"输入支付密码";
    [self.baseScrollView setContentSize:CGSizeMake(ScreenWidth*2, HEIGHT(self)-130)];
    [self.baseScrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
    [self.pswView.unitField becomeFirstResponder];
}
- (void)createPaystatusView {
    [self.baseScrollView addSubview:self.stausView];
    [self.baseScrollView addSubview:self.sureButton];
    [self.baseScrollView setContentSize:CGSizeMake(ScreenWidth*3, HEIGHT(self)-130)];
    [self.baseScrollView setContentOffset:CGPointMake(ScreenWidth*2, 0) animated:YES];
}
- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton createTextButtonWithFrame:RECT(40+ScreenWidth*2, HEIGHT(self.baseScrollView)-90., ScreenWidth-80, 50) bgColor:ColorBlue textColor:[UIColor whiteColor] font:15 bold:YES title:@"完成"];
        [_sureButton addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.layer.cornerRadius = 5;
        _sureButton.layer.masksToBounds = YES;
    }
    return _sureButton;
}
- (statusView *)stausView {
    if (!_stausView) {
        _stausView = [[statusView alloc]initWithFrame:RECT(ScreenWidth*2+ScreenWidth/2.0-80, 30, 160, 120)];
    }
    return _stausView;
}
- (passwordView *)pswView {
    if (!_pswView) {
        __weak typeof(self)weakSelf = self;
        _pswView = [[passwordView alloc]initWithFrame:RECT(ScreenWidth, 0, ScreenWidth, HEIGHT(self)-130)];
        _pswView.passwordBlock = ^(NSInteger index) {
            if (index==1) {
                 //忘记密码
                [weakSelf.pswView.unitField resignFirstResponder];
                if (weakSelf.payBlock) {
                    weakSelf.payBlock(3);
                }
            }else {
                //输入完成
                if (weakSelf.payBlock) {
                    weakSelf.payBlock(5);
                }
//                [weakSelf createPaystatusView];
            }
        };
    }
    return _pswView;
}
- (UIScrollView *)baseScrollView {
    if (!_baseScrollView) {
        _baseScrollView = [[UIScrollView alloc]initWithFrame:RECT(0, 50, ScreenWidth, HEIGHT(self)-50)];
        _baseScrollView.showsVerticalScrollIndicator = NO;
        _baseScrollView.showsHorizontalScrollIndicator = NO;
        _baseScrollView.scrollEnabled = NO;
    }
    return _baseScrollView;
}
- (UIButton *)dismissBtn {
    if (!_dismissBtn) {
        _dismissBtn = [UIButton createimageButtonWithFrame:RECT(0, 0, 50, 50) imageName:@"close"];
        [_dismissBtn addTarget:self action:@selector(disMissBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [_titleLabel rect:RECT(50, 10, ScreenWidth-100, 30) aligment:Center font:17 isBold:NO text:@"确认订单" textColor:Color1D superView:nil];
    }
    return _titleLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        [_priceLabel rect:RECT(50, 5, ScreenWidth-100, 80) aligment:Center font:50 isBold:YES text:@"1902ETH" textColor:Color1D superView:nil];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"1902ETH"];
        UIFont *font2 = [UIFont boldSystemFontOfSize:15];
        [str addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(_priceLabel.text.length-3,3)];
        _priceLabel.attributedText = str;
    }
    return _priceLabel;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView createViewWithFrame:RECT(0, 49.5, ScreenWidth, .5) color:ColorLine];
    }
    return _lineView;
}
- (InputView *)typeInputView {
    if (!_typeInputView) {
        _typeInputView = [[InputView alloc]initWithFrame:RECT(0, 90, ScreenWidth, 55)];
        _typeInputView.leftStr = @"订单信息";
        _typeInputView.leftLabel.font = [UIFont systemFontOfSize:16];
        _typeInputView.rightTf.font = [UIFont systemFontOfSize:16];
        _typeInputView.rightTf.text = @"充值";
        _typeInputView.rightTf.userInteractionEnabled = NO;
        
    }
    return _typeInputView;
}
- (void)setOrderStatus:(NSString *)orderStatus {
    _orderStatus = orderStatus;
    self.typeInputView.rightTf.text  = orderStatus;
}
- (UIButton *)payButton {
    if (!_payButton) {
        _payButton = [UIButton createTextButtonWithFrame:RECT(40, HEIGHT(self.baseScrollView)-90., ScreenWidth-80, 50) bgColor:ColorBlue textColor:[UIColor whiteColor] font:15 bold:YES title:@"立即支付"];
        [_payButton addTarget:self action:@selector(apyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payButton.layer.cornerRadius = 5;
        _payButton.layer.masksToBounds = YES;
    }
    return _payButton;
}
#pragma mark 相关代理
- (void)disMissBtnClick {
    if (_payBlock) {
        _payBlock(1);
    }
    //取消
}
//立即支付
- (void)apyBtnClick {
    if (_payBlock) {
        _payBlock(2);
    }
    //支付
}
- (void)sureBtnClick {
    if (_payBlock) {
        _payBlock(4);
    }
}
@end
