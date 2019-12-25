//
//  WebViewController.h
//  FML
//
//  Created by apple on 2018/7/31.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseViewController.h"

@interface WebViewController : MJBaseViewController

@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* webTitle;
@property (nonatomic, assign) BOOL type;//不设置是网页  1是文案

@end
