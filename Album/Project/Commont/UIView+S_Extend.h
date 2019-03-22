//
//  UIView+S_Extend.h
//  gerendanche
//
//  Created by Marshal on 2017/6/20.
//  Copyright © 2017年 Mr.li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (S_Extend)

@property (nonatomic, assign) CGFloat s_width;
@property (nonatomic, assign) CGFloat s_height;
@property (nonatomic, assign) CGFloat s_Y;
@property (nonatomic, assign) CGFloat s_X;
@property (nonatomic, assign) CGPoint s_origin;
@property (nonatomic, assign) CGSize s_size;
@property (nonatomic, assign) CGFloat s_BY;//boundY
@property (nonatomic, assign) CGFloat s_BX;

@end
