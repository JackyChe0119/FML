//
//  customInputView.m
//  FML
//
//  Created by 车杰 on 2018/7/17.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "customInputView.h"

@implementation customInputView

- (instancetype)initWithFrame:(CGRect)frame style:(NSInteger)style {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.leftImageView];
        [self addSubview:self.inputTextField];
        if (style==0) {
            //普通状态
        }else if (style==1) {
            //按钮
            [self addSubview:self.rightButton];
        }else {
            //验证码
            [self addSubview:self.time_CountLabel];
        }
        [self addSubview:self.lineView];
    }
    return self;
}
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]initWithFrame:RECT(0, HEIGHT(self)/2.0-15, 30, 30)];
        _leftImageView.contentMode = UIViewContentModeCenter;
    }
    return _leftImageView;
}
- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc]initWithFrame:RECT(GETX(self.leftImageView.frame)+5, HEIGHT(self)/2.0-15, WIDTH(self)-60, 30)];
        _inputTextField.borderStyle = 0;
        _inputTextField.font = FONT(14);
        _inputTextField.delegate = self;
        _inputTextField.textColor = colorWithHexString(@"#111111");
    }
    return _inputTextField;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView createViewWithFrame:RECT(0, HEIGHT(self)-0.5, WIDTH(self), .5) color:colorWithHexString(@"#ebebeb")];
    }
    return _lineView;
}
- (UILabel *)time_CountLabel {
    if (!_time_CountLabel) {
        _time_CountLabel = [UILabel new];
        [_time_CountLabel rect:RECT(WIDTH(self)-112, HEIGHT(self)/2.0-17, 112, 34) aligment:Center font:13 isBold:NO text:@"获取验证码" textColor:ColorWhite superView:nil];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(time_countLabel_click)];
        _time_CountLabel.userInteractionEnabled = YES;
        _time_CountLabel.backgroundColor  = ColorBlue;
        _time_CountLabel.layer.cornerRadius = 3;
        _time_CountLabel.layer.masksToBounds = YES;
        [_time_CountLabel addGestureRecognizer:tap];
        self.right_offset = 120;
    }
    return _time_CountLabel;
}
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton createimageButtonWithFrame:RECT(WIDTH(self)-40, HEIGHT(self)/2.0-20, 40, 40) imageName:@""];
        [_rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _right_offset = 40;
    }
    return _rightButton;
}
- (void)setRightImageStr:(NSString *)rightImageStr {
    _rightImageStr = rightImageStr;
    [self.rightButton setImage:IMAGE(rightImageStr) forState:UIControlStateNormal];
}
- (void)setNeedCount_down:(BOOL)needCount_down {
    _needCount_down = needCount_down;
    if (needCount_down) {
        if (self.isBoard) {
            [_time_CountLabel countdown:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.time_CountLabel.backgroundColor = ColorWhite;
                });
            } :^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.time_CountLabel.backgroundColor = ColorWhite;
                });
            }];
        }else {
            [_time_CountLabel countdown:^{} :^{}];
        }
    }
}
- (void)setNeedencryption:(BOOL)needencryption {
    _needencryption = needencryption;
    if (needencryption) {
        self.inputTextField.secureTextEntry = YES;
        self.rightImageStr = @"icon_cannotsee";
    }else {
        self.inputTextField.secureTextEntry = NO;
        self.rightImageStr = @"icon_cansee";
    }
}
#pragma mark 相关事件处理
- (void)time_countLabel_click {
    if (_inputViewBlcok) {
        _inputViewBlcok(2);
    }
}
- (void)setLeftImageHidden:(BOOL)leftImageHidden {
    _leftImageHidden = leftImageHidden;
    if (leftImageHidden) {
        self.leftImageView.hidden = YES;
        self.inputTextField.frame = RECT(0, HEIGHT(self)/2.0-15, WIDTH(self)-_right_offset, 30);
    }
}
- (void)setLeftImageStr:(NSString *)leftImageStr {
    _leftImageStr = leftImageStr;
    UIImage* image = IMAGE(leftImageStr);
//    _leftImageView.left = _leftImageView.left + (_leftImageView.width - image.size.width) / 2;
//    _leftImageView.top = _leftImageView.top + (_leftImageView.height - image.size.height) / 2;
//    _leftImageView.width = image.size.width;
//    _leftImageView.height = image.size.height;
    _leftImageView.image = image;
}
- (void)setIsBoard:(BOOL)isBoard {
    _isBoard = isBoard;
    if (isBoard) {
        _time_CountLabel.backgroundColor = [UIColor whiteColor];
        [_time_CountLabel setTextColor:ColorBlue];
        _time_CountLabel.layer.borderWidth = .5;
        _time_CountLabel.layer.borderColor = ColorBlue.CGColor;
    }
}
- (void)rightBtnClick {
    self.needencryption = !self.needencryption;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}
@end
