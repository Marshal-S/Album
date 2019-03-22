//
//  QYLGenerateOneController.m
//  Album
//
//  Created by Marshal on 2017/10/14.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLGenerateOneController.h"
#import "QYLKindModel.h"
#import "UIViewController+S_QYLNaviExtersion.h"
#import "QYLFormboardView.h"
#import "QYLCommont.h"
#import "UIView+S_Extend.h"
#import "QYLToast.h"
#import "QYLProgressView.h"
#import "NSString+QYLString.h"

@interface QYLGenerateOneController ()

@property (weak, nonatomic) IBOutlet UITextField *tfFirst;
@property (weak, nonatomic) IBOutlet UITextField *tfLast;
@property (weak, nonatomic) IBOutlet UIButton *btnGenerate;
@property (nonatomic, strong) QYLKindModel *kindModel;

@end

@implementation QYLGenerateOneController

- (instancetype)initWithKindModel:(QYLKindModel *)kindModel {
    if (self = [super init]) {
        _kindModel = kindModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self s_setDefaultBack];
    _btnGenerate.layer.cornerRadius = 5;
    _tfFirst.text = [_kindModel.firstKindModel.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    _tfLast.text = [_kindModel.lastKindModel.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

- (IBAction)onClickToGenerate:(id)sender {
    QYLFormboardView *formView = [[QYLFormboardView alloc] initWithKindModel:_kindModel];
    [formView updateWithSelectType:QYLSelectTextTypeFirst Text:[_tfFirst.text getCommontWithType:[_kindModel.firstKindModel.typeModel.kindValue integerValue]]];
    [formView updateWithSelectType:QYLSelectTextTypeLast Text:[_tfLast.text getCommontWithType:[_kindModel.lastKindModel.typeModel.kindValue integerValue]]];
    [QYLProgressView show];
    self.navigationItem.rightBarButtonItem.customView.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(formView.s_width,formView.s_height), NO, [UIScreen mainScreen].scale);
        [formView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        [QYLProgressView dismiss];
        self.navigationItem.rightBarButtonItem.customView.userInteractionEnabled = YES;
        if (!error) {
            [QYLToast showWithMessage:kQYLSaveSuccessfully];
        }else {
            [QYLToast showWithMessage:kQYLFailToSave];
        }
    });
}

- (IBAction)onValueChanged:(UITextField *)sender {
    NSString *text = sender.text;
    if (sender.tag == 10) {
        if (text.length < 4) return;
        sender.text = [text substringToIndex:text.length-1];
    }else {
        if (text.length < 12) return;
        sender.text = [text substringToIndex:text.length-1];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    QYLog(nil);
}

@end
