//
//  XYSliderView.m
//  Extension
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "XYSliderView.h"

@implementation XYSliderModel

- (instancetype)init {
    if (self = [super init]) {
        _lineColor = [UIColor redColor];
    
        _cornerRadius = 1.5;
        _lineHeight = 3;
        _lineType = XYSliderLineTypeBottom;
        _lineAdaptOffsetWidth = 0;
        
        _selColor = [UIColor redColor];
        _unSelColor = [UIColor blackColor];
        
        _selFont = [UIFont systemFontOfSize:16];
        _unSelFont = [UIFont systemFontOfSize:16];
        
        _titles = @[];

        _isScrollEnabled = YES;
        
        _itemBottomOffset = 10;
        
        _animateWithDuration = .3f;
        
        _offsetTopTitle = 4;
        
    }
    return self;
}

@end



@interface XYSliderView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray<UILabel *>*   items;
@property (nonatomic, strong) NSMutableArray<NSValue *>*   sizes;
@property (nonatomic, strong) UILabel*          lastLabel;
//滚动下划线
@property(strong,nonatomic)UIView *line;

@property (nonatomic, strong) UIScrollView*     baseScrollView;

@end

@implementation XYSliderView

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.layer.cornerRadius = _typeModel.cornerRadius;
        _line.backgroundColor = _typeModel.lineColor;
    }
    return _line;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
    }
    return self;
}

- (void)initData {
    _items = [NSMutableArray array];
    _sizes = [NSMutableArray array];
}

- (void)setTypeModel:(XYSliderModel *)typeModel {
    NSAssert(typeModel.titles.count, @"请检查titles是否有值.........");
    
    if (_typeModel) {
        [self removeFromSubView:self];
    }
    _typeModel = typeModel;
    
    if (_typeModel.selColor == _typeModel.lineColor && _typeModel.lineType == XYSliderLineTypeCenter) {
        _typeModel.selColor = [UIColor whiteColor];
    }
    
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollEnabled = _typeModel.isScrollEnabled;
    _baseScrollView = scrollView;
    [self addSubview:scrollView];
    
    UIView * contentView = [[UIView alloc] init];
    [scrollView addSubview:contentView];
    [contentView addSubview:self.line];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.greaterThanOrEqualTo(scrollView);
        make.height.greaterThanOrEqualTo(scrollView);//此处保证容器View高度的动态变化 大于等于0.f的高度
    }];
    
    UILabel* lastLB;
    CGFloat  contentViewWidth = 0;
    for (int i = 0; i < self.typeModel.titles.count; i++) {
        
        CGSize size = [self getSizeWithString:self.typeModel.titles[i] font:self.typeModel.selFont];
        contentViewWidth += size.width;
        NSValue* value = [NSValue valueWithCGSize:size];
        [_sizes addObject:value];
        
        UILabel * contentLabel = [[UILabel alloc] init];
        contentLabel.numberOfLines = 0;
        contentLabel.tag = 100086 + i;
        contentLabel.font = _typeModel.unSelFont;
        contentLabel.textColor = _typeModel.unSelColor;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.text = _typeModel.titles[i];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat offsetX = _typeModel.viewType == XYSliderViewTypeAdapt ? _typeModel.spacing : 0;
            if (i == 0) {
                make.left.equalTo(contentView).offset(offsetX);
            } else {
                make.left.equalTo(lastLB.mas_right).offset(offsetX);
            }
            switch (_typeModel.viewType) {
                case XYSliderViewTypeAdapt:{
                }
                    break;
                case XYSliderViewTypeDivideWindow:{
                    make.width.equalTo(self).dividedBy(_typeModel.titles.count);
                }
                    break;
                case XYSliderViewTypeDivide:{
                    NSAssert(typeModel.itemWidth, @"请检查itemWidth是否有值.........");
                    make.width.mas_equalTo(_typeModel.itemWidth);
                }
                    break;
                default:
                    NSLog(@"这里应该不会走的吧。。。。。。。。。。。。");
                    break;
            }
            make.bottom.equalTo(contentView).offset(-_typeModel.itemBottomOffset);
            //不合理，如果setmodel的时候没有frame XYSliderViewTypeAdapt 最后一个titleLB的right没有self的width数值大就尴尬了
            if (i == _typeModel.titles.count - 1 && contentViewWidth > self.frame.size.width) {
                make.right.equalTo(contentView);
            }
        }];
        
        lastLB = contentLabel;
        [self.items addObject:contentLabel];

        if (i == 0) {
            contentLabel.font = _typeModel.selFont;
            contentLabel.textColor = _typeModel.selColor;
            _lastLabel = contentLabel;
            _currentIndex = 0;
            
            [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(contentLabel.mas_centerX);
                
                if (_typeModel.lineType == XYSliderLineTypeCenter) {
                    CGFloat lineWidth;
                    if (_typeModel.lineWidth) {
                        lineWidth = _typeModel.lineWidth;
                    } else {
                        lineWidth = size.width + _typeModel.spacing;
                    }
                    make.width.mas_equalTo(lineWidth);
                    make.height.mas_equalTo(_typeModel.lineHeight);
                    make.centerY.mas_equalTo(self.mas_centerY);
                } else {
                    make.centerX.mas_equalTo(contentLabel.mas_centerX);
                    if (_typeModel.lineWidth) {
                        make.width.mas_equalTo(_typeModel.lineWidth);
                    } else {
                        CGFloat lineWidth = size.width - 2 * _typeModel.lineAdaptOffsetWidth;
                        make.width.mas_equalTo(lineWidth);
                    }
                    make.height.mas_equalTo(_typeModel.lineHeight);
                    if (_typeModel.lineType == XYSliderLineTypeTop) {
                        make.top.equalTo(contentLabel.mas_top).offset(- typeModel.offsetTopTitle);
                    } else {
                        make.bottom.equalTo(contentLabel.mas_bottom).offset(typeModel.offsetTopTitle);
                    }
                    
                }
  
            }];
        }
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemPressed:)];
        [contentLabel addGestureRecognizer:tap];
        contentLabel.userInteractionEnabled = YES;
    }
    
    _typeModel.bottomScrollView.delegate = self;
    _typeModel.bottomScrollView.pagingEnabled = YES;
}

