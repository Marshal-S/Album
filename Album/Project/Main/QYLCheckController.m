//
//  QYLCheckController.m
//  Album
//
//  Created by Marshal on 2017/10/14.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLCheckController.h"
#import "UIViewController+S_QYLNaviExtersion.h"
#import "QYLKindModel.h"
#import "QYLCustomController.h"
#import "QYLFormboardView.h"
#import "QYLNotifications.h"
#import "UIView+S_Extend.h"
#import "QYLGenerateOneController.h"
#import "QYLGenerateManyController.h"

@interface QYLCheckController ()

@property (nonatomic, strong) QYLKindModel *kindModel;
@property (weak, nonatomic) IBOutlet UIImageView *ivImage;
@property (nonatomic, strong) QYLFormboardView *formView;

@end

@implementation QYLCheckController

- (instancetype)initWithKindModel:(QYLKindModel *)kindModel {
    if (self = [super init]) {
        _kindModel = kindModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initOthers];
    [self setupFormBoardView];
}

- (void)initOthers {
    [self s_setDefaultBack];
    self.navigationItem.title = kQYLCurrentTemplate;
    [self s_setRightWithImage:nil title:kQYLEdit size:15 titleColor:[UIColor whiteColor] action:@selector(onClickToEdit)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupFormBoardView) name:kQYLNotificationUpdateFormboard object:nil];
}

- (void)setupFormBoardView {
    if (_formView) [_formView removeFromSuperview];
    _formView = [[QYLFormboardView alloc] initWithKindModel:[_kindModel copy] formImage:nil];
    _formView.userInteractionEnabled = NO;
    [self.view addSubview:_formView];
}

- (void)onClickToEdit {
    QYLCustomController *custom = [[QYLCustomController alloc] initWithImage:nil kindModel:_kindModel];
    custom.editType = QYLEditTypeEdit;
    [self.navigationController pushViewController:custom animated:YES];
}

- (IBAction)onClickToGenerate:(UIButton *)sender {
    if (sender.tag == 20) {
        QYLGenerateManyController *many = [[QYLGenerateManyController alloc] initWithKindModel:_kindModel];
        [self.navigationController pushViewController:many animated:YES];
    }else {
        QYLGenerateOneController *one = [[QYLGenerateOneController alloc] initWithKindModel:_kindModel];
        [self.navigationController pushViewController:one animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kQYLNotificationUpdateFormboard object:nil];
    QYLog(nil);
}

@end
