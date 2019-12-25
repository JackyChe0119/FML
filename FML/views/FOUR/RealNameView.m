//
//  RealNameView.m
//  FML
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "RealNameView.h"

@implementation RealNameView {
//    UIImageView* _imageView;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setView];
    }
    return self;
}

- (void)setView {
    
    _imageView = [UIImageView new];
    _imageView.userInteractionEnabled = YES;
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(100);
        make.centerX.top.equalTo(self);
    }];
    
    _title = [UILabel new];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.font = [UIFont systemFontOfSize:14];
    _title.textColor = Color1D;
    [self addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self);
        make.top.equalTo(_imageView.mas_bottom).offset(10);
    }];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upImage)];
    [self addGestureRecognizer:tap];
}

- (void)upImage{
    if (_upImageBlock) {
        _upImageBlock(self);
    }
}

- (void)setBaseImage:(UIImage *)baseImage {
    _baseImage = baseImage;
    _imageView.image = baseImage;
}

- (void)setRealImage:(UIImage *)realImage {
    _realImage = realImage;
    _imageView.image = _realImage;
}
@end
