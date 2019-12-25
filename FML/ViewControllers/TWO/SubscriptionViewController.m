//
//  SubscriptionViewController.m
//  FML
//
//  Created by 车杰 on 2018/9/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "ExportViewController.h"
#import "CutsomPayView.h"
#import "FindPswViewController.h"
#import "FMLAlertView.h"
#import "RealNameViewController.h"
#import "BindPhoneViewController.h"
@interface SubscriptionViewController ()<UITextFieldDelegate> {
    BOOL isHaveDian;
}
@property (nonatomic,strong)UIScrollView *baseScrollView;
@property (nonatomic,strong)UITextField *numberTF,*priceTf;
@property (nonatomic,strong)UILabel *balanceLabel;
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,strong) CutsomPayView *payView;

@end

@implementation SubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:@"认购信息" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    [self currencyInfo];
}
- (void)navgationLeftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)currencyInfo {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"currencyId"] = _resultDic[@"currencyId"];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"wallet_card/currency_info.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            _dict = responseMessage.bussinessData;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self layoutUI];
            });
        }
    }];
}
- (void)layoutUI {
    
    _baseScrollView = [[UIScrollView alloc]initWithFrame:RECT(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight-SafeAreaBottomHeight-60)];
    _baseScrollView.backgroundColor = ColorBg;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_baseScrollView];
        
    UIImageView *TopImageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, 75) imageName:@"icon_top_imageView"];
    [_baseScrollView addSubview:TopImageView];
        
    UILabel  *label1 = [UILabel new];
    [label1 rect:RECT(20,15,100, 20) aligment:Left font:12 isBold:YES text:@"账户余额" textColor:[UIColor whiteColor] superView:_baseScrollView];
        
    _balanceLabel = [UILabel new];
    [_balanceLabel rect:RECT(20,37,ScreenWidth-40, 20) aligment:Left font:17 isBold:YES text:[NSString stringWithFormat:@"%.2f %@",[_dict[@"number"] doubleValue],_resultDic[@"currencyType"]] textColor:[UIColor whiteColor] superView:_baseScrollView];
    
    UIButton *rechargeBtn = [UIButton createimageButtonWithFrame:RECT(ScreenWidth-68, 25, 50, 25) imageName:@""];
    rechargeBtn.backgroundColor = [UIColor whiteColor];
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    rechargeBtn.titleLabel.font = FONT(10);
    [rechargeBtn setTitleColor:colorWithHexString(@"#4f69f9") forState:UIControlStateNormal];
    [rechargeBtn addTarget:self action:@selector(rechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:rechargeBtn];
        
        UIView *whiteView = [UIView createViewWithFrame:RECT(0, 75, ScreenWidth, 100) color:[UIColor whiteColor]];
        [_baseScrollView addSubview:whiteView];
    
    NSArray *array = @[@"认购数量",@"预期收益"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel  *label = [UILabel new];
        [label rect:RECT(20,10*(idx+1)+40*idx,90, 30) aligment:Left font:12 isBold:YES text:array[idx] textColor:colorWithHexString(@"#7d7d7d") superView:whiteView];
        if (idx!=array.count-1) {
            UIView *lineView = [UIView createViewWithFrame:RECT(20, 50*(idx+1), ScreenWidth-40, .5) color:ColorBg];
            [whiteView addSubview:lineView];
        }
    }];

    UILabel  *danweilabel = [UILabel new];
    [danweilabel rect:RECT(ScreenWidth-50,10,30, 30) aligment:Right font:12 isBold:YES text:_resultDic[@"currencyType"] textColor:colorWithHexString(@"#7d7d7d") superView:whiteView];
    
    _numberTF = [[UITextField alloc]initWithFrame:RECT(110,10 , ScreenWidth-160, 30)];
    _numberTF.borderStyle = 0;
    _numberTF.delegate =self;
    _numberTF.font = FONT(13);
    _numberTF.textAlignment = NSTextAlignmentRight;
    _numberTF.placeholder = @"请输入虚拟资产数量";
    [whiteView addSubview:_numberTF];
    
    NSString *str = _resultDic[@"currencyType"];
    
    UILabel  *danweilabel2 = [UILabel new];
    [danweilabel2 rect:RECT(ScreenWidth-50,60,8*str.length+5, 30) aligment:Right font:12 isBold:YES text:_resultDic[@"currencyType"] textColor:colorWithHexString(@"#7d7d7d") superView:whiteView];
    
    _priceTf = [[UITextField alloc]initWithFrame:RECT(110,60 , ScreenWidth-135-8*str.length, 30)];
    _priceTf.borderStyle = 0;
    _priceTf.font = FONT(13);
    _priceTf.textAlignment = NSTextAlignmentRight;
    _priceTf.placeholder = @"0.00";
    _priceTf.userInteractionEnabled = NO;
    _priceTf.enabled = NO;
    [whiteView addSubview:_priceTf];
    
    UIView *whiteView2 = [UIView createViewWithFrame:RECT(0, GETY(whiteView.frame)+10, ScreenWidth, 190) color:[UIColor whiteColor]];
    [_baseScrollView addSubview:whiteView2];
    
    UILabel  *contractlabel = [UILabel new];
    [contractlabel rect:RECT(15,10,ScreenWidth-30, 30) aligment:Left font:14 isBold:YES text:[NSString stringWithFormat:@"%@(%@)",_resultDic[@"title"],_resultDic[@"currencyType"]]textColor:colorWithHexString(@"#7d7d7d") superView:whiteView2];
    
    UIView *lineView2 = [UIView createViewWithFrame:RECT(15, 50, ScreenWidth-30, .5) color:ColorLine];
    [whiteView2 addSubview:lineView2];
    
    NSArray *array2 = @[@"预期年化",@"预期净值",@"起购数量",@"认购期限"];
    NSArray *array3 = @[[NSString stringWithFormat:@"%.2f%%",[_resultDic[@"profitRate"] doubleValue]*100*12],[NSString stringWithFormat:@"%.2f%@",[_resultDic[@"investRatio"] doubleValue],_resultDic[@"currencyType"]],[NSString stringWithFormat:@"%.2f%@",[_resultDic[@"minAmount"] doubleValue],_resultDic[@"currencyType"]],[NSString stringWithFormat:@"%ldDAY",[_resultDic[@"duration"] integerValue]]];
    [array2 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel  *label = [UILabel new];
        [label rect:RECT(20,60+30*idx,90, 30) aligment:Left font:10 isBold:YES text:array2[idx] textColor:colorWithHexString(@"#c9c9c9") superView:whiteView2];
        
        UILabel  *label2 = [UILabel new];
        [label2 rect:RECT(ScreenWidth-180,60+30*idx,165, 30) aligment:Right font:12 isBold:YES text:array3[idx] textColor:colorWithHexString(@"#7d7d7d") superView:whiteView2];
       
    }];
    
    _baseScrollView.contentSize = CGSizeMake(ScreenWidth, GETY(whiteView2.frame)+20);
    
    UIView *bgView = [UIView createViewWithFrame:RECT(20, ScreenHeight-SafeAreaBottomHeight-50, ScreenWidth-40, 40) color:[UIColor whiteColor]];
    [self.view addSubview:bgView];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)colorWithHexString(@"#56a2fa").CGColor, (__bridge id)colorWithHexString(@"#5065f9").CGColor];
    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height);
    [bgView.layer addSublayer:gradientLayer];
    
    UIButton *sure = [UIButton createTextButtonWithFrame:RECT(20, ScreenHeight-SafeAreaBottomHeight-50, ScreenWidth-40, 40)  bgColor:[UIColor clearColor] textColor:[UIColor whiteColor] font:14 bold:NO title:@"确认"];
    [sure addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sure];
    
}
- (void)sureButtonClick {
    if (_numberTF.text.length==0) {
        [self showToastHUD:@"请输入认购数量"];
        return;
    }
    if ([_numberTF.text doubleValue]<=0) {
        [self showToastHUD:@"认购数量需大于零"];
        return;
    }
    if ([_numberTF.text doubleValue]>[_dict[@"number"] doubleValue]) {
        [self showToastHUD:@"认购数量不能大于账户余额"];
        return;
    }
    if ([_numberTF.text doubleValue]<[_resultDic[@"minAmount"] doubleValue]) {
        [self showToastHUD:@"认购数量不能小于起购数量"];
        return;
    }
    if ([_numberTF.text doubleValue]>[_resultDic[@"maxAmount"] doubleValue]) {
        [self showToastHUD:[NSString stringWithFormat:@"认购最大数量为%.2f",[_resultDic[@"maxAmount"] doubleValue]]];
        return;
    }
    [_numberTF endEditing:YES];
    [self showShadowViewWithColor:YES];
    if (!_payView) {
        __weak typeof(self)weakSelf = self;
        _payView = [[CutsomPayView alloc]initWithFrame:RECT(0, ScreenHeight, ScreenWidth, 420)];
        _payView.typeInputView.rightTf.text = @"量化基金";
        [MainWindow addSubview:_payView];
        [UIView animateWithDuration:.3 animations:^{
            _payView.frame = RECT(0, ScreenHeight-420, ScreenWidth, 420);
        }];
        NSString *type = _resultDic[@"currencyType"];
        NSString* s = [NSString stringWithFormat:@"%@%@" ,_numberTF.text ,type];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:s];
        UIFont *font2 = [UIFont boldSystemFontOfSize:15];
        [str addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(s.length-type.length,type.length)];
        _payView.priceLabel.attributedText = str;
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
                [weakSelf doBuyFund];
            }
        };
    }
}
- (void)doBuyFund {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"fundId"] = _resultDic[@"id"];
    dict[@"number"] = [NSNumber numberWithDouble:[_numberTF.text doubleValue]];
    dict[@"payPwd"] = self.payView.pswView.unitField.text;
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"fdfund/buy.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
            self.payView.pswView.unitField.text = @"";
        } else {
            [_payView createPaystatusView];
            _payView.stausView.statusLabel.text = @"认购成功！";
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
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length==0) {
     _priceTf.text = @"0.00";
    }else {
       _priceTf.text = [NSString stringWithFormat:@"%.2f",[textField.text doubleValue]*[_resultDic[@"profitRate"] doubleValue]*[_resultDic[@"duration"] integerValue]/30.0];
    }
}
- (void)rechargeButtonClick {
    if ([UserSingle sharedUser].isAuth==3&&[[UserSingle sharedUser].email containsString:@"@"]) {
        ExportViewController *vc = [[ExportViewController alloc]init];
        vc.currencyId = _resultDic[@"currencyId"];
        vc.currencyName = _resultDic[@"currencyType"];
        vc.number = [_dict[@"number"] floatValue];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [vc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }else {
        [self showAuthAlert];
    }
}
- (void)showAuthAlert {
    if (![[UserSingle sharedUser].email containsString:@"@"]) {
        [self showShadowViewWithColor:YES];
        FMLAlertView* alertView = [[FMLAlertView alloc] initWithTitle:@"邮箱未绑定" msg:@"为了保证您的交易正常进行，请先去绑定邮箱"];
            [alertView addBtn:@"确定" titleColor:ColorBlue action:^{
                BindPhoneViewController* vc = [BindPhoneViewController new];
                vc.isEmail = YES;
                [self.navigationController pushViewController:vc animated:YES];
                [self hiddenShadowView];
            }];
        
        [alertView addBtn:@"取消" titleColor:ColorGrayText action:^{
            [self hiddenShadowView];
        }];
        [self.shadowView addSubview:alertView];
        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.shadowView);
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
    [self showShadowViewWithColor:YES];
    FMLAlertView* alertView = [[FMLAlertView alloc] initWithTitle:@"实名认证" msg:str];
    
    if ([UserSingle sharedUser].isAuth != 1) {
        [alertView addBtn:@"确定" titleColor:ColorBlue action:^{
            RealNameViewController* vc = [RealNameViewController new];
            vc.noPush = YES;
            [self presentViewController:vc animated:YES completion:^{}];
            [self hiddenShadowView];
        }];
    }
    [alertView addBtn:@"取消" titleColor:ColorGrayText action:^{
        [self hiddenShadowView];
    }];
    [self.shadowView addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.shadowView);
        make.width.mas_equalTo(ScreenWidth * 0.8);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
