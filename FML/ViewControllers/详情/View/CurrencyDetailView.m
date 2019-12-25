//
//  CurrencyDetailView.m
//  XjBaseProject
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 xjhuang. All rights reserved.
//

#import "CurrencyDetailView.h"
#import "CurrencyChartView.h"
#import "CommonUtil.h"
#import "ExchangeViewController.h"
#import "RealNameViewController.h"
#import "FMLAlertView.h"
#import "BindPhoneViewController.h"
#import "FMLExchangeViewController.h"
@interface CurrencyDetailView()

@property (nonatomic, strong) UIImageView*  currencyIcon;
//@property (nonatomic, strong) UILabel*      currencyName;
@property (nonatomic, strong) UILabel*      price;
@property (nonatomic, strong) UILabel*      percent;


@property (nonatomic, strong) CurrencyItem* item1;
@property (nonatomic, strong) CurrencyItem* item2;
@property (nonatomic, strong) CurrencyItem* item3;
@property (nonatomic, strong) CurrencyItem* item4;

@property (nonatomic, strong) CurrencyChartView    *columnChartView;
@property (nonatomic, copy)   NSString             *kingEnum;

@property (nonatomic, assign) BOOL          isLock;

@end

@implementation CurrencyDetailView

- (instancetype)initWithFrame:(CGRect)frame isLock:(BOOL)isLock currencyName:(NSString *)currencyName {
    if (self = [super initWithFrame:frame]) {
        
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.startPoint = CGPointMake(0, 0.5);
        layer.endPoint = CGPointMake(1, 0.5);
        layer.colors = [NSArray arrayWithObjects:(id)colorWithHexString(@"#5172fa").CGColor, (id)colorWithHexString(@"#569dfa").CGColor, nil];
        layer.locations = @[@0.0, @0.5];
        layer.frame = CGRectMake(0, 0, ScreenWidth, isLock ? 239 : 165);
        [self.layer addSublayer:layer];
        _currencyName = currencyName;
        _isLock = isLock;
        if (isLock) {
            [self setLockTopView];
        } else {
            [self setTopView];
        }
        
        [self setMidView];
        [self setBottomView];
        
    }
    return self;
}

- (void)setLockTopView {
    
    
    _price = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 185, 15)];
    _price.textColor = [UIColor whiteColor];
    _price.text = @"0.00 usdt / ETH";
    _price.font = [UIFont systemFontOfSize:16];
    [self addSubview:_price];
    
    _currencyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _price.bottom + 25, 200, 20)];
    _currencyNameLabel.text = @"0.0000 ETH";
    _currencyNameLabel.textColor = [UIColor whiteColor];
    _currencyNameLabel.font = [UIFont systemFontOfSize:21 weight:UIFontWeightSemibold];
    [self addSubview:_currencyNameLabel];
    
    _freeLB = [[UILabel alloc] initWithFrame:CGRectMake(20, _currencyNameLabel.bottom + 15, 200, 15)];
    _freeLB.text = @"可用：0.0000个";
    _freeLB.textColor = [UIColor whiteColor];
    _freeLB.font = [UIFont systemFontOfSize:14];
    [self addSubview:_freeLB];
    
    _lockLB = [[UILabel alloc] initWithFrame:CGRectMake(20, _freeLB.bottom + 8, 200, 15)];
    _lockLB.text = @"锁定：0.0000个";
    _lockLB.textColor = [UIColor whiteColor];
    _lockLB.font = [UIFont systemFontOfSize:14];
    [self addSubview:_lockLB];
    
    UIButton *style = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 20 - 91, _freeLB.top, 91, 35)];
    style.layer.cornerRadius = 4;
    style.backgroundColor = [UIColor colorWithRed:80.0f/255.0f green:106.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
    style.alpha = 1;
    style.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    [style setTitle:@"兑换" forState:UIControlStateNormal];
    [style addTarget:self action:@selector(exchangeVC) forControlEvents:UIControlEventTouchUpInside];
    
    //Shadow 0 for 圆角矩形 4 拷贝 11
    CALayer *shadowLayer0 = [[CALayer alloc] init];
    shadowLayer0.frame = style.frame;
    shadowLayer0.shadowColor = [UIColor colorWithRed:38.0f/255.0f green:59.0f/255.0f blue:179.0f/255.0f alpha:0.39].CGColor;
    shadowLayer0.shadowOpacity = 1;
    shadowLayer0.shadowOffset = CGSizeMake(0, 5);
    shadowLayer0.shadowRadius = 5;
    CGFloat shadowSize0 = -1;
    CGRect shadowSpreadRect0 = CGRectMake(-shadowSize0, -shadowSize0, style.bounds.size.width+shadowSize0*2, style.bounds.size.height+shadowSize0*2);
    CGFloat shadowSpreadRadius0 =  style.layer.cornerRadius == 0 ? 0 : style.layer.cornerRadius+shadowSize0;
    UIBezierPath *shadowPath0 = [UIBezierPath bezierPathWithRoundedRect:shadowSpreadRect0 cornerRadius:shadowSpreadRadius0];
    shadowLayer0.shadowPath = shadowPath0.CGPath;
    [self.layer addSublayer:shadowLayer0];
    [self addSubview:style];
    
}

