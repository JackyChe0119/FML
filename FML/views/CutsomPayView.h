//
//  CutsomPayView.h
//  FML
//
//  Created by 车杰 on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputView.h"
#import "passwordView.h"
#import "statusView.h"
@interface CutsomPayView : UIView
//取消按钮
@property (nonatomic,strong)UIButton *dismissBtn;
//标题
@property (nonatomic,strong)UILabel *titleLabel;
//订单状态
@property (nonatomic,strong)InputView *typeInputView;
//支付按钮
@property (nonatomic,strong)UIButton *payButton;

@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIScrollView *baseScrollView;
@property (nonatomic,strong)UILabel *priceLabel;
//支付密码
@property (nonatomic,strong)passwordView *pswView;
//付款状态
@property (nonatomic,strong)statusView *stausView;
@property (nonatomic,strong)UIButton *sureButton;
//订单类型
@property (nonatomic,strong)NSString *orderStatus;
@property (nonatomic,strong) void (^payBlock)(NSInteger index);
- (void)createPasswordView;
- (void)createPaystatusView;
@end
