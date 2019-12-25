//
//  statusView.h
//  FML
//
//  Created by 车杰 on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface statusView : UIView
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *statusLabel;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *imageStr;
@end
