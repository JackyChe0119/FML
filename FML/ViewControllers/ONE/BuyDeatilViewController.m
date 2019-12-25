//
//  BuyDeatilViewController.m
//  FML
//
//  Created by 车杰 on 2018/8/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "BuyDeatilViewController.h"
#import "OrderListModel.h"
@interface BuyDeatilViewController ()
@property (nonatomic,strong)UIScrollView *baseScrollView;
@property (nonatomic,strong)UIButton *tipButton;
@property (nonatomic,strong)OrderListModel *model;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,strong)NSDictionary *result;
@property (nonatomic,strong)UIButton *compeleteBtn;
@end

@implementation BuyDeatilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:@"支付" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    self.view.backgroundColor = ColorBg;
    [self dorequest];
}
- (void)dorequest {
    [self showProgressHud];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    [params setValue:[NSNumber numberWithInteger:_orderId] forKey:@"exchangeId"];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"exchangeRecord/exchange_info.htm".apifml method:POST args:params];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            _model = [[OrderListModel alloc]initWithDictionary:responseMessage.bussinessData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self layoutUI];
            });
        }
    }];
}

- (void)layoutUI {
    
    _baseScrollView = [[UIScrollView alloc]initWithFrame:RECT(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight-150)];
    _baseScrollView.backgroundColor = ColorBg;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_baseScrollView];
    
    UILabel *PriceLabel = [UILabel new];
    [PriceLabel rect:RECT(15, 30,ScreenWidth-30, 25) aligment:Center font:22 isBold:YES text:@"" textColor:Color1D superView:self.baseScrollView];
    NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f CNY",[_model.price doubleValue]]];
    NSRange redRangeTwo = NSMakeRange(noteStr.length-3,3);
    [noteStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:redRangeTwo];
    PriceLabel.attributedText = noteStr;
    
    UIImageView *timeImage = [UIImageView createImageViewWithFrame:RECT(ScreenWidth/2.0-10, GETY(PriceLabel.frame)+10, 20, 20) imageName:@"icon_time_count"];
    [_baseScrollView addSubview:timeImage];
    
    UILabel *statusLabel = [UILabel new];
    [statusLabel rect:RECT(ScreenWidth/2.0-100, GETY(PriceLabel.frame)+10,80, 20) aligment:Right font:13 isBold:NO text:@"未付款" textColor:Color1D superView:self.baseScrollView];
    
    UILabel *timeLabel = [UILabel new];
    [timeLabel rect:RECT(ScreenWidth/2.0+20, GETY(PriceLabel.frame)+10,120, 20) aligment:Left font:13 isBold:NO text:@"" textColor:Color1D superView:self.baseScrollView];
    [timeLabel DatecountdownOrder:3600*12-([_model.systemTime integerValue]/1000-[_model.createTime integerValue]/1000) str:@"" final:@"付款时间已结束" :^{
        _status = 1;
        _compeleteBtn.userInteractionEnabled = NO;
        [_compeleteBtn setBackgroundColor:ColorGray];
    } :^{
    }];
    
    UIImageView *bgImageView = [UIImageView createImageViewWithFrame:RECT(15, GETY(timeLabel.frame)+40, ScreenWidth-30, 130) imageName:@"iocn_zichantop"];
    bgImageView.userInteractionEnabled = YES;
    [_baseScrollView addSubview:bgImageView];
    
    UIImageView *crad = [UIImageView createImageViewWithFrame:RECT(20, 20, 30, 20) imageName:@"iocn_bankcard"];
    crad.contentMode = UIViewContentModeCenter;
    [bgImageView addSubview:crad];

    UILabel *bankLabel = [UILabel new];
    [bankLabel rect:RECT(GETX(crad.frame)+5, 20,220, 20) aligment:Left font:13 isBold:YES text:_model.sysBankName textColor:[UIColor whiteColor] superView:bgImageView];
    bankLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *nameLabel = [UILabel new];
    [nameLabel rect:RECT(20, 57,70, 20) aligment:Left font:13 isBold:NO text:@"收款人" textColor:[UIColor whiteColor] superView:bgImageView];
    
    UILabel *CardNoLabel = [UILabel new];
    [CardNoLabel rect:RECT(20, 80,70, 20) aligment:Left font:13 isBold:NO text:@"收款账户" textColor:[UIColor whiteColor] superView:bgImageView];
    
    UILabel *name = [UILabel new];
    [name rect:RECT(100, 57,100, 20) aligment:Left font:13 isBold:NO text:_model.targetName textColor:[UIColor whiteColor] superView:bgImageView];
    
    UILabel *NoLabel = [UILabel new];
    [NoLabel rect:RECT(100, 80,100, 20) aligment:Left font:13 isBold:NO text:@"" textColor:[UIColor whiteColor] superView:bgImageView];
    NSString *str = _model.sysBankNumber;
