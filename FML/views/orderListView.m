//
//  orderListView.m
//  FML
//
//  Created by 车杰 on 2018/8/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "orderListView.h"

@implementation orderListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
    }
    return self;
}
- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        [_leftLabel rect:RECT(15, 3, 80, 20) aligment:Left font:13 isBold:NO text:@"" textColor:colorWithHexString(@"#828599") superView:nil];
    }
    return _leftLabel;
}
- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        [_rightLabel rect:RECT(100, 3, WIDTH(self)-115, 20) aligment:Right font:13 isBold:NO text:@"" textColor:Color4D superView:nil];
    }
    return _rightLabel;
}
- (void)setLeftStr:(NSString *)leftStr {
    _leftStr = leftStr;
    self.leftLabel.text = _leftStr;
}
- (void)setRightStr:(NSString *)rightStr {
    _rightStr = rightStr;
    self.rightLabel.text = rightStr;
}
@end
