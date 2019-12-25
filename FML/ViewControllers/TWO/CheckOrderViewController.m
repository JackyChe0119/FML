//
//  CheckOrderViewController.m
//  FML
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "CheckOrderViewController.h"

@interface CheckOrderViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *ddLB;
@property (weak, nonatomic) IBOutlet UILabel *ZCLB;


@property (weak, nonatomic) IBOutlet UILabel *currencyNameLB;
@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@end

@implementation CheckOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currencyNameLB.textColor = _priceLB.textColor = _titleLB.textColor = _ddLB.textColor = _ZCLB.textColor = Color1D;

    _priceLB.text = _num;
    _currencyNameLB.text = _currencyName;
    
    _okBtn.layer.cornerRadius = 5;
    _okBtn.backgroundColor = ColorBlue;
    [_okBtn addTarget:self action:@selector(currencyDetail) forControlEvents:UIControlEventTouchUpInside];
    
    [_dismissBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dismissVC {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)currencyDetail {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"currencyInvestId"] = _sysCurrencyId;
    dict[@"number"] = _num;
    dict[@"payPwd"] = @"123456";
    
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"curOrder/create_order.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            [self showToastHUD:@"转账成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }];
}

@end
