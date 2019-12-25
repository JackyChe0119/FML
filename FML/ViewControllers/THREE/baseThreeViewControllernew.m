//
//  baseThreeViewControllernew.m
//  FML
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "baseThreeViewControllernew.h"
#import "XYSliderView.h"
#import "ExchangeView.h"
#import "UIButton+EdgeInset.h"
#import "PopoverView.h"
#import "MyOrderViewController.h"
@interface baseThreeViewControllernew ()<ShadowViewDelegate>

@property (nonatomic, strong) XYSliderView*     sliderView;
@property (nonatomic, strong) UIScrollView*     scrollView;
@property (nonatomic, strong) ExchangeView*     exchangeView1;
@property (nonatomic, strong) ExchangeView*     exchangeView2;
@property (nonatomic, strong) PopoverView*      popView;
@property (nonatomic, strong) UIButton*         selectBtn;
@property (nonatomic,strong) NSArray *BitListArray;//币种数据源
@property (nonatomic,assign) BOOL isLoadSuccessful;//是否加载成功

@property (nonatomic, copy) NSString*           currencyId;

@end

@implementation baseThreeViewControllernew

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shadowViewDelegate = self;
    [self navgationRightButtonImage:@"icon_exchangelistwieth"];
}
- (void)doRewuestBitList:(BOOL)refresh {
    if (self.isLoadSuccessful) {
        return;
    }
    [self showProgressHud];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"sys_currency/show_currency.htm".apifml method:POST args:params];
    [self hiddenProgressHud];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            self.BitListArray = responseMessage.bussinessData;
            self.isLoadSuccessful = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setView];
            });
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self doRewuestBitList:NO];

}
- (void)navgationRightButtonClick {
    [self hiddenView];
    MyOrderViewController *ordrVC = [[MyOrderViewController alloc]init];
    [self.navigationController pushViewController:ordrVC animated:YES];
}
- (void)setView {
    self.customNavView.backgroundColor = ColorBlue;
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.backgroundColor = ColorBlue;
    if (self.BitListArray.count>0) {
        NSDictionary *listA = self.BitListArray[0];
        _currencyId = [NSString stringWithFormat:@"%ld",[listA[@"id"] integerValue]];
        [_selectBtn setTitle:[NSString stringWithFormat:@"%@  ",listA[@"currencyName"]] forState:UIControlStateNormal];
    }
    [self.customNavView addSubview:_selectBtn];
    [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_selectBtn setTitleColor:ColorWhite forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"cc_unselect"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"cc_select"] forState:UIControlStateSelected];
    _selectBtn.width = 100;
    [_selectBtn exchangeImageAndTitle];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.customNavView).offset(-15);
        make.centerX.equalTo(self.customNavView);
    }];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBtnClick)];
    [self.customNavView addGestureRecognizer:tap];
    
    
    [self.view addSubview:self.sliderView];
    _exchangeView1 = [[ExchangeView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height) type:ExchangeViewTypeBuy];
    _exchangeView1.currencyId = _currencyId;
    [self.scrollView addSubview:_exchangeView1];
    
    [self.scrollView addSubview:self.exchangeView2];
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
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight + 45, ScreenWidth, ScreenHeight - NavHeight - 45 - TabBarHeight)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(2 * ScreenWidth, 0);
        _scrollView.backgroundColor = RGB_A(248, 248, 248, 1);
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (PopoverView *)popView {
    if (!_popView) {
        _popView = [[PopoverView alloc] initWithFrame:CGRectMake((ScreenWidth - 133) / 2, - 7.5, 133, 0) titles:self.BitListArray selectIndex:0];
        _popView.clipsToBounds = YES;
        __weak typeof(self) weakSelf = self;
        _popView.popoverHandler = ^(NSString *currencyId, NSString *currencyName) {
            weakSelf.currencyId = currencyId;
            weakSelf.exchangeView1.currencyId = currencyId;
            weakSelf.exchangeView2.currencyId = currencyId;
            weakSelf.selectBtn.selected = !weakSelf.selectBtn.selected;
            [weakSelf hiddenView];
            [weakSelf.selectBtn setTitle:currencyName forState:UIControlStateNormal];
            [weakSelf.selectBtn exchangeImageAndTitle];
        };
    }
    return _popView;
}


- (void)selectBtnClick {
    if (!self.isLoadSuccessful) {
        [self doRewuestBitList:YES];
        return;
    }
    _selectBtn.selected = !_selectBtn.selected;
    if (_selectBtn.selected) {
        [self showShadowViewWithColor:YES];
        self.shadowView.top = self.customNavView.bottom;
        [self.shadowView addSubview:self.popView];
        [UIView animateWithDuration:0.3 animations:^{
            self.popView.height = 160;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [self hiddenView];
    }


}

- (void)touchesInShadowView {
    [self hiddenView];
    self.selectBtn.selected = !self.selectBtn.selected;
}

- (void)hiddenView {
    [self hiddenShadowView];
    [UIView animateWithDuration:0.3 animations:^{
        _popView.height = 0;
    } completion:^(BOOL finished) {
    }];
}
@end
