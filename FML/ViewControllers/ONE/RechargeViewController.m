//
//  RechargeViewController.m
//  FML
//
//  Created by 车杰 on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "RechargeViewController.h"
#import "InputView.h"
#import "CutsomPayView.h"
#import "SetPasswordViewController.h"
#import "FMLAlertView.h"
#import "RealNameViewController.h"
#import "FindPswViewController.h"
#import "customInputView.h"
#import "RecordViewController.h"
#import "BindPhoneViewController.h"
@interface RechargeViewController ()<UITextFieldDelegate>{
    BOOL isHaveDian;
}
@property (nonatomic,strong)InputView *addressInputView,*priceInputView, *phoneInputView, *getNumberInputView,*remarkView;
@property (nonatomic,strong)CutsomPayView *payView;
@property (nonatomic, strong) customInputView *codeView;
@property (nonatomic, strong) UIButton* registerBtton;
@property (nonatomic, assign) CGFloat  eth;

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:@"提现" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    [self navgationRightButtonImage:@"icon_ico_order"];
    [self layoutUI];
    [self getSysParam];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeOneCI:) name:UITextFieldTextDidChangeNotification object:_priceInputView.rightTf];
}

- (void)navgationRightButtonClick {
    RecordViewController* record = [RecordViewController new];
    record.isIncome = NO;
    [self.navigationController pushViewController:record animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)textFieldTextDidChangeOneCI:(NSNotification *)notification {
    UITextField *textfield=[notification object];
    _getNumberInputView.rightTf.text = [NSString stringWithFormat:@"%.2f %@", _eth * textfield.text.floatValue, _currencyName];
}


- (void)layoutUI {
    
    UIScrollView *baseScrollView = [[UIScrollView alloc]initWithFrame:RECT(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight)];
    baseScrollView.backgroundColor = [UIColor whiteColor];
    baseScrollView.showsVerticalScrollIndicator = NO;
    baseScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:baseScrollView];
    
    _addressInputView = [[InputView alloc]initWithFrame:RECT(0,10 , ScreenWidth, 55)];

    _addressInputView.rightTfPalceHold = @"请输入收款地址";
    _addressInputView.leftStr = @"收款地址";
    [baseScrollView addSubview:_addressInputView];
    
    _priceInputView = [[InputView alloc]initWithFrame:RECT(0,GETY(_addressInputView.frame) , ScreenWidth, 55)];
    _priceInputView.rightTfPalceHold = [NSString stringWithFormat:@"当前余额：%.2f", _number];
    
    _priceInputView.leftStr = @"转帐金额";
    _priceInputView.rightTf.delegate = self;
    _priceInputView.rightTf.keyboardType = UIKeyboardTypeDecimalPad;
    [baseScrollView addSubview:_priceInputView];
    
    
    _phoneInputView = [[InputView alloc]initWithFrame:RECT(0,GETY(_priceInputView.frame) , ScreenWidth, 55)];
    
    _phoneInputView.rightTfPalceHold = @"请输入手机号";
    _phoneInputView.leftStr = @"手机号";
    _phoneInputView.rightTf.keyboardType = UIKeyboardTypeDecimalPad;
    [baseScrollView addSubview:_phoneInputView];
    
    UILabel* label = [[UILabel alloc] initWithFrame:RECT(15,_phoneInputView.bottom , 120, 55)];
    [label rect:RECT(15,_phoneInputView.bottom , 120, 55) aligment:Left font:16 isBold:NO text:@"短信验证码" textColor:Color1D superView:nil];
    [baseScrollView addSubview:label];
    
    __weak typeof(self) weakSelf = self;
    _codeView = [[customInputView alloc]initWithFrame:RECT(125,GETY(_phoneInputView.frame) , ScreenWidth - 140, 55) style:2];
    //    _codeView.leftImageStr = @"icon_checkcode";
    _codeView.inputTextField.placeholder = @"短信验证码";
    _codeView.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    _codeView.inputTextField.textAlignment = NSTextAlignmentLeft;
    [_codeView.inputTextField addTarget:self action:@selector(rigisterLengthCount) forControlEvents:UIControlEventEditingChanged];
    _codeView.inputViewBlcok = ^(NSInteger type) {
        if (type==2) { //获取验证码
            [weakSelf doResuestToGetCode];
        }
    };
    [baseScrollView addSubview:_codeView];
    
    _getNumberInputView = [[InputView alloc]initWithFrame:RECT(0,GETY(_codeView.frame) , ScreenWidth, 55)];
//    _getNumberInputView.rightTfPalceHold = [NSString stringWithFormat:@"当前余额：%.4f", _number];
    _getNumberInputView.rightTf.text = [@"0.00" stringByAppendingString:_currencyName];
    _getNumberInputView.leftStr = @"手续费";
    _getNumberInputView.userInteractionEnabled = NO;
    [baseScrollView addSubview:_getNumberInputView];
    
    _remarkView = [[InputView alloc]initWithFrame:RECT(0,GETY(_getNumberInputView.frame) , ScreenWidth, 55)];
    _remarkView.rightTfPalceHold = @"输入备注内容";
    _remarkView.leftStr = @"备注";
    //    _remarkView.rightTf.keyboardType = UIKeyboardTypeDecimalPad;
    [baseScrollView addSubview:_remarkView];
    
    UIButton *rechargeBtton = [UIButton createTextButtonWithFrame:RECT(40, GETY(_remarkView.frame)+115, ScreenWidth-80, 50) bgColor:ColorBlue textColor:[UIColor whiteColor] font:14 bold:YES title:@"提交"];
    [rechargeBtton addTarget:self action:@selector(rechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rechargeBtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rechargeBtton.layer.cornerRadius = 5;
    rechargeBtton.layer.masksToBounds = YES;
    rechargeBtton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [baseScrollView addSubview:rechargeBtton];
    _registerBtton = rechargeBtton;
    [baseScrollView setContentSize:CGSizeMake(ScreenWidth, GETY(rechargeBtton.frame)+20)];
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
- (void)rechargeBtnClick {
    if (_addressInputView.rightTf.text.length == 0) {
        [self showToastHUD:_addressInputView.rightTf.placeholder];
        return;
    }
    if (_priceInputView.rightTf.text.length == 0) {
        [self showToastHUD:@"请输入转账金额"];
        return;
    }
    if ([_priceInputView.rightTf.text doubleValue]<=0) {
        [self showToastHUD:@"转账金额需大于零"];
        return;
    }
    if (!_phoneInputView.rightTf.text.isValidMobile) {
        [self showToastHUD:@"请输入正确的手机号"];
        return;
    }
    if (_codeView.inputTextField.text.length < 4) {
        [self showToastHUD:@"请检查验证码"];
        return;
    }
    
    if (_priceInputView.rightTf.text.floatValue > _number) {
        [self showToastHUD:@"您的余额不足"];
        return;
    }
    
    if (![UserSingle sharedUser].isPayPwd) {
        [self showAlert];
        return;
    }
    if ([UserSingle sharedUser].isAuth != 3||![[UserSingle sharedUser].email containsString:@"@"]) {
        [self showAuthAlert];
        return;
    }
    [_addressInputView.rightTf resignFirstResponder];
    [_priceInputView.rightTf resignFirstResponder];
    [self showShadowViewWithColor:YES];
    if (!_payView) {
        __weak typeof(self)weakSelf = self;
        _payView = [[CutsomPayView alloc]initWithFrame:RECT(0, ScreenHeight, ScreenWidth, 420)];
        [MainWindow addSubview:_payView];
        [UIView animateWithDuration:.3 animations:^{
            _payView.frame = RECT(0, ScreenHeight-420, ScreenWidth, 420);
        }];
        _payView.orderStatus = @"提现";
        NSString* s = [NSString stringWithFormat:@"%@%@" ,_priceInputView.rightTf.text ,_currencyName];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:s];
        UIFont *font2 = [UIFont boldSystemFontOfSize:15];
        [str addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(s.length-_currencyName.length,_currencyName.length)];
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
//                [weakSelf export];
                [weakSelf hiddenPayView:YES];
            }else if (index==5) {
                [weakSelf export];
            }
        };
    }
}

