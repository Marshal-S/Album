//
//  QYLBaseKindModel.m
//  Album
//
//  Created by Marshal on 2017/10/11.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLBaseKindModel.h"
#import <YYModel/YYModel.h>

@implementation QYLBaseKindModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

- (NSUInteger)hash {
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}


@end