//    if (str.length>8) {
//        NSString *top = [str substringToIndex:4];
//        NSString *bottom = [str substringWithRange:NSMakeRange(str.length-4, 4)];
//        NoLabel.text = [NSString stringWithFormat:@"%@****%@",top,bottom];
//    }else {
        NoLabel.text = str;
//    }
    [NoLabel sizeToFit];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setImage:[UIImage imageNamed:@"pasteboard"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pasteboard) forControlEvents:UIControlEventTouchUpInside];
    btn.frame =RECT(GETX(NoLabel.frame)+5, NoLabel.frame.origin.y, 20, 20);
    [bgImageView addSubview:btn];
    
    UIImageView *tipImageView = [UIImageView createImageViewWithFrame:RECT(20, GETY(bgImageView.frame)+20, 20, 20) imageName:@"icon_rediii"];
    tipImageView.contentMode = UIViewContentModeCenter;
    [_baseScrollView addSubview:tipImageView];
    
    UILabel* tipLabel = [UILabel new];
    tipLabel.textColor = colorWithHexString(@"e00000");
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.numberOfLines = 0;
    tipLabel.frame = RECT(45, GETY(bgImageView.frame)+20, ScreenWidth-60, 30);
    [_baseScrollView addSubview:tipLabel];
    tipLabel.numberOfLines = 0;
    tipLabel.text = @"为确保您的资产快速到账，在付款时请不要备注关于数钱钱任何内容，否则放行处理会有延误 ";
    [tipLabel sizeToFit];
    
    _tipButton = [UIButton createTextButtonWithFrame:RECT(45, ScreenHeight-150, 30, 30) bgColor:nil textColor:[UIColor whiteColor] font:14 bold:YES title:@""];
    [_tipButton addTarget:self action:@selector(tipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _tipButton.tag = 400;
    [_tipButton setImage:IMAGE(@"icon_unselect") forState:UIControlStateNormal];
    [self.view addSubview:_tipButton];
    
    UILabel *nextLoginLabel = [UILabel new];
    nextLoginLabel.numberOfLines = 0;
    [nextLoginLabel rect:RECT(GETX(_tipButton.frame)+5,_tipButton.frame.origin.y, ScreenWidth-120, 20) aligment:Left font:13 isBold:NO text:@"付款成功后点击下方按钮通知卖方放币，恶意点击会被冻结账号" textColor:colorWithHexString(@"#4d5066") superView:self.view];
    [nextLoginLabel sizeToFit];
    
    _compeleteBtn = [UIButton createTextButtonWithFrame:RECT(45, ScreenHeight-90, ScreenWidth-90, 50) bgColor:nil textColor:[UIColor whiteColor] font:16 bold:YES title:@"已完成付款"];
    [_compeleteBtn addTarget:self action:@selector(tipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _compeleteBtn.tag = 500;
    _compeleteBtn.userInteractionEnabled = NO;
    _compeleteBtn.layer.cornerRadius = 5;
    [_compeleteBtn setBackgroundColor:ColorGray];
    [_compeleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_compeleteBtn];
    
}
- (void)tipBtnClick:(UIButton *)sender {
    if (sender.tag==400) {
        if (sender.selected) {
            [sender setImage:IMAGE(@"icon_unselect") forState:UIControlStateNormal];
            _compeleteBtn.userInteractionEnabled = NO;
            [_compeleteBtn setBackgroundColor:ColorGray];
        }else {
            [sender setImage:IMAGE(@"icon_select") forState:UIControlStateNormal];
            _compeleteBtn.userInteractionEnabled = YES;
            [_compeleteBtn setBackgroundColor:ColorBlue];
        }
        sender.selected = !sender.selected;
    }else {
        if (_status==1) {
            [self showToastHUD:@"付款时间已结束，订单已取消，无法付款"];
            return;
        }
        if (!_tipButton.selected) {
            [self showToastHUD:@"请先勾选提示按钮"];
            return;
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"你已完成付款？" message:@"务必确认您已完成转账付款，恶意点击可能会被冻结账号，请谨慎操作。" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"暂未完成" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self compeletePay];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}
- (void)compeletePay {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    [params setValue:[NSNumber numberWithInteger:_orderId] forKey:@"exchangeId"];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"exchangeRecord/comfirm_order.htm".apifml method:POST args:params];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showToastHUD:@"操作成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"orderStatusChangeSuccessful" object:nil];
                if (self.canPop) {
                    if (_dismissBlock) {
                        _dismissBlock();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            });
        }
    }];
}
- (void)navgationLeftButtonClick {
    if (self.canPop) {
        if (_dismissBlock) {
            _dismissBlock();
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)pasteboard {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.result[@"bankNumber"];
    [self showToastHUD:@"复制成功"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
