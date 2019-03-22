//
//  Test.m
//  Album
//
//  Created by Marshal on 2017/10/11.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLKindModel.h"
#import <YYModel/YYModel.h>

@implementation QYLKindModel

- (instancetype)init {
    if (self = [super init]) {
        [self firstKindModel];
        [self lastKindModel];
    }
    return self;
}

- (QYLTextKindModel *)firstKindModel {
    if (!_firstKindModel) {
        _firstKindModel = [[QYLTextKindModel alloc] init];
        _firstKindModel.frame = CGRectMake(20, 10, 300, 120);
        _firstKindModel.text = @"雨巷";
    }
    return _firstKindModel;
}

- (QYLTextKindModel *)lastKindModel {
    if (!_lastKindModel) {
        _lastKindModel = [[QYLTextKindModel alloc] init];
        _lastKindModel.frame = CGRectMake(20, 140, 300, 120);
        _lastKindModel.text = @"像我一样的凄婉迷茫";
    }
    return _lastKindModel;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone {
    QYLKindModel *kindModel = [self yy_modelCopy];
    kindModel.firstKindModel = [self.firstKindModel copy];
    kindModel.lastKindModel = [self.lastKindModel copy];
    return kindModel;
}

- (NSUInteger)hash {
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}

- (instancetype)getRealKindModel {
    QYLKindModel *newKindModel = [self copy];
    newKindModel.bounds = CGRectMake(0, 0, newKindModel.bounds.size.width*_scale, newKindModel.bounds.size.height*_scale);
    
    QYLTextKindModel *firstKindModel = newKindModel.firstKindModel;
    CGRect fF = firstKindModel.frame;
    firstKindModel.frame = CGRectMake(fF.origin.x*_scale, fF.origin.y*_scale, fF.size.width*_scale, fF.size.height*_scale);
    QYLBaseKindModel *sizeModel = firstKindModel.sizeModel;
    sizeModel.kindValue = @([sizeModel.kindValue floatValue]*_scale);
    
    QYLTextKindModel *lastKindModel = newKindModel.lastKindModel;
    fF = lastKindModel.frame;
    lastKindModel.frame = CGRectMake(fF.origin.x*_scale, fF.origin.y*_scale, fF.size.width*_scale, fF.size.height*_scale);
    sizeModel = lastKindModel.sizeModel;
    sizeModel.kindValue = @([sizeModel.kindValue floatValue]*_scale);
    return newKindModel;
}

@end
