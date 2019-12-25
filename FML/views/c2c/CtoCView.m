//
//  CtoCView.m
//  FML
//
//  Created by apple on 2018/8/14.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "CtoCView.h"
#import "XYSliderView.h"
#import "ExchangeView.h"

@interface CtoCView()

@property (nonatomic, strong) UIScrollView*     scrollView;
@property (nonatomic, strong) ExchangeView*     exchangeView1;
@property (nonatomic, strong) ExchangeView*     exchangeView2;
@property (nonatomic, strong) ExchangeView*     exchangeView3;
@property (nonatomic, strong) ExchangeView*     exchangeView4;


@end

@implementation CtoCView {
    ExchangeViewType _type;
}

- (instancetype)initWithFrame:(CGRect)frame type:(ExchangeViewType)type {
    if (self = [super initWithFrame:frame]) {
        _type = type;
        [self setView];
        
    }
    return self;
}

- (void)setView {
    
    XYSliderView* sliderView = [[XYSliderView alloc] initWithFrame:CGRectMake(15, 12, ScreenWidth - 30, 30)];
    sliderView.backgroundColor = [UIColor clearColor];
    sliderView.layer.cornerRadius = 15;
    sliderView.layer.borderColor = Color4D.CGColor;
    sliderView.layer.borderWidth = 1;
    sliderView.layer.masksToBounds = YES;
    [self addSubview:sliderView];
    
    XYSliderModel* model = [[XYSliderModel alloc] init];
    model.titles = @[@"ETH", @"USDT", @"BTC", @"EOS"];
    model.viewType = XYSliderViewTypeDivideWindow;
    model.lineWidth = (ScreenWidth - 15) / 4 - 1;
    model.lineType = XYSliderLineTypeCenter;
    model.selColor = ColorWhite;
    model.unSelColor = Color4D;
    model.lineColor = Color4D;
    model.selFont = [UIFont systemFontOfSize:16];
    model.unSelFont = [UIFont systemFontOfSize:16];
    model.cornerRadius = 15;
    model.lineHeight = 30;
    model.itemBottomOffset = 5;
    model.bottomScrollView = self.scrollView;
    sliderView.typeModel = model;
    
    __weak typeof(self) weakSelf = self;
    sliderView.currentClickIndex = ^(NSUInteger currentIndex) {
        if (currentIndex == 1) {
            [weakSelf.scrollView addSubview:weakSelf.exchangeView2];
        } else if (currentIndex == 2) {
            [weakSelf.scrollView addSubview:weakSelf.exchangeView3];
        } else if (currentIndex == 3) {
            [weakSelf.scrollView addSubview:weakSelf.exchangeView4];
        }
    };
    
    _exchangeView1 = [[ExchangeView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height) type:_type];
    _exchangeView1.currencyId = @"19";
    [self.scrollView addSubview:_exchangeView1];
}

- (ExchangeView *)exchangeView2 {
    if (!_exchangeView2) {
        _exchangeView2 = [[ExchangeView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, self.scrollView.width, self.scrollView.height) type:_type];
        _exchangeView2.currencyId = @"30";
    }
    return _exchangeView2;
}

- (ExchangeView *)exchangeView3 {
    if (!_exchangeView3) {
        _exchangeView3 = [[ExchangeView alloc] initWithFrame:CGRectMake(2 * ScreenWidth, 0, self.scrollView.width, self.scrollView.height) type:_type];
        _exchangeView3.currencyId = @"18";
    }
    return _exchangeView3;
}

- (ExchangeView *)exchangeView4 {
    if (!_exchangeView4) {
        _exchangeView4 = [[ExchangeView alloc] initWithFrame:CGRectMake(3 * ScreenWidth, 0, self.scrollView.width, self.scrollView.height) type:_type];
        _exchangeView4.currencyId = @"23";
    }
    return _exchangeView4;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, self.width, self.height - 45)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(4 * ScreenWidth, 0);
        _scrollView.backgroundColor = RGB_A(248, 248, 248, 1);
        [self addSubview:_scrollView];
    }
    return _scrollView;
}


@end
