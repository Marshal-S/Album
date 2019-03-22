//
//  NSString+QYLString.h
//  Album
//
//  Created by Marshal on 2017/10/20.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QYLString)

- (NSString *)getCommontWithType:(NSInteger)type;//type=0为竖文本，否则横文本

@end
