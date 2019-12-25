//
//  CurrencyIncomeViewController.m
//  FML
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "CurrencyIncomeViewController.h"
#import "IncomeTopView.h"
#import "IncomeModel.h"
#import "MJRefresh.h"
#import "ICOListModel.h"
#import "TimeTableViewCell.h"

static NSString* const ID = @"id";
@interface CurrencyIncomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) IncomeTopView*    topView;
@property (nonatomic, strong) NSMutableArray<ICOListModel *>*   models;
@property (nonatomic, assign) int               pageNum;


@end

@implementation CurrencyIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    _models = [NSMutableArray array];
    _pageNum = -1;
    [self mybranch:_pageNum];
}

- (void)setUI {
    
    _topView = [[IncomeTopView alloc] initWithFrame:CGRectZero];
    _topView.currencyName.text = _model.currencyName;
    _topView.titleLabel.text = _model.currencyName;
    _topView.currencyNum.text = [NSString stringWithFormat:@"数量%.2f个", _model.lockNumber];
    [_topView.currencyIcon sd_setImageWithURL:_model.logo.toUrl];
    [_topView.leftButton addTarget:self action:@selector(navgationLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_topView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, BOTTOM(_topView), ScreenWidth, ScreenHeight - BOTTOM(_topView)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = YES;
    _tableView.backgroundColor = ColorBg;
    _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"TimeTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    [self.view addSubview:_tableView];
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.pageNum = 0;
        [weakSelf mybranch:weakSelf.pageNum];
    }];
    [_tableView addFooterWithCallback:^{
        if (weakSelf.pageNum == -1) {
            [weakSelf showToastHUD:@"没有更多数据了"];
            [weakSelf.tableView.footer endRefreshing];
        } else {
            [weakSelf mybranch:weakSelf.pageNum];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    ICOListModel* model = _models[indexPath.row];
    if (indexPath.row == 0) {
        model.isShowTop = NO;
    } else {
        model.isShowTop = YES;
    }
    if ((indexPath.row + 1) == self.models.count) {
        model.isShowBottom = NO;
    } else {
        model.isShowBottom = YES;
    }
    cell.model = model;
    
    UIView* line;
    line = [cell.contentView viewWithTag:10001111];
    if (!line) {
        line = [[UIView alloc] initWithFrame:CGRectMake(45, 54.5, ScreenWidth - 15, 0.5f)];
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

- (void)mybranch:(int)pageNum {
    if (pageNum == -1) {
        [self showProgressHud];
        _pageNum = pageNum = 0;
    }
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"pageNum"] = @(pageNum);
    dict[@"currencyId"] = @(_model.currencyId);
    
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"curOrder/order_list.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            if (pageNum == 0) {
                [_models removeAllObjects];
            }
            
            _pageNum = pageNum + 1;
            //            _pageNum = (pageNum + 1 < responseMessage.totalPage) ? pageNum + 1 : -1;
            //            if (_pageNum == -1) {
            //            }
            NSArray* array = [ICOListModel arrayToModel:responseMessage.bussinessData];
            if (array.count == 0) {
                _pageNum = -1;
            }
            [_models addObjectsFromArray:[ICOListModel arrayToModel:responseMessage.bussinessData]];
            [self.tableView reloadData];
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];
        }
    }];
}

@end
