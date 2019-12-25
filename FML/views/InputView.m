//
//  InputView.m
//  FML
//
//  Created by 车杰 on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "InputView.h"

@implementation InputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightTf];
        [self addSubview:self.lineView];
    }
    return self;
}
- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        [_leftLabel rect:RECT(15, 5, 80, self.frame.size.height-10) aligment:Left font:16 isBold:NO text:@"" textColor:Color1D superView:nil];
    }
    return _leftLabel;
}
- (UITextField *)rightTf {
    if (!_rightTf) {
        _rightTf = [[UITextField alloc]initWithFrame:RECT(GETX(self.leftLabel.frame)+5, HEIGHT(self)/2.0-15, WIDTH(self)-GETX(self.leftLabel.frame)-5-15, 30)];
        _rightTf.borderStyle = 0;
        _rightTf.font = FONT(16);
        _rightTf.delegate = self;
        _rightTf.textAlignment = NSTextAlignmentRight;
        _rightTf.textColor = colorWithHexString(@"#111111");
    }
    return _rightTf;
}
- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        [_rightLabel rect:RECT(GETX(self.leftLabel.frame)+5, HEIGHT(self)/2.0-20, WIDTH(self)-GETX(self.leftLabel.frame)-5-15, 40) aligment:Right font:14 isBold:NO text:_rightStr textColor:ColorGrayText superView:nil];
        _rightLabel.numberOfLines = 2;
        _rightLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _rightLabel;
}
- (void)setRightStr:(NSString *)rightStr {
    _rightStr = rightStr;
    [self addSubview:self.rightLabel];
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView createViewWithFrame:RECT(15, HEIGHT(self)-0.5, WIDTH(self)-15 ,.5) color:colorWithHexString(@"#ebebeb")];
    }
    return _lineView;
}
- (void)setLeftStr:(NSString *)leftStr {
    _leftStr = leftStr;
    self.leftLabel.text = _leftStr;
}
- (void)setRightTfPalceHold:(NSString *)rightTfPalceHold {
    _rightTfPalceHold = rightTfPalceHold;
    self.rightTf.placeholder = rightTfPalceHold;
}
- (void)setLineViewHidden:(BOOL)lineViewHidden {
    self.lineView.hidden = lineViewHidden;
}
- (void)setLeftLabelWidth:(CGFloat)leftLabelWidth {
    _leftLabelWidth = leftLabelWidth;
    self.leftLabel.frame = RECT(15,  5, leftLabelWidth, self.frame.size.height-10);
    self.rightTf.frame = RECT(GETX(self.leftLabel.frame)+5, HEIGHT(self)/2.0-15, WIDTH(self)-GETX(self.leftLabel.frame)-5-15, 30);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}
@end
