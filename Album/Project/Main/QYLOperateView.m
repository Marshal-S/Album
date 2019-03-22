//
//  QYLOperateView.m
//  Album
//
//  Created by Marshal on 2017/10/11.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLOperateView.h"
#import "QYLBaseKindModel.h"
#import "UIView+S_Extend.h"
#import "QYLOperateCell.h"

NSString *kQYLOperateCellIdentifier = @"kQYLOperateCellIdentifier";

@interface QYLOperateView ()<UITableViewDataSource, UITableViewDelegate>
{
    CGFloat _cellWidth;
    CGRect _operateFrame;
}

@property (nonatomic, assign) QYLOperateType operateType;
@property (nonatomic, strong) NSArray<QYLBaseKindModel *> *kindList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation QYLOperateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectZero]) {
        _operateFrame = frame;
        [self initContentView];
    }
    return self;
}

- (void)initContentView {
    _cellWidth = _operateFrame.size.width/4;
    self.backgroundColor = [UIColor clearColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[QYLOperateCell class] forCellReuseIdentifier:kQYLOperateCellIdentifier];
    _tableView.bounces = NO;
    _tableView.rowHeight = 40;
    _tableView.separatorColor = [UIColor blackColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.hidden = YES;
    [self addSubview:_tableView];
    
    _slider = [[UISlider alloc] init];
    _slider.backgroundColor = [UIColor blackColor];
    _slider.maximumTrackTintColor = [UIColor whiteColor];
    _slider.minimumTrackTintColor = [UIColor greenColor];
    _slider.hidden = YES;
    [_slider addTarget:self action:@selector(onValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_slider];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenOperateView)];
    [self addGestureRecognizer:tap];
}

#pragma mark --滑块的值变动的反馈事件
- (void)onValueChanged:(UISlider *)sender {
    if (!_updateKindBlock) return;
    float value = sender.value*150;
    QYLBaseKindModel *kindModel = [[QYLBaseKindModel alloc] init];
    kindModel.kindName = [NSString stringWithFormat:@"%.0fpx",2*value];
    kindModel.kindValue = @(value);
    _updateKindBlock(_operateType, kindModel);
}

#pragma mark -设置新的值的时候的反馈事件
- (void)wakeUpOperateViewWithBaseKindModelList:(NSArray<QYLBaseKindModel*> *)kindList operateType:(QYLOperateType)operateType {
    self.frame = _operateFrame;
    _kindList = kindList;
    _operateType = operateType;
    
    CGFloat height = kindList.count*40;
    height = height < self.s_height ? height : self.s_height;
    
    switch (operateType) {
        case QYLOperateTypeSize: {
            //颠倒个头进行翻转
            _slider.center = CGPointMake((operateType+0.5)*_cellWidth, self.s_height-150);
            _slider.bounds =  CGRectMake(0, 0, 300, _cellWidth-30);
            _slider.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI_2);
            _tableView.hidden = YES;
            _slider.hidden = NO;
            _slider.value = [kindList[0].kindValue floatValue]/150;
        }break;
        default: {
            _tableView.frame = CGRectMake(operateType*_cellWidth, self.s_height-height, _cellWidth, height);
            _slider.hidden = YES;
            _tableView.hidden = NO;
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_kindList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

#pragma mark --tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _kindList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYLOperateCell *cell = [tableView dequeueReusableCellWithIdentifier:kQYLOperateCellIdentifier forIndexPath:indexPath];
    QYLBaseKindModel *kindModel = _kindList[indexPath.row];
    [cell updateCellWithKindName:[kindModel kindName]];
    __weak typeof(self) wself = self;
    [cell setSelectTypeBlock:^{
        [wself updateForboard:kindModel];
    }];
    return cell;
}

#pragma mark --点击cell选择后更新cell事件
- (void)updateForboard:(QYLBaseKindModel *)kindModel {
    if (_updateKindBlock) _updateKindBlock(_operateType, kindModel);
    [self hiddenOperateView];
}

#pragma mark --隐藏该视图，防止手势冲突
- (void)hiddenOperateView {
    self.frame = CGRectZero;
    _tableView.frame = CGRectZero;
    _slider.frame = CGRectZero;
    [self.superview endEditing:YES];
}

- (void)dealloc {
    QYLog(nil);
}

@end
