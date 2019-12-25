//
//  FMLExchangeViewController.m
//  FML
//
//  Created by 车杰 on 2018/9/17.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "FMLExchangeViewController.h"
#import "CutsomPayView.h"
#import "FindPswViewController.h"
#import "FMLlistViewController.h"
@interface FMLExchangeViewController ()<UITextFieldDelegate> {
    BOOL isHaveDian;
}
@property (nonatomic,strong)UIScrollView *baseScrollView;
@property (nonatomic,strong)UILabel *statusLabel;
@property (nonatomic,strong)UITextField *numberTF;
@property (nonatomic,strong)UILabel *ExchangeLabel;
@property (nonatomic,strong)UILabel *numberLabel;
@property (nonatomic,strong)UIView *typeView;
@property (nonatomic,strong)NSDictionary *resultDic;
@property (nonatomic,strong)CutsomPayView *payView;
@end

@implementation FMLExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self NavigationItemTitle:@"兑换" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    [self navgationRightButtonImage:@"icon_ico_order"];
}
- (void)navgationRightButtonClick {
    FMLlistViewController *vc = [[FMLlistViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)requestData {
    [self showProgressHud];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"exchangeRecord/currency_rate.htm".apifml method:POST args:params];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            _resultDic = responseMessage.bussinessData;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self layoutUI];
            });
        }
    }];
}
- (void)layoutUI {

    _baseScrollView = [[UIScrollView alloc]initWithFrame:RECT(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight)];
    _baseScrollView.backgroundColor =ColorBg;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_baseScrollView];
    
    UIView *topView = [UIView createViewWithFrame:RECT(15, 20, ScreenWidth-30, 50) color:[UIColor whiteColor] cornerRadius:3];
    topView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeType)];
    [topView addGestureRecognizer:tap];
    [_baseScrollView addSubview:topView];
    
    UILabel *Label1 = [UILabel new];
    [Label1 rect:RECT(15, 0, 100, 50) aligment:Left font:13 isBold:NO text:@"兑换币种" textColor:Color4D superView:topView];
    
    _statusLabel = [UILabel new];
    [_statusLabel rect:RECT(115, 0, WIDTH(topView)-142, 50) aligment:Right font:15 isBold:YES text:@"ETH" textColor:Color4D superView:topView];
    
    UIImageView *imageView = [UIImageView createImageViewWithFrame:RECT(WIDTH(topView)-25, 10, 20, 30) imageName:@"icon_right"];
    imageView.contentMode = UIViewContentModeCenter;
    [topView addSubview:imageView];
    
    UIView *middleView = [UIView createViewWithFrame:RECT(15, GETY(topView.frame)+20, ScreenWidth-30, 150) color:[UIColor whiteColor] cornerRadius:3];
    [_baseScrollView addSubview:middleView];
    
    NSArray *array = @[@"兑换数量",@"交易对",@"FML数量"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *Label1 = [UILabel new];
        [Label1 rect:RECT(15, 50*idx, 100, 50) aligment:Left font:13 isBold:NO text:array[idx] textColor:Color4D superView:middleView];
        if (idx!=array.count-1) {
            UIView *lineView = [UIView createViewWithFrame:RECT(20, 50*(idx+1), WIDTH(middleView)-40,.5) color:ColorLine];
            [middleView addSubview:lineView];
        }
        if (idx==0) {
            _numberTF = [[UITextField alloc]initWithFrame:RECT(115, 10, WIDTH(topView)-130, 30)];
            _numberTF.placeholder = [NSString stringWithFormat:@"可兑换%.2fETH",_currencyNumber/([_resultDic[@"ethRate"] doubleValue]/[_resultDic[@"fmlRate"] doubleValue])];
            _numberTF.font = FONT(13);
            _numberTF.textAlignment = NSTextAlignmentRight;
            _numberTF.borderStyle = UITextBorderStyleNone;
            _numberTF.delegate = self;
            _numberTF.textColor = Color4D;
            [middleView addSubview:_numberTF];
        }else if (idx==1) {
            _ExchangeLabel = [UILabel new];
            [_ExchangeLabel rect:RECT(115, 60, WIDTH(topView)-130, 30) aligment:Right font:13 isBold:YES text:[NSString stringWithFormat:@"ETH/FML %.2f",[_resultDic[@"ethRate"] doubleValue]/[_resultDic[@"fmlRate"] doubleValue]] textColor:Color4D superView:middleView];
            _ExchangeLabel.adjustsFontSizeToFitWidth = YES;
        }else {
            _numberLabel = [UILabel new];
            [_numberLabel rect:RECT(115, 110, WIDTH(topView)-130, 30) aligment:Right font:13 isBold:YES text:[NSString stringWithFormat:@"余额:%.2fFML",_currencyNumber] textColor:ColorGray superView:middleView];
            _numberLabel.adjustsFontSizeToFitWidth = YES;
            
        }
    }];
    UIView *bgView = [UIView createViewWithFrame:RECT(40, ScreenHeight-SafeAreaBottomHeight-80, ScreenWidth-80, 50) color:[UIColor whiteColor]];
    bgView.layer.cornerRadius = 3;
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)colorWithHexString(@"#56a2fa").CGColor, (__bridge id)colorWithHexString(@"#5065f9").CGColor];
    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height);
    [bgView.layer addSublayer:gradientLayer];
    
    UIButton *sure = [UIButton createTextButtonWithFrame:RECT(20, ScreenHeight-SafeAreaBottomHeight-80, ScreenWidth-40, 50)  bgColor:[UIColor clearColor] textColor:[UIColor whiteColor] font:14 bold:NO title:@"确认"];
    [sure addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sure];
    
}
- (void)changeType {
    [self showShadowViewWithColor:YES];
    if (!_typeView) {
        _typeView = [UIView createViewWithFrame:RECT(0, ScreenHeight, ScreenWidth, 150+SafeAreaBottomHeight) color:[UIColor whiteColor]];
        NSArray *array = @[@"ETH",@"BTC",@"USDT"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton createTextButtonWithFrame:RECT(0, 5+50*idx, ScreenWidth, 40) bgColor:[UIColor whiteColor] textColor:Color1D font:15 bold:YES title:array[idx]];
            button.tag = 100+idx;
            [button addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_typeView addSubview:button];
            
            UIView *lineView = [UIView createViewWithFrame:RECT(0, 50*(idx+1), ScreenWidth,.5) color:ColorLine];
            [_typeView addSubview:lineView];
        }];
        [UIView animateWithDuration:.3 animations:^{
            _typeView.frame = RECT(0, ScreenHeight-150-SafeAreaBottomHeight, ScreenWidth, 150+SafeAreaBottomHeight);
        }];
        [MainWindow addSubview:_typeView];
    }
}
- (void)typeButtonClick:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
        {
            _statusLabel.text = @"ETH";
            _ExchangeLabel.text = [NSString stringWithFormat:@"ETH/FML %.2f",[_resultDic[@"ethRate"] doubleValue]/[_resultDic[@"fmlRate"] doubleValue]];
           _numberTF.placeholder =  [NSString stringWithFormat:@"可兑换%.2fETH",_currencyNumber/([_resultDic[@"ethRate"] doubleValue]/[_resultDic[@"fmlRate"] doubleValue])];
        }
            break;
        case 101:
        {
            _statusLabel.text = @"BTC";
            _ExchangeLabel.text = [NSString stringWithFormat:@"BTC/FML %.2f",[_resultDic[@"btcRate"] doubleValue]/[_resultDic[@"fmlRate"] doubleValue]];
            _numberTF.placeholder =  [NSString stringWithFormat:@"可兑换%.2fBTC",_currencyNumber/([_resultDic[@"btcRate"] doubleValue]/[_resultDic[@"fmlRate"] doubleValue])];

        }
            break;
        case 102:
        {
            _statusLabel.text = @"USDT";
            _ExchangeLabel.text = [NSString stringWithFormat:@"USDT/FML %.2f",[_resultDic[@"usdtRate"] doubleValue]/[_resultDic[@"fmlRate"] doubleValue]];
            _numberTF.placeholder =  [NSString stringWithFormat:@"可兑换%.2fUSDT",_currencyNumber/([_resultDic[@"usdtRate"] doubleValue]/[_resultDic[@"fmlRate"] doubleValue])];
        }
            break;
        default:
            break;
    }
    _numberTF.text = @"";
    _numberLabel.text = [NSString stringWithFormat:@"余额:%.2fFML",_currencyNumber];
    _numberLabel.textColor = ColorGray;
    [UIView animateWithDuration:.3 animations:^{
        _typeView.frame = RECT(0, ScreenHeight, ScreenWidth, 150+SafeAreaBottomHeight);
    }completion:^(BOOL finished) {
        [_typeView removeFromSuperview];
        _typeView = nil;
        [self hiddenShadowView];
    }];
}
- (void)sureButtonClick {
    if (_numberTF.text.length==0) {
        [self showToastHUD:@"请输入兑换数量"];
        return;
    }
    if ([_numberTF.text doubleValue]<=0) {
        [self showToastHUD:@"兑换数量不能小于0"];
        return;
    }
    if ([_numberTF.text doubleValue]>[_numberLabel.text doubleValue]) {
        [self showToastHUD:@"兑换数量不能大于可兑换数量"];
        return;
    }
    [_numberTF endEditing:YES];
    [self showShadowViewWithColor:YES];
    if (!_payView) {
        __weak typeof(self)weakSelf = self;
        _payView = [[CutsomPayView alloc]initWithFrame:RECT(0, ScreenHeight, ScreenWidth, 420)];
        [_payView createPasswordView];
        [MainWindow addSubview:_payView];
        [UIView animateWithDuration:.3 animations:^{
            _payView.frame = RECT(0, ScreenHeight-420, ScreenWidth, 420);
        }];
      
        _payView.payBlock = ^(NSInteger index) {
            if (index==1) {
                //取消
                [weakSelf hiddenPayView:NO];
            }else if(index==2){
                //支付
                [weakSelf.payView createPasswordView];
            }else if (index==3) {
                [weakSelf hiddenPayView:NO];
                [weakSelf hiddenShadowView];
                FindPswViewController* vc = [FindPswViewController new];
                vc.type = FMLPasswordTypeChangeBuy;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if (index==4) {
                [weakSelf hiddenPayView:YES];
            }else if (index==5) {
                [weakSelf doExchange];
            }
        };
    }
}
- (void)doExchange {
    [self showProgressHud];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"exchangeRecord/fml_exchange.htm".apifml method:POST args:params];
    [params setValue:_statusLabel.text forKey:@"type"];
    [params setValue:self.payView.pswView.password forKey:@"payPwd"];
    [params setValue:[NSNumber numberWithDouble:[_numberTF.text doubleValue]] forKey:@"number"];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            [self showToastHUD:@"兑换成功"];
            [self hiddenPayView:YES];
        }
    }];
}
- (void)hiddenPayView:(BOOL)dismiss {
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
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length==0) {
        _numberLabel.text = [NSString stringWithFormat:@"可用%.2fFML",_currencyNumber];
        _numberLabel.textColor = ColorGray;
    }else {
        if ([_statusLabel.text isEqualToString:@"ETH"]) {
            _numberLabel.text = [NSString stringWithFormat:@"%.2fFML",[textField.text doubleValue]*[_resultDic[@"ethRate"] doubleValue]/[_resultDic[@"fmlRate"] doubleValue]];
        }else if ([_statusLabel.text isEqualToString:@"BTC"]) {
            _numberLabel.text = [NSString stringWithFormat:@"%.2fFML",[textField.text doubleValue]*[_resultDic[@"btcRate"] doubleValue]/[_resultDic[@"fmlRate"] doubleValue]];
        }else {
            _numberLabel.text = [NSString stringWithFormat:@"%.2fFML",[textField.text doubleValue]*[_resultDic[@"usdtRate"] doubleValue]/[_resultDic[@"fmlRate"] doubleValue]];
        }
        _numberLabel.textColor = Color4D;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [self showToastHUD:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            if ([textField.text isEqualToString:@"0"]) {
                if (single != '.') {
                    [self showToastHUD:@"亲，第一个数字不能为0"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    [self showToastHUD:@"亲，您已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        [self showToastHUD:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [self showToastHUD:@"亲，您输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
