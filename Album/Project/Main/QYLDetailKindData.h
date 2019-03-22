//
//  QYLDetailKindData.h
//  Album
//
//  Created by Marshal on 2017/10/13.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QYLOperateType);

@interface QYLDetailKindData : UIView

//获取编辑列表嘻嘻
+ (NSArray *)textArray:(QYLOperateType)type;

//获取姓氏
+ (NSArray *)getFamilyName;

//获取名字
+ (NSArray *)getName;

@end
