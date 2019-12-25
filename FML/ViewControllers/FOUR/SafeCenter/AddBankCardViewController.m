//
//  AddBankCardViewController.m
//  FML
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "LeftLableTextField.h"

@interface AddBankCardViewController ()

@property (nonatomic, strong) LeftLableTextField*  item1;
@property (nonatomic, strong) LeftLableTextField*  item2;
@property (nonatomic, strong) LeftLableTextField*  item3;
@property (nonatomic, strong) LeftLableTextField*  item4;

@property (nonatomic, strong) UIButton*            btn;

@end

@implementation AddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self NavigationItemTitle:@"绑定银行卡" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    
    [self setView];
    [self layout];
}

- (void)setView {
    _item1 = [LeftLableTextField new];
    _item1.titleLB.text = @"户主";
    _item1.titleLB.textColor = Color1D;
    _item1.textField.placeholder = @"请输入户主姓名";
    _item1.bottomLine.hidden = YES;
    
    _item2 = [LeftLableTextField new];
    _item2.titleLB.text = @"银行名称";
    _item2.titleLB.textColor = Color1D;
    _item2.textField.placeholder = @"请输入银行名称";
    _item2.bottomLine.hidden = YES;
    
    _item3 = [LeftLableTextField new];
    _item3.titleLB.text = @"支行名称";
    _item3.titleLB.textColor = Color1D;
    _item3.textField.placeholder = @"请输入支行名称";
    _item3.bottomLine.hidden = YES;
    
    _item4 = [LeftLableTextField new];
    _item4.titleLB.text = @"储蓄卡号";
    _item4.titleLB.textColor = Color1D;
    _item4.textField.placeholder = @"请输入储蓄卡号";
    _item4.bottomLine.hidden = YES;
    _item4.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:@"马上绑定" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(addBankCard) forControlEvents:UIControlEventTouchUpInside];
    _btn.layer.cornerRadius = 5;
    _btn.backgroundColor = ColorBlue;
    
    [self.view addSubview:_item1];
    [self.view addSubview:_item2];
    [self.view addSubview:_item3];
    [self.view addSubview:_item4];
    [self.view addSubview:_btn];
}


- (void)layout {
    [_item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(NavHeight+10);
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
    
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.mas_equalTo(50);
        make.top.equalTo(_item4.mas_bottom).offset(60);
    }];
}

- (void)addBankCard {

    if (_item1.textField.text == nil || _item1.textField.text.length == 0) {
        [self showToastHUD:_item1.textField.placeholder];
        return;
    }
    
    if (_item2.textField.text == nil || _item2.textField.text.length == 0) {
        [self showToastHUD:_item2.textField.placeholder];
        return;
    }
    
    if (_item3.textField.text == nil || _item3.textField.text.length == 0) {
        [self showToastHUD:_item3.textField.placeholder];
        return;
    }
    
    if (_item4.textField.text == nil || _item4.textField.text.length == 0) {
        [self showToastHUD:_item4.textField.placeholder];
        return;
    }
    if (_item4.textField.text.length >= 20||_item4.textField.text.length<15) {
        [self showToastHUD:@"银行卡长度出现错误"];
        return;
    }
//    if (![_item4.textField.text checkCardNo:_item4.textField.text]) {
//        [self showToastHUD:@"银行卡号出现错误"];
//        return;
//    }
    
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"realName"] = _item1.textField.text;
    dict[@"bankName"] = _item2.textField.text;
    dict[@"branchName"] = _item3.textField.text;
    dict[@"bankNumber"] = _item4.textField.text;
    
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"bank/add_bank.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            [self showToastHUD:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
    
}
@end
