//
//  QYLTextKindModel.h
//  Album
//
//  Created by Marshal on 2017/10/11.
//  Copyright © 2017年 Marshal. All rights reserved.
//  文本框样式模型

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import "QYLBaseKindModel.h"

@interface QYLTextKindModel : NSObject<NSCoding, NSCopying>

@property (nonatomic, copy) NSString *text; //文本
@property (nonatomic, assign) CGRect frame; //位置
@property (nonatomic, strong) QYLBaseKindModel *typeModel; //文本模型，为横文本或者竖文本
@property (nonatomic, strong) QYLBaseKindModel *colorModel;//颜色模型
@property (nonatomic, strong) QYLBaseKindModel *fontModel; //字体样式模型
@property (nonatomic, strong) QYLBaseKindModel *sizeModel;//注意大小是像素了,这里保存的不是像素

@end
