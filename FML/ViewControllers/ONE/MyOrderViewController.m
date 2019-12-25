//
//  MyOrderViewController.m
//  FML
//
//  Created by 车杰 on 2018/8/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MyOrderViewController.h"
#import "XYSliderView.h"
#import "OrderListCell.h"
#import "OrderDeatilViewController.h"
#import "OrderListModel.h"
@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)XYSliderView *sliderView;
@property (nonatomic,strong)UIButton *allButton,*waitPayButton,*compelteButton;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic,assign)BOOL needRefresh;//需要刷新数据
@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = RGB_A(248, 248, 248, 1);
    [self NavigationItemTitle:@"我的订单" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    [self.view addSubview:self.sliderView];
    _status = 1;
    _type = @"buy";
    [self addTopButton];
    [self addTableView];
    [self doRequestWithPage:0 type:_type first:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderStatusChangeSuccessful) name:@"orderStatusChangeSuccessful" object:nil];
    
}
- (void)orderStatusChangeSuccessful {
    _needRefresh = YES;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_needRefresh) {
        _needRefresh = YES;
        self.currentPage = 0;
        [self doRequestWithPage:0 type:self.type first:YES];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
- (void)doRequestWithPage:(NSInteger)page type:(NSString *)type first:(BOOL)first{
    if (first) {
        [self showProgressHud];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    [params setValue:[NSNumber numberWithInteger:_status] forKey:@"status"];
    [params setValue:[NSNumber numberWithInteger:page] forKey:@"pageNum"];
    [params setObject:type forKey:@"type"];
    if (_currencyId) {
        [params setValue:[NSNumber numberWithInteger:[_currencyId integerValue]] forKey:@"exchangeId"];
    }
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"exchangeRecord/exchange_list.htm".apifml method:POST args:params];
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
                OrderListModel *model = [[OrderListModel alloc]initWithDictionary:obj];
                [self.listArray addObject:model];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.listArray.count==0) {
                    [CommonToastHUD showTips:@"暂无数据"];
                    UILabel *label = [UILabel new];
                    [label rect:RECT(ScreenWidth/2.0-100, 100, 200, 20) aligment:Center font:14 isBold:NO text:@"暂无订单数据" textColor:ColorGrayText superView:nil];
                    self.tableView.backgroundView =label;
                }else {
                    self.tableView.backgroundView =[UIView new];
                }
                [_tableView reloadData];
            });
        }
    }];
}
- (XYSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[XYSliderView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, 45)];
        _sliderView.backgroundColor = ColorWhite;
        __weak typeof(self)weakSelf = self;
        _sliderView.currentClickIndex = ^(NSUInteger currentIndex) {
            if (currentIndex==1) {
                _type = @"sale";
            }else {
                _type = @"buy";
            }
            weakSelf.currentPage = 0;
            [weakSelf doRequestWithPage:0 type:weakSelf.type first:YES];
        };
        [self.view addSubview:_sliderView];
        
        XYSliderModel* model = [XYSliderModel new];
        model.titles = @[@"购买", @"出售"];
        model.selColor = Color1D;
        model.unSelColor = ColorGrayText;
        model.lineColor = Color1D;
        model.itemBottomOffset = 13;
        model.viewType = XYSliderViewTypeDivideWindow;
        model.offsetTopTitle = 13;
