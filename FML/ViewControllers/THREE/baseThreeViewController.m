//
//  baseThreeViewController.m
//  ManggeekBaseProject
//
//  Created by 车杰 on 2017/12/20.
//  Copyright © 2017年 Jacky. All rights reserved.
//

#import "baseThreeViewController.h"
#import "XYSliderView.h"
#import "CtoCView.h"
@interface baseThreeViewController ()

@property (nonatomic, strong) XYSliderView*     sliderView;
@property (nonatomic, strong) UIScrollView*     scrollView;
@property (nonatomic, strong) CtoCView*     exchangeView1;
@property (nonatomic, strong) CtoCView*     exchangeView2;

@end

@implementation baseThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setView];
    __weak typeof(self) weakSelf = self;
    self.sliderView.currentClickIndex = ^(NSUInteger currentIndex) {
        if (currentIndex == 1) {
            [weakSelf.scrollView addSubview:weakSelf.exchangeView2];
        }
    };
} 
- (void)setView {
    _exchangeView1 = [[CtoCView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height) type:ExchangeViewTypeBuy];
    [self.scrollView addSubview:_exchangeView1];

}

- (CtoCView *)exchangeView2 {
    if (!_exchangeView2) {
        _exchangeView2 = [[CtoCView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, self.scrollView.width, self.scrollView.height) type:ExchangeViewTypeSell];
    }
    return _exchangeView2;
}

- (XYSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[XYSliderView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 100, NavHeight - 44, 200, 45)];
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
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight + 1, ScreenWidth, ScreenHeight - NavHeight - 1 - TabBarHeight)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(2 * ScreenWidth, 0);
        _scrollView.backgroundColor = RGB_A(248, 248, 248, 1);
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

@end
