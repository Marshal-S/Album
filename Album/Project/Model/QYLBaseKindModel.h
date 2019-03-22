//
//  QYLBaseKindModel.h
//  Album
//
//  Created by Marshal on 2017/10/11.
//  Copyright © 2017年 Marshal. All rights reserved.
//  基础样式模型，包括样式名称和值

#import <Foundation/Foundation.h>

//用到这个类就可能会用到这个枚举
typedef NS_ENUM(NSUInteger, QYLTextKindType) {
    QYLTextKindTypeVertical = 0,    //竖直文本框
    QYLTextKindTypeHorizontal       //水平文本框
};

@interface QYLBaseKindModel : NSObject<NSCoding, NSCopying>

@property (nonatomic, copy) NSString *kindName;
@property (nonatomic) id kindValue;//可以有很多值，注意不能为数字，至少得为number类型的

@end