//        model.bottomScrollView = self.scrollView;
        
        model.lineAdaptOffsetWidth = 5;
        _sliderView.typeModel = model;
        
    }
    return _sliderView;
}
- (void)addTopButton {
    _allButton = [UIButton createCommonButtonWithFrame:RECT(15, GETY(self.sliderView.frame)+15, (ScreenWidth-60)/3.0, 30) title:@"全部"];
    _allButton.tag = 100;
    [_allButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _allButton.titleLabel.font = FONT(13);
    _allButton.layer.cornerRadius = 4;
    [_allButton setBackgroundColor:ColorBlue];
    _allButton.layer.borderColor = ColorBlue.CGColor;
    [_allButton addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_allButton];
    
    _waitPayButton = [UIButton createCommonButtonWithFrame:RECT(30+(ScreenWidth-60)/3.0, GETY(self.sliderView.frame)+15, (ScreenWidth-60)/3.0, 30) title:@"未完成"];
    _waitPayButton.tag = 200;
    [_waitPayButton setBackgroundColor:colorWithHexString(@"#f8f8f8")];
    _waitPayButton.titleLabel.font = FONT(13);
    _waitPayButton.layer.cornerRadius = 4;
    [_waitPayButton addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _waitPayButton.layer.borderColor = colorWithHexString(@"#b8bbcc").CGColor;
    [_waitPayButton setTitleColor:colorWithHexString(@"#b8bbcc") forState:UIControlStateNormal];
    [self.view addSubview:_waitPayButton];
    
    _compelteButton = [UIButton createCommonButtonWithFrame:RECT(45+(ScreenWidth-60)/3.0*2, GETY(self.sliderView.frame)+15, (ScreenWidth-60)/3.0, 30) title:@"已完成"];
    _compelteButton.tag = 300;
    [_compelteButton addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_compelteButton setBackgroundColor:colorWithHexString(@"#f8f8f8")];
    _compelteButton.titleLabel.font = FONT(13);
    _compelteButton.layer.cornerRadius = 4;
    _compelteButton.layer.borderColor = colorWithHexString(@"#b8bbcc").CGColor;
    [_compelteButton setTitleColor:colorWithHexString(@"#b8bbcc") forState:UIControlStateNormal];
    [self.view addSubview:_compelteButton];
}
- (void)addTableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:RECT(0, GETY(_compelteButton.frame)+15, ScreenWidth, ScreenHeight-GETY(_compelteButton.frame)-15-SafeAreaBottomHeight) style:0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"OrderListCell" bundle:nil] forCellReuseIdentifier:@"OrderListCell"];
        _tableView.backgroundColor = ColorBg;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [self addRefreshHeader:_tableView];
        [self addRefreshFooter:_tableView];
        [self.view addSubview:_tableView];
    }
}
- (void)refreshNewData {
    self.currentPage = 0;
    [self doRequestWithPage:self.currentPage type:self.type first:NO];
}
- (void)loadMoreData:(NSInteger)page {
    self.currentPage++;
    [self doRequestWithPage:page type:self.type first:NO];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListModel *model = self.listArray[indexPath.row];
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListCell"];
    [cell showCellWithModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDeatilViewController *vc = [[OrderDeatilViewController alloc]init];
    OrderListModel *model = self.listArray[indexPath.row];
    vc.orderId = model.Id;
    UINavigationController *nav= [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)typeButtonClick:(UIButton *)sender {
    if (sender.tag==100) {
        [_allButton setBackgroundColor:ColorBlue];
        _allButton.layer.borderColor = ColorBlue.CGColor;
        [_allButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_waitPayButton setBackgroundColor:colorWithHexString(@"#f8f8f8")];
        _waitPayButton.layer.borderColor = colorWithHexString(@"#b8bbcc").CGColor;
        [_waitPayButton setTitleColor:colorWithHexString(@"#b8bbcc") forState:UIControlStateNormal];
        [_compelteButton setBackgroundColor:colorWithHexString(@"#f8f8f8")];
        _compelteButton.layer.borderColor = colorWithHexString(@"#b8bbcc").CGColor;
        [_compelteButton setTitleColor:colorWithHexString(@"#b8bbcc") forState:UIControlStateNormal];
        _status = 1;
        
    }else if (sender.tag==200) {
        [_waitPayButton setBackgroundColor:ColorBlue];
        _waitPayButton.layer.borderColor = ColorBlue.CGColor;
        [_waitPayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_allButton setBackgroundColor:colorWithHexString(@"#f8f8f8")];
        _allButton.layer.borderColor = colorWithHexString(@"#b8bbcc").CGColor;
        [_allButton setTitleColor:colorWithHexString(@"#b8bbcc") forState:UIControlStateNormal];
        
        [_compelteButton setBackgroundColor:colorWithHexString(@"#f8f8f8")];
        _compelteButton.layer.borderColor = colorWithHexString(@"#b8bbcc").CGColor;
        [_compelteButton setTitleColor:colorWithHexString(@"#b8bbcc") forState:UIControlStateNormal];
        _status = 2;
    }else {
        [_compelteButton setBackgroundColor:ColorBlue];
        _compelteButton.layer.borderColor = ColorBlue.CGColor;
        [_compelteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_allButton setBackgroundColor:colorWithHexString(@"#f8f8f8")];
        _allButton.layer.borderColor = colorWithHexString(@"#b8bbcc").CGColor;
        [_allButton setTitleColor:colorWithHexString(@"#b8bbcc") forState:UIControlStateNormal];
        [_waitPayButton setBackgroundColor:colorWithHexString(@"#f8f8f8")];
        _waitPayButton.layer.borderColor = colorWithHexString(@"#b8bbcc").CGColor;
        [_waitPayButton setTitleColor:colorWithHexString(@"#b8bbcc") forState:UIControlStateNormal];
        _status = 3;
    }
    self.currentPage = 0;
    [self doRequestWithPage:0 type:_type first:YES];
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
