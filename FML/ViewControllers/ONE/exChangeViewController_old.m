//
//  exChangeViewController.m
//  FML
//
//  Created by 车杰 on 2018/7/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "exChangeViewController_old.h"
#import "InputView.h"
#import "CutsomPayView.h"
#import "CurrencyDetailViewController.h"
#import "DateUtil.h"
#import "SetPasswordViewController.h"

@interface exChangeViewController_old ()
@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) UILabel *refreshTimeLabel;
@property (nonatomic, strong) CutsomPayView *payView;
@property (nonatomic, strong) UIImageView* currencyIV;
@property (nonatomic, strong) UILabel *currencyNameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) InputView *perPriceInputView;
@property (nonatomic, strong) InputView *TotalInputView;

@property (nonatomic, copy) NSString*   icoId;

@end

@implementation exChangeViewController_old

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
}

- (void)layoutUI {
    [self NavigationItemTitle:@"兑换" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    
    _baseScrollView = [[UIScrollView alloc]initWithFrame:RECT(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight)];
    _baseScrollView.backgroundColor = ColorBg;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    _baseScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_baseScrollView];
    
    [self layoutTopView];
    
    [self layoutBottomView];

    [self exchange];

}
- (void)layoutTopView {
    
    UIView *topView = [UIView createViewWithFrame:RECT(15, 20, ScreenWidth-30, 143) color:[UIColor whiteColor]];
    topView.layer.shadowOffset = CGSizeMake(0, 0);
    topView.layer.shadowColor = [UIColor blackColor].CGColor;
    topView.layer.shadowOpacity = .1;
    topView.layer.cornerRadius = 5;
    [_baseScrollView addSubview:topView];
    
    UIImageView *timeImage = [UIImageView createImageViewWithFrame:RECT(15, 15, 20, 20) imageName:@"icon_refreshtime"];
    timeImage.contentMode = UIViewContentModeCenter;
    [topView addSubview:timeImage];
    
    _refreshTimeLabel = [UILabel new];
    [_refreshTimeLabel rect:RECT(40, 15, ScreenHeight-75, 20) aligment:Left font:13 isBold:NO text:@"价格刷新时间 2018/8/25 10:27" textColor:Color1D superView:topView];
    
    UIImageView *BitImage = [UIImageView createImageViewWithFrame:RECT(15, 55, 30, 30) imageName:@""];
    BitImage.layer.cornerRadius = 15;
    BitImage.layer.masksToBounds = YES;
    BitImage.contentMode = UIViewContentModeCenter;
//    BitImage.backgroundColor = [UIColor yellowColor];
    [topView addSubview:BitImage];
    _currencyIV = BitImage;
    
    UILabel *bitTitleLabel = [UILabel new];
    [bitTitleLabel rect:RECT(GETX(BitImage.frame)+5, 60,80, 20) aligment:Left font:17 isBold:YES text:@"ETH" textColor:Color1D superView:topView];
    _currencyNameLabel = bitTitleLabel;

    UILabel *priceLabel = [UILabel new];
    [priceLabel rect:RECT(GETX(bitTitleLabel.frame)+10, 55,WIDTH(topView)-GETX(bitTitleLabel.frame)-25, 30) aligment:Right font:20 isBold:YES text:@"" textColor:Color1D superView:topView];
    _priceLabel = priceLabel;

    UIButton *introduceBtn = [UIButton createimageButtonWithFrame:RECT(WIDTH(topView)-100, 102, 100, 30) imageName:@"icon_bittype"];
    [introduceBtn setTitle:@" 币种介绍" forState:UIControlStateNormal];
    [introduceBtn setTitleColor:Color4D forState:UIControlStateNormal];
    introduceBtn.titleLabel.font = FONT(13);
    [introduceBtn addTarget:self action:@selector(introduceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:introduceBtn];
}
- (void)layoutBottomView {
    
    UIView *bottomView = [UIView createViewWithFrame:RECT(15, 173, ScreenWidth-30, 165) color:[UIColor whiteColor]];
    bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    bottomView.layer.shadowOpacity = .1;
    bottomView.layer.cornerRadius = 5;
    [_baseScrollView addSubview:bottomView];
    
    InputView *numInputView = [[InputView alloc]initWithFrame:RECT(0,5 , ScreenWidth-30, 45)];
    numInputView.rightTfPalceHold = @"请输入购买币种数量";
    numInputView.leftStr = @"数量";
    numInputView.rightTf.keyboardType = UIKeyboardTypeDecimalPad;
    numInputView.lineView.hidden = YES;
    [bottomView addSubview:numInputView];
    
    InputView *perPriceInputView = [[InputView alloc]initWithFrame:RECT(0,55 , ScreenWidth-30, 55)];
    perPriceInputView.rightTfPalceHold = @"";
    perPriceInputView.rightTf.text = @"¥128";
    perPriceInputView.rightTf.userInteractionEnabled = NO;
    perPriceInputView.rightTf.font = FONT(15);
    perPriceInputView.leftStr = @"币种单价";
    [bottomView addSubview:perPriceInputView];
    _perPriceInputView = perPriceInputView;
    
    InputView *TotalInputView = [[InputView alloc]initWithFrame:RECT(0,115 , ScreenWidth-30, 45)];
    TotalInputView.rightTfPalceHold = @"";
    TotalInputView.rightTf.text = @"¥0.00";
    TotalInputView.rightTf.userInteractionEnabled = NO;
    TotalInputView.rightTf.font = [UIFont boldSystemFontOfSize:18];
    TotalInputView.leftStr = @"总金额";
    TotalInputView.lineView.hidden = YES;
    [bottomView addSubview:TotalInputView];
    _TotalInputView = TotalInputView;
    
    UILabel *liabilityExemptionLabel = [UILabel new];
    [liabilityExemptionLabel rect:RECT(40, GETY(bottomView.frame)+80,100, 20) aligment:Left font:14 isBold:NO text:@"条款(免责声明)" textColor:Color4D superView:_baseScrollView];
    liabilityExemptionLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *TAP = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(liabilityExemptiontap)];
    [liabilityExemptionLabel addGestureRecognizer:TAP];
    
    UIButton *sureBtn = [UIButton createTextButtonWithFrame:RECT(40, GETY(liabilityExemptionLabel.frame)+15, ScreenWidth-80, 50) bgColor:ColorBlue textColor:[UIColor whiteColor] font:14 bold:YES title:@"确认"];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 5;
    sureBtn.layer.masksToBounds = YES;
    [_baseScrollView addSubview:sureBtn];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeOneCI:) name:UITextFieldTextDidChangeNotification object:numInputView.rightTf];
    
}

