//
//  CustomBaseViewController.h
//  hehe
//
//  Created by xiaorandsnow on 15/7/27.
//  Copyright (c) 2015年 xiaorandsnow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomBaseViewController : UIViewController

{
    NSInteger _totalPages;
}
#pragma mark - Refresh Control And Request Latest Data

@property (nonatomic) BOOL isDefault;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *pageDataArr;
@property (strong, nonatomic)UILabel *labelNoData;

- (void)addRefreshHeader:(UIScrollView *)scrollView;//只在表头添加
- (void)addRefreshFooter:(UIScrollView *)scrollView;//只在表尾添加
- (void)addRefreshHeaderAndFooterView:(UIScrollView *)scrollView;//在表头和表尾都添加
- (void)addLabelNoDataToView:(UIView *)view AndText:(NSString *)str  andFrame:(CGRect)rect;
- (void)endRefreshControlLoading;
- (void)refreshNewData;
- (void)setTotalPages:(NSInteger)totalPage;
- (void)loadMoreData:(NSInteger)page;
- (void)tableViewEndRefresh:(UITableView *)currentView;
- (void)setCurrentPageLessTotalPage;
- (void)setCurrentPageEqualTotalPage;
- (void)setCurrentPageWith:(NSInteger)currentPage;
@end
