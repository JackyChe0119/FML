//
//  UILabel+UILabel_countDown.m
//  JobGame
//
//  Created by mc on 16/4/30.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import "UILabel+UILabel_countDown.h"

@implementation UILabel (UILabel_countDown)
- (void)countdown:(void (^)(void))complete :(void(^)(void))uncomplete {
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                complete ();
                self.userInteractionEnabled = YES;
                self.text = @"重新获取";
                self.backgroundColor =ColorBlue;
            });
        }else{
            int seconds = timeout - 1;
            NSString *strTime = [NSString stringWithFormat:@"%dS", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.text = strTime;
                uncomplete();
                self.userInteractionEnabled = NO;
                self.backgroundColor = ColorGray;
            });
            timeout --;
        }
    });
    dispatch_resume(_timer);
}
- (void)Datecountdown:(NSInteger)time str:(NSString *)title final:(NSString *)finalStr :(void (^)(void))complete :(void(^)(void))uncomplete {
    __block NSInteger timeout = time;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.text = finalStr;
                complete ();
            });
        }else{
            NSInteger seconds = timeout - 1;

            NSInteger hours = ((NSInteger)seconds)%(3600*24)/3600;
            
            NSInteger minutes = ((NSInteger)seconds)%(3600*24)%3600/60;
            
            NSInteger second = ((NSInteger)seconds)%(3600*24)%3600%60;
            NSString *strTime = [NSString stringWithFormat:@"%li:%li:%li",hours,minutes,(long)second];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.text = strTime;
                uncomplete();
                self.userInteractionEnabled = NO;
            });
            timeout --;
        }
    });
    dispatch_resume(_timer);
}
- (void)DatecountdownOrder:(NSInteger)time str:(NSString *)title final:(NSString *)final :(void (^)(void))complete :(void(^)(void))uncomplete {
    __block NSInteger timeout = time;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.text = final;
                complete ();
            });
        }else{
            NSInteger seconds = timeout - 1;
            
            NSInteger hours = ((NSInteger)seconds)%(3600*24)/3600;
            
            NSInteger minutes = ((NSInteger)seconds)%(3600*24)%3600/60;
            
            NSInteger second = ((NSInteger)seconds)%(3600*24)%3600%60;
            NSString *strTime = [NSString stringWithFormat:@"%02li:%02li:%02li",hours,minutes,(long)second];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.text = strTime;
                uncomplete();
                self.userInteractionEnabled = NO;
            });
            timeout --;
        }
    });
    dispatch_resume(_timer);
}

@end
