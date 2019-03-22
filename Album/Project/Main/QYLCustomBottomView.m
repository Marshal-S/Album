//
//  QYLCustomBottomView.m
//  Album
//
//  Created by Marshal on 2017/10/11.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLCustomBottomView.h"
#import "QYLTextKindModel.h"
#import "UIView+S_Extend.h"
#import "QYLEnum.h"

@interface QYLCustomBottomView ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *btnList;//底部按钮的数组列表，用户赋值

@end

@implementation QYLCustomBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _btnList = [NSMutableArray arrayWithCapacity:4];
        [self initContentView];
    }
    return self;
}

#pragma mark --初始化内部视图
- (void)initContentView {
    CGFloat width = self.s_width/4;
    NSAssert(self.s_height>=44, @"高度要不小于44，才能有更好的点击体验");
    self.backgroundColor = [UIColor blackColor];
    for (NSInteger idx = 0; idx < 4; idx++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(idx*width, 0, width, 49)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        btn.tag = 10+idx;
        [btn addTarget:self action:@selector(onClickToChangeKind:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [_btnList addObject:btn];
    }
}

#pragma mark --用于初始化或者更换文本
- (void)setTextKindModel:(QYLTextKindModel *)textKindModel {
    if (!textKindModel) return;
    [_btnList[0] setTitle:textKindModel.typeModel.kindName forState:UIControlStateNormal];
    [_btnList[1] setTitle:textKindModel.colorModel.kindName forState:UIControlStateNormal];
    [_btnList[2] setTitle:textKindModel.fontModel.kindName forState:UIControlStateNormal];
    [_btnList[3] setTitle:textKindModel.sizeModel.kindName forState:UIControlStateNormal];
    _textKindModel = textKindModel;
}

#pragma mark --更新状态,返回是否更换新的值
- (BOOL)updateBottomText:(QYLBaseKindModel *)kindModel operateType:(QYLOperateType)operateType {
    UIButton *btnOperate = _btnList[operateType];
    if ([kindModel.kindName isEqualToString:btnOperate.titleLabel.text]){
        return NO;
    }
    [btnOperate setTitle:kindModel.kindName forState:UIControlStateNormal];
    return YES;
}

#pragma mark --点击事件
- (void)onClickToChangeKind:(UIButton *)sender {
    if (sender.tag == 10) {
        if (_textTypeBlock) _textTypeBlock();
    }else if (sender.tag == 11) {
        if (_textColorBlock) _textColorBlock();
    }else if (sender.tag == 12) {
        if (_textFontBlock) _textFontBlock();
    }else {
        if (_textSizeBlock) _textSizeBlock();
    }
}

- (void)dealloc {
    QYLog(nil);
}

@end
