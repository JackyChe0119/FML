//
//  CurrencyViewController.m
//  FML
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "CurrencyViewController.h"
#import "TransactionTableViewCell.h"
#import "CurrencyDetailView.h"
#import "RechargeViewController.h"
#import "ExportViewController.h"
#import "ExchangeViewController.h"
#import "MJRefresh.h"
#import "FlowListModel.h"
#import "CurrencySectionView.h"
#import "FMLAlertView.h"
#import "RealNameViewController.h"
#import "BindPhoneViewController.h"
static NSString* const ID = @"TransactionTableViewCell";

@interface CurrencyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) CurrencyDetailView* topView;
@property (nonatomic, assign) NSInteger     pageNum;
@property (nonatomic, strong) NSMutableArray<FlowListModel *>* models;
@property (nonatomic, strong) CurrencySectionView*       secView0;
@property (nonatomic, strong) UIView*       headerSectionView;
@property (nonatomic, copy)   NSString*     selectType;

@property (nonatomic, strong) dispatch_group_t myGroup;
@property (nonatomic, assign) BOOL              isFristGetData;

@property (nonatomic, assign) BOOL              isOpenSection;

@end

@implementation CurrencyViewController

- (NSArray *)types {
    return @[@"sbuy", @"sale", @"recharge", @"tocash", @"commission", @"buy"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_isFristGetData) {
        [self currencyDetail];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self topLayer];
    [self layoutUI];
    
    _pageNum = 0;
    _isFristGetData = YES;
    _models = [NSMutableArray array];
    
    [self showProgressHud];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_t group = dispatch_group_create();
    self.myGroup = group;
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self currencyDetail];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self getList:_pageNum];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        if (![self.currencyName isEqualToString:@"FML"]) {
            [self getKline:@"sixty"];
        }else {
            [self getkkline:@"1H"];
        }
    });
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hiddenProgressHud];
            _isFristGetData = NO;
        });
    });
    
    _isOpenSection = NO;
}

- (void)topLayer {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint = CGPointMake(0, 0.5);//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
    layer.endPoint = CGPointMake(1, 0.5);//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
    layer.colors = [NSArray arrayWithObjects:(id)colorWithHexString(@"#5172fa").CGColor, (id)colorWithHexString(@"#569dfa").CGColor, nil];
    layer.locations = @[@0.0, @0.5];
    layer.frame = self.customNavView.bounds;
    [self.customNavView.layer addSublayer:layer];
}

- (void)layoutUI {
    if ([_currencyName isEqualToString:@"FML"]) {
        [self NavigationItemTitle:_currencyName Color:[UIColor whiteColor]];
    }else {
        [self NavigationItemTitle:_currencyName Color:[UIColor whiteColor]];
    }
    [self navgationLeftButtonImage:backUp_wihte];
    [self.view addSubview:self.tableView];
    [self.view addSubview:[self bottomView]];
    
    self.titleLabel.right =  self.titleLabel.right + 24;
    UIImageView* icon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 34, self.customNavView.bottom - 33, 23, 23)];
    icon.layer.cornerRadius = 11.5;
    icon.layer.masksToBounds = YES;
    [icon sd_setImageWithURL:_currencyIcon.toUrl];
    [self.customNavView addSubview:icon];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
#pragma mark -- delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_models.count == 0) {
        return 1;
    }
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_models.count == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        }
        cell.textLabel.text = @"暂无数据";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    TransactionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.model = _models[indexPath.row];
    UIView* line;
    if (!line) {
        line = [[UIView alloc] initWithFrame:CGRectMake(20, 79.5, ScreenWidth - 15, 0.5f)];
        line.tag = 10001111;
        line.backgroundColor = ColorLine;
        [cell.contentView addSubview:line];
    }
    line.hidden = ((indexPath.row + 1) == self.models.count);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _isOpenSection ? 175 : 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self sectionView];
}

