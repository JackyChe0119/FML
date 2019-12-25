//
//  FMLTransitionDelegate.h
//  FML
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    AnimationStyleBackScale,//for present
} AnimationStyle;


@interface FMLTransitionDelegate : NSObject<UIViewControllerTransitioningDelegate>

+ (instancetype)shareInstance;

@property (nonatomic, assign) AnimationStyle style;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) NSTimeInterval    timer;

@end
