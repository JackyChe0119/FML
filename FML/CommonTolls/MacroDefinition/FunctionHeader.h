//
//  FunctionHeader.h
//  iOS SDK
//
//  Created by 王振 on 16/1/6.
//  Copyright © 2016年 杭州空极科技有限公司. All rights reserved.
//

#ifndef FunctionHeader_h
#define FunctionHeader_h

// ****************** 功能类宏定义 ******************
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
/**
 *  快速设置 font
 */
#define FONT(_SIZE_) [UIFont systemFontOfSize:_SIZE_]
/**
 *  快速配置 imageName
 */
#define IMAGE(_IMAGE_)  [UIImage imageNamed:_IMAGE_]
/**
 *  快速设置 point
 */
#define POINT(_X_,_Y_) CGPointMake(_X_, _Y_)
/**
 *  快速设置 rect
 */
#define RECT(_X_,_Y_,_W_,_H_) CGRectMake(_X_, _Y_, _W_, _H_)
/**
 *  快速设置 size
 */
#define SIZE(_W_,_H_) CGSizeMake(_W_, _H_)
/**
 *  快速设置 bounds
 */
#define BOUNDS(_X_,_Y_,_W_,_H_) CGRectMake(0, 0, _W_, _H_)
/**
 *  快速设置 range
 */
#define RANGE(_location_,_length_) NSMakeRange(_location_,_length_)
/**
 *  获取简易位置
 */
#define HeightProportion        [[UIScreen mainScreen] bounds].size.height/667
#define WIDTH(X)  (X).frame.size.width
#define HEIGHT(X) (X).frame.size.height
#define STARTX(X) (X).frame.origin.x
#define STARTY(X) (X).frame.origin.y
#define LEFT(X)   (X).frame.origin.x
#define RIGHT(X)  ((X).frame.origin.x+X.frame.size.width)
#define TOP(X)    (X).frame.origin.y
#define BOTTOM(X) ((X).frame.origin.y+X.frame.size.height)
#define InitObject(vc) [[vc alloc]init]
/**
 *  带边框
 */
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]
// 系统控件默认高度
#define kStatusBarHeight        (20.f)
#define kTopBarHeight           (44.f)
#define kBottomBarHeight        (49.f)

#define GETY(_Y_) CGRectGetMaxY(_Y_)
#define GETX(_X_) CGRectGetMaxX(_X_)

#define String(s) [NSString stringWithFormat:@"%@", s]
#endif /* FunctionHeader_h */