-(void)textFieldTextDidChangeOneCI:(NSNotification *)notification
{
    UITextField *textfield=[notification object];
    _TotalInputView.rightTf.text = [NSString stringWithFormat:@"%.2f usdt", (_perPriceInputView.rightTf.text.floatValue * textfield.text.floatValue)];
}

- (void)navgationLeftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)introduceBtnClick {
    CurrencyDetailViewController* vc = [CurrencyDetailViewController new];
    vc.icoId = _icoId.intValue;
    vc.currencyName = _currencyNameLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)liabilityExemptiontap {
    [self showToastHUD:@"跳转到免责声明页"];
}
- (void)sureBtnClick {
    [self showShadowViewWithColor:YES];
    if (!_payView) {
        __weak typeof(self)weakSelf = self;
        _payView = [[CutsomPayView alloc]initWithFrame:RECT(0, ScreenHeight, ScreenWidth, 420)];
        [MainWindow addSubview:_payView];
//        _payView.priceLabel.text =
        [UIView animateWithDuration:.3 animations:^{
            _payView.frame = RECT(0, ScreenHeight-420, ScreenWidth, 420);
        }];
        _payView.orderStatus = @"兑换";
        _payView.payBlock = ^(NSInteger index) {
            if (index==1) {
                //取消
                [weakSelf hiddenPayView:NO];
            }else if(index==2){
                //支付
                [weakSelf.payView createPasswordView];
            }else if (index==3) {
                //忘记密码 跳转到忘记密码界面
                [weakSelf hiddenPayView:NO];
                [weakSelf hiddenShadowView];
                FindPswViewController* vc = [FindPswViewController new];
                vc.type = FMLPasswordTypeChangeBuy;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if (index==4) {
                [weakSelf showToastHUD:@"兑换成功"];
                [weakSelf hiddenPayView:YES];
            }
        };
    }
}
- (void)hiddenPayView:(BOOL)dismiss {
//    [_item2.textField resignFirstResponder];
//    [_item3.textField resignFirstResponder];
    [UIView animateWithDuration:.3 animations:^{
        self.payView.frame = RECT(0, ScreenHeight, ScreenWidth, 420);
    } completion:^(BOOL finished) {
        [_payView removeFromSuperview];
        _payView = nil;
        [self hiddenShadowView];
        if (dismiss) {
            [self navgationLeftButtonClick];
        }
    }];
}

- (void)exchange {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"sysCurrencyId"] = _currencyId;

    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"recharge/curr_rate.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            NSDictionary *dic = responseMessage.bussinessData;
            [_currencyIV sd_setImageWithURL:_currencyIcon.toUrl];
            _perPriceInputView.rightTf.text = [NSString stringWithFormat:@"%.2f usdt", String(dic[@"currentPrice"]).floatValue];
            _currencyNameLabel.text = dic[@"currencyName"];
            _refreshTimeLabel.text = [NSString stringWithFormat:@"价格刷新时间 %@", [DateUtil getDateStringFormString:String(dic[@"updateTime"]) format:@"YYYY/M/d H:mm"]];
            _priceLabel.text =  [NSString stringWithFormat:@"%.2f usdt", String(dic[@"currentPrice"]).floatValue];

        }
    }];
}

@end
