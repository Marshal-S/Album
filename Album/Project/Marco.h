//
//  Marco.h
//  DiBaiDanChe
//
//  Created by Marshal on 2017/6/17.
//  Copyright © 2017年 angledog. All rights reserved.
//

#ifndef Marco_h
#define Marco_h



#ifdef DEBUG
#define QYLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,__VA_ARGS__)
#else
#define QYLog(...)
#endif

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


#endif /* Marco_h */
