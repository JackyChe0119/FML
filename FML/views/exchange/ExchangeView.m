//
//  ExchangeView.m
//  FML
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "ExchangeView.h"
#import "SellOrBuyViewController.h"
#import "MJRefresh.h"
#import "ExchangListModel.h"
#import "FMLAlertView.h"
#import "RealNameViewController.h"
#import "BindPhoneViewController.h"
@interface ExchangeView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) UITableView*        tableView;
@property (nonatomic, strong) NSMutableArray<ExchangListModel *> *models;

@end

@implementation ExchangeView {
    ExchangeViewType    _type;
    
}

- (instancetype)initWithFrame:(CGRect)frame type:(ExchangeViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        [self setView];
        
        _models = [NSMutableArray array];

    }
    return self;
}

- (void)setView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = ColorBg;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"ExchangeTableViewCell" bundle:nil] forCellReuseIdentifier:@"id"];
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.pageNum = 0;
        [weakSelf exchangeList:weakSelf.pageNum];
    }];
    [_tableView addFooterWithCallback:^{
        if (weakSelf.pageNum == -1) {
            [(MJBaseViewController *)weakSelf.viewController showToastHUD:@"没有更多数据了"];
            [weakSelf.tableView.footer endRefreshing];
        } else {
            [weakSelf exchangeList:weakSelf.pageNum];
        }
    }];
    [self addSubview:_tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExchangeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"id" forIndexPath:indexPath];
    cell.type = _type;
    cell.exchangeHandler = ^(ExchangeViewType type) {
        [self doresuestAuth:type index:indexPath.row];
    };
    cell.model = _models[indexPath.row];
    return cell;
}
- (void)doresuestAuth:(ExchangeViewType )type index:(NSInteger )index{
    if ([UserSingle sharedUser].isAuth==3&&[[UserSingle sharedUser].email containsString:@"@"]) {
        SellOrBuyViewController *vc = [SellOrBuyViewController new];
        vc.type = type;
        vc.exchangeModel = _models[index];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }else {
        [(MJBaseViewController *)self.viewController showProgressHud];
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"user/user_info.htm".apifml method:POST args:dict];
        [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
            [(MJBaseViewController *)self.viewController hiddenProgressHud];
            if (responseMessage.errorMessage) {
                [CommonToastHUD showTips:responseMessage.errorMessage];
            } else {
                [[UserSingle sharedUser] setLoginInfo:responseMessage.bussinessData];
                if ([UserSingle sharedUser].isAuth!=3||![[UserSingle sharedUser].email containsString:@"@"]) {
                    [self showAuthAlert];
                }else {
                    SellOrBuyViewController *vc = [SellOrBuyViewController new];
                    vc.type = type;
                    vc.exchangeModel = _models[index];
                    [self.viewController.navigationController pushViewController:vc animated:YES];
                }
            }
        }];
    }
}
- (void)showAuthAlert {
    if (![[UserSingle sharedUser].email containsString:@"@"]) {
        MJBaseViewController *mjVC = (MJBaseViewController *)self.viewController;
        [mjVC showShadowViewWithColor:YES];
        FMLAlertView* alertView = [[FMLAlertView alloc] initWithTitle:@"邮箱未绑定" msg:@"为了保证您的交易正常进行，请先去绑定邮箱"];
        [alertView addBtn:@"确定" titleColor:ColorBlue action:^{
                BindPhoneViewController* vc = [BindPhoneViewController new];
                vc.isEmail = YES;
               [mjVC.navigationController pushViewController:vc animated:YES];
                [mjVC hiddenShadowView];
        }];
        [alertView addBtn:@"取消" titleColor:ColorGrayText action:^{
            [(MJBaseViewController *)self.viewController hiddenShadowView];
        }];
        [mjVC.shadowView addSubview:alertView];
        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(mjVC.shadowView);
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
    MJBaseViewController *vc = (MJBaseViewController *)self.viewController;
    [(MJBaseViewController *)self.viewController showShadowViewWithColor:YES];
    FMLAlertView* alertView = [[FMLAlertView alloc] initWithTitle:@"实名认证" msg:str];
    
    if ([UserSingle sharedUser].isAuth != 1) {
        [alertView addBtn:@"确定" titleColor:ColorBlue action:^{
            RealNameViewController* vc = [RealNameViewController new];
            vc.noPush = YES;
            [self.viewController presentViewController:vc animated:YES completion:^{
            }];
            [(MJBaseViewController *)self.viewController hiddenShadowView];
        }];
    }
    [alertView addBtn:@"取消" titleColor:ColorGrayText action:^{
        [(MJBaseViewController *)self.viewController hiddenShadowView];
    }];
    [vc.shadowView addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(vc.shadowView);
        make.width.mas_equalTo(ScreenWidth * 0.8);
    }];
}
- (void)setCurrencyId:(NSString *)currencyId {
    _currencyId = currencyId;
    _pageNum = 0;
    [self exchangeList:_pageNum];
}

- (void)exchangeList:(NSUInteger)pageNum {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"pageNum"] = @(pageNum);
    dict[@"type"] = _type == ExchangeViewTypeBuy ? @"buy" : @"sale";
    dict[@"currencyId"] = _currencyId;
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"exchangeRecord/product_list.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        
        if (responseMessage.errorMessage) {
            [(MJBaseViewController *)self.viewController showToastHUD:responseMessage.errorMessage];
        } else {
            if (pageNum == 0) {
                [_models removeAllObjects];
            }
            
            _pageNum = pageNum + 1;

            NSArray* array = [ExchangListModel arrayToModel:responseMessage.bussinessData];
            if (array.count == 0) {
                _pageNum = -1;
            }
            [_models addObjectsFromArray:[ExchangListModel arrayToModel:responseMessage.bussinessData]];
        }
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
    }];
}
@end
