//
//  InterstellarViewController.m
//  FML
//
//  Created by 车杰 on 2018/9/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "InterstellarViewController.h"
#import "InterstellarListCell.h"
#import "EarningSourceViewController.h"
#import "SonNodeViewController.h"
#import "UpdateViewController.h"
#import "QRCodeViewController.h"
#import "MJRefresh.h"
#import "WebViewController.h"
@interface InterstellarViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSDictionary *resultDic;
@property (nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic,assign)BOOL isUpdate;
@end

@implementation InterstellarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getIntertellarInfo:YES];
    [self layoutUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent ;
    if (self.isUpdate) {
        self.isUpdate = NO;
        [self getIntertellarInfo:YES];
    }
}
- (void)loadListView {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"node/node_com.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            [self.listArray removeAllObjects];
            [responseMessage.bussinessData enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.listArray addObject:obj];
            }];
            if (self.listArray.count==0) {
                _tableView.tableFooterView = [self tableViewFootView];
            }else {
                _tableView.tableFooterView = [UIView createViewWithFrame:CGRectZero color:[UIColor clearColor]];
            }
            [_tableView reloadData];
        }
    }];
}
- (void)getIntertellarInfo:(BOOL)first {
    if (first) {
        [self showProgressHud];
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"node/node_head.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (first) {
            [self hiddenProgressHud];
        }else {
            [self.tableView.header endRefreshing];
        }
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            _resultDic = responseMessage.bussinessData;
            dispatch_async(dispatch_get_main_queue(), ^{
                _tableView.tableHeaderView = [self tableViewHeaderView];
            });
        }
        [self loadListView];
    }];
}
- (void)layoutUI {
    
    UIImageView *BGImageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, ScreenHeight-TabBarHeight) imageName:@"iocn_-interstellar_bg"];
    [self.view addSubview:BGImageView];
    
    UIImageView *middleImageView = [UIImageView createImageViewWithFrame:RECT(ScreenWidth/2.0-80, (ScreenHeight-TabBarHeight)/2.0-80, 160, 160) imageName:@"iocn_-interstellar"];
    [self.view addSubview:middleImageView];
    
    UILabel *titleLabel = [UILabel new];
    [titleLabel rect:RECT(60, StatusBarHeight, ScreenWidth-120, 44) aligment:Center font:17 isBold:YES text:@"星际节点" textColor:[UIColor whiteColor] superView:self.view];
    
    UIButton *_rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *rightImage = [UIImage imageNamed:@"icon_rule_top"];
    _rightButton.frame = CGRectMake(ScreenWidth-60, StatusBarHeight, 50,44);
    [_rightButton setImage:rightImage forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(navgationRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightButton];
    
    _tableView = [[UITableView alloc]initWithFrame:RECT(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight-TabBarHeight) style:0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView setSeparatorColor:[[UIColor whiteColor] colorWithAlphaComponent:.3] ];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 30, 0, 30)];
    [_tableView registerClass:[InterstellarListCell class] forCellReuseIdentifier:@"InterstellarListCell"];
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        [weakSelf getIntertellarInfo:NO];
    }];
    [self.view addSubview:_tableView];
    
}
- (void)navgationRightButtonClick {
    WebViewController *vc  = [[WebViewController alloc]init];
    vc.webTitle = @"星际节点规则";
    vc.url = @"https://www.baidu.com";
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)refreshNewData {
    [self getIntertellarInfo:NO];
}
- (UIView *)tableViewHeaderView {
    UIView *baseView = [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, 240) color:[[UIColor clearColor] colorWithAlphaComponent:0]];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[colorWithHexString(@"#182363") colorWithAlphaComponent:.5].CGColor, (__bridge id)[colorWithHexString(@"#350a4d") colorWithAlphaComponent:.5].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(20, 20, baseView.frame.size.width-40, 100);
    gradientLayer.cornerRadius = 3;
    [baseView.layer addSublayer:gradientLayer];
    
