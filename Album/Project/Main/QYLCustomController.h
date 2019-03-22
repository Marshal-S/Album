//
//  QYLCustomController.h
//  Album
//
//  Created by Marshal on 2017/10/11.
//  Copyright © 2017年 Marshal. All rights reserved.
//  样式制作界面

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QYLEditType) {
    QYLEditTypeAdd = 0, //默认为添加功能
    QYLEditTypeEdit, //编辑
};

@class QYLKindModel;

@interface QYLCustomController : UIViewController

@property (nonatomic, assign) QYLEditType editType;//编辑类型,默认为添加

- (instancetype)initWithImage:(UIImage *)image kindModel:(QYLKindModel *)kindModel;

@end
