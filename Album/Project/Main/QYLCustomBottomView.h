//
//  QYLCustomBottomView.h
//  Album
//
//  Created by Marshal on 2017/10/11.
//  Copyright © 2017年 Marshal. All rights reserved.
//  样式制作界面,底部基础图像

#import <UIKit/UIKit.h>

@class QYLTextKindModel, QYLBaseKindModel;

typedef NS_ENUM(NSUInteger, QYLOperateType);

typedef void (^TextBlock)();

@interface QYLCustomBottomView : UIView

//当前文本样式模型
@property (nonatomic, strong) QYLTextKindModel *textKindModel;

//设置文本类型回调
@property (nonatomic, copy) TextBlock textTypeBlock;

//设置文本颜色的回调
@property (nonatomic, copy) TextBlock textColorBlock;

//设置文本字体样式的回调
@property (nonatomic, copy) TextBlock textFontBlock;

//设置文本字体大小的字样
@property (nonatomic, copy) TextBlock textSizeBlock;

//更新状态
- (BOOL)updateBottomText:(QYLBaseKindModel *)kindModel operateType:(QYLOperateType)operateType;

@end
