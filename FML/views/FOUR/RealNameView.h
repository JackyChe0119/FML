//
//  RealNameView.h
//  FML
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RealNameView : UIView

@property (nonatomic, strong) UIImage* baseImage;
@property (nonatomic, strong) UIImage* realImage;
@property (nonatomic, strong) UILabel* title;
@property (nonatomic, copy) void (^ upImageBlock)(RealNameView* realView);
@property (nonatomic, strong) UIImageView* imageView;

@property (nonatomic, copy) NSString*  imagePath;

@end