- (void)setTopView {
    
    UIButton *style = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 20 - 91, 26, 91, 35)];
    style.layer.cornerRadius = 4;
    style.backgroundColor = [UIColor colorWithRed:80.0f/255.0f green:106.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
    style.alpha = 1;
    style.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    [style setTitle:@"兑换" forState:UIControlStateNormal];
    [style addTarget:self action:@selector(exchangeVC) forControlEvents:UIControlEventTouchUpInside];
    
    //Shadow 0 for 圆角矩形 4 拷贝 11
    CALayer *shadowLayer0 = [[CALayer alloc] init];
    shadowLayer0.frame = style.frame;
    shadowLayer0.shadowColor = [UIColor colorWithRed:38.0f/255.0f green:59.0f/255.0f blue:179.0f/255.0f alpha:0.39].CGColor;
    shadowLayer0.shadowOpacity = 1;
    shadowLayer0.shadowOffset = CGSizeMake(0, 5);
    shadowLayer0.shadowRadius = 5;
    CGFloat shadowSize0 = -1;
    CGRect shadowSpreadRect0 = CGRectMake(-shadowSize0, -shadowSize0, style.bounds.size.width+shadowSize0*2, style.bounds.size.height+shadowSize0*2);
    CGFloat shadowSpreadRadius0 =  style.layer.cornerRadius == 0 ? 0 : style.layer.cornerRadius+shadowSize0;
    UIBezierPath *shadowPath0 = [UIBezierPath bezierPathWithRoundedRect:shadowSpreadRect0 cornerRadius:shadowSpreadRadius0];
    shadowLayer0.shadowPath = shadowPath0.CGPath;
    [self.layer addSublayer:shadowLayer0];
    [self addSubview:style];
  
    _currencyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, 200, 20)];
    _currencyNameLabel.text = @"0.0000 ETH";
    _currencyNameLabel.textColor = [UIColor whiteColor];
    _currencyNameLabel.font = [UIFont systemFontOfSize:21 weight:UIFontWeightSemibold];
    _currencyNameLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_currencyNameLabel];

    _price = [[UILabel alloc] initWithFrame:CGRectMake(20, _currencyNameLabel.bottom + 10, 185, 15)];
    _price.textColor = [UIColor whiteColor];
    _price.text = @"0.00 usdt / ETH";
    _price.font = [UIFont systemFontOfSize:16];
    _price.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_price];

}

- (void)addPicWithIndex:(NSInteger )index image:(NSString *)imageName label:(UILabel *)label{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",label.text]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:imageName];
    // 设置图片大小
    attch.bounds = CGRectMake(0, -2, 19, 13);
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    //在文字下标第几个添加图片  0就是文字前面添加图片
    [attri insertAttributedString:string atIndex:index];
    // 用label的attributedText属性来使用富文本
    label.attributedText = attri;
}

