//
//  EarningSourceViewController.m
//  FML
//
//  Created by 车杰 on 2018/9/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "EarningSourceViewController.h"
#import "EarningListCell.h"
#import "MJRefresh.h"
@interface EarningSourceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView,*tableView2;
@property (nonatomic,strong)UIButton *ziJieDianButton,*jiedianButton;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,assign)NSInteger type;//子节点  节点收益
@property (nonatomic,strong)NSMutableArray *listArray,*listArray2;
@property (nonatomic,assign)BOOL isloadSuccess;
@property (nonatomic,assign)NSInteger page1,page2;
@end

@implementation EarningSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page1 = 0;
    _page2 = 0;
    [self layoutUI];
    [self getIntertellarInfopageNum:0 first:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent ;
}
- (void)getIntertellarInfopageNum:(NSInteger )pageNum first:(BOOL)first {
    if (first) {
        [self showProgressHud];
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSNumber numberWithInteger:_currencyId] forKey:@"currencyId"];
    if (_type==1) {
        [dict setValue:@"sonnode" forKey:@"scene"];
    }else {
        [dict setValue:@"node" forKey:@"scene"];
    }
    [dict setValue:[NSNumber numberWithInteger:pageNum] forKey:@"pageNum"];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"commission/list.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (first) {
            [self hiddenProgressHud];
        } else {
            if (_type==1) {
                [_tableView.footer endRefreshing];
            }else {
                [_tableView2.footer endRefreshing];
            }
        }
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            if (pageNum==0) {
                if (_type==1) {
                    [self.listArray removeAllObjects];
                } else {
                    [self.listArray2 removeAllObjects];
                }
            }
            NSArray *array = responseMessage.bussinessData;
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (_type==1) {
                    [self.listArray addObject:obj];
                }else {
                    [self.listArray2 addObject:obj];
                }
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_type==1) {
                    [_tableView reloadData];
                }else {
                    [_tableView2 reloadData];
                }
            });
        }
    }];
}
- (void)layoutUI {
    
    _type = 1;
    
    UIImageView *BGImageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, ScreenHeight) imageName:@"iocn_-interstellar_bg"];
    [self.view addSubview:BGImageView];
    
    UIImageView *middleImageView = [UIImageView createImageViewWithFrame:RECT(ScreenWidth/2.0-80, (ScreenHeight)/2.0-80, 160, 160) imageName:@"iocn_-interstellar"];
    [self.view addSubview:middleImageView];
    
    UILabel *titleLabel = [UILabel new];
    [titleLabel rect:RECT(60, StatusBarHeight, ScreenWidth-120, 44) aligment:Center font:17 isBold:YES text:[NSString stringWithFormat:@"%@ 收益来源",_currencyType] textColor:[UIColor whiteColor] superView:self.view];
    
    UIButton *_leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:backUp_wihte];
    _leftButton.frame = CGRectMake(0, StatusBarHeight, 44, 44);
    [_leftButton setImage:leftImage forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(navgationLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftButton];
    
    _ziJieDianButton = [UIButton createTextButtonWithFrame:RECT(5, NavHeight, 80, 50) bgColor:[UIColor clearColor] textColor:colorWithHexString(@"#ffffff") font:13.5 bold:YES title:@"子节点"];
    _ziJieDianButton.tag = 100;
    [_ziJieDianButton addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ziJieDianButton];
    
    _jiedianButton = [UIButton createTextButtonWithFrame:RECT(85, NavHeight, 80, 50) bgColor:[UIColor clearColor] textColor:colorWithHexString(@"#c8c8c8") font:13.5 bold:YES title:@"节点收益"];
    _jiedianButton.tag = 200;
    [_jiedianButton addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_jiedianButton];
    
    _lineView = [UIView createViewWithFrame:RECT(0, 0, 60, 2) color:colorWithHexString(@"#ffffff")];
    _lineView.center = CGPointMake(_ziJieDianButton.center.x, _ziJieDianButton.center.y+15);
    [self.view addSubview:_lineView];
    
    _tableView = [[UITableView alloc]initWithFrame:RECT(0, NavHeight+50, ScreenWidth, ScreenHeight-NavHeight-50) style:0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView setSeparatorColor:[[UIColor whiteColor] colorWithAlphaComponent:.3] ];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 30, 0, 30)];
    [_tableView registerClass:[EarningListCell class] forCellReuseIdentifier:@"EarningListCell"];

    [self.view addSubview:_tableView];
    
    _tableView2 = [[UITableView alloc]initWithFrame:RECT(0, NavHeight+50, ScreenWidth, ScreenHeight-NavHeight-50) style:0];
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    _tableView2.backgroundColor = [UIColor clearColor];
    _tableView2.estimatedRowHeight = 0;
    _tableView2.estimatedSectionHeaderHeight = 0;
    _tableView2.estimatedSectionFooterHeight = 0;
    [_tableView2 setSeparatorColor:[[UIColor whiteColor] colorWithAlphaComponent:.3] ];
    [_tableView2 setSeparatorInset:UIEdgeInsetsMake(0, 30, 0, 30)];
    [_tableView2 registerClass:[EarningListCell class] forCellReuseIdentifier:@"EarningListCell"];
    _tableView2.hidden  = YES;
    [self.view addSubview:_tableView2];
    
    __weak typeof(self)weakSelf = self;
    [_tableView addFooterWithCallback:^{
        weakSelf.page1++;
        [weakSelf getIntertellarInfopageNum:weakSelf.page1 first:NO];
    }];
    
    [_tableView2 addFooterWithCallback:^{
        weakSelf.page2++;
        [weakSelf getIntertellarInfopageNum:weakSelf.page2 first:NO];

    }];
    
}
- (UIView *)tableViewHeaderView {
    UIView *baseView = [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, 70) color:[[UIColor clearColor] colorWithAlphaComponent:0]];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[colorWithHexString(@"#182363") colorWithAlphaComponent:.5].CGColor, (__bridge id)[colorWithHexString(@"#350a4d") colorWithAlphaComponent:.5].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(20, 10, baseView.frame.size.width-40, 50);
    gradientLayer.cornerRadius = 3;
    [baseView.layer addSublayer:gradientLayer];
    
    UILabel *titleLabel = [UILabel new];
    [titleLabel rect:RECT(30, 25, 100, 20) aligment:Left font:12 isBold:YES text:@"星际节点" textColor:colorWithHexString(@"#979797") superView:baseView];
    
    UILabel *numberLabel = [UILabel new];
    [numberLabel rect:RECT(ScreenWidth-120, 25, 90, 20) aligment:Right font:12 isBold:YES text:@"127" textColor:[UIColor whiteColor] superView:baseView];
    
    return baseView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView==_tableView) {
        if (self.listArray.count==0) {
            return 50;
        }
    }else {
        if (self.listArray2.count==0) {
            return 50;
        }
    }
    return .01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==_tableView) {
        return self.listArray.count;
    } else {
        return self.listArray2.count;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView==_tableView) {
        if (self.listArray.count!=0) {
            return [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, .01) color:[UIColor clearColor]];
        }
    }else {
        if (self.listArray2.count!=0) {
            return [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, .01) color:[UIColor clearColor]];
        }
    }
    UIView *baseView = [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, 50) color:[[UIColor clearColor] colorWithAlphaComponent:0]];
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.colors = @[(__bridge id)[colorWithHexString(@"#182363") colorWithAlphaComponent:.5].CGColor, (__bridge id)[colorWithHexString(@"#350a4d") colorWithAlphaComponent:.5].CGColor];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1.0, 0);
    gradientLayer2.cornerRadius  = 3;
    gradientLayer2.frame = CGRectMake(20, 0, baseView.frame.size.width-40, 50);
    [baseView.layer addSublayer:gradientLayer2];
    
    UILabel *tipLabel = [UILabel new];
    [tipLabel rect:RECT(0, 0, WIDTH(baseView), 50) aligment:Center font:14 isBold:YES text:@"暂无数据" textColor:colorWithHexString(@"#c7c7c7") superView:baseView];
    
    return baseView;
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
    [Label rect:RECT(30,10,(ScreenWidth-60)/3.0, 30) aligment:Left font:12 isBold:YES text:@"来源" textColor:colorWithHexString(@"#979797") superView:baseView];
    if (tableView==_tableView2) {
        Label.text = @"时间";
    }
    
    UILabel  *Label2 = [UILabel new];
    [Label2 rect:RECT(30+(ScreenWidth-60)/3.,10,(ScreenWidth-60)/3., 30) aligment:Center font:12 isBold:YES text:@"形式" textColor:colorWithHexString(@"#979797") superView:baseView];
    
    UILabel  *Label3 = [UILabel new];
    [Label3 rect:RECT(30+(ScreenWidth-60)/3.*2,10,(ScreenWidth-60)/3., 30) aligment:Right font:12 isBold:YES text:@"收益" textColor:colorWithHexString(@"#979797") superView:baseView];
    
    UIView *lineView = [UIView createViewWithFrame:RECT(30, 49.5, ScreenWidth-60, .5) color:[[UIColor whiteColor] colorWithAlphaComponent:.3]];
    [baseView addSubview:lineView];
    return baseView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EarningListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InterstellarListCell"];
    if (!cell) {
        cell = [[EarningListCell alloc]initWithStyle:0 reuseIdentifier:@"InterstellarListCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    if (tableView==_tableView) {
        NSDictionary *result = self.listArray[indexPath.row];
        cell.timeLabel.text = [DateUtil getDateStringFormString:result[@"createTime"] format:@"yyyy.MM.dd"];
        cell.priceLabel.frame =  RECT(30+(ScreenWidth-60)/3.0*2, 5, (ScreenWidth-60)/3.0, 20);
        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",[result[@"num"] doubleValue]];
        cell.nameLabel.text = result[@"nickName"];
        if ([result[@"type"] isEqualToString:@"ioc"]) {
            cell.typeLabel.text = @"资产优选";
        } else {
            cell.typeLabel.text = @"量化投资";
        }
    }else {
        NSDictionary *result = self.listArray2[indexPath.row];
        cell.timeLabel.hidden = YES;
        cell.priceLabel.frame =  RECT(30+(ScreenWidth-60)/3.0*2, 15, (ScreenWidth-60)/3.0, 20);
        cell.nameLabel.text = [DateUtil getDateStringFormString:result[@"createTime"] format:@"yyyy.MM.dd"];
        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",[result[@"num"] doubleValue]];
        if ([result[@"type"] isEqualToString:@"ioc"]) {
            cell.typeLabel.text = @"资产优选";
        } else {
            cell.typeLabel.text = @"量化投资";
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)navgationLeftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)chooseButtonClick:(UIButton *)sender {
    if (sender.tag==100) {
        _type = 1;
        [_ziJieDianButton setTitleColor:colorWithHexString(@"#ffffff") forState:UIControlStateNormal];
        [_jiedianButton setTitleColor:colorWithHexString(@"#c8c8c8") forState:UIControlStateNormal];
        [UIView animateWithDuration:.3 animations:^{
            _lineView.center = CGPointMake(_ziJieDianButton.center.x, _ziJieDianButton.center.y+15);
        }];
//        _tableView.tableHeaderView = [[UIView alloc]initWithFrame: CGRectZero];
        _tableView.hidden = NO;
        _tableView2.hidden = YES;
        _page1 = 0;
        [self getIntertellarInfopageNum:0 first:YES];
    }else {
        _type = 2;
        [_ziJieDianButton setTitleColor:colorWithHexString(@"#c8c8c8") forState:UIControlStateNormal];
        [_jiedianButton setTitleColor:colorWithHexString(@"#ffffff") forState:UIControlStateNormal];
        [UIView animateWithDuration:.3 animations:^{
            _lineView.center = CGPointMake(_jiedianButton.center.x, _jiedianButton.center.y+15);
        }];
//        _tableView.tableHeaderView = [self tableViewHeaderView];
        _tableView.hidden = YES;
        _tableView2.hidden = NO;
        _page2 = 2;
        [self getIntertellarInfopageNum:0 first:YES];
    }
}
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _listArray;
}
- (NSMutableArray *)listArray2 {
    if (!_listArray2) {
        _listArray2 = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _listArray2;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
