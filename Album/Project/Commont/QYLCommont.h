//
//  QYLCommont.h
//  Album
//
//  Created by Marshal on 2017/10/13.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYLCommont : NSObject

/**
 获取模型保存路径

 @param interval 当前时间到1970年的时间间隔
 @return 路径
 */
+ (NSString *)getKindModelPathWithInterval:(long)interval;

/**
 获取图片保存路径
 
 @param interval 当前时间到1970年的时间间隔
 @return 路径
 */
+ (NSString *)getImagePathWithInterval:(long)interval;

/**
 获取重绘图片保存路径
 
 @param interval 当前时间到1970年的时间间隔
 @return 路径
 */
+ (NSString *)getReRenderImagePathWithInterval:(long)interval;

/**
 保存到userdefaults里面,注意删除的话，只需要修改完的把改对象给覆盖就行了
 
 @param KindModelPath 保存新保存的QYLKindModel类型的对象的路径
 */
+ (void)saveToUserDefaults:(id)KindModelPath;

/**
 更新数据列表

 @param kindModelList 传入更新完毕后
 */
+ (void)updateUserDefaults:(NSArray *)kindModelList;

/**
 读取userdefault里面的数据

 @return 返回值为一个数据
 */
+ (NSArray *)getUserDefaultObject;


@end
