//
//  Test.h
//  Album
//
//  Created by Marshal on 2017/10/11.
//  Copyright © 2017年 Marshal. All rights reserved.
//  模板模型

#import "QYLTextKindModel.h"

@interface QYLKindModel : NSObject<NSCoding, NSCopying>

@property (nonatomic, strong) QYLTextKindModel *firstKindModel; //第一个文本模型
@property (nonatomic, strong) QYLTextKindModel *lastKindModel;  //后一个文本模型
@property (nonatomic, assign) CGRect bounds; //保存最外层的布局bounds
@property (nonatomic, assign) CGFloat scale;//真实图片相对显示图片的比例，即字号什么的都要根据比例进行调整，scale = imageWidth/formboard.frame.width
@property (nonatomic, copy) NSString *imagePath;//保存下来的图片路径
@property (nonatomic, copy) NSString *smallImagePath; //主界面小图片路径
@property (nonatomic, assign) CGFloat imageScale; //保存主界面小图片的比例 为高比宽 
@property (nonatomic, assign) long timeInterval;//到1970之间的时间间隔，可用于排序

- (instancetype)getRealKindModel;//获取绘制所需要的真实的model

@end