- (UIView *)sectionView {
    if (_secView0) {
        return _secView0;
    }
    
    _secView0 = [[[NSBundle mainBundle] loadNibNamed:@"CurrencySectionView" owner:self options:nil] firstObject];
    _secView0.clipsToBounds = YES;
    if ([_currencyName isEqualToString:@"ETH"]||[_currencyName isEqualToString:@"USDT"]||[_currencyName isEqualToString:@"BTC"]||[_currencyName isEqualToString:@"EOS"]) {
        _secView0._btn6.hidden = YES;
        [_secView0._btn5 setTitle:@"投资" forState:UIControlStateNormal];
    }else {
        [_secView0._btn6 setTitle:@"释放" forState:UIControlStateNormal];
    }
    
    __weak typeof(self) weakSelf = self;
    _secView0.openHander = ^{
        [weakSelf openSection];
    };
    _secView0.currencySelectIndex = ^(int index) {
        [weakSelf openSection];
        if ([_currencyName isEqualToString:@"ETH"]||[_currencyName isEqualToString:@"USDT"]||[_currencyName isEqualToString:@"BTC"]||[_currencyName isEqualToString:@"EOS"]) {
            weakSelf.secView0._btn6.hidden = YES;
            if (index>=4) {
                weakSelf.selectType = @"buy";
            }else {
                weakSelf.selectType = weakSelf.types[index];
            }
        }else {
            if (index>=5) {
                weakSelf.selectType = @"release";
            }else {
                weakSelf.selectType = weakSelf.types[index];
            }
        }
        weakSelf.pageNum = 0;
        [weakSelf getList:weakSelf.pageNum];
    };
    
    return _secView0;
}

- (void)openSection {
    _isOpenSection = !_isOpenSection;
    [self.tableView reloadData];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight-50 - (IPhoneX ? 34 : 0)) style:UITableViewStylePlain];
        _tableView.backgroundColor = ColorWhite;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.rowHeight = 80;
        [_tableView registerClass:[TransactionTableViewCell class] forCellReuseIdentifier:ID];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [self tableHeaderView];
        _tableView.tableFooterView = [UIView new];
        
        __weak typeof(self) weakSelf = self;
        [_tableView addHeaderWithCallback:^{
            weakSelf.pageNum = 0;
            [weakSelf currencyDetail];
            [weakSelf getList:weakSelf.pageNum];
        }];
        [_tableView addFooterWithCallback:^{
            if (weakSelf.pageNum == -1) {
                [weakSelf showToastHUD:@"没有更多数据了"];
                [weakSelf.tableView.footer endRefreshing];
            } else {
                [weakSelf getList:weakSelf.pageNum];
            }
        }];
    }
    return _tableView;
}

- (UIView *)tableHeaderView {
    __weak typeof(self) weakSelf = self;
    UIView* view = [UIView new];
    view.backgroundColor = colorWithHexString(@"#548efa");
    _topView = [[CurrencyDetailView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0) isLock:(_walletModel.freezeNumber > 0.00001) currencyName:self.currencyName];
    if (_walletModel.freezeNumber > 0.00001) {
        _topView.lockLB.text = [NSString stringWithFormat:@"锁定：%.2f个", _walletModel.freezeNumber];
        _topView.freeLB.text = [NSString stringWithFormat:@"可用：%.2f个", _walletModel.number - _walletModel.freezeNumber];
    }
    _topView.Namecurrency = _currencyName;
    _topView.logo = _currencyIcon;
    _topView.kingEnumHandle = ^(NSString *KEnum) {
        if (![weakSelf.currencyName isEqualToString:@"FML"]) {
            [weakSelf getKline:KEnum];
        }else {
            [weakSelf getkkline:KEnum];
        }
    };
    _topView.clipsToBounds = YES;
    [view addSubview:_topView];
    view.frame = CGRectMake(0, -20, ScreenWidth, BOTTOM(_topView));
    return view;
}

