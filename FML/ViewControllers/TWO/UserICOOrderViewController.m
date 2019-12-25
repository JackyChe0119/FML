//
//  UserICOOrderViewController.m
//  FML
//
//  Created by apple on 2018/7/31.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "UserICOOrderViewController.h"
#import "ICOOrderTableViewCell.h"
#import "ICOListModel.h"
#import "MJRefresh.h"

static NSString* const ID = @"id";
@interface UserICOOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<ICOListModel *> *models;
@property (nonatomic, assign) int               pageNum;

@end

@implementation UserICOOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _models = [NSMutableArray array];
    [self layoutUI];
    _pageNum = -1;
    [self recIOC:_pageNum];

}

- (void)layoutUI {
    [self NavigationItemTitle:@"我的资产订单" Color:Color1D];
//    [self navgationRightButtonImage:@"icon_ico_order"];
    [self navgationLeftButtonImage:backUp];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = YES;
    _tableView.backgroundColor = ColorBg;
    [_tableView registerClass:[ICOOrderTableViewCell class] forCellReuseIdentifier:ID];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.pageNum = 0;
        [weakSelf recIOC:weakSelf.pageNum];
    }];
    [_tableView addFooterWithCallback:^{
        if (weakSelf.pageNum == -1) {
            [weakSelf showToastHUD:@"没有更多数据了"];
            [weakSelf.tableView.footer endRefreshing];
        } else {
            [weakSelf recIOC:weakSelf.pageNum];
        }
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICOOrderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.model = _models[indexPath.row];
    UIView* line;
    line = [cell.contentView viewWithTag:10001111];
    if (!line) {
        line = [[UIView alloc] initWithFrame:CGRectMake(20, 84.5, ScreenWidth - 15, 0.5f)];
        line.tag = 10001111;
        line.backgroundColor = ColorLine;
        [cell.contentView addSubview:line];
    }
    line.hidden = ((indexPath.row + 1) == self.models.count);
    return cell;
}
- (void)recIOC:(int)pageNum {
    if (pageNum == -1) {
        [self showProgressHud];
        _pageNum = pageNum = 0;
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"pageNum"] = @(pageNum);
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"curOrder/order_list.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            if (pageNum == 0) {
                [_models removeAllObjects];
            }
            _pageNum = pageNum + 1;
            NSArray* array = [ICOListModel arrayToModel:responseMessage.bussinessData];
            if (array.count == 0) {
                _pageNum = -1;
            }
            [_models addObjectsFromArray:[ICOListModel arrayToModel:responseMessage.bussinessData]];
            if (_models.count==0) {
                [CommonToastHUD showTips:@"暂无数据"];
                UILabel *label = [UILabel new];
                [label rect:RECT(ScreenWidth/2.0-100, 100, 200, 20) aligment:Center font:14 isBold:NO text:@"暂无资产订单记录" textColor:ColorGrayText superView:nil];
                self.tableView.backgroundView =label;
            }else {
                self.tableView.backgroundView =[UIView new];
            }
            [self.tableView reloadData];
        }
    }];
}


@end
