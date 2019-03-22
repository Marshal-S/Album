//
//  QYLAuthorizationHandle.h
//  PersonBike
//
//  Created by Marshal on 2017/8/12.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QYLAuthorizationType) {
    QYLAuthorizationTypeCamera = 1,             //相机权限
    QYLAuthorizationTypeMediaLibrary = 1 << 1  //媒体库权限
};

@interface QYLAuthorizationHandle : NSObject

+ (BOOL)handleWithAuthorizationType:(QYLAuthorizationType)type;

+ (void)handleSettingWithMessage:(NSString *)message remind:(NSString *)remind;

@end
