//
//  QYLImagepickHandle.m
//  Album
//
//  Created by Marshal on 2017/10/11.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLImagePickerHandle.h"
#import <UIKit/UIImagePickerController.h>
#import "QYLToast.h"
#import "QYLCustomController.h"
#import "UIViewController+S_QYLNaviExtersion.h"
#import "QYLAuthorizationHandle.h"

@interface QYLImagePickerHandle ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController *delegate;

@end

@implementation QYLImagePickerHandle

QYLImagePickerHandle *pickerHandle;

+ (void)pickerImageWithViewController:(UIViewController *)vc {
    if (![QYLAuthorizationHandle handleWithAuthorizationType:QYLAuthorizationTypeMediaLibrary]) {
        return;
    }
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [QYLToast showWithMessage:kQYLUnableToOpenTheAlbum];
        return;
    }
    pickerHandle = [[QYLImagePickerHandle alloc] init];
    pickerHandle.delegate = vc;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = pickerHandle;
    [vc presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    QYLCustomController *custom = [[QYLCustomController alloc] initWithImage:image kindModel:nil];
    //尽量保证比较好的衔接
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (_delegate) [_delegate s_push:custom animated:NO];
    pickerHandle = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismiss];
}

- (void)dismiss {
    if (_delegate) {
        [_delegate dismissViewControllerAnimated:YES completion:nil];
        pickerHandle = nil;
    }
}

- (void)dealloc {
    QYLog(nil);
}

@end
