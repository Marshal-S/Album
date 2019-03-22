//
//  QYLCustomController.m
//  Album
//
//  Created by Marshal on 2017/10/11.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLCustomController.h"
#import "UIViewController+S_QYLNaviExtersion.h"
#import "QYLCustomBottomView.h"
#import "QYLKindModel.h"
#import "QYLOperateView.h"
#import "QYLFormboardView.h"
#import "QYLDetailKindData.h"
#import "QYLCommont.h"
#import "QYLToast.h"
#import "QYLNotifications.h"
#import "UIView+S_Extend.h"
#import "UIImage+S_QYLImageExtersion.h"
#import "QYLProgressView.h"

@interface QYLCustomController ()

@property (nonatomic, copy) UIImage *image;
@property (nonatomic, strong) QYLKindModel *kindModel;
@property (nonatomic, strong) QYLFormboardView *formboardView;//模板
@property (nonatomic, strong) QYLCustomBottomView *bottomView; //底部视图
@property (nonatomic, strong) QYLOperateView *operateView;//操作视图

@end

@implementation QYLCustomController

- (instancetype)initWithImage:(UIImage *)image kindModel:(QYLKindModel *)kindModel {
    if (self = [super init]) {
        _kindModel = kindModel ? kindModel : [[QYLKindModel alloc] init];
        if (image) {
            _image = image;
        }else {
            _image = [UIImage imageWithData:[NSData dataWithContentsOfFile:_kindModel.imagePath]];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initContentView];
    [self setOthers];
    // Do any additional setup after loading the view.
}

- (void)setOthers {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self s_setDefaultBack];
    self.navigationItem.title = kQYLStyleProduction;
    [self s_setRightWithImage:nil title:kQYLComplete size:16 titleColor:[UIColor whiteColor] action:@selector(onClickToFinished)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickToEndEditing)];
    [self.view addGestureRecognizer:tap];
}

- (void)onClickToEndEditing {
    [self.view endEditing:YES];
}

#pragma mark --初始化内部视图
- (void)initContentView {
    __weak typeof(self) wself = self;
    _formboardView = [[QYLFormboardView alloc] initWithKindModel:_kindModel formImage:_image];
    [_formboardView setTextViewSwitchBlock:^(QYLTextKindModel *textKindModel){
        wself.bottomView.textKindModel = textKindModel;
    }];
    [self.view addSubview:_formboardView];
    //初始化底部视图
    _bottomView = [[QYLCustomBottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-bottomHeight, SCREEN_WIDTH, bottomHeight)];
    _bottomView.textKindModel = _kindModel.firstKindModel;
    [_bottomView setTextTypeBlock:^ {
        [wself.operateView wakeUpOperateViewWithBaseKindModelList:[QYLDetailKindData textArray:QYLOperateTypeTextType] operateType:QYLOperateTypeTextType];
    }];
    [_bottomView setTextColorBlock:^ {
        [wself.operateView wakeUpOperateViewWithBaseKindModelList:[QYLDetailKindData textArray:QYLOperateTypeColor] operateType:QYLOperateTypeColor];
    }];
    [_bottomView setTextFontBlock:^ {
        [wself.operateView wakeUpOperateViewWithBaseKindModelList:[QYLDetailKindData textArray:QYLOperateTypeFont] operateType:QYLOperateTypeFont];
    }];
    [_bottomView setTextSizeBlock:^ {
        [wself.operateView wakeUpOperateViewWithBaseKindModelList:@[wself.bottomView.textKindModel.sizeModel] operateType:QYLOperateTypeSize];
    }];
    [self.view addSubview:_bottomView];
    
    //初始化操作视图
    _operateView = [[QYLOperateView alloc] initWithFrame:CGRectMake(0, topHeight, SCREEN_WIDTH, SCREEN_HEIGHT-topHeight-bottomHeight)];
    [_operateView setUpdateKindBlock:^(QYLOperateType operateType, QYLBaseKindModel *kindModel){
        if ([wself.bottomView updateBottomText:kindModel operateType:operateType]) {
            [wself.formboardView updateFormboardWithOperateType:operateType baseKindModel:kindModel];
        }
    }];
    [self.view addSubview:_operateView]; 
}

#pragma mark --完成编辑后的处理
- (void)onClickToFinished {
    long interval = [[NSDate date] timeIntervalSince1970];
    [QYLProgressView show];
    self.navigationItem.rightBarButtonItem.customView.userInteractionEnabled = NO;
    [self saveImageWithInterval:interval completed:^{
        [QYLProgressView dismiss];
        BOOL isNeedSaveUserDefault = !self.kindModel.timeInterval;//是否需要保存，为零默认为没有保存过索引，则需要保存下
        if (isNeedSaveUserDefault) {
            self.kindModel.timeInterval = interval;//保存到1970年的时间,可在下次用于判断是否已经被保存了
        }
        NSString *kindModelPath = [QYLCommont getKindModelPathWithInterval:self.kindModel.timeInterval];
        BOOL isSuccess = [NSKeyedArchiver archiveRootObject:self.kindModel toFile:kindModelPath];
        if (isNeedSaveUserDefault) [QYLCommont saveToUserDefaults:kindModelPath];
        if (isSuccess) {
            [QYLToast showWithMessage:kQYLSaveSuccessfully];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.editType == QYLEditTypeAdd) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kQYLNotificationAddFormboard object:self.kindModel];
            }else {
                [[NSNotificationCenter defaultCenter] postNotificationName:kQYLNotificationUpdateFormboard object:nil];
            }
        }else {
            [QYLToast showWithMessage:kQYLFailToSave];
        }
        [QYLProgressView dismiss];
        self.navigationItem.rightBarButtonItem.customView.userInteractionEnabled = YES;
    }];
}

- (void)saveImageWithInterval:(long)interval completed:(void(^)())completed {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = UIImagePNGRepresentation(self.image);
        if (imageData) {
            NSString *path = self.kindModel.imagePath;
            path = path ? path : [QYLCommont getImagePathWithInterval:interval];
            if ([imageData writeToFile:path atomically:YES]) {
                self.kindModel.imagePath = path;//保存生成后的图片到某个界面
            }
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //这个绘制只是用来显示的不是真正用来生成的，注意了
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.formboardView.s_width, self.formboardView.s_height), NO, [UIScreen mainScreen].scale);
        [self.formboardView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //到这一步，图片有点大，再加工一下
        CGFloat width = SCREEN_WIDTH/2 - 20;
        CGFloat imageScale = newImage.size.height/newImage.size.width;
        newImage = [newImage s_getNewImage:CGSizeMake(width, width*imageScale)];
        NSData *imageData = UIImagePNGRepresentation(newImage);
        if (imageData) {
            NSString *path = self.kindModel.smallImagePath;
            path = path ? path : [QYLCommont getReRenderImagePathWithInterval:interval];
            if ([imageData writeToFile:path atomically:YES]) {
                self.kindModel.smallImagePath = path;//保存生成后的图片到某个界面
                self.kindModel.imageScale = imageScale;
            }
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (completed) completed();
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    QYLog(nil);
}

@end
