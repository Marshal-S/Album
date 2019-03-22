//
//  UIImage+S_QYLImageExtersion.m
//  PersonBike
//
//  Created by Marshal on 2017/7/17.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "UIImage+S_QYLImageExtersion.h"

@implementation UIImage (S_QYLImageExtersion)

- (UIImage *)s_getNewImage:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);//设置YES为不透明能提高效率
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
