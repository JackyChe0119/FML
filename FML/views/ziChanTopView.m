//
//  ziChanTopView.m
//  FML
//
//  Created by 车杰 on 2018/7/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "ziChanTopView.h"

@implementation ziChanTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =colorWithHexString(@"#f8f8f8");
        UIImageView *baseIamgeView = [UIImageView createImageViewWithFrame:RECT(5, 20, ScreenWidth-10, 145) imageName:@"iocn_zichantop"];
        baseIamgeView.contentMode = 2;
        [self addSubview:baseIamgeView];
        
        [self addSubview:self.qianbaoIamgeView];
        [self addSubview:self.titleLabel];
//        [self addSubview:self.subTitlelabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.seleectButton];

//        UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
//        [btn setImage:[UIImage imageNamed:@"pasteboard"] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(pasteboard) forControlEvents:UIControlEventTouchUpInside];
//        btn.frame = CGRectMake(self.subTitlelabel.right , self.subTitlelabel.top - (20 - self.subTitlelabel.height / 2) , 40, 40);
//        [self addSubview:btn];
    }
    return self;
}

//- (void)pasteboard {
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    if ([UserSingle sharedUser].walletAddress!=nil) {
//        pasteboard.string = [UserSingle sharedUser].walletAddress;
//    }
//    [(MJBaseViewController *)self.viewController showToastHUD:@"复制成功"];
//}
- (UIImageView *)qianbaoIamgeView {
    if (!_qianbaoIamgeView) {
        _qianbaoIamgeView = [UIImageView createImageViewWithFrame:RECT(35, 40, 40, 40) imageName:@""];
        _qianbaoIamgeView.layer.cornerRadius = 20;
        _qianbaoIamgeView.layer.masksToBounds = YES;
        _qianbaoIamgeView.backgroundColor = [UIColor whiteColor];
        [_qianbaoIamgeView sd_setImageWithURL:[UserSingle sharedUser].picture.toUrl placeholderImage:[UIImage imageNamed:@"icon_default"]];
    }
    return _qianbaoIamgeView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [_titleLabel rect:RECT(90, 40, ScreenWidth-120, 40) aligment:Left font:16 isBold:NO text:@"我的钱包" textColor:ColorWhite superView:nil];
    }
    return _titleLabel;
}
- (UILabel *)subTitlelabel {
    if (!_subTitlelabel) {
        _subTitlelabel = [UILabel new];
        [_subTitlelabel rect:RECT(90, 63, 70, 18) aligment:Left font:12 isBold:NO text:@"" textColor:ColorWhite superView:nil];
    }
    return _subTitlelabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        [_priceLabel rect:RECT(35, 110, ScreenWidth-100, 25) aligment:Left font:21 isBold:NO text:@"" textColor:ColorWhite superView:nil];
        _priceLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _priceLabel;
}
- (UIButton *)seleectButton {
    if (!_seleectButton) {
        _seleectButton = [UIButton createimageButtonWithFrame:RECT(ScreenWidth-60, 110, 40, 40) imageName:@"icon_xiala"];
        [_seleectButton addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seleectButton;
}
- (void)setUrl:(NSString *)url {
    _url = url;
    [self.qianbaoIamgeView sd_setImageWithURL:[NSURL URLWithString:url]];
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}
- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    self.subTitlelabel.text = subtitle;
}
- (void)setPrice:(NSString *)price{
    _price = price;
    self.priceLabel.text = price;
}
- (void)selectBtnClick {
    _seleectButton.selected= !_seleectButton.selected;
//    if (_seleectButton.selected) {
//        [_seleectButton setImage:IMAGE(@"icon_shangla") forState:UIControlStateNormal];
//    }else {
//        [_seleectButton setImage:IMAGE(@"icon_xiala") forState:UIControlStateNormal];
//    }
    if (_seleectButton.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            _seleectButton.transform = CGAffineTransformMakeRotation(180 *M_PI / 180.0);
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            _seleectButton.transform = CGAffineTransformMakeRotation(0);
        }];
    }
    
    
    if (_exChangeBlock) {
        _exChangeBlock(_seleectButton.selected);
    }
}


@end
