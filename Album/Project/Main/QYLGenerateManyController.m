//
//  QYLGenerateManyController.m
//  Album
//
//  Created by Marshal on 2017/10/14.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLGenerateManyController.h"
#import "QYLKindModel.h"
#import "UIViewController+S_QYLNaviExtersion.h"
#import "QYLFormboardView.h"
#import "UIView+S_Extend.h"
#import "QYLToast.h"
#import "QYLCommont.h"
#import "QYLDetailKindData.h"
#import "QYLEnum.h"
#import "QYLProgressView.h"
#import "NSString+QYLString.h"

@interface QYLGenerateManyController ()
{
    NSInteger _selectIndex;
    NSOperationQueue *_queue;
}

@property (atomic, assign) long successCount;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property (nonatomic, strong) QYLKindModel *kindModel;

@property (weak, nonatomic) IBOutlet UITextField *tfLast
;
@property (weak, nonatomic) IBOutlet UIButton *btnGenerate;

@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, copy) NSArray *titleAry;

@end

@implementation QYLGenerateManyController

- (instancetype)initWithKindModel:(QYLKindModel *)kindModel {
    if (self = [super init]) {
        _kindModel = kindModel;
        _titleAry = @[kQYLRandomSurnames,kQYLRandomName];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self s_setDefaultBack];
    [_btnSelect setTitle:_titleAry[0] forState:UIControlStateNormal];
    _btnGenerate.layer.cornerRadius = 5;
    _btnSelect.layer.cornerRadius = 5;
    _tfLast.text = [_kindModel.lastKindModel.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelectView)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissSelectView {
    _selectView.hidden = YES;
    [_tfLast resignFirstResponder];
}

- (IBAction)onValueChanged:(UITextField *)sender {
    NSString *text = sender.text;
    if (text.length < 12) return;
    sender.text = [text substringToIndex:text.length-1];
}

#pragma mark --初始化选择框
- (void)initSelectView {
    _selectView = [[UIView alloc] initWithFrame:CGRectMake(_btnSelect.s_X, _btnSelect.s_Y+_btnSelect.s_height, _btnSelect.s_width, 64)];
    _selectView.userInteractionEnabled = YES;
    [self.view addSubview:_selectView];
    for (NSInteger idx = 0; idx < _titleAry.count; idx++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 32*idx, _selectView.s_width, 32)];
        [btn setTitle:_titleAry[idx] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.tag = 30 + idx;
        [btn addTarget:self action:@selector(onClickToSelect:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:btn];
    }
}

- (IBAction)onClickToShow:(id)sender {
    if (!_selectView) [self initSelectView];
    _selectView.hidden = NO;
}

- (void)onClickToSelect:(UIButton *)sender {
    _selectView.hidden = YES;
    _selectIndex = sender.tag-30;
    [_btnSelect setTitle:_titleAry[_selectIndex] forState:UIControlStateNormal];
}

- (IBAction)onClickToGenerate:(id)sender {
    [QYLProgressView show];
    self.navigationItem.rightBarButtonItem.customView.userInteractionEnabled = NO;
    _queue = [[NSOperationQueue alloc] init];
    _queue.maxConcurrentOperationCount = 4;//最多创建4个线程，防止内存占用太大了
    dispatch_group_t group = dispatch_group_create();
    NSArray *names = _selectIndex > 0 ? [QYLDetailKindData getName] : [QYLDetailKindData getFamilyName];
    for (NSInteger idx = 0; idx < 20; idx++) {
        //注意不能再子线程中绘制
        @autoreleasepool {
            dispatch_group_enter(group);
            QYLFormboardView *formView = [[QYLFormboardView alloc] initWithKindModel:[_kindModel copy]];
            [formView updateWithSelectType:QYLSelectTextTypeLast Text:[_tfLast.text getCommontWithType:[_kindModel.lastKindModel.typeModel.kindValue integerValue]]];
            [formView updateWithSelectType:QYLSelectTextTypeFirst Text:[names[arc4random()%names.count] getCommontWithType:[_kindModel.firstKindModel.typeModel.kindValue integerValue]]];
            [_queue addOperationWithBlock:^{
                @autoreleasepool {
                    UIGraphicsBeginImageContextWithOptions(CGSizeMake(formView.s_width,formView.s_height), NO, [UIScreen mainScreen].scale);
                    [formView.layer renderInContext:UIGraphicsGetCurrentContext()];
                    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                    dispatch_group_leave(group);
                    self.successCount++;
                }
            }];
        }
    }
        
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [QYLProgressView dismiss];
        self.navigationItem.rightBarButtonItem.customView.userInteractionEnabled = YES;
        if (self.successCount > 0) {
            [QYLToast showWithMessage:kQYLSaveSuccessfully];
        }else {
            [QYLToast showWithMessage:kQYLFailToSave];
        }
        self.successCount = 0;
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    //保存相册方法执行后回调改方法，这个方法回调会有延迟
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_queue cancelAllOperations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    QYLog(nil);
}

@end
