//
//  baseTwoViewController.m
//  ManggeekBaseProject
//
//  Created by 车杰 on 2017/12/20.
//  Copyright © 2017年 Jacky. All rights reserved.
//

#import "baseTwoViewController.h"
#import "touZiListCell.h"
#import "allAssetViewController.h"
#import "touZiTopView.h"
#import "UserICOViewController.h"
#import "CurrencyDetailViewController.h"
#import "InvestModel.h"
#import "UserICOOrderViewController.h"
#import "MJRefresh.h"
#import "QuantizationListCell.h"
#import "QuantizationDetailViewController.h"
#import "QuantizationViewController.h"
@interface baseTwoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UITableView *tableView2;
@property (nonatomic, strong) NSArray<InvestModel *>*   models;
@property (nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic,strong)UIButton *ICOButton,*liangHuaButton;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,assign)BOOL isIco;
@end

@implementation baseTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
    [self liangHuaList:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UserSingle sharedUser] login];
}
- (void)layoutUI {
    [self NavigationItemTitle:@"投资" Color:Color1D];
    [self navgationRightButtonImage:@"icon_zichan_right"];
    
    self.view.backgroundColor = ColorBg;
    
    _ICOButton = [UIButton createTextButtonWithFrame:RECT(5, NavHeight, 80, 50) bgColor:[UIColor clearColor] textColor:colorWithHexString(@"#232652") font:13.5 bold:YES title:@"量化投资"];
    _ICOButton.tag = 100;
    [_ICOButton addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ICOButton];
    
    _liangHuaButton = [UIButton createTextButtonWithFrame:RECT(85, NavHeight, 80, 50) bgColor:[UIColor clearColor] textColor:colorWithHexString(@"#c8c8c8") font:13.5 bold:YES title:@"资产优选"];
    _liangHuaButton.tag = 200;
    [_liangHuaButton addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_liangHuaButton];
    
    _lineView = [UIView createViewWithFrame:RECT(0, 0, 60, 2) color:colorWithHexString(@"#232652")];
    _lineView.center = CGPointMake(_ICOButton.center.x, _ICOButton.center.y+15);
    [self.view addSubview:_lineView];
    
    
    _tableView = [[UITableView alloc]initWithFrame:RECT(0, NavHeight+50, ScreenWidth, ScreenHeight-NavHeight-TabBarHeight-50) style:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = YES;
    _tableView.backgroundColor = ColorBg;
    [_tableView registerClass:[QuantizationListCell class] forCellReuseIdentifier:@"QuantizationListCell"];    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _tableView2 = [[UITableView alloc]initWithFrame:RECT(0, NavHeight+50, ScreenWidth, ScreenHeight-NavHeight-TabBarHeight-50) style:1];
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    _tableView2.bounces = YES;
    _tableView2.backgroundColor = ColorBg;
    [_tableView2 registerNib:[UINib nibWithNibName:@"touZiListCell" bundle:nil] forCellReuseIdentifier:@"touZiListCell"];
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView2.estimatedSectionFooterHeight = 0;
    _tableView2.estimatedSectionHeaderHeight = 0;
    _tableView2.hidden = YES;
    [self.view addSubview:_tableView2];

    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        [weakSelf liangHuaList:NO];
    }];
    
    [_tableView2 addHeaderWithCallback:^{
        [weakSelf recIOC:NO];

    }];
}
- (void)chooseButtonClick:(UIButton *)sender {
    if (sender.tag==100) {
        [_ICOButton setTitleColor:colorWithHexString(@"#232652") forState:UIControlStateNormal];
        [_liangHuaButton setTitleColor:colorWithHexString(@"#c8c8c8") forState:UIControlStateNormal];
        [UIView animateWithDuration:.3 animations:^{
            _lineView.center = CGPointMake(_ICOButton.center.x, _ICOButton.center.y+15);
        }];
        _tableView.hidden = NO;
        _tableView2.hidden = YES;
        _isIco = NO;
        [self liangHuaList:YES];

    }else {

        [_ICOButton setTitleColor:colorWithHexString(@"#c8c8c8") forState:UIControlStateNormal];
        [_liangHuaButton setTitleColor:colorWithHexString(@"#232652") forState:UIControlStateNormal];
        [UIView animateWithDuration:.3 animations:^{
            _lineView.center = CGPointMake(_liangHuaButton.center.x, _liangHuaButton.center.y+15);
        }];
        _tableView.hidden = YES;
        _tableView2.hidden = NO;
        _isIco = YES;
        [self recIOC:YES];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView2) {
        return _models.count;
    }else {
        return self.listArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_tableView2) {
        return 145;
    }
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_tableView2) {
        touZiListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"touZiListCell"];
        cell.model = _models[indexPath.row];
        return cell;
    }else {
        QuantizationListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuantizationListCell"];
        if (!cell) {
            cell = [[QuantizationListCell alloc]initWithStyle:0 reuseIdentifier:@"QuantizationListCell"];
        }
        [cell showCellWithDic:self.listArray[indexPath.row]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_tableView2) {
        CurrencyDetailViewController* vc = [CurrencyDetailViewController new];
        vc.icoId = _models[indexPath.row].icoId;
        vc.currencyName = _models[indexPath.row].currenctyName;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        QuantizationDetailViewController *vc = [[QuantizationDetailViewController alloc]init];
        vc.resultDic = self.listArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 相关事件处理
//ico资产优选
- (void)Quantization {
    QuantizationViewController *vc = [[QuantizationViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)lookICO {
    UserICOOrderViewController* vc = [UserICOOrderViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)navgationRightButtonClick {
    if (self.isIco) {
        [self lookICO];
    }else {
        [self Quantization];
    }
}
- (void)recIOC:(BOOL)first {
    if (first) {
        [self showProgressHud];
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"currency_invest/top_list.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (first) {
            [self hiddenProgressHud];
        }else {
            [self.tableView2.header endRefreshing];
        }
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            _models = [InvestModel arrayToModel:responseMessage.bussinessData];
            [self.tableView2 reloadData];
        }
    }];
}
- (void)liangHuaList:(BOOL)first {
    if (first) {
        [self showProgressHud];
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"fdfund/fund_list.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (first) {
            [self hiddenProgressHud];
        }else {
            [self.tableView.header endRefreshing];
        }
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            [self.listArray removeAllObjects];
            [responseMessage.bussinessData enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.listArray addObject:obj];
            }];
            [_tableView reloadData];
        }
    }];
}
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _listArray;
}
@end
