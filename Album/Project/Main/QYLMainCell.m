//
//  QYLMainViewCell.m
//  Album
//
//  Created by Marshal on 2017/10/11.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLMainCell.h"
#import "QYLKindModel.h"
#import "UIView+S_Extend.h"

@interface QYLMainCell ()

@property (nonatomic, strong) QYLKindModel *kindModel;
@property (nonatomic, strong) UIImageView *ivKind;
@property (nonatomic, strong) UIButton *removeView;

@end

@implementation QYLMainCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initContentView];
    }
    return self;
}

- (void)initContentView {
    _ivKind = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.s_width, self.s_height)];
    _ivKind.clipsToBounds = YES;
    _ivKind.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_ivKind];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickToSelect)];
    [self.contentView addGestureRecognizer:tap];
    
    _removeView = [[UIButton alloc] init];
    _removeView.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 15, 15);
    [_removeView setImage:[UIImage imageNamed:@"delete_pic"] forState:UIControlStateNormal];
    [_removeView addTarget: self action:@selector(onClickToRemoveKind) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_removeView];
}

- (void)onClickToSelect {
    if (_selectBlock) _selectBlock();
}

- (void)onClickToRemoveKind {
    if (_removeBlock) _removeBlock();
}

- (void)updateCellWithKindModel:(QYLKindModel *)kindModel isEidt:(BOOL)isEidt {
    _kindModel = kindModel;
    _removeView.hidden = !isEidt;
    _ivKind.frame = CGRectMake(0, 0, self.s_width, self.s_height);
    _removeView.frame = CGRectMake(-10, -10, 60, 60);
    _ivKind.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:kindModel.smallImagePath]];
    if (isEidt) {
        CABasicAnimation *base = [CABasicAnimation animationWithKeyPath:@"transform"];
        base.fromValue = [NSNumber valueWithCATransform3D:CATransform3DRotate(_ivKind.layer.transform, -0.03, 0, 0, 1)];
        base.toValue = [NSNumber valueWithCATransform3D:CATransform3DRotate(_ivKind.layer.transform, 0.03, 0, 0, 1)];
        base.duration = 0.4;
        base.repeatCount = NSIntegerMax;
        base.autoreverses = YES;
        [_ivKind.layer addAnimation:base forKey:@"huangdong"];
    }else {
        [_ivKind.layer removeAllAnimations];
    }
}


@end
