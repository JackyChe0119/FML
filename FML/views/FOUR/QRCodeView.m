//
//  QRCodeView.m
//  FML
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "QRCodeView.h"
#import "ZXingObjC.h"

@implementation QRCodeView {
    UILabel* _teamName;
    UIImageView*    _qrcode;
}


- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self setView];
    }
    return self;
}

- (void)setView {
    UIView* view = [UIView new];
    view.backgroundColor = ColorWhite;
    view.layer.cornerRadius = 5;
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(ScreenWidth * 0.8);
    }];
    
    _teamName = [UILabel new];
    _teamName.textColor = Color4D;
    _teamName.font = [UIFont systemFontOfSize:16];
    _teamName.text = @"我的团队";
    [view addSubview:_teamName];
    [_teamName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(20);
        make.top.equalTo(view).offset(25);
    }];
    
    UIButton* btn = [UIButton new];
    [btn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(view);
        make.width.height.mas_equalTo(50);
    }];
    
    _qrcode = [UIImageView new];
    [view addSubview:_qrcode];
    [_qrcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.width.height.mas_equalTo(200);
    }];
    
    UILabel* tip = [UILabel new];
    tip.text = @"扫描上方二维码加入团队";
    tip.textColor = Color4D;
    tip.font = [UIFont systemFontOfSize:14];
    [view addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_qrcode);
        make.top.equalTo(_qrcode.mas_bottom).offset(-5);
    }];
    
}

- (void)createQRCodeStr:(NSString *)qrStr teamName:(NSString *)teamName {
    _qrcode.image = [self createCodeWithString:qrStr size:CGSizeMake(200, 200) CodeFomart:kBarcodeFormatQRCode];
    _teamName.text = teamName;
}

- (void)closeView {
    [self removeFromSuperview];
}

- (UIImage*)createCodeWithString:(NSString*)str
                            size:(CGSize)size
                      CodeFomart:(ZXBarcodeFormat)format
{
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result = [writer encode:str format:format width:size.width height:size.width error:nil];
    ZXImage *image = [ZXImage imageWithMatrix:result];
    return [UIImage imageWithCGImage:image.cgimage];
}


@end
