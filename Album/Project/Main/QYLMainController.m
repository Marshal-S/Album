//
//  QYLMainController.m
//  Album
//
//  Created by Marshal on 2017/10/11.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLMainController.h"
#import "QYLMainCell.h"
#import "QYLKindModel.h"
#import "UIView+S_Extend.h"
#import "UIViewController+S_QYLNaviExtersion.h"
#import "QYLImagePickerHandle.h"
#import "QYLCommont.h"
#import "QYLNotifications.h"
#import "QYLCheckController.h"
#import "QYLWaterfallLayout.h"

NSString *kQYLMainCellIdentifier = @"kQYLMainCellIdentifier";

@interface QYLMainController ()<UICollectionViewDelegate,UICollectionViewDataSource,QYLWaterfallLayoutDelegate>
{
    BOOL _isEdit;//是否是处于编辑的状态
    CGFloat _cellWidth;
}
@property (nonatomic, strong) NSMutableArray<QYLKindModel *> *kindList;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *kindModelPaths;//数据路径列表

@end

@implementation QYLMainController

- (instancetype)init {
    if (self = [super init]) {
        _kindList = [NSMutableArray array];
        _kindModelPaths = [NSMutableArray array];
        _cellWidth = SCREEN_WIDTH/2 - 20;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = kQYLMyStyle;
    [self s_setRightWithImage:[UIImage imageNamed:@"ic_add"] title:nil size:0 titleColor:nil action:@selector(onClickToCustomFormboard)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addForboard:) name:kQYLNotificationAddFormboard object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateForboard) name:kQYLNotificationUpdateFormboard object:nil];
    [self initKindList];
    [self initCollectionView];
}

#pragma mark --保存完毕新模板后存放到数组中
- (void)addForboard:(NSNotification *)notification {
    self.kindModelPaths.array = [QYLCommont getUserDefaultObject];
    QYLKindModel *kindModel = notification.object;
    [_kindList insertObject:kindModel atIndex:0];
    [_collectionView reloadData];
}

#pragma mark --更新原有模板
- (void)updateForboard {
    [_collectionView reloadData];
}

#pragma mark --去定制模板
- (void)onClickToCustomFormboard {
    if (_isEdit) [self onClickToCancelEdit];
    [QYLImagePickerHandle pickerImageWithViewController:self];
}

- (void)initKindList {
    //在这里读取数据
    self.kindModelPaths.array = [QYLCommont getUserDefaultObject];
    [self.kindModelPaths enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:obj];
        if (object) {
            [self.kindList addObject:object];
        }
    }];
}


- (void)initCollectionView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    QYLWaterfallLayout *waterfall = [[QYLWaterfallLayout alloc] init];
    waterfall.delegate = self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, topHeight, SCREEN_WIDTH, SCREEN_HEIGHT-topHeight) collectionViewLayout:waterfall];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:NSClassFromString(@"QYLMainCell") forCellWithReuseIdentifier:kQYLMainCellIdentifier];
    _collectionView.clipsToBounds = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    
    UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onClickToEdit)];
    [self.view addGestureRecognizer:lp];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickToCancelEdit)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark --取消编辑状态
- (void)onClickToCancelEdit {
    _isEdit = NO;
    [self.collectionView reloadData];
}

#pragma mark --进入编辑状态
- (void)onClickToEdit {
    if (_isEdit) return;
    _isEdit = YES;
    [self.collectionView reloadData];
}

#pragma mark --collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _kindList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QYLMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kQYLMainCellIdentifier forIndexPath:indexPath];
    [cell updateCellWithKindModel:_kindList[indexPath.row] isEidt:_isEdit];
    __weak typeof(self) wself = self;
    [cell setRemoveBlock:^{
        [wself alertToRemoveFormboardWithIndex:indexPath.row];//删除模板操作
    }];
    [cell setSelectBlock:^{
        [wself onClickToSelectWithIndex:indexPath.row];
    }];
    return cell;
}

- (CGFloat)waterfallLayout:(QYLWaterfallLayout *)waterfallLayout indexPath:(NSIndexPath *)indexPath {
    return _cellWidth*_kindList[indexPath.row].imageScale;
}

#pragma mark --点击选中模板事件
- (void)onClickToSelectWithIndex:(NSInteger)index {
    if (_isEdit) {
        [self onClickToCancelEdit];
        return;
    }
    QYLCheckController *check = [[QYLCheckController alloc] initWithKindModel:_kindList[index]];
    [self.navigationController pushViewController:check animated:YES];
}

#pragma mark --删除选中模板
- (void)alertToRemoveFormboardWithIndex:(NSInteger)row {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kQYLConfirmDeleteTemplate message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:kQYLCancel style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:kQYLDetermine style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        QYLKindModel *kindModel = self.kindList[row];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //处理删除本地数组之外，还要删除图片和归档模型数据，以及模型的索引
        [fileManager removeItemAtPath:kindModel.imagePath error:nil];//删除原始图片
        [fileManager removeItemAtPath:kindModel.smallImagePath error:nil];//删除重绘图片
        [fileManager removeItemAtPath:self.kindModelPaths[row] error:nil];//
        //更新索引
        [self.kindModelPaths removeObjectAtIndex:row];
        [QYLCommont updateUserDefaults:self.kindModelPaths];
        
        [self.kindList removeObjectAtIndex:row];
        [self.collectionView reloadData];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kQYLNotificationUpdateFormboard object:nil];
    QYLog(nil);
}

@end
