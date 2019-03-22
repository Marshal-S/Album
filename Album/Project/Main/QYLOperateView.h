//
//  QYLOperateView.h
//  Album
//
//  Created by Marshal on 2017/10/11.
//  Copyright © 2017年 Marshal. All rights reserved.
//  操作视图,即弹出来的选择框

#import <UIKit/UIKit.h>
#import "QYLEnum.h"

@class QYLBaseKindModel;

@interface QYLOperateView : UIView

//用于回调更新定制界面文本框的状态 ,注意第二个参数为两种可能的值类型
@property(nonatomic, copy) void (^updateKindBlock)(QYLOperateType operateType, QYLBaseKindModel *kindModel);

//用于唤出定制界面
- (void)wakeUpOperateViewWithBaseKindModelList:(NSArray<NSString*> *)kindList operateType:(QYLOperateType)operateType;


@end