- (void)setMidView {
    
    CGFloat top;
    if (_isLock) {
        top = self.lockLB.bottom + 35;
    } else {
        top = BOTTOM(_price) + 40;
    }
    
    _item1 = [[CurrencyItem alloc] initWithFrame:CGRectMake(0, top, ScreenWidth / 2.0, 20)];
//    _item2 = [[CurrencyItem alloc] initWithFrame:CGRectMake(ScreenWidth / 2.0, top, ScreenWidth / 2.0, 20)];
//    _item3 = [[CurrencyItem alloc] initWithFrame:CGRectMake(0, BOTTOM(_item1) + 5, ScreenWidth / 2.0, 20)];
//    _item4 = [[CurrencyItem alloc] initWithFrame:CGRectMake(ScreenWidth / 2.0, BOTTOM(_item1) + 5, ScreenWidth / 2.0, 20)];
    
    [self addSubview:_item1];
    [self addSubview:_item2];
//    [self addSubview:_item3];
//    [self addSubview:_item4];
    
    _item1.leftStr = @"总发行量";
//    _item2.leftStr = @"流通市值";
//    _item3.leftStr = @"交易量";
//    _item4.leftStr = @"24h成交量";
    
    _item1.rightStr = @"0";
//    _item2.rightStr = @"0";
//    _item3.rightStr = @"0";
//    _item4.rightStr = @"0";
    
}

- (void)setBottomView {
    
    self.kingEnum = @"threehour";
    
    [self addSubview:self.columnChartView];
    
    CGRect rect = self.frame;
    rect.size.height = BOTTOM(_columnChartView);
    self.frame = rect;
}

-(CurrencyChartView *)columnChartView{
    if (!_columnChartView) {
        _columnChartView = [[CurrencyChartView alloc]initWithFrame:CGRectMake(0, BOTTOM(_item1) + 15, ScreenWidth, 250) currencyName:_currencyName];
        __weak __typeof(self)weakSelf = self;
        _columnChartView.backgroundColor = [UIColor whiteColor];
        _columnChartView.skChooseView.chooseBlock = ^(NSInteger type) {
            switch (type - 100) {
                case 0:
                {
                    weakSelf.kingEnum = @"sixty";
                    if (weakSelf.isFml) {
                        weakSelf.kingEnum = @"1H";
                    }
                    
                }
                    break;
                case 1:
                {
                    weakSelf.kingEnum = @"oneday";
                    if (weakSelf.isFml) {
                        weakSelf.kingEnum = @"6H";
                    }
                }
                    break;
                case 2:
                {
                    weakSelf.kingEnum = @"oneweek";
                    if (weakSelf.isFml) {
                        weakSelf.kingEnum = @"12H";
                    }
                }
                    break;
                case 3:
                {
                    weakSelf.kingEnum = @"onemon";
                    if (weakSelf.isFml) {
                        weakSelf.kingEnum = @"1D";
                    }
                }
                    break;
                default:
                {
                    weakSelf.kingEnum = @"oneyear";
                    if (weakSelf.isFml) {
                        weakSelf.kingEnum = @"1W";
                    }
                }
                    break;
            }
            if (weakSelf.kingEnumHandle) {
                weakSelf.kingEnumHandle(weakSelf.kingEnum);
            }
//            [weakSelf _getColumnData];
        };
    }
    return _columnChartView;
}

- (void)setKlineDict:(NSArray *)klineDict {
    _klineDict = klineDict;
    NSMutableArray *dataArray = [NSMutableArray array];
    [klineDict enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([_currencyDetailDict[@"currencyName"] isEqualToString:@"FML"]) {
            NSString *str = [NSString stringWithFormat:@"%f",[obj[@"c"] doubleValue]];
            [dataArray addObject:@([str doubleValue])];
        }else {
            NSString *str = [NSString stringWithFormat:@"%f",[obj[@"close"] doubleValue]];
            [dataArray addObject:@([str doubleValue])];
        }
    }];
    self.columnChartView.dataArray = dataArray;
}