- (void)hiddenPayView:(BOOL)dismiss {
    [_addressInputView.rightTf resignFirstResponder];
    [_priceInputView.rightTf resignFirstResponder];
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
- (void)navgationLeftButtonClick {
    [self dismissViewControllerAnimated:YES completion:^{
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
        
        if ([UserSingle sharedUser].isAuth != 1) {
            [alertView addBtn:@"确定" titleColor:ColorBlue action:^{
                BindPhoneViewController* vc = [BindPhoneViewController new];
                vc.isEmail = YES;
                [self.navigationController pushViewController:vc animated:YES];
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
    
        [alertView addBtn:@"确定" titleColor:ColorBlue action:^{
            RealNameViewController* vc = [RealNameViewController new];
            vc.noPush = YES;
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

- (void)doResuestToGetCode {
    if (!_phoneInputView.rightTf.text.isValidMobile) {
        [self showToastHUD:@"请输入正确的手机号"];
        return;
    }
        [self showProgressHud];
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        dict[@"mobile"] = _phoneInputView.rightTf.text;
        dict[@"type"] = @"check";
        RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"send/check_code.htm".apifml method:POST args:dict];
        [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
            [self hiddenProgressHud];
            if (responseMessage.errorMessage) {
                [self showToastHUD:responseMessage.errorMessage];
            } else {
                [self showToastHUD:@"验证码已发送"];
                _codeView.needCount_down = YES;
            }
        }];
}
- (void)rigisterLengthCount {
    if (_phoneInputView.rightTf.text.isValidMobile) {
        _registerBtton.userInteractionEnabled = YES;
        [_registerBtton setBackgroundColor:ColorBlue];
    }else {
        _registerBtton.userInteractionEnabled = NO;
        [_registerBtton setBackgroundColor:ColorGray];
    }
}
- (void)export {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"sysCurrencyId"] = _currencyId;
    dict[@"walletAddress"] = _addressInputView.rightTf.text;
    dict[@"number"] = [NSString stringWithFormat:@"%.2f", _priceInputView.rightTf.text.floatValue];
    dict[@"payPwd"] = _payView.pswView.password;
    dict[@"mobileNo"] = _phoneInputView.rightTf.text;
    dict[@"mobileCode"] = _codeView.inputTextField.text;
    if (_remarkView.rightTf.text.length!=0) {
        dict[@"remark"] = _remarkView.rightTf.text;
    }
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"tocash/add_tocash.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
            self.payView.pswView.unitField.text = @"";
        } else {
            [_payView createPaystatusView];
            NSString* s = @" 已提交！\n请耐心等待后台审核";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:s];
            [str addAttribute:NSFontAttributeName value:FONT(19) range:NSMakeRange(0,4)];
            [str addAttribute:NSFontAttributeName value:FONT(16) range:NSMakeRange(4,s.length - 4)];
            _payView.stausView.statusLabel.attributedText = str;
        }
    }];
}
- (void)getSysParam {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"type"] = @"withdrawCost";
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"sysParam/data.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            _eth = String(responseMessage.bussinessData[@"content"]).floatValue;
        }
    }];
}

@end
