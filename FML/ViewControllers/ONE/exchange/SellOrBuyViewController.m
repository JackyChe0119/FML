//
//  SellOrBuyViewController.m
//  FML
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "SellOrBuyViewController.h"
#import "LeftLableTextField.h"
#import "PaySelectViewController.h"
#import "FMLTransitionDelegate.h"
#import "CutsomPayView.h"
#import "FMLAlertView.h"
#import "SetPasswordViewController.h"
#import "BankCardModel.h"
#import "SafeCenterViewController.h"
#import "RealNameViewController.h"
#import "AlipayManager.h"
#import "orderListView.h"
#import "BuyDeatilViewController.h"
#import "OrderDeatilViewController.h"
#import "AddBankCardViewController.h"
#import "BindPhoneViewController.h"
@interface SellOrBuyViewController ()<UITextFieldDelegate>
{
    BOOL isHaveDian;
}
@property (nonatomic, strong) LeftLableTextField*  item1;
@property (nonatomic, strong) LeftLableTextField*  item2;
@property (nonatomic, strong) LeftLableTextField*  item3;
@property (nonatomic, strong) LeftLableTextField*  item4;
@property (nonatomic, strong) LeftLableTextField*  item5;
@property (nonatomic,strong)UIView *orderBaseView;
@property (nonatomic, strong) UIButton*            btn;
@property (nonatomic, strong) UIButton*            numAllBtn;
@property (nonatomic, strong) UIButton*            canbuyAllBtn;
@property (nonatomic, strong) UIButton*            imageBtn;

@property (nonatomic, strong) FMLTransitionDelegate* delegate;
@property (nonatomic, strong) CutsomPayView*        payView;
@property (nonatomic, strong) BankCardModel*        model;
@property (nonatomic, copy) NSDictionary*           dict;
@property (nonatomic,assign) NSInteger orderId;
@property (nonatomic,assign)BOOL canPop;
@property (nonatomic,copy)NSString *exChangeId;
@end

@implementation SellOrBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* title;
    if (_type == ExchangeViewTypeBuy) {
        title = @"购买";
    } else if (_type == ExchangeViewTypeSell) {
        title = @"出售";
        [self currencyInfo];
    }
    
    [self NavigationItemTitle:title Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    
    [self setView];
    [self layout];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.canPop) {
        self.canPop = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)setView {
    _item1 = [LeftLableTextField new];
    _item1.titleLB.text = @"单价";
    _item1.titleLB.textColor = Color1D;
    _item1.textField.placeholder = [NSString stringWithFormat:@"%.2f", _exchangeModel.priceRatio];
    _item1.textField.text = [NSString stringWithFormat:@"%.2f CNY", _exchangeModel.priceRatio];
    _item1.textField.userInteractionEnabled = NO;
    _item1.bottomLine.hidden = YES;
    
    _item2 = [LeftLableTextField new];
    _item2.titleLB.text = @"数量";
    _item2.titleLB.textColor = Color1D;
    _item2.textField.delegate = self;
    _item2.changeFrame = YES;
    _item2.textField.minimumFontSize = 5;
    [_item2.textField setAdjustsFontSizeToFitWidth:YES];
    _item2.textField.placeholder = (_type == ExchangeViewTypeBuy) ? [NSString stringWithFormat:@"可购买数量%.2f %@", _exchangeModel.stock, _exchangeModel.currencyName] : [NSString stringWithFormat:@"可用余额%.2f %@", _exchangeModel.stock, _exchangeModel.currencyName];
    _item2.textField.keyboardType = UIKeyboardTypeDecimalPad;
    _item2.bottomLine.hidden = YES;
    
    _item3 = [LeftLableTextField new];
    _item3.titleLB.text = @"金额";
    _item3.titleLB.textColor = Color1D;
    _item3.textField.delegate = self;
    _item3.textField.placeholder = @"0.00CNY";
    _item3.textField.enabled = NO;
    _item3.textField.keyboardType = UIKeyboardTypeDecimalPad;
    _item3.bottomLine.hidden = YES;
//
    _item4 = [LeftLableTextField new];
    _item4.titleLB.text = @"到账方式";
    _item4.titleLB.textColor = Color1D;
    _item4.textField.placeholder = @"请选择到账银行卡";
    _item4.bottomLine.hidden = YES;
    if (_type == ExchangeViewTypeBuy) {
        _item4.textField.placeholder = @"请选择支付银行卡";
        _item4.titleLB.text = @"支付方式";
    }
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:@"确认" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(sellOrBuy) forControlEvents:UIControlEventTouchUpInside];
    _btn.layer.cornerRadius = 5;
    _btn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _btn.backgroundColor = ColorBlue;
    
    _numAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _numAllBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_numAllBtn setTitle:@"全部" forState:UIControlStateNormal];
    [_numAllBtn setTitleColor:ColorBlue forState:UIControlStateNormal];
    [_numAllBtn addTarget:self action:@selector(allETH) forControlEvents:UIControlEventTouchUpInside];
    
    
    _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imageBtn setImage:[UIImage imageNamed:@"icon_accesstype1"] forState:UIControlStateNormal];
    _imageBtn.hidden = _type == ExchangeViewTypeBuy;
    
    [self.view addSubview:_item1];
    [self.view addSubview:_item2];
    [self.view addSubview:_item3];
    [self.view addSubview:_item4];
