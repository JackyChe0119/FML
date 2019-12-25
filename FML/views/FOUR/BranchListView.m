//
//  BranchListView.m
//  FML
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

//#import <IQKeyboardManager/IQUIView+Hierarchy.h>
#import "BranchListView.h"
#import "BranchTableViewCell.h"
#import "TeamUserModel.h"
#import "MJRefresh.h"

static NSString* const ID = @"id";

@interface BranchListView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView*         tableView;
@property (nonatomic, copy)   NSMutableArray<TeamUserModel *>* data;
@property (nonatomic, assign) int pageNum;

@end

@implementation BranchListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        self.image = [[UIImage imageNamed:@"layer"] resizableImageWithCapInsets:UIEdgeInsetsMake(17, 10, 10, 20) resizingMode:UIImageResizingModeStretch];
        _data = [NSMutableArray array];
        _pageNum = -1;
        [self setView];
    }
    return self;
}

- (void)setView {
    [self addSubview:self.tableView];
    self.frame = CGRectZero;
//    [self reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getTeamList:_pageNum];
    });
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BranchTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    TeamUserModel *model = _data[indexPath.row];
    cell.model = model;
    
    UIView* line;
    if (!line) {
        line = [[UIView alloc] initWithFrame:CGRectMake(60, 64.5, ScreenWidth - 15, 0.5f)];
        line.tag = 10001111;
        line.backgroundColor = ColorLine;
        [cell.contentView addSubview:line];
    }
    line.hidden = ((indexPath.row + 1) == _data.count);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(3, 2, self.width - 6, self.height - 5) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.scrollEnabled = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"BranchTableViewCell" bundle:nil] forCellReuseIdentifier:ID];

        __weak typeof(self) weakSelf = self;
        [_tableView addHeaderWithCallback:^{
            weakSelf.pageNum = 0;
            [weakSelf getTeamList:weakSelf.pageNum];
        }];
        [_tableView addFooterWithCallback:^{
            if (weakSelf.pageNum == -1) {
                [(MJBaseViewController *)weakSelf.viewController showToastHUD:@"没有更多数据了"];
                [weakSelf.tableView.footer endRefreshing];
            } else {
                [weakSelf getTeamList:weakSelf.pageNum];
            }
        }];
    }
    return _tableView;
}

- (void)setIsScoll:(BOOL)isScoll {
    _isScoll = isScoll;
    _tableView.scrollEnabled = _isScoll;
}

- (void)getTeamList:(int)pageNum {
    if (pageNum == -1) {
        [(MJBaseViewController *)self.viewController showProgressHud];
        _pageNum = pageNum = 0;
    }
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"pageNum"] = @(pageNum);
    NSString *urlStr = _isTeam ? @"item/item_numbers.htm" : @"item/first_layer.htm";

    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:urlStr.apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [(MJBaseViewController *)self.viewController hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [(MJBaseViewController *)self.viewController showToastHUD:responseMessage.errorMessage];
        } else {
            if (pageNum == 0) {
                [_data removeAllObjects];
            }
            _pageNum = pageNum + 1;
            NSArray* array = [TeamUserModel arrayToModel:responseMessage.bussinessData];
            if (array.count == 0) {
                _pageNum = -1;
            }
            [_data addObjectsFromArray:[TeamUserModel arrayToModel:responseMessage.bussinessData]];
            [self.tableView reloadData];
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];
            if (_reloadDataCompletion) {
                _reloadDataCompletion(self, [self.tableView numberOfRowsInSection:0]);
            }
        }
    }];
}

@end
