//
//  SKChooseView.m
//  ManggeekBaseProject
//
//  Created by 宋可 on 2017/11/20.
//  Copyright © 2017年 Jacky. All rights reserved.
//

#import "SKChooseView.h"

@interface SKChooseView()
//滚动视图

//滚动下划线
@property(strong,nonatomic)UIView *line;
//所有的Button集合
@property(nonatomic,strong)NSMutableArray  *items;
//所有的Button的宽度集合
@property(nonatomic,copy)NSArray *itemsWidth;
//被选中前面的宽度合（用于计算是否进行超过一屏，没有一屏则进行平分）
@property(nonatomic,assign)CGFloat selectedTitlesWidth;
@property (nonatomic,strong) UIButton *lastbutton;
@property (nonatomic,strong) NSMutableArray *floatwidth;
@property (nonatomic,assign) float font;
@property (nonatomic,assign) float selfont;
@property (nonatomic,assign) BOOL isB;
@property (nonatomic,strong) UIColor *lineColor;
@end
@implementation SKChooseView

- (instancetype)initWithFrame:(CGRect)frame nameAry:(NSArray *)namrArray unselect:(UIColor *)unselectColor select:(UIColor *)selectColor More:(BOOL )isMore font:(float )font selectFont:(float )selfont isBlod:(BOOL)isB lineColor:(UIColor* )lineColor{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentIndex = 0;
        _isB = isB;
        _font = font;
        _selfont = selfont;
        _isMore = isMore;
        _lineColor = lineColor;
        self.unselectColor = unselectColor;
        self.selectColor = selectColor;
        //初始化数组
        if (!self.myTitleArray) {
            self.myTitleArray = namrArray;
        }
        
        self.items=[[NSMutableArray alloc]init];
        self.itemsWidth=[[NSArray alloc]init];
        
        //初始化滚动
        if (!self.myScrollView) {
            self.myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width , self.frame.size.height)];
            self.myScrollView.backgroundColor = [UIColor whiteColor];
            self.myScrollView.showsHorizontalScrollIndicator = NO;
            self.myScrollView.showsVerticalScrollIndicator = NO;
            if (@available(iOS 11.0, *)) {
                self.myScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                // Fallback on earlier versions
            }
            [self addSubview:self.myScrollView];
        }
        
        //赋值跟计算滚动
        _itemsWidth = [self getButtonsWidthWithTitles:self.myTitleArray];
        CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
        self.myScrollView.contentSize = CGSizeMake(contentWidth, 0);
        
        self.currentIndex=0;
    }
    return self;
}

/**
 *  @author wujunyang, 16-01-22 13:01:45
 *
 *  @brief  计算宽度
 *

 */
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    
    NSMutableArray *widths = [@[] mutableCopy];
    _floatwidth = [@[] mutableCopy];
    _selectedTitlesWidth = 0;
    for (NSString *title in titles)
    {
        CGSize size = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:_font]} context:nil].size;
        CGFloat eachButtonWidth = size.width + 50.f;
        CGFloat eachfloatWidth = size.width - 6.0f;
        
        NSNumber *width = [NSNumber numberWithFloat:eachButtonWidth];
        [widths addObject:width];
        if (title.length < 2) {
            eachfloatWidth = 12;
        }
        if (title.length < 4) {
            eachButtonWidth = 50;
        }
        _selectedTitlesWidth += eachButtonWidth;
        [_floatwidth addObject:[NSNumber numberWithFloat:eachfloatWidth]];
    }
    if (_selectedTitlesWidth < self.frame.size.width) {
        [widths removeAllObjects];
        NSNumber *width = [NSNumber numberWithFloat:self.frame.size.width / titles.count];
        for (int index = 0; index < titles.count; index++) {
            [widths addObject:width];
        }
    }
    return widths;
}
/**
 *  @author wujunyang, 16-01-22 13:01:14
 *
 *  @brief  初始化Button
 *

 */
- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    if (_isMore) {
        CGFloat buttonX = 0;
        for (NSInteger index = 0; index < widths.count; index++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat three = 0;
            if (index<3) {
                button.frame = CGRectMake(buttonX, 0, [widths[index] floatValue], self.frame.size.height);
                three += [widths[index] floatValue];
            }else{
                button.frame = CGRectMake(buttonX-three, 0, [widths[index] floatValue], self.frame.size.height);
            }
            if (_isB) {
                button.titleLabel.font = [UIFont boldSystemFontOfSize:_font];
            }else{
                button.titleLabel.font = [UIFont systemFontOfSize:_font];
            }
            button.tag = index +100;
            button.backgroundColor = [UIColor clearColor];
            [button setTitle:self.myTitleArray[index] forState:UIControlStateNormal];
            [button setTitleColor:self.unselectColor forState:UIControlStateNormal];
            [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.myScrollView addSubview:button];
            if (index == 0) {
                _lastbutton = button;
                [button setTitleColor:self.selectColor forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont boldSystemFontOfSize:_font];
            }
            [_items addObject:button];
            buttonX += [widths[index] floatValue];
            if (widths.count) {
                [self showLineWithButtonWidth:[widths[0] floatValue]floatWidth:[_floatwidth[0]floatValue]];
            }
            return buttonX;
        }
    }else{
        CGFloat buttonX = 0;
        for (NSInteger index = 0; index < widths.count; index++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(buttonX, 0, [widths[index] floatValue], self.frame.size.height);
            if (_isB) {
                button.titleLabel.font = [UIFont boldSystemFontOfSize:_font];
            }else{
                button.titleLabel.font = [UIFont systemFontOfSize:_font];
            }
            button.tag = index +100;
            button.backgroundColor = [UIColor clearColor];
            [button setTitle:self.myTitleArray[index] forState:UIControlStateNormal];
            [button setTitleColor:self.unselectColor forState:UIControlStateNormal];
            [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.myScrollView addSubview:button];
            if (index == 0) {
                _lastbutton = button;
                [button setTitleColor:self.selectColor forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont boldSystemFontOfSize:_selfont];
            }
            [_items addObject:button];
            buttonX += [widths[index] floatValue];
        }
        if (widths.count) {
            [self showLineWithButtonWidth:[widths[0] floatValue]floatWidth:[_floatwidth[0]floatValue]];
        }
        return buttonX;
    }
    return 2;
}
/**
 *  @author wujunyang, 16-01-22 13:01:33
 *
 *  @brief  选中
 *
 *  @param currentIndex 选中索引
 *
 
 */
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    UIButton *button = nil;
    button = _items[currentIndex];
//    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    CGFloat offsetX = button.center.x - WIDTH(self) * 0.5;
    CGFloat offsetMax = _selectedTitlesWidth - WIDTH(self);
    if (offsetX < 0 || offsetMax < 0) {
        offsetX = 0;
    } else if (offsetX > offsetMax){
        offsetX = offsetMax;
    }
    [self.myScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    [UIView animateWithDuration:.2f animations:^{
        
        _line.frame = CGRectMake(button.center.x - [_floatwidth[currentIndex] floatValue]/2.0 - 15, _line.frame.origin.y, [_floatwidth[currentIndex] floatValue] + 30, _line.frame.size.height);
    }];
}

/**
 *  @author wujunyang, 16-01-22 13:01:47
 *
 *  @brief  增加下划线
 *
 *  @param width Button的宽
 *
 
 */
- (void)showLineWithButtonWidth:(CGFloat)width floatWidth:(CGFloat)floatwidth
{

    _line = [[UIView alloc] initWithFrame:CGRectMake(width - 30, self.frame.size.height/2 - 12.5f, width - 30, 25.0f)];
    _line.backgroundColor = _lineColor;
    _line.layer.cornerRadius = 2;
    _line.layer.masksToBounds = YES;

    [self.myScrollView addSubview:_line];
    [self.myScrollView sendSubviewToBack:_line];
}

- (void)cleanData
{
    [_items removeAllObjects];
    [self.myScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

/**
 *  @author wujunyang, 16-01-22 11:01:27
 *
 *  @brief  选中时的事件
 *

 */
- (void)itemPressed:(UIButton *)button
{
    NSInteger index = [_items indexOfObject:button];
    self.currentIndex = index;

    if (_lastbutton == button) {
        return;
    }else{
        [_lastbutton setTitleColor:self.unselectColor forState:UIControlStateNormal];
        _lastbutton.titleLabel.font = [UIFont systemFontOfSize:_font];
        [button setTitleColor:self.selectColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:_selfont];
        _lastbutton = button;
        if (_chooseBlock) {
            _chooseBlock (button.tag);
        }
    }
    
    
    
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            button.transform = CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)changeTypeWithIndex:(NSInteger )index{
    self.currentIndex = index-100;
    UIButton *button = [self.myScrollView viewWithTag:index];
    if (_lastbutton == button) {
        return;
    }else{
        [_lastbutton setTitleColor:self.unselectColor forState:UIControlStateNormal];
        _lastbutton.titleLabel.font = [UIFont systemFontOfSize:_font];
        [button setTitleColor:self.selectColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:_font];
        _lastbutton = button;
//        if (_chooseBlock) {
//            _chooseBlock (button.tag);
//        }
    }
    [UIView animateWithDuration:.2f animations:^{
        if ([_floatwidth[index-100] floatValue]/2.0 < 6.1) {
            _line.frame = CGRectMake(button.center.x - [_floatwidth[index-100] floatValue]/2.0, _line.frame.origin.y, [_floatwidth[index-100] floatValue] + 20, 1.5);
        } else {
            _line.frame = CGRectMake(button.center.x - [_floatwidth[index-100] floatValue]/2.0, _line.frame.origin.y, [_floatwidth[index-100] floatValue] + 20, _line.frame.size.height);
        }
        
    }];
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            button.transform = CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            
        }];
    }];
}




@end
