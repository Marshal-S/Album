//
//  QYLFormboardView.h
//  Album
//
//  Created by Marshal on 2017/10/12.
//  Copyright © 2017年 Marshal. All rights reserved.
//  模板视图，用于显示，或者生成新的视图

#import <UIKit/UIKit.h>

@class QYLKindModel, QYLTextKindModel, QYLBaseKindModel;

typedef NS_ENUM(NSUInteger, QYLTextKindType);
typedef NS_ENUM(NSUInteger, QYLOperateType);
typedef NS_ENUM(NSUInteger, QYLSelectTextType) {
    QYLSelectTextTypeFirst = 0, //默认选择第一个文本框
    QYLSelectTextTypeLast = 1,      //第二个文本框
};

@interface QYLFormboardView : UIView

@property (nonatomic, copy) void (^textViewSwitchBlock)(QYLTextKindModel *textKindModel);

- (instancetype)initWithKindModel:(QYLKindModel *)kindModel formImage:(UIImage *)formImage;

- (instancetype)initWithKindModel:(QYLKindModel *)kindModel;//仅用于绘制使用

//根据类型更新模板状态
- (void)updateFormboardWithOperateType:(QYLOperateType)operateType baseKindModel:(QYLBaseKindModel *)baseKindModel;

//更新单个文本（一般被动更新），这个在绘制的时候主动调用
- (void)updateWithSelectType:(QYLSelectTextType)selectType Text:(NSString *)text;

@end
