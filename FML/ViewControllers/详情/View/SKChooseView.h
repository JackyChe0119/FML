//
//  SKChooseView.h
//  ManggeekBaseProject
//
//  Created by 宋可 on 2017/11/20.
//  Copyright © 2017年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKChooseView : UIView
@property (nonatomic,strong) UIView *floatView;
@property (nonatomic,copy) void (^chooseBlock) (NSInteger type);

@property (nonatomic, assign) NSInteger currentIndex;
@property(nonatomic,strong) NSArray *myTitleArray;
@property (nonatomic,strong) UIColor *selectColor;//选中颜色
@property (nonatomic,strong) UIColor *unselectColor;//未选中颜色
@property (nonatomic,assign) BOOL isMore;
@property(strong,nonatomic)UIScrollView *myScrollView;

- (instancetype)initWithFrame:(CGRect)frame nameAry:(NSArray *)namrArray unselect:(UIColor *)unselectColor select:(UIColor *)selectColor More:(BOOL )isMore font:(float )font selectFont:(float )selfont isBlod:(BOOL)isB lineColor:(UIColor* )lineColor; 

- (void)changeTypeWithIndex:(NSInteger )index;
@end
