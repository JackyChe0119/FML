//
//  OrderDeatilViewController.m
//  FML
//
//  Created by 车杰 on 2018/8/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "OrderDeatilViewController.h"
#import "orderListView.h"
#import "OrderListModel.h"
#import "TimeCountView.h"
#import "BuyDeatilViewController.h"
#import "statusView.h"
@interface OrderDeatilViewController ()
@property (nonatomic,strong)UIScrollView *baseScrollView;
@property (nonatomic,strong)UIView *orderViewOne,*orderViewTwo,*orderBaseView;
@property (nonatomic,strong)UIButton *operationButton;
@property (nonatomic,strong)orderListView *orderList1,*orderList2,*orderList3,*orderList4;
@property (nonatomic,strong)OrderListModel *model;
@property (nonatomic,strong)TimeCountView *timeCountView;
@property (nonatomic,assign)NSInteger operationType;//1 确认支付
@property (nonatomic,strong)statusView *stateView;
@end

@implementation OrderDeatilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:@"订单详情" Color:[UIColor whiteColor]];
    [self navgationLeftButtonImage:backUp_wihte];
    self.customNavView.backgroundColor = ColorBlue;
    self.view.backgroundColor = ColorBlue;
    [self doRequest];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)navgationLeftButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)doRequest {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
 
    [params setObject:[NSNumber numberWithInteger:_orderId] forKey:@"exchangeId"];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"exchangeRecord/exchange_info.htm".apifml method:POST args:params];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            _model = [[OrderListModel alloc]initWithDictionary:responseMessage.bussinessData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self layoutOrderView];
            });
        }
    }];
}
- (void)layoutOrderView {
    if (!_baseScrollView ) {
        _baseScrollView = [[UIScrollView alloc]initWithFrame:RECT(48, NavHeight, ScreenWidth-96, ScreenHeight-NavHeight-10)];
        _baseScrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self.view addSubview:_baseScrollView];
    }
    _orderBaseView = [UIView createViewWithFrame:RECT(0, 30, WIDTH(_baseScrollView), 242) color:[UIColor whiteColor]];
    _orderBaseView.layer.cornerRadius = 5;
    _orderBaseView.layer.masksToBounds = YES;
    [_baseScrollView addSubview:_orderBaseView];
    
    UILabel *titleLabel = [UILabel new];
    [titleLabel rect:RECT(10, 15, WIDTH(_baseScrollView)-20, 20) aligment:Center font:17 isBold:YES text:@"出售订单" textColor:Color4D superView:_orderBaseView];
    
    _orderList1 = [[orderListView alloc]initWithFrame:RECT(0, GETY(titleLabel.frame)+20, WIDTH(_orderBaseView), 26)];
    _orderList1.leftStr = @"出售订单";
    _orderList1.rightStr =@"";
    [_orderBaseView addSubview:_orderList1];
    
    _orderList2 = [[orderListView alloc]initWithFrame:RECT(0, GETY(_orderList1.frame), WIDTH(_orderBaseView), 26)];
    _orderList2.leftStr = @"单价";
    _orderList2.rightStr =@"";
    [_orderBaseView addSubview:_orderList2];
    
    _orderList3 = [[orderListView alloc]initWithFrame:RECT(0, GETY(_orderList2.frame), WIDTH(_orderBaseView), 26)];
    _orderList3.leftStr = @"数量";
    _orderList3.rightStr =@"";
    [_orderBaseView addSubview:_orderList3];
    
    _orderList4 = [[orderListView alloc]initWithFrame:RECT(0, GETY(_orderList3.frame), WIDTH(_orderBaseView), 26)];
    _orderList4.leftStr = @"买家";
    _orderList4.rightStr =@"";
    [_orderBaseView addSubview:_orderList4];
    
    _orderViewTwo = [UIView createViewWithFrame:RECT(0, HEIGHT(_orderBaseView)-66, WIDTH(_orderBaseView), 66) color:colorWithHexString(@"#b8bbcc")];
    [_orderBaseView addSubview:_orderViewTwo];
    
    UILabel *orderLabel = [UILabel new];
    [orderLabel rect:RECT(15, 10, WIDTH(_baseScrollView)-30, 23) aligment:Left font:13 isBold:NO text:@"订单号  11127190209707192" textColor:[UIColor whiteColor] superView:_orderViewTwo];
    
    UILabel *timeLabel = [UILabel new];
    [timeLabel rect:RECT(15, 33, WIDTH(_baseScrollView)-30, 23) aligment:Left font:13 isBold:NO text:@"订单时间  2018-10-10" textColor:[UIColor whiteColor] superView:_orderViewTwo];
    
    _operationButton = [UIButton createTextButtonWithFrame:RECT(0, GETY(_orderBaseView.frame)+30, WIDTH(_baseScrollView), 50) bgColor:colorWithHexString(@"#1d2659") textColor:[UIColor whiteColor] font:16 bold:YES title:@"放行"];
    [_operationButton addTarget:self action:@selector(operationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _operationButton.layer.cornerRadius = 5;
    [_baseScrollView addSubview:_operationButton];
    
    if ([_model.type isEqualToString:@"buy"]) {
        titleLabel.text = @"购买订单";
        _orderList1.leftStr = @"交易价格";
        _orderList1.rightStr = [NSString stringWithFormat:@"%.2fCNY",[_model.price doubleValue]];
        _orderList4.leftStr = @"卖家";
        _orderList4.rightStr = _model.targetNickName;
        _orderList2.rightStr = [NSString stringWithFormat:@"%.2fCNY",[_model.ratePrice doubleValue]];
        _orderList3.rightStr = [NSString stringWithFormat:@"%.2f%@",_model.num,_model.currencyType];
        orderLabel.text = [NSString stringWithFormat:@"订单号  %@",_model.recordNo];
        timeLabel.text = [NSString stringWithFormat:@"订单时间  %@",[DateUtil getDateStringFormString:_model.createTime format:@"yyyy-MM-dd HH:mm"]];
        if (_model.status==0) {
            _timeCountView= [[TimeCountView alloc]initWithFrame:RECT(WIDTH(_orderBaseView)/2.0-50, GETY(titleLabel.frame)+20, 100, 100)];
            _timeCountView.count = 3600*12-([_model.systemTime integerValue]/1000-[_model.createTime integerValue]/1000);
            [_orderBaseView addSubview:_timeCountView];
            _orderList1.frame = RECT(0, GETY(_timeCountView.frame)+20, WIDTH(_orderBaseView), 26);
            _orderList2.frame = RECT(0, GETY(_orderList1.frame), WIDTH(_orderBaseView), 26);
            _orderList3.frame = RECT(0, GETY(_orderList2.frame), WIDTH(_orderBaseView), 26);
            _orderList4.frame = RECT(0, GETY(_orderList3.frame), WIDTH(_orderBaseView), 26);
            _orderBaseView.frame = RECT(0, 30, WIDTH(_baseScrollView), 350);
            _orderViewTwo.frame = RECT(0, HEIGHT(_orderBaseView)-66, WIDTH(_orderBaseView), 66);
            _operationButton.frame = RECT(0, GETY(_orderBaseView.frame)+30, WIDTH(_baseScrollView), 50);
            [_operationButton setTitle:@"确认支付" forState:UIControlStateNormal];
            _operationType = 1;
        }else if (_model.status==1) {
            _stateView = [[statusView alloc]initWithFrame:RECT(WIDTH(_orderBaseView)/2.0-50, GETY(titleLabel.frame)+20, 100, 100)];
            _stateView.iconImageView.frame = RECT(20, 0, 60, 60);
            _stateView.statusLabel.frame =RECT(0, 65, 100, 25);
            _stateView.status = @"待确认";
            _stateView.imageStr = @"iocn_time_red";
            [_orderBaseView addSubview:_stateView];
            _orderList1.frame = RECT(0, GETY(_stateView.frame)+20, WIDTH(_orderBaseView), 26);
            _orderList2.frame = RECT(0, GETY(_orderList1.frame), WIDTH(_orderBaseView), 26);
            _orderList3.frame = RECT(0, GETY(_orderList2.frame), WIDTH(_orderBaseView), 26);
            _orderList4.frame = RECT(0, GETY(_orderList3.frame), WIDTH(_orderBaseView), 26);
            _orderBaseView.frame = RECT(0, 30, WIDTH(_baseScrollView), 350);
            _orderViewTwo.frame = RECT(0, HEIGHT(_orderBaseView)-66, WIDTH(_orderBaseView), 66);
            _operationButton.frame = RECT(0, GETY(_orderBaseView.frame)+30, WIDTH(_baseScrollView), 50);
            [_operationButton setTitle:@"返回" forState:UIControlStateNormal];
            _operationType = 2;

        }else if (_model.status==2){
            _stateView = [[statusView alloc]initWithFrame:RECT(WIDTH(_orderBaseView)/2.0-50, GETY(titleLabel.frame)+20, 100, 100)];
            _stateView.iconImageView.frame = RECT(20, 0, 60, 60);
            _stateView.statusLabel.frame =RECT(0, 65, 100, 25);
            _stateView.status = @"已完成";
            _stateView.imageStr = @"iocn_pay_succ";
            [_orderBaseView addSubview:_stateView];
            _orderList1.frame = RECT(0, GETY(_stateView.frame)+20, WIDTH(_orderBaseView), 26);
            _orderList2.frame = RECT(0, GETY(_orderList1.frame), WIDTH(_orderBaseView), 26);
            _orderList3.frame = RECT(0, GETY(_orderList2.frame), WIDTH(_orderBaseView), 26);
            _orderList4.frame = RECT(0, GETY(_orderList3.frame), WIDTH(_orderBaseView), 26);
            _orderBaseView.frame = RECT(0, 30, WIDTH(_baseScrollView), 350);
            _orderViewTwo.frame = RECT(0, HEIGHT(_orderBaseView)-66, WIDTH(_orderBaseView), 66);
            _operationButton.frame = RECT(0, GETY(_orderBaseView.frame)+30, WIDTH(_baseScrollView), 50);
            [_operationButton setTitle:@"返回" forState:UIControlStateNormal];
            _operationType = 2;
        }else {
            //订单取消状态
            [_operationButton setTitle:@"返回" forState:UIControlStateNormal];
            _operationType = 2;
        }
    }else {
      
        titleLabel.text = @"出售订单";
        _orderList1.leftStr = @"交易价格";
        _orderList1.rightStr = [NSString stringWithFormat:@"%.2fCNY",[_model.price doubleValue]];
        _orderList4.leftStr = @"买家";
        _orderList4.rightStr = _model.targetNickName;
        _orderList2.rightStr = [NSString stringWithFormat:@"%.2fCNY",[_model.ratePrice doubleValue]];
        _orderList3.rightStr = [NSString stringWithFormat:@"%.2f%@",_model.num,_model.currencyType];
        orderLabel.text = [NSString stringWithFormat:@"订单号  %@",_model.recordNo];
        timeLabel.text = [NSString stringWithFormat:@"订单时间  %@",[DateUtil getDateStringFormString:_model.createTime format:@"yyyy-MM-dd HH:mm"]];
        if (_model.status==0) {
            [_operationButton setTitle:@"放行" forState:UIControlStateNormal];
            _operationType = 3;
        }else if (_model.status==1) {
            [_operationButton setTitle:@"放行" forState:UIControlStateNormal];
            _operationType = 3;
        }else if (_model.status==2) {
            [_operationButton setTitle:@"返回" forState:UIControlStateNormal];
            _operationType = 2;
        }else {
            [_operationButton setTitle:@"返回" forState:UIControlStateNormal];
            _operationType = 2;
        }
    }
    
    [_baseScrollView setContentSize:CGSizeMake(WIDTH(_baseScrollView), GETY(_operationButton.frame)+20)];

}
- (void)operationButtonClick {
    if (_operationType==1) {
        //去支付界面
        BuyDeatilViewController *vc = [[BuyDeatilViewController alloc]init];
        vc.orderId = _model.Id;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (_operationType==2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (_operationType==3) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认放行？" message:@"放行前请确认您已收到出售款项,如未收到请点击取消。" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showProgressHudWithTitle:@"放行中..."];
            NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
            [params setObject:[NSNumber numberWithInteger:_orderId] forKey:@"exchangeId"];
            RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"exchangeRecord/release_sale.htm".apifml method:POST args:params];
            [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
                [self hiddenProgressHud];
                if (responseMessage.errorMessage) {
                    [self showToastHUD:responseMessage.errorMessage];
                } else {
                    [self showToastHUD:@"放行成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderStatusChangeSuccessful" object:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
