//
//  CurrencyBuyViewController.m
//  FML
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "CurrencyBuyViewController.h"
#import "BuyView.h"
#import "CheckOrderViewController.h"
#import "FMLTransitionDelegate.h"
#import "CutsomPayView.h"
#import "FMLAlertView.h"
#import "SetPasswordViewController.h"
#import "RealNameViewController.h"
#import "BindPhoneViewController.h"
@interface CurrencyBuyViewController ()<UITextFieldDelegate>
{
    BOOL isHaveDian;
}
@property (nonatomic, strong) FMLTransitionDelegate* delegate;
@property (nonatomic, strong) BuyView*               buyView;
@property (nonatomic, assign) float                  eth;
@property (nonatomic, strong) CutsomPayView         *payView;

@property (nonatomic, assign) CGFloat                userHaveETH;

@end

@implementation CurrencyBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
    [self currencyInfo];
}


- (void)layoutUI {
    [self NavigationItemTitle:[NSString stringWithFormat:@"%@购买", String(_dict[@"currencyName"])] Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    
    BuyView* buy = [[[NSBundle mainBundle] loadNibNamed:@"BuyView" owner:self options:nil] lastObject];
    buy.frame = CGRectMake(0, BOTTOM(self.customNavView), ScreenWidth, 400);
    buy.numberTF.placeholder = [NSString stringWithFormat:@"限额%@-%@%@",String(_dict[@"minNum"]), String(_dict[@"maxNum"]), String(_dict[@"currencyName"])];
    buy.exchangeLB.text = @"0";
    buy.numberTF.delegate = self;
    buy.numberTF.delegate = self;
    buy.numberTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:buy];
    _buyView = buy;
    
    [buy.okBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    
    _eth = 10000 / String(_dict[@"ethRate"]).floatValue;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeOneCI:) name:UITextFieldTextDidChangeNotification object:_buyView.numberTF];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)textFieldTextDidChangeOneCI:(NSNotification *)notification
{
    UITextField *textfield=[notification object];
    _buyView.exchangeLB.text = [NSString stringWithFormat:@"%.2f", (_eth * textfield.text.floatValue) / 10000];
}
- (void)buy {
    if (_buyView.numberTF.text.length == 0) {
        [self showToastHUD:@"请输入您要购买的数量"];
        return;
    }
    if ([_buyView.numberTF.text doubleValue]<=0) {
        [self showToastHUD:@"购买的数量不能小于零"];
        return;
    }
    if (_buyView.numberTF.text.doubleValue > String(_dict[@"maxNum"]).floatValue) {
        [self showToastHUD:@"您购买的数量超出限额了"];
        return;
    }
    if (_buyView.numberTF.text.doubleValue < String(_dict[@"minNum"]).floatValue) {
        [self showToastHUD:@"您购买的数量低于限额了"];
        return;
    }
    if (_buyView.exchangeLB.text.floatValue > _userHaveETH) {
        [self showToastHUD:@"您ETH余额不足"];
        return;
    }
    [_buyView.numberTF resignFirstResponder];
    if (![UserSingle sharedUser].isPayPwd) {
        [self showAlert];
        return;
    }
    if ([UserSingle sharedUser].isAuth != 3||![[UserSingle sharedUser].email containsString:@"@"]) {
        [self showAuthAlert];
        return;
    }
    [self showShadowViewWithColor:YES];
    if (!_payView) {
        __weak typeof(self)weakSelf = self;
        _payView = [[CutsomPayView alloc]initWithFrame:RECT(0, ScreenHeight, ScreenWidth, 420)];
        [MainWindow addSubview:_payView];
        [UIView animateWithDuration:.3 animations:^{
            _payView.frame = RECT(0, ScreenHeight-420, ScreenWidth, 420);
        }];
        _payView.titleLabel.text = @"确认订单";
        _payView.orderStatus = @"token兑换";
        NSString* s = [NSString stringWithFormat:@"%@ ETH" ,_buyView.exchangeLB.text];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:s];
        UIFont *font2 = [UIFont boldSystemFontOfSize:15];
        [str addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(s.length-4,4)];
        _payView.priceLabel.attributedText = str;
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
                [weakSelf hiddenPayView:YES];
            }else if (index==5) {
                [weakSelf export];
            }
        };
    }
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

- (void)showAlert {
    [self showShadowViewWithColor:YES];
    FMLAlertView* alertView = [[FMLAlertView alloc] initWithTitle:@"支付密码" msg:@"您还未设置支付密码，请前往设置密码！"];
    [alertView addBtn:@"确定" titleColor:ColorBlue action:^{
        SetPasswordViewController* vc = [SetPasswordViewController new];
        vc.type = FMLPasswordTYPESetNewBuyNoPush;
        [self presentViewController:vc animated:YES completion:^{
            
        }];
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
            [self presentViewController:vc animated:YES completion:^{
                
            }];
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

- (void)export {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"currencyInvestId"] = _dict[@"icoId"];
    dict[@"number"] = _buyView.numberTF.text;
    dict[@"payPwd"] = _payView.pswView.password;
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"curOrder/create_order.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
            self.payView.pswView.unitField.text = @"";
        } else {
            [_payView createPaystatusView];
        }
    }];
}

- (void)currencyInfo {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"type"] = @"ETH";//ETH
    
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"wallet/wallet.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            _userHaveETH = String(responseMessage.bussinessData[@"number"]).floatValue;
        }
    }];
}


@end
