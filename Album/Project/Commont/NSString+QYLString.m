//
//  NSString+QYLString.m
//  Album
//
//  Created by Marshal on 2017/10/20.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "NSString+QYLString.h"

@implementation NSString (QYLString)

- (NSString *)getCommontWithType:(NSInteger)type {
    NSString *str = self;
    if (!type) {
        str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSMutableString *newStr = [NSMutableString string];
        for (NSInteger idx = 0; idx < str.length; idx++) {
            unichar c = [str characterAtIndex:idx];
            if (idx > 0) {
                [newStr appendString:[NSString stringWithFormat:@"\n%C",c]];
            }else {
                [newStr appendString:[NSString stringWithFormat:@"%C",c]];
            }
        }
    }
    return str;
}

@end