- (void)itemPressed:(UIGestureRecognizer *)tap {
    UILabel* contentLabel = (UILabel *)tap.view;
    [self selectLabel:contentLabel];
}

- (void)selectLabel:(UILabel *)contentLabel {
    if (contentLabel.tag == _lastLabel.tag) {
        return;
    }
    
    for (UILabel* item in self.items) {
        item.font = _typeModel.unSelFont;
        item.textColor = _typeModel.unSelColor;
    }
    
    [self setNeedsUpdateConstraints];
    _lastLabel = contentLabel;
    contentLabel.font = _typeModel.selFont;
    contentLabel.textColor = _typeModel.selColor;
    [contentLabel.superview layoutIfNeeded];
    
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:_typeModel.animateWithDuration animations:^{
        _typeModel.bottomScrollView.contentOffset = CGPointMake((contentLabel.tag - 100086) * _typeModel.bottomScrollView.frame.size.width, 0);
        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentLabel);
            if (_typeModel.lineType == XYSliderLineTypeCenter) {
                CGFloat lineWidth;
                if (_typeModel.lineWidth) {
                    lineWidth = _typeModel.lineWidth;
                } else {
                    lineWidth = self.sizes[contentLabel.tag - 100086].CGSizeValue.width + _typeModel.spacing;
                }
                make.width.mas_equalTo(lineWidth);
                make.height.mas_equalTo(_typeModel.lineHeight);
                make.centerY.mas_equalTo(self.mas_centerY);
            } else {
                if (_typeModel.lineWidth) {
                    make.width.mas_equalTo(_typeModel.lineWidth);
                } else {
                    CGFloat lineWidth = self.sizes[contentLabel.tag - 100086].CGSizeValue.width - 2 * _typeModel.lineAdaptOffsetWidth;
                    make.width.mas_equalTo(lineWidth);
                }
                make.height.mas_equalTo(_typeModel.lineHeight);
                if (_typeModel.lineType == XYSliderLineTypeTop) {
                    make.top.equalTo(contentLabel.mas_top).offset(-_typeModel.offsetTopTitle);
                } else {
                    make.bottom.equalTo(contentLabel.mas_bottom).offset(_typeModel.offsetTopTitle);
                }
            }
        }];
        [self.line.superview layoutIfNeeded];
        
        if (contentLabel.center.x < self.frame.size.width / 2) {
            _baseScrollView.contentOffset = CGPointMake(0, 0);
        } else if ((_baseScrollView.contentSize.width - contentLabel.center.x) < self.frame.size.width / 2) {
            _baseScrollView.contentOffset = CGPointMake(_baseScrollView.contentSize.width - self.frame.size.width, 0);
        } else {
            _baseScrollView.contentOffset = CGPointMake(contentLabel.center.x - self.frame.size.width / 2, 0);
        }
    }];
    
    
    if (_currentClickIndex) {
        _currentClickIndex(contentLabel.tag - 100086);
    }
    _currentIndex = contentLabel.tag - 100086;
    
    
}

#pragma mark -- delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ((int)(scrollView.contentOffset.x / _typeModel.bottomScrollView.frame.size.width) > self.items.count - 1) {
        [scrollView setContentOffset:CGPointMake((self.items.count - 1) * scrollView.frame.size.width, 0)];
        return;
    }
    [self selectLabel:self.items[(int)(scrollView.contentOffset.x / _typeModel.bottomScrollView.frame.size.width)]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f", scrollView.contentOffset.x / _typeModel.bottomScrollView.frame.size.width);
//    int index = (int)(scrollView.contentOffset.x / _typeModel.bottomScrollView.frame.size.width);
//    double floatIndex = scrollView.contentOffset.x / _typeModel.bottomScrollView.frame.size.width;
//    
//    if (index != self.items.count - 1) {
//        CGFloat centerX = (self.items[index + 1].center.x - self.items[index].center.x) * floatIndex + self.items[index].center.x;
//        CGFloat width;
//        if (_typeModel.lineWidth) {
//            width = _typeModel.lineWidth;
//        } else {
//            CGFloat lineWidth1 = self.sizes[index].CGSizeValue.width - 2 * _typeModel.lineAdaptOffsetWidth;
//            CGFloat lineWidth2 = self.sizes[index + 1].CGSizeValue.width - 2 * _typeModel.lineAdaptOffsetWidth;
//            width = (lineWidth2 - lineWidth1) * floatIndex + lineWidth1;
//        }
//        _line.frame = CGRectMake(centerX, _line.frame.origin.y, width, _line.frame.size.height);
//        NSLog(@"%@",NSStringFromCGRect(_line.frame));
//    }
}

//辅助类方法


- (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font {
    CGSize size = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
    return size;
}

- (void)removeFromSubView:(UIView *)superView {
    for (UIView* view in superView.subviews) {
        [view removeFromSuperview];
    }
}

@end