- (void)setCurrencyDetailDict:(NSMutableDictionary *)currencyDetailDict {
    _currencyDetailDict = currencyDetailDict;
    self.price.text = [NSString stringWithFormat:@"%.2f usdt / %@",String(_currencyDetailDict[@"price"]).floatValue,_currencyDetailDict[@"currencyName"]];
    [self currencyInfo:_currencyDetailDict[@"currencyName"]];
    if ([_currencyDetailDict[@"currencyName"] isEqualToString:@"FML"]) {
        _isFml = YES;
    }

    self.item1.rightStr = [self numberToString:[_currencyDetailDict[@"totalNumber"] doubleValue]];
    self.item2.rightStr = [NSString stringWithFormat:@"%@ usdt",[self numberToString2:[_currencyDetailDict[@"marketValue"] doubleValue]]];
   
}
- (NSString *)numberToString:(double )value {
    NSString *numberStr = @"";
    if (value>=10000&&value<100000000) {
        numberStr = [NSString stringWithFormat:@"%.2f万",value/10000.0];
    }else if (value>=100000000) {
        numberStr = [NSString stringWithFormat:@"%.2f亿",value/100000000.0];
    }else {
        numberStr = [NSString stringWithFormat:@"%.2f",value/10000.0];
    }
    return numberStr;
}
- (NSString *)numberToString2:(double )value {
    NSString *numberStr = @"";
    if (value>=10000&&value<100000000) {
        numberStr = [NSString stringWithFormat:@"%.2f万",value/10000.0];
    }else if (value>=100000000) {
        numberStr = [NSString stringWithFormat:@"%.2f亿",value/100000000.0];
    }else {
        numberStr = [NSString stringWithFormat:@"%.2f",value/10000.0];
    }
    return numberStr;
    
}
- (void)setLogo:(NSString *)logo {
    _logo = logo;
    [self.currencyIcon sd_setImageWithURL:_logo.toUrl];
}
- (void)setNamecurrency:(NSString *)Namecurrency {
    _Namecurrency = Namecurrency;
}
- (void)exchangeVC {
    if (![_Namecurrency isEqualToString:@"ETH"]&&![_Namecurrency isEqualToString:@"USDT"]&&![_Namecurrency isEqualToString:@"BTC"]&&![_Namecurrency isEqualToString:@"EOS"]&&![_Namecurrency isEqualToString:@"FML"]) {
        [CommonToastHUD showTips:@"该币种暂不支持兑换"];
        return;
    }
    if ([UserSingle sharedUser].isAuth==3&&[[UserSingle sharedUser].email containsString:@"@"]) {
        [self statusVC];
    }else {
        [(MJBaseViewController *)self.viewController showProgressHud];
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"user/user_info.htm".apifml method:POST args:dict];
        [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
            [(MJBaseViewController *)self.viewController hiddenProgressHud];
            if (responseMessage.errorMessage) {
                [CommonToastHUD showTips:responseMessage.errorMessage];
            } else {
                [[UserSingle sharedUser] setLoginInfo:responseMessage.bussinessData];
                if ([UserSingle sharedUser].isAuth!=3||![[UserSingle sharedUser].email containsString:@"@"]) {
                    [self showAuthAlert];
                }else {
                    [self statusVC];
                }
            }
        }];
    }
}
- (void)statusVC {
    if ([_Namecurrency isEqualToString:@"FML"]) {
        FMLExchangeViewController *vc = [[FMLExchangeViewController alloc]init];
        vc.currencyId = _currencyDetailDict[@"currencyId"];
        vc.currencyName = _currencyDetailDict[@"currencyName"];
        vc.currencyNumber = [_currencyDetailDict[@"number"] doubleValue];
        [self.viewController.navigationController pushViewController:vc animated:YES];
        return;
    }
    ExchangeViewController *vc = [[ExchangeViewController alloc]init];
    vc.currencyId = _currencyDetailDict[@"currencyId"];
    vc.currencyName = _currencyDetailDict[@"currencyName"];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
- (void)showAuthAlert {
    if (![[UserSingle sharedUser].email containsString:@"@"]) {
        MJBaseViewController *mjVC = (MJBaseViewController *)self.viewController;

        [mjVC showShadowViewWithColor:YES];
        FMLAlertView* alertView = [[FMLAlertView alloc] initWithTitle:@"邮箱未绑定" msg:@"为了保证您的交易正常进行，请先去绑定邮箱"];
        
            [alertView addBtn:@"确定" titleColor:ColorBlue action:^{
                BindPhoneViewController* vc = [BindPhoneViewController new];
                vc.isEmail = YES;
                [mjVC.navigationController pushViewController:vc animated:YES];
                [mjVC hiddenShadowView];
            }];
        
        [alertView addBtn:@"取消" titleColor:ColorGrayText action:^{
            [mjVC hiddenShadowView];
        }];
        [mjVC.shadowView addSubview:alertView];
        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(mjVC.shadowView);
            make.width.mas_equalTo(ScreenWidth * 0.8);
        }];
        return;
    }

    NSString *str;
    switch ([UserSingle sharedUser].isAuth) {
        case 0:
            str = @"您还未实名认证，请前往认证！";
            break;
        case 1:
            str = @"您的身份还在认证中！";
            break;
        case 2:
            str = @"实名认证被拒绝，请前往重新认证！";
            break;
        default:
            break;
    }
    MJBaseViewController *vc = (MJBaseViewController *)self.viewController;
    [(MJBaseViewController *)self.viewController showShadowViewWithColor:YES];
    FMLAlertView* alertView = [[FMLAlertView alloc] initWithTitle:@"实名认证" msg:str];
    
    if ([UserSingle sharedUser].isAuth != 1) {
        [alertView addBtn:@"确定" titleColor:ColorBlue action:^{
            RealNameViewController* vc = [RealNameViewController new];
            vc.noPush = YES;
            [self.viewController presentViewController:vc animated:YES completion:^{
            }];
            [(MJBaseViewController *)self.viewController hiddenShadowView];
        }];
    }
    [alertView addBtn:@"取消" titleColor:ColorGrayText action:^{
        [(MJBaseViewController *)self.viewController hiddenShadowView];
    }];
    [vc.shadowView addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(vc.shadowView);
        make.width.mas_equalTo(ScreenWidth * 0.8);
    }];
}
- (void)currencyInfo:(NSString *)type {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"type"] = type;//ETH
    
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"wallet/wallet.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (responseMessage.errorMessage) {
        } else {
            self.currencyNameLabel.text = [NSString stringWithFormat:@"%.2f %@",  String(responseMessage.bussinessData[@"lockNumber"]).floatValue + String(responseMessage.bussinessData[@"number"]).floatValue + String(responseMessage.bussinessData[@"lockCommissNumber"]).floatValue+String(responseMessage.bussinessData[@"freezeNumber"]).floatValue, _currencyDetailDict[@"currencyName"]];
            self.lockLB.text = [NSString stringWithFormat:@"锁定：%.2f个", [responseMessage.bussinessData[@"lockNumber"] doubleValue]+[responseMessage.bussinessData[@"lockCommissNumber"] doubleValue]+String(responseMessage.bussinessData[@"freezeNumber"]).floatValue];
            self.freeLB.text = [NSString stringWithFormat:@"可用：%.2f个",[responseMessage.bussinessData[@"number"] doubleValue]];
            [self.currencyDetailDict setObject:String(responseMessage.bussinessData[@"number"]) forKey:@"number"];
        }
    }];
}


@end

@interface CurrencyItem()

@property (nonatomic, strong) UILabel* leftLB;
@property (nonatomic, strong) UILabel* rightLB;

@end

@implementation CurrencyItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    _leftLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 65, HEIGHT(self))];
    _leftLB.textColor = [UIColor groupTableViewBackgroundColor];
    _leftLB.font = [UIFont systemFontOfSize:13];
    _leftLB.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_leftLB];
    
    _rightLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 0, HEIGHT(self))];
    _rightLB.textColor = [UIColor whiteColor];
    _rightLB.font = [UIFont systemFontOfSize:13];
    _rightLB.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_rightLB];
}

- (void)setLeftStr:(NSString *)leftStr {
    _leftStr = leftStr;
    _leftLB.text = leftStr;
    [_leftLB sizeToFit];
    if (IPHONE6P) {
        _leftLB.width = 65;
    }
}

- (void)setRightStr:(NSString *)rightStr {
    _rightStr = rightStr;
    _rightLB.frame = CGRectMake(RIGHT(_leftLB) + 10, 0,ScreenWidth/2.0-RIGHT(_leftLB) -10, HEIGHT(_leftLB));
    _rightLB.text = _rightStr;
//    [_rightLB sizeToFit];
}
@end