//    UIButton *messageButton = [UIButton createimageButtonWithFrame:RECT(30, 40, 20, 20) imageName:@"icon_message_white"];
//    [messageButton addTarget:self action:@selector(messageButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [baseView addSubview:messageButton];
    
    UILabel *titleLabel = [UILabel new];
    [titleLabel rect:RECT(50, 40, ScreenWidth-100, 20) aligment:Center font:13 isBold:YES text:[NSString stringWithFormat:@"%@(%@)",_resultDic[@"nickName"],_resultDic[@"levelName"]] textColor:[UIColor whiteColor] superView:baseView];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    UIButton *shareButton = [UIButton createimageButtonWithFrame:RECT(ScreenWidth-50, 40, 20, 20) imageName:@"icon_share"];
    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:shareButton];
    
    UIButton *updateButton = [UIButton createimageButtonWithFrame:RECT(ScreenWidth/2.0-45, 80, 90, 24) imageName:@""];
    [updateButton setTitle:@"立即升级" forState:UIControlStateNormal];
    [updateButton setTitleColor:colorWithHexString(@"#02357b") forState:UIControlStateNormal];
    updateButton.titleLabel.font = FONT(11);
    updateButton.layer.cornerRadius = 3;
    [updateButton setBackgroundColor:[UIColor whiteColor]];
    [updateButton addTarget:self action:@selector(updateButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:updateButton];
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.colors = @[(__bridge id)[colorWithHexString(@"#182363") colorWithAlphaComponent:.5].CGColor, (__bridge id)[colorWithHexString(@"#350a4d") colorWithAlphaComponent:.5].CGColor];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1.0, 0);
    gradientLayer2.cornerRadius  = 3;
    gradientLayer2.frame = CGRectMake(20, 130, baseView.frame.size.width-40, 100);
    [baseView.layer addSublayer:gradientLayer2];
    
    UILabel  *zijiedianLabel = [UILabel new];
    [zijiedianLabel rect:RECT(30,140,70, 30) aligment:Left font:12 isBold:YES text:@"子节点" textColor:colorWithHexString(@"#9b9b9b") superView:baseView];
    
    UILabel  *NumberLabel = [UILabel new];
    [NumberLabel rect:RECT(110,140,ScreenWidth-160, 30) aligment:Right font:12 isBold:YES text:[NSString stringWithFormat:@"%ld",[_resultDic[@"sonNodeNum"] integerValue]] textColor:[UIColor whiteColor] superView:baseView];
    
    UIImageView *accImageView = [UIImageView createImageViewWithFrame:RECT(ScreenWidth-40, 140, 10, 30) imageName:@"icon_accesstype_star"];
    accImageView.contentMode = UIViewContentModeCenter;
    [baseView addSubview:accImageView];
    
    UIView *tapView = [UIView createViewWithFrame:RECT(20, 130, ScreenWidth-40, 50) color:[UIColor clearColor]];
    tapView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [tapView addGestureRecognizer:tap];
    [baseView addSubview:tapView];
    
    UILabel  *suanLiLabel = [UILabel new];
    [suanLiLabel rect:RECT(30,190,90, 30) aligment:Left font:12 isBold:YES text:@"算力余额" textColor:colorWithHexString(@"#9b9b9b") superView:baseView];
    
    UILabel  *yuELabel = [UILabel new];
    [yuELabel rect:RECT(110,190,ScreenWidth-140, 30) aligment:Right font:12 isBold:YES text:[NSString stringWithFormat:@"%.4f FML",[_resultDic[@"fmlAmount"] doubleValue]] textColor:[UIColor whiteColor] superView:baseView];
    
    return baseView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *baseView = [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, 50) color:[[UIColor clearColor] colorWithAlphaComponent:0]];
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.colors = @[(__bridge id)[colorWithHexString(@"#182363") colorWithAlphaComponent:.5].CGColor, (__bridge id)[colorWithHexString(@"#350a4d") colorWithAlphaComponent:.5].CGColor];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1.0, 0);
    gradientLayer2.cornerRadius  = 3;
    gradientLayer2.frame = CGRectMake(20, 0, baseView.frame.size.width-40, 50);
    [baseView.layer addSublayer:gradientLayer2];
    
    UILabel  *Label = [UILabel new];
    [Label rect:RECT(30,10,90, 30) aligment:Left font:12 isBold:YES text:@"节点总收益" textColor:[UIColor whiteColor] superView:baseView];
    UIView *lineView = [UIView createViewWithFrame:RECT(30, 49.5, ScreenWidth-60, .5) color:[[UIColor whiteColor] colorWithAlphaComponent:.3]];
    [baseView addSubview:lineView];
    return baseView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InterstellarListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InterstellarListCell"];
    if (!cell) {
        cell = [[InterstellarListCell alloc]initWithStyle:0 reuseIdentifier:@"InterstellarListCell"];
    }
    NSDictionary *result = self.listArray[indexPath.row];
    if ([UserSingle sharedUser].bitArray.count!=0) {
        __block NSString *url;
        [[UserSingle sharedUser].bitArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"currencyName"] isEqualToString:result[@"currencyType"]]) {
                url = obj[@"logo"];
            }
        }];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    }
    cell.bitLabel.text = result[@"currencyType"];
    cell.priceLabel.text = [NSString stringWithFormat:@"%.4f",[result[@"releaseNum"] doubleValue]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (UIView *)tableViewFootView {
    UIView *baseView = [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, 50) color:[[UIColor clearColor] colorWithAlphaComponent:0]];
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.colors = @[(__bridge id)[colorWithHexString(@"#182363") colorWithAlphaComponent:.5].CGColor, (__bridge id)[colorWithHexString(@"#350a4d") colorWithAlphaComponent:.5].CGColor];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1.0, 0);
    gradientLayer2.cornerRadius  = 3;
    gradientLayer2.frame = CGRectMake(20, 0, baseView.frame.size.width-40, 50);
    [baseView.layer addSublayer:gradientLayer2];
    
    UILabel *tipLabel = [UILabel new];
    [tipLabel rect:RECT(0, 0, WIDTH(baseView), 50) aligment:Center font:14 isBold:YES text:@"暂无节点收益" textColor:colorWithHexString(@"#c7c7c7") superView:baseView];
    
    return baseView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EarningSourceViewController *vc = [[EarningSourceViewController alloc]init];
    NSDictionary *result = self.listArray[indexPath.row];
    vc.currencyId = [result[@"currencyId"] integerValue];
    vc.currencyType =  result[@"currencyType"];
    [self.navigationController pushViewController:vc animated:YES];
}
//- (void)messageButtonClick {
//    [self showToastHUD:@"信息"];
//}
- (void)shareButtonClick {
    QRCodeViewController *vc = [[QRCodeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)updateButtonClick {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"node/upLeve.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UpdateViewController *vc = [[UpdateViewController alloc]init];
            if ([responseMessage.bussinessData[@"flag"] integerValue]==0) {
                vc.type = 1;
            }else {
                vc.type = 2;
                self.isUpdate = YES;
            }
            vc.result = responseMessage.bussinessData;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
- (void)tapClick {
    SonNodeViewController *vc = [[SonNodeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _listArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
