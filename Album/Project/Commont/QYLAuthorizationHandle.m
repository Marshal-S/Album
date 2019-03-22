//
//  QYLAuthorizationHandle.m
//  PersonBike
//
//  Created by Marshal on 2017/8/12.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLAuthorizationHandle.h"
#import <UIKit/UIAlertController.h>
#import <Photos/Photos.h>

@implementation QYLAuthorizationHandle

+ (BOOL)handleWithAuthorizationType:(QYLAuthorizationType)type {
    NSString *authorStr;
    NSString *remindStr;
    switch (type) {
        case QYLAuthorizationTypeCamera:{
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
                authorStr = kQYLCamera;
                remindStr = kQYLUnuseCamera;
            }
            break;
        }
        case QYLAuthorizationTypeMediaLibrary: {
            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
                authorStr = kQYLPhotoAlbum;;
                remindStr = kQYLUnusePhotoAlbum;
            }
            break;
        }
    }
    if (!authorStr) return YES;
    [self handleSettingWithMessage:authorStr remind:remindStr];
    return NO;
}

+ (void)handleSettingWithMessage:(NSString *)message remind:(NSString *)remind {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:kQYLAuthorFormatter,message,remind?[@"," stringByAppendingString:remind]:@""] message:kQYLClickOkSetting preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:kQYLOK style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if ([[UIDevice currentDevice].systemVersion floatValue] > 10.0) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:kQYLTemporarilyNotSet style:UIAlertActionStyleCancel handler:nil]];
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