- (UIView *)bottomView {
    CGFloat viewHeight = 50 ;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - viewHeight - (IPhoneX ? 34 : 0), ScreenWidth, viewHeight)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton* accountsBtn = [[UIButton alloc] initWithFrame:CGRectMake(7, 0, (ScreenWidth-21) / 2.0, 43)];
    [accountsBtn setTitle:@"提现" forState:UIControlStateNormal];
    [accountsBtn setTitleColor:ColorBlue forState:UIControlStateNormal];
    [accountsBtn addTarget:self action:@selector(chongzhiButtonClick) forControlEvents:UIControlEventTouchUpInside];
    accountsBtn.layer.cornerRadius = 5;
    accountsBtn.layer.masksToBounds = YES;
    accountsBtn.layer.borderWidth = .5;
    accountsBtn.layer.borderColor = ColorBlue.CGColor;
    accountsBtn.titleLabel.font = FONT(15);
    [view addSubview:accountsBtn];
    
    UIButton* receivablesBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth / 2.0+3.5, 0, (ScreenWidth-21) / 2.02, 43)];
    [receivablesBtn setTitle:@"充值" forState:UIControlStateNormal];
    receivablesBtn.backgroundColor = ColorBlue;
    [receivablesBtn addTarget:self action:@selector(zhuanzhangButtonClick) forControlEvents:UIControlEventTouchUpInside];
    receivablesBtn.titleLabel.font = FONT(15);
    receivablesBtn.layer.cornerRadius = 5;
    receivablesBtn.layer.masksToBounds = YES;
    [view addSubview:receivablesBtn];
    return view;
}
- (void)zhuanzhangButtonClick {
    if ([UserSingle sharedUser].isAuth==3&&[[UserSingle sharedUser].email containsString:@"@"]) {
        ExportViewController *vc = [[ExportViewController alloc]init];
        vc.currencyId = _currencyId;
        vc.currencyName = _currencyName;
        vc.number = String(self.topView.currencyDetailDict[@"number"]).floatValue;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [vc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"user/user_info.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [CommonToastHUD showTips:responseMessage.errorMessage];
        } else {
            [[UserSingle sharedUser] setLoginInfo:responseMessage.bussinessData];
            if ([UserSingle sharedUser].isAuth!=3||![[UserSingle sharedUser].email containsString:@"@"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showAuthAlert];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ExportViewController *vc = [[ExportViewController alloc]init];
                    vc.currencyId = _currencyId;
                    vc.currencyName = _currencyName;
                    vc.number = String(self.topView.currencyDetailDict[@"number"]).floatValue;
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                    [vc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
                    [self presentViewController:nav animated:YES completion:nil];
                });
            }
        }
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
- (void)chongzhiButtonClick {
    if ([UserSingle sharedUser].isAuth==3&&[[UserSingle sharedUser].email containsString:@"@"]) {
        RechargeViewController *vc = [[RechargeViewController alloc]init];
        vc.currencyId = _currencyId;
        vc.currencyName = _currencyName;
        vc.number = String(self.topView.currencyDetailDict[@"number"]).floatValue;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [vc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"user/user_info.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [CommonToastHUD showTips:responseMessage.errorMessage];
        } else {
            [[UserSingle sharedUser] setLoginInfo:responseMessage.bussinessData];
            if ([UserSingle sharedUser].isAuth!=3||![[UserSingle sharedUser].email containsString:@"@"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showAuthAlert];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    RechargeViewController *vc = [[RechargeViewController alloc]init];
                    vc.currencyId = _currencyId;
                    vc.currencyName = _currencyName;
                    vc.number = String(self.topView.currencyDetailDict[@"number"]).floatValue;
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                    [vc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
                    [self presentViewController:nav animated:YES completion:nil];
                });
            }
        }
    }];
}

- (void)currencyDetail {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"currencyId"] = _currencyId;
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"sys_currency/info.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            self.topView.currencyDetailDict = [NSMutableDictionary dictionaryWithDictionary:responseMessage.bussinessData];
            [self.topView.currencyDetailDict setValue:_currencyId forKey:@"currencyId"];
        }
        if (_isFristGetData) {
            dispatch_group_leave(self.myGroup);
        }
    }];
}
- (void)getKline:(NSString *)kingEnum {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"currencyId"] = _currencyId;
    dict[@"period"] = kingEnum;
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"sys_currency/get_kline1.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            if ([[NSString stringWithFormat:@"%@",[responseMessage.bussinessData class]] isEqualToString:@"__NSCFString"]) {
                responseMessage.bussinessData = [NSString stringWithFormat:@"%@",responseMessage.bussinessData];
                NSData *stringData = [responseMessage.bussinessData dataUsingEncoding:NSUTF8StringEncoding];
                responseMessage.bussinessData = [NSJSONSerialization JSONObjectWithData:stringData options:0 error:nil];
            }
            self.topView.klineDict = responseMessage.bussinessData;
        }
        if (_isFristGetData) {
            dispatch_group_leave(self.myGroup);
        }
        
    }];
}

- (void)getkkline:(NSString *)kingEnum {
   
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"currencyId"] = _currencyId;
    dict[@"period"] = kingEnum;
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"https://openapi.idax.mn/api/v1/kline?pair=FML_ETH" method:GET args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            self.topView.klineDict = responseMessage.bussinessData;
        }
        if (_isFristGetData) {
            dispatch_group_leave(self.myGroup);
        }
    }];
}

- (void)getList:(NSUInteger)pageNum {
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"pageNum"] = @(pageNum);
    dict[@"type"] = _currencyName;
    dict[@"delType"] = _selectType;
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"flow/flow_list.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {

        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            if (pageNum == 0) {
                [_models removeAllObjects];
            }
            _pageNum = pageNum + 1;
            NSArray* array = [FlowListModel arrayToModel:responseMessage.bussinessData];
            if (array.count == 0) {
                _pageNum = -1;
            }
            [_models addObjectsFromArray:[FlowListModel arrayToModel:responseMessage.bussinessData]];

        }
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        if (_isFristGetData) {
            dispatch_group_leave(self.myGroup);
        }

    }];
}

@end
