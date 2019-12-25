//
//  statusView.m
//  FML
//
//  Created by 车杰 on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "statusView.h"

@implementation statusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.statusLabel];
    }
    return self;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView ) {
        _iconImageView = [UIImageView createImageViewWithFrame:RECT(WIDTH(self)/2.0-45, 10, 90, 90) imageName:@"iocn_successful"];
        _iconImageView.contentMode = UIViewContentModeCenter;
    }
    return _iconImageView;
}
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        [_statusLabel rect:RECT(0, GETY(self.iconImageView.frame)+5, WIDTH(self), 45) aligment:Center font:15 isBold:NO text:@"支付成功" textColor:Color1D superView:nil];
        _statusLabel.numberOfLines = 2;
    }
    return _statusLabel;
}
- (void)setImageStr:(NSString *)imageStr {
    _imageStr = imageStr;
    self.iconImageView.image = IMAGE(imageStr);
}
- (void)setStatus:(NSString *)status {
    _status = status;
    self.statusLabel.text = status;
}
@end
