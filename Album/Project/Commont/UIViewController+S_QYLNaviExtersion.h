//
//  UIViewController+S_QYLNaviExtersion.h
//  PersonBike
//
//  Created by Marshal on 2017/7/10.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (S_QYLNaviExtersion)

/**
 设置返回按钮为默认
 */
- (void)s_setDefaultBack;


/**
 设置导航右按钮

 @param image       图片
 @param title       文字
 @pram  titleSize   文字大小
 @param color       颜色
 @param sel         点击事件
 */
- (void)s_setRightWithImage:(UIImage *)image title:(NSString *)title size:(CGFloat)titleSize titleColor:(UIColor *)color action:(SEL)sel;

/**
 返回

 @param animated 是否使用动画返回
 */
- (void)s_push:(UIViewController *)vc animated:(BOOL)animated;

@end
