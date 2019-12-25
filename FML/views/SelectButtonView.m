//
//  SelectButtonView.m
//  KangDuKe
//
//  Created by 车杰 on 17/2/23.
//  Copyright © 2017年 MJ Science and Technology Ltd. All rights reserved.
//

#import "SelectButtonView.h"

@implementation SelectButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _selectButton = [UIButton createimageButtonWithFrame:RECT(0, 0, WIDTH(self), HEIGHT(self)) imageName:@""];
        _selectButton.tag = self.tag;
        _selectButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [_selectButton setTitleColor:Color1D forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectButton];
    }
    return self;
}
- (void)setFont:(NSInteger)font {
    _font = font;
    _selectButton.titleLabel.font = [UIFont boldSystemFontOfSize:_font];
}
- (void)setTitleColor:(NSString *)titleColor {
    _titleColor = titleColor;
    [_selectButton setTitleColor:[UIColor colorWithHexString:titleColor] forState:UIControlStateNormal];
}
- (void)setImageStr:(UIImage *)imageStr {
    _imageStr = imageStr;
    [_selectButton setImage:imageStr forState:UIControlStateNormal];
}
- (void)setTitle:(NSString *)title {
    _title = title;
    [_selectButton setTitle:title forState:UIControlStateNormal];
    CGFloat labelWidth = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:_font]}].width;
    labelWidth = labelWidth+3;
    [_selectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_imageStr.size.width, 0, _imageStr.size.width)];
    [_selectButton setImageEdgeInsets:UIEdgeInsetsMake(0, labelWidth+3, 0, -labelWidth)];
}
- (void)selectButtonClick:(UIButton *)sender {
    if (_block) {
        _block (sender.superview.tag);
    }
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(DelegateDidClickAtAnyImageView:)]) {
        [self.delegate DelegateDidClickAtAnyImageView:self];
    }
}
@end
