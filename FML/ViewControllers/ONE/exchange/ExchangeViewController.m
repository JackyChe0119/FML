//
//  ExchangeViewController.m
//  FML
//
//  Created by apple on 2018/8/3.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "ExchangeViewController.h"
#import "XYSliderView.h"
#import "ExchangeView.h"
#import "MyOrderViewController.h"
@interface ExchangeViewController ()

@property (nonatomic, strong) XYSliderView*     sliderView;
@property (nonatomic, strong) UIScrollView*     scrollView;
@property (nonatomic, strong) ExchangeView*     exchangeView1;
@property (nonatomic, strong) ExchangeView*     exchangeView2;

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:[NSString stringWithFormat:@"%@ 兑换", _currencyName] Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    [self navgationRightButtonImage:@"icon_exchangelist"];
    self.view.backgroundColor = RGB_A(248, 248, 248, 1);
    
    __weak typeof(self) weakSelf = self;
    self.sliderView.currentClickIndex = ^(NSUInteger currentIndex) {
        if (currentIndex == 1) {
            [weakSelf.scrollView addSubview:weakSelf.exchangeView2];
        }
    };
    [self setView];
}
- (void)navgationRightButtonClick {
    MyOrderViewController *vc = [[MyOrderViewController alloc]init];
    vc.currencyId = self.currencyId;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setView {
    _exchangeView1 = [[ExchangeView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height) type:ExchangeViewTypeBuy];
    _exchangeView1.currencyId = _currencyId;
    [self.scrollView addSubview:_exchangeView1];
}

- (ExchangeView *)exchangeView2 {
    if (!_exchangeView2) {
        _exchangeView2 = [[ExchangeView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, self.scrollView.width, self.scrollView.height) type:ExchangeViewTypeSell];
        _exchangeView2.currencyId = _currencyId;
    }
    return _exchangeView2;
}

- (XYSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[XYSliderView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, 45)];
        _sliderView.backgroundColor = ColorWhite;
        [self.view addSubview:_sliderView];
        
        XYSliderModel* model = [XYSliderModel new];
        model.titles = @[@"购买", @"出售"];
        model.selColor = Color1D;
        model.unSelColor = ColorGrayText;
        model.lineColor = Color1D;
        model.itemBottomOffset = 13;
        model.viewType = XYSliderViewTypeDivideWindow;
        model.offsetTopTitle = 13;
        model.bottomScrollView = self.scrollView;
        model.lineAdaptOffsetWidth = 5;
        _sliderView.typeModel = model;
    }
    return _sliderView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight + 45, ScreenWidth, ScreenHeight - NavHeight - 45)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(2 * ScreenWidth, 0);
        _scrollView.backgroundColor = RGB_A(248, 248, 248, 1);
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}


@end
