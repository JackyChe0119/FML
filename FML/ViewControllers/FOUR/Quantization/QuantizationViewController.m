//
//  QuantizationViewController.m
//  FML
//
//  Created by 车杰 on 2018/9/4.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "QuantizationViewController.h"
#import "QuantizationCell.h"
#import "TiXiViewController.h"
#import "RedemptionViewController.h"
@interface QuantizationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *listArray;
@end

@implementation QuantizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
    [self loadList:0 first:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)layoutUI {
    [self NavigationItemTitle:@"量化记录" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    
    _tableView = [[UITableView alloc]initWithFrame:RECT(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight-SafeAreaBottomHeight) style:0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[QuantizationCell class] forCellReuseIdentifier:@"QuantizationCell"];
    [self addRefreshHeader:_tableView];
    [self addRefreshFooter:_tableView];
    
    [self.view addSubview:_tableView];
}
- (void)refreshNewData {
    self.currentPage = 0;
    [self loadList:0 first:NO];
}
- (void)loadMoreData:(NSInteger)page {
    [self loadList:page first:NO];
}
- (void)loadList:(NSInteger)pageNum first:(BOOL)first{
    if (first) {
        [self showProgressHud];
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"pageNum"] = [NSNumber numberWithInteger:pageNum];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"fdOrder/list.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (first) {
            [self hiddenProgressHud];
        }else {
            [self endRefreshControlLoading];
        }
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            if (pageNum==0) {
                [self.listArray removeAllObjects];
            }
            NSArray *array = responseMessage.bussinessData;
            if (array.count==0) {
                [self setCurrentPageEqualTotalPage];
            }else {
                [self setCurrentPageLessTotalPage];
            }
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.listArray addObject:[obj mutableCopy]];
            }];
            if (self.listArray .count==0) {
                UILabel *label = [UILabel new];
                [label rect:RECT(ScreenWidth/2.0-100, 100, 200, 20) aligment:Center font:14 isBold:NO text:@"暂无量化基金订单" textColor:ColorGrayText superView:nil];
                self.tableView.backgroundView =label;
            }else {
                self.tableView.backgroundView =[UIView new];
            }
            [_tableView reloadData];
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuantizationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuantizationCell"];
    if (!cell) {
        cell = [[QuantizationCell alloc]initWithStyle:0 reuseIdentifier:@"QuantizationCell"];
    }
    [cell showCellWithDic:self.listArray[indexPath.row]];
    cell.operationBlock = ^(NSInteger type) {
        if (type==1) {
         //提息
            TiXiViewController *vc = [[TiXiViewController alloc]init];
            NSMutableDictionary *result = self.listArray[indexPath.row];
            vc.resultDic = result;
            vc.tixiBlock = ^{
                [result setValue:@"income" forKey:@"0"];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else if(type==2){
         // 赎回
            RedemptionViewController *vc = [[RedemptionViewController alloc]init];
            NSMutableDictionary *result = self.listArray[indexPath.row];
            vc.resultDic =result;
            vc.RedemptionBlock = ^{
                [result setValue:@"status" forKey:@"3"];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            //强制赎回
            RedemptionViewController *vc = [[RedemptionViewController alloc]init];
            NSMutableDictionary *result = self.listArray[indexPath.row];
            vc.resultDic =result;
            vc.isFocus = YES;
            vc.RedemptionBlock = ^{
                [result setValue:@"status" forKey:@"3"];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _listArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
