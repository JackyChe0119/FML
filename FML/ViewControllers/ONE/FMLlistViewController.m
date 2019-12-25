//
//  FMLlistViewController.m
//  FML
//
//  Created by 车杰 on 2018/9/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "FMLlistViewController.h"
#import "FMLListCell.h"
@interface FMLlistViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *changeingButton,*changedButton;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,copy)NSString *status;
@end

@implementation FMLlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navgationLeftButtonImage:backUp];
    [self NavigationItemTitle:@"交易记录" Color:Color1D];
    [self layoutUI];
    _status = @"0";
    [self doRequestWithpage:0 first:YES];
}
- (void)doRequestWithpage:(NSInteger)page first:(BOOL)first {
    if (first) {
        [self showProgressHud];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    [params setValue:_status forKey:@"status"];
    [params setValue:[NSNumber numberWithInteger:page] forKey:@"pageNum"];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"exchangeRecord/fml_exchangges.htm".apifml method:POST args:params];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (first) {
            [self hiddenProgressHud];
        }else {
            [self endRefreshControlLoading];
        }
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            if (page==0) {
                [self.listArray removeAllObjects];
            }
            NSArray *array = responseMessage.bussinessData;
            if (array.count>0) {
                [self setCurrentPageLessTotalPage];
            }else {
                [self setCurrentPageEqualTotalPage];
            }
            [responseMessage.bussinessData enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.listArray addObject:obj];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.listArray.count==0) {
                    [CommonToastHUD showTips:@"暂无数据"];
                    UILabel *label = [UILabel new];
                    [label rect:RECT(ScreenWidth/2.0-100, 100, 200, 20) aligment:Center font:14 isBold:NO text:@"暂无兑换数据" textColor:ColorGrayText superView:nil];
                    self.tableView.backgroundView =label;
                }else {
                    self.tableView.backgroundView =[UIView new];
                }
                [_tableView reloadData];
            });
        }
    }];
}
- (void)layoutUI {
    
    UIView *topView = [UIView createViewWithFrame:RECT(0, NavHeight, ScreenWidth, 50) color:[UIColor whiteColor]];
    [self.view addSubview:topView];
    
    _changeingButton = [UIButton createTextButtonWithFrame:RECT(0, 0, ScreenWidth/2.0, 50) bgColor:[UIColor clearColor] textColor:colorWithHexString(@"#232652") font:13.5 bold:YES title:@"交易中"];
    _changeingButton.tag = 100;
    [_changeingButton addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_changeingButton];
    
    _changedButton = [UIButton createTextButtonWithFrame:RECT(ScreenWidth/2.0, 0, ScreenWidth/2.0, 50) bgColor:[UIColor clearColor] textColor:colorWithHexString(@"#c8c8c8") font:13.5 bold:YES title:@"已完成"];
    _changedButton.tag = 200;
    [_changedButton addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_changedButton];
    
    _lineView = [UIView createViewWithFrame:RECT(0, 0, 25, 2) color:colorWithHexString(@"#232652")];
    _lineView.center = CGPointMake(_changeingButton.center.x, _changeingButton.center.y+23);
    [topView addSubview:_lineView];
    
    self.view.backgroundColor = ColorBg;
    
    _tableView = [[UITableView alloc]initWithFrame:RECT(0, NavHeight+50, ScreenWidth, ScreenHeight-NavHeight-SafeAreaBottomHeight-50) style:0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alwaysBounceVertical = YES;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = ColorBg;
    [_tableView setSeparatorStyle:0];
    [_tableView registerClass:[FMLListCell class] forCellReuseIdentifier:@"FMLListCell"];
    [self addRefreshHeaderAndFooterView:_tableView];
    [self.view addSubview:_tableView];
}
- (void)refreshNewData {
    self.currentPage = 0;
    [self doRequestWithpage:0 first:NO];
}
- (void)loadMoreData:(NSInteger)page {
    [self doRequestWithpage:page first:NO];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return  130;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMLListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FMLListCell"];
    NSDictionary *result = self.listArray[indexPath.row];
    cell.label1.text = [NSString stringWithFormat:@"发起币种%@",result[@"currencyType"]];
    cell.label2.text = [NSString stringWithFormat:@"%.2f",[result[@"total"] doubleValue]];
    cell.label5.text = [NSString stringWithFormat:@"获得币种%@",result[@"targetCurrencyType"]];
    cell.label6.text = [NSString stringWithFormat:@"%.2f",[result[@"num"] doubleValue]];
//    if ([result[@"status"] integerValue]==0) {
//        cell.label4.text = @"等待后台确定";
//        cell.label4.textColor = colorWithHexString(@"#646464");
//    }else if ([result[@"status"] integerValue]==-1) {
//        cell.label4.text = @"已拒绝";
//        cell.label4.textColor = [UIColor redColor];
//    }else {
//        cell.label4.text = @"已完成";
//        cell.label4.textColor = [UIColor blueColor];
//    }
    cell.label4.text = [NSString stringWithFormat:@"%.2f",[result[@"targetRatePrice"] doubleValue]/[result[@"fmlRatePrice"] doubleValue]];
    cell.label8.text = [DateUtil getDateStringFormString:result[@"createTime"] format:@"yyyy.MM.dd HH:mm:ss"];
    return cell;
}
- (void)chooseButtonClick:(UIButton *)sender {
    if (sender.tag==100) {
        [_changeingButton setTitleColor:colorWithHexString(@"#232652") forState:UIControlStateNormal];
        [_changedButton setTitleColor:colorWithHexString(@"#c8c8c8") forState:UIControlStateNormal];
        [UIView animateWithDuration:.3 animations:^{
            _lineView.center = CGPointMake(_changeingButton.center.x, _changeingButton.center.y+23);
        }];
        _status = @"0";
        
    }else {
        [_changeingButton setTitleColor:colorWithHexString(@"#c8c8c8") forState:UIControlStateNormal];
        [_changedButton setTitleColor:colorWithHexString(@"#232652") forState:UIControlStateNormal];
        [UIView animateWithDuration:.3 animations:^{
            _lineView.center = CGPointMake(_changedButton.center.x, _changedButton.center.y+23);
        }];
        _status = @"1";
    }
    self.currentPage = 0;
    [self doRequestWithpage:0 first:YES];
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
