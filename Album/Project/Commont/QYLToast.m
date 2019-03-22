//
//  QYLToast.m
//  PersonBike
//
//  Created by Marshal on 2017/8/7.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLToast.h"

static NSInteger toastCount = 0; //用于了解toast的数量

static BOOL toastIndex[3];

@implementation QYLToast

+ (void)showWithMessage:(NSString *)message {
    toastCount++;
    //判断是否都不在显示，是的话就重置在中间位置
    BOOL isExist = NO;
    for (NSInteger idx = 0; idx < 3; idx++) {
        if (toastIndex[idx]) {
            isExist = YES;
            break;
        }
    }
    if (!isExist) toastCount = 0;
    
    NSInteger index = toastCount%3;//将要出现的是第几位
    if (toastIndex[index]) return; //如果某一位置已经是有显示了那就不在显示了
    toastIndex[index] = YES;
    __block QYLToast *back = [[QYLToast alloc] init];
    back.backgroundColor = RGBA(0, 0, 0, 0.9);
    back.layer.cornerRadius = 4;
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:back];//直接添加到rooCcontroller上面(navi)
    UILabel *toast = [[UILabel alloc] init];
    toast.textColor = [UIColor whiteColor];
    toast.backgroundColor = [UIColor clearColor];
    toast.textAlignment = NSTextAlignmentCenter;
    toast.font = [UIFont systemFontOfSize:14];
    toast.numberOfLines = 0;
    toast.layer.cornerRadius = 5;
    toast.text = message;
    CGSize size = [toast sizeThatFits:CGSizeMake(SCREEN_WIDTH-80, 20)];
    back.bounds = CGRectMake(0, 0, size.width+30, size.height+16);
    toast.frame = CGRectMake(15, 8, size.width, size.height);
    [back addSubview:toast];
    if (index == 0) {
        back.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    }else if (index == 1) {
        back.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-70);
    }else if (index == 2) {
        back.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2+70);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            back.alpha = 0;
        } completion:^(BOOL finished) {
            [back removeFromSuperview];
            toastIndex[index] = NO;
            back = nil;
        }];
    });
}

- (void)dealloc {
    QYLog(nil);
}

@end
