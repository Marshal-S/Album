//
//  QYLCommont.m
//  Album
//
//  Created by Marshal on 2017/10/13.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLCommont.h"

NSString * const kQYLKindModelPathKey = @"kQYLKindModelPathKey";

@implementation QYLCommont

+ (NSString *)getKindModelPathWithInterval:(long)interval {
    return [self getPathWithKindName:[NSString stringWithFormat:@"kindModel%ld",interval]];
}

+ (NSString *)getPathWithKindName:(NSString *)kindName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    ;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/formboard/"];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]; 
    }
    return [path stringByAppendingString:kindName];
}

+ (NSString *)getImagePathWithInterval:(long)interval {
    return [self getPathWithKindName:[NSString stringWithFormat:@"img%ld.png",interval]];
}

+ (NSString *)getReRenderImagePathWithInterval:(long)interval {
    return [self getPathWithKindName:[NSString stringWithFormat:@"reRenderImg%ld.png",interval]];
}

//这个object为QYLKindModel类型
+ (void)saveToUserDefaults:(id)KindModelPath {
    NSMutableArray *kindModelList = [NSMutableArray array];
    kindModelList.array = [self getUserDefaultObject];
    [kindModelList insertObject:KindModelPath atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:kindModelList forKey:kQYLKindModelPathKey];
    [[NSUserDefaults standardUserDefaults] synchronize];//强制写入
}

+ (void)updateUserDefaults:(NSArray *)kindModelList {
    [[NSUserDefaults standardUserDefaults] setObject:kindModelList forKey:kQYLKindModelPathKey];
    [[NSUserDefaults standardUserDefaults] synchronize];//强制写入
}

+ (NSArray *)getUserDefaultObject {
    NSArray *kindList = [[NSUserDefaults standardUserDefaults] objectForKey:kQYLKindModelPathKey];
    return kindList ? kindList : [NSArray array];
}

@end