//    [self.view addSubview:_item5];
    [self.view addSubview:_btn];
    [_item2 addSubview:_numAllBtn];
    [_item3 addSubview:_canbuyAllBtn];
    [_item4 addSubview:_imageBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeOneCI:) name:UITextFieldTextDidChangeNotification object:_item2.textField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeOneCI:) name:UITextFieldTextDidChangeNotification object:_item3.textField];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)textFieldTextDidChangeOneCI:(NSNotification *)notification {
    UITextField *textfield=[notification object];
    if (_item2.textField == textfield) {
        if (textfield.text.length == 0) {
            _item3.textField.text = @"0.00CNY";
        } else {
            _item3.textField.text = [NSString stringWithFormat:@"%.2fCNY", _item2.textField.text.floatValue * _exchangeModel.priceRatio];
        }
        
    } else {
        if (textfield.text.length == 0) {
            _item2.textField.text = @"";
        } else {
            _item2.textField.text = [NSString stringWithFormat:@"%.2f", _item3.textField.text.floatValue / _exchangeModel.priceRatio];
        }
    }
}

- (void)layout {
    [_item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(NavHeight);
    }];
    
    [_item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_item1.mas_bottom);
    }];
    
    [_item3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_item2.mas_bottom);
    }];
    
    [_item4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_item3.mas_bottom);
    }];
    
//    [_item5 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.top.equalTo((_type == ExchangeViewTypeBuy) ? _item3.mas_bottom : _item4.mas_bottom);
//    }];
    
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
    }];
    
    [_numAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_item2);
        make.right.equalTo(_item2.mas_right).offset(-20);
    }];
    
    [_canbuyAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_item3);
        make.right.equalTo(_item3.mas_right).offset(-20);
    }];
    
    [_imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_item4);
        make.right.equalTo(_item4.mas_right).offset(-20);
    }];
    
    UIButton* selectPay = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectPay addTarget:self action:@selector(selectPay:) forControlEvents:UIControlEventTouchUpInside];
    [_item4 addSubview:selectPay];
    [selectPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_item4);
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
- (void)allETH {
    if (_dict) {
        CGFloat stock = _exchangeModel.stock > String(_dict[@"freezeNumber"]).floatValue ? String(_dict[@"number"]).floatValue : _exchangeModel.stock;
        _item2.textField.text = [NSString stringWithFormat:@"%.2f", stock];
        _item3.textField.text = [NSString stringWithFormat:@"%.2fCNY", stock * _exchangeModel.priceRatio];
    } else {
        CGFloat stock = _exchangeModel.stock;
        _item2.textField.text = [NSString stringWithFormat:@"%.2f", stock];
        _item3.textField.text = [NSString stringWithFormat:@"%.2fCNY", stock * _exchangeModel.priceRatio];
    }

}

