//
//  passwordView.m
//  FML
//
//  Created by 车杰 on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "passwordView.h"

@implementation passwordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.unitField];
        UIButton *forgetBtn = [UIButton createimageButtonWithFrame:RECT(ScreenWidth/2.0+70, 90, 80, 30) imageName:@""];
        [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        forgetBtn.titleLabel.font = FONT(14);
        [forgetBtn setBackgroundColor:[UIColor whiteColor]];
        [forgetBtn addTarget:self action:@selector(forgetBtn) forControlEvents:UIControlEventTouchUpInside];
        [forgetBtn setTitleColor:ColorBlue forState:UIControlStateNormal];
        [self addSubview:forgetBtn];
    }
    return self;
}
- (WLUnitField *)unitField {
    if (!_unitField) {
        _unitField = [[WLUnitField alloc]initWithFrame:RECT(ScreenWidth/2.0-150, 30, 300, 50)];
        _unitField.delegate = self;
        _unitField.unitSpace =  10;
        _unitField.inputUnitCount = 6;
        _unitField.borderRadius = 0;
        _unitField.borderWidth = 0;
        _unitField.textFont = [UIFont boldSystemFontOfSize:20];
        _unitField.secureTextEntry = YES;
        _unitField.textColor =Color1D;
        _unitField.cursorColor = Color1D;
        _unitField.trackTintColor = colorWithHexString(@"#b7b7b7");
        _unitField.autoResignFirstResponderWhenInputFinished = YES;
        [_unitField addTarget:self action:@selector(unitFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        for (int i = 0; i<6; i++) {
            UIView *line = [UIView createViewWithFrame:RECT(ScreenWidth/2.0-150+250/6.0*i+10*i, 80, 250/6.0, .5) color:colorWithHexString(@"#b8bbcc")];
            [self addSubview:line];
        }
    }
    return _unitField;
}

- (void)unitFieldEditingChanged:(WLUnitField *)uniField {
    _password = uniField.text;
    if (_password.length == 6) {
        if (_passwordBlock) {
            _passwordBlock(2);
        }
    }
}
- (BOOL)unitField:(WLUnitField *)uniField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}
- (void)forgetBtn {
    if (_passwordBlock) {
        _passwordBlock(1);
    }
}
@end
