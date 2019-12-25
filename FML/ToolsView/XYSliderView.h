//
//  XYSliderView.h
//  Extension
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, XYSliderViewType) {
    XYSliderViewTypeAdapt, //全体靠左 item数量不多时也靠左 宽度根据title自适应
    XYSliderViewTypeDivide, //所有控件宽度相等
    XYSliderViewTypeDivideWindow, //所有控件平分window的宽度
};

typedef NS_ENUM(NSInteger, XYSliderLineType) {
    XYSliderLineTypeBottom,//线在label下方
    XYSliderLineTypeTop,   //线在label上方
    XYSliderLineTypeCenter //线盖住label
};


@interface XYSliderModel : NSObject

//scrollview
@property (nonatomic, assign) BOOL      isScrollEnabled;
@property (nonatomic, strong) UIScrollView* bottomScrollView;

//line底部滑块
@property (nonatomic, strong) UIColor*  lineColor;

@property (nonatomic, assign) CGFloat   cornerRadius; //滑块圆角
@property (nonatomic, assign) CGFloat   lineHeight; //滑块的高度
@property (nonatomic, assign) CGFloat   lineWidth; //设置滑块的宽度
@property (nonatomic, assign) CGFloat   lineAdaptOffsetWidth; //设置滑块左右两端向内偏移pt
@property (nonatomic, assign) CGFloat   offsetTopTitle;
@property (nonatomic, assign) XYSliderLineType  lineType; //XYSliderLineTypeCenter时 以上高宽属性全部失效

//label的类型
@property (nonatomic, strong) UIColor*  selColor;
@property (nonatomic, strong) UIColor*  unSelColor;

@property (nonatomic, strong) UIFont*   selFont;
@property (nonatomic, strong) UIFont*   unSelFont;

//XYSliderViewTypeDivideWindow 时下面两个属性失效
@property (nonatomic, assign) CGFloat   spacing; //XYSliderViewTypeLeft控件之间的间距 || XYSliderLineTypeCenter是为字体到线段两边的空间/2
@property (nonatomic, assign) CGFloat   itemWidth; //XYSliderViewTypeDivide类型时生效
@property (nonatomic, assign) CGFloat   itemBottomOffset;

@property (nonatomic, strong) NSArray*  titles;
@property (nonatomic, assign) XYSliderViewType  viewType;

@property (nonatomic, assign) NSTimeInterval    animateWithDuration;

@end


@interface XYSliderView : UIView

@property (nonatomic, strong) XYSliderModel*    typeModel;

@property (nonatomic, assign) NSUInteger       currentIndex;
@property (nonatomic, copy) void (^currentClickIndex) (NSUInteger currentIndex);

@end
