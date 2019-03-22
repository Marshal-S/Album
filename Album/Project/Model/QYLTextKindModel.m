//
//  QYLTextKindModel.m
//  Album
//
//  Created by Marshal on 2017/10/11.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLTextKindModel.h"
#import <YYModel/YYModel.h>
#import <UIKit/UIColor.h>

@implementation QYLTextKindModel

- (instancetype)init {
    if (self = [super init]) {
        [self typeModel];
        [self colorModel];
        [self fontModel];
        [self sizeModel];
    }
    return self;
}

- (QYLBaseKindModel *)typeModel {
    if (!_typeModel) {
        _typeModel = [[QYLBaseKindModel alloc] init];
        _typeModel.kindName = kQYLHorizontalText;
        _typeModel.kindValue = @(QYLTextKindTypeHorizontal);
    }
    return _typeModel;
}

- (QYLBaseKindModel *)colorModel {
    if (!_colorModel) {
        _colorModel = [[QYLBaseKindModel alloc] init];
        _colorModel.kindName = kQYLWhite;
        _colorModel.kindValue = [UIColor whiteColor];
    }
    return _colorModel;
}

- (QYLBaseKindModel *)fontModel {
    if (!_fontModel) {
        _fontModel = [[QYLBaseKindModel alloc] init];
        _fontModel.kindName = @"汉仪行楷简";
        _fontModel.kindValue = @"HYXingKaiJ";
    }
    return _fontModel;
}

- (QYLBaseKindModel *)sizeModel {
    if (!_sizeModel) {
        _sizeModel = [[QYLBaseKindModel alloc] init];
        _sizeModel.kindName = @"32px";
        _sizeModel.kindValue = @(16);
    }
    return _sizeModel;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone {
    QYLTextKindModel *kindModel = [self yy_modelCopy];
    kindModel.typeModel = [self.typeModel copy];
    kindModel.colorModel = [self.colorModel copy];
    kindModel.fontModel = [self.fontModel copy];
    kindModel.sizeModel = [self.sizeModel copy];
    return kindModel;
}

- (NSUInteger)hash {
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}

@end