- (void)allyuE {
    _item3.textField.text = [NSString stringWithFormat:@"%.2f", _exchangeModel.maxLimit];
    _item2.textField.text = [NSString stringWithFormat:@"%.2f", _exchangeModel.maxLimit / _exchangeModel.priceRatio];
}

- (void)selectPay:(UIButton *)sender {
    [self myBankCard];
}

- (void)sellOrBuy {
    NSString* tip1 = @"请输入出售数量";
    if (_type == ExchangeViewTypeBuy) {
        tip1 = @"请输入购买数量";
    }
    if (_item2.textField.text == nil || _item2.textField.text.length == 0) {
        [self showToastHUD:tip1];
        return;
    }
    if ([_item2.textField.text floatValue]<=0) {
        if (_type == ExchangeViewTypeBuy) {
            [self showToastHUD:@"购买数量需大于零"];
        }else {
            [self showToastHUD:@"出售数量需大于零"];
        }
        return;
    }
    if (_item3.textField.text == nil || _item3.textField.text.length == 0) {
        [self showToastHUD:@"请输入额度"];
        return;
    }
    if (_item2.textField.text.floatValue * _exchangeModel.priceRatio>1000000000) {
        [self showToastHUD:@"涉及金额过大,请分批操作"];
        return;
    }
    
    if (_type == ExchangeViewTypeSell && (_item4.textField.text == nil || _item4.textField.text.length == 0)) {
        [self showToastHUD:_item4.textField.placeholder];
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
    
    [_item2.textField resignFirstResponder];
    [_item3.textField resignFirstResponder];
    if (_type == ExchangeViewTypeBuy) {
         //生成一个订单
        [self DoBuy];
        return;
    }
    
    [self showShadowViewWithColor:YES];
    if (!_payView) {
        __weak typeof(self)weakSelf = self;
        _payView = [[CutsomPayView alloc]initWithFrame:RECT(0, ScreenHeight, ScreenWidth, 420)];
        [MainWindow addSubview:_payView];
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.payView.frame = RECT(0, ScreenHeight-420, ScreenWidth, 420);
        }];
        NSString* s = [NSString stringWithFormat:@"%@%@" ,_item2.textField.text, _exchangeModel.currencyName];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:s];
        UIFont *font2 = [UIFont boldSystemFontOfSize:15];
        [str addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(s.length-_exchangeModel.currencyName.length,_exchangeModel.currencyName.length)];
        _payView.priceLabel.attributedText = str;
        _payView.orderStatus = @"出售";
        if (_type != ExchangeViewTypeBuy) {
            [_payView.payButton setTitle:@"确定" forState:UIControlStateNormal];
        }
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
- (void)DoBuy {
    [self showProgressHud];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    [params setValue:[NSNumber numberWithDouble:[_item2.textField.text doubleValue] ]  forKey:@"number"];
    [params setValue:[NSNumber numberWithInteger:_exchangeModel.Id] forKey:@"productId"];
    params[@"bankId"] = @(_model.Id);
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"exchangeRecord/buy.htm".apifml method:POST args:params];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            _orderId = [responseMessage.bussinessData[@"id"] integerValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showOrderView:responseMessage.bussinessData];
            });
        }
    }];
}
- (void)hiddenPayView:(BOOL)dismiss {
    [_item2.textField resignFirstResponder];
    [_item3.textField resignFirstResponder];
    [UIView animateWithDuration:.3 animations:^{
        self.payView.frame = RECT(0, ScreenHeight, ScreenWidth, 420);
    } completion:^(BOOL finished) {
        [_payView removeFromSuperview];
        _payView = nil;
        [self hiddenShadowView];
        if (dismiss) {
            self.canPop = YES;
            OrderDeatilViewController *vc = [[OrderDeatilViewController alloc]init];
            vc.orderId = _orderId;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }];
}
- (void)showAlert {
    [self showShadowViewWithColor:YES];
    FMLAlertView* alertView = [[FMLAlertView alloc] initWithTitle:@"支付密码" msg:@"您还未设置支付密码，请前往设置密码！"];
    [alertView addBtn:@"确定" titleColor:ColorGrayText action:^{
        SetPasswordViewController* vc = [SetPasswordViewController new];
        vc.type = FMLPasswordTYPESetNewBuyNoPush;
        [self presentViewController:vc animated:YES completion:^{
            
        }];
        [self hiddenShadowView];
    }];
    [alertView addBtn:@"取消" titleColor:ColorBlue action:^{
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
             [self hiddenShadowView];
             BindPhoneViewController* vc = [BindPhoneViewController new];
             vc.isEmail = YES;
             [self.navigationController pushViewController:vc animated:YES];
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

- (void)gotoSafeCenter {
    [self showShadowViewWithColor:YES];
    FMLAlertView* alertView = [[FMLAlertView alloc] initWithTitle:@"暂无绑定银行卡" msg:@"您还未绑银行卡，请前往安全中心绑定,否则出现财产损失,概不负责!"];
    [alertView addBtn:@"确定" titleColor:ColorGrayText action:^{
        AddBankCardViewController* vc = [AddBankCardViewController new];
        [self hiddenShadowView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:vc animated:YES];
        });
    }];
    [alertView addBtn:@"取消" titleColor:ColorBlue action:^{
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
    dict[@"productId"] = @(_exchangeModel.Id);
    dict[@"number"] = [NSNumber numberWithDouble:[_item2.textField.text doubleValue]];
    dict[@"type"] = @"bank";
    dict[@"bankId"] = @(_model.Id);
    dict[@"payPassword"] = _payView.pswView.password;
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"exchangeRecord/sale.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
            self.payView.pswView.unitField.text = @"";
        } else {
            [_payView createPaystatusView];
            _orderId = [responseMessage.bussinessData[@"id"] integerValue];
        }
    }];
}
- (void)myBankCard {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"bank/bank_list.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            PaySelectViewController* vc = [PaySelectViewController new];
            self.delegate = [FMLTransitionDelegate shareInstance];
            self.delegate.height = 440;
            self.delegate.style = AnimationStyleBackScale;
            vc.modalPresentationStyle = UIModalPresentationCustom;
            vc.transitioningDelegate = self.delegate;
            NSMutableArray* models = [NSMutableArray array];
            NSArray* array = [BankCardModel arrayToModel:responseMessage.bussinessData];
            BankCardModel* model = [BankCardModel new];
            for (BankCardModel* model in array) {
                if (_model && model.bankNumber == _model.bankNumber ) {
                    model.isShowCheck = YES;
                }
                [models addObject:model];
            }
            if ([UserSingle sharedUser].alipayPicture.length > 10) {
                if (model.bankNumber == _model.bankNumber) model.isShowCheck = YES;
                [models addObject:model];
            }
            vc.models = models;
            __weak typeof(self) weakSelf = self;
            vc.payModelHanlder = ^(BankCardModel *model) {
                weakSelf.model = model;
                if (model.bankNumber == 100000000) {
                    _item4.textField.text = model.bankName;
                } else {
                    _item4.textField.text = [NSString stringWithFormat:@"%@(%ld)", model.bankName, (NSInteger)model.bankNumber % 10000];
                }
            };
            if (models.count == 0) {
                [self gotoSafeCenter];
            } else {
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
    }];
}
- (void)currencyInfo {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"currencyId"] = @(_exchangeModel.currencyId);
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"wallet_card/currency_info.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            _dict = responseMessage.bussinessData;
            _item2.textField.placeholder = [NSString stringWithFormat:@"可用余额%.2f %@", String(_dict[@"number"]).floatValue, _exchangeModel.currencyName];
        }
    }];
}
- (void)showOrderView:(NSDictionary *)result {
    [self showShadowViewWithColor:YES];
    _orderBaseView = [UIView createViewWithFrame:RECT(48, ScreenHeight/2.0-121, ScreenWidth-96, 242) color:[UIColor whiteColor]];
    _orderBaseView.layer.cornerRadius = 5;
    _orderBaseView.layer.masksToBounds = YES;
    [self.shadowView addSubview:_orderBaseView];
    
    UIButton *cancelButton = [UIButton createimageButtonWithFrame:RECT(ScreenWidth-48-40, _orderBaseView.frame.origin.y-60, 40, 40) imageName:@"iocn_cancelbutton"];
    [cancelButton addTarget:self action:@selector(iocn_cancelbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.shadowView addSubview:cancelButton];
    
    UILabel *titleLabel = [UILabel new];
    [titleLabel rect:RECT(10, 15, WIDTH(_orderBaseView)-20, 20) aligment:Center font:17 isBold:YES text:@"购买订单" textColor:Color4D superView:_orderBaseView];
    
    orderListView*_orderList1 = [[orderListView alloc]initWithFrame:RECT(0, GETY(titleLabel.frame)+20, WIDTH(_orderBaseView), 26)];
    _orderList1.leftStr = @"交易金额";
    _orderList1.rightStr = [NSString stringWithFormat:@"%.2fCNY",[result[@"price"] doubleValue]];
    [_orderBaseView addSubview:_orderList1];
    
    orderListView*_orderList2 = [[orderListView alloc]initWithFrame:RECT(0, GETY(_orderList1.frame), WIDTH(_orderBaseView), 26)];
    _orderList2.leftStr = @"单价";
    _orderList2.rightStr = [NSString stringWithFormat:@"%.2fCNY",[result[@"ratePrice"] doubleValue]];
    [_orderBaseView addSubview:_orderList2];
    
   orderListView* _orderList3 = [[orderListView alloc]initWithFrame:RECT(0, GETY(_orderList2.frame), WIDTH(_orderBaseView), 26)];
    _orderList3.leftStr = @"数量";
    _orderList3.rightStr = [NSString stringWithFormat:@"%.2f",[result[@"num"] doubleValue] ];;
    [_orderBaseView addSubview:_orderList3];
    
    orderListView*_orderList4 = [[orderListView alloc]initWithFrame:RECT(0, GETY(_orderList3.frame), WIDTH(_orderBaseView), 26)];
    _orderList4.leftStr = @"卖家";
    _orderList4.rightStr = result[@"targetNickName"];
    [_orderBaseView addSubview:_orderList4];
    
     UIView *_orderViewTwo = [UIView createViewWithFrame:RECT(0, HEIGHT(_orderBaseView)-66, WIDTH(_orderBaseView), 66) color:colorWithHexString(@"#b8bbcc")];
    [_orderBaseView addSubview:_orderViewTwo];
    
    UILabel *orderLabel = [UILabel new];
    [orderLabel rect:RECT(15, 10, WIDTH(_orderBaseView)-30, 23) aligment:Left font:13 isBold:NO text:[NSString stringWithFormat:@"订单号  %@",result[@"recordNo"]] textColor:[UIColor whiteColor] superView:_orderViewTwo];
    
    UILabel *timeLabel = [UILabel new];
    [timeLabel rect:RECT(15, 33, WIDTH(_orderBaseView)-30, 23) aligment:Left font:13 isBold:NO text:[NSString stringWithFormat:@"订单时间  %@",[DateUtil getDateStringFormString:result[@"createTime"] format:@"yyyy-MM-dd HH:mm"]] textColor:[UIColor whiteColor] superView:_orderViewTwo];
    
    UIButton *_operationButton = [UIButton createTextButtonWithFrame:RECT(48, GETY(_orderBaseView.frame)+20, WIDTH(_orderBaseView), 50) bgColor:ColorBlue textColor:[UIColor whiteColor] font:16 bold:YES title:@"去支付"];
    [_operationButton addTarget:self action:@selector(operationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _operationButton.layer.cornerRadius = 5;
    [self.shadowView addSubview:_operationButton];
}
- (void)operationButtonClick {
    [self cancel];
    BuyDeatilViewController *vc = [[BuyDeatilViewController alloc]init];
    vc.orderId = _orderId;
    vc.canPop = YES;
    vc.dismissBlock = ^{
        self.canPop = YES;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)iocn_cancelbuttonClick {
    [self cancel];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cancel {
    [_orderBaseView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.shadowView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    } ];
    [self hiddenShadowView];
}
@end
