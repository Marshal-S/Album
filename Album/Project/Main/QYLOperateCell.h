//
//  QYLOperateCell.h
//  Album
//
//  Created by Marshal on 2017/10/13.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYLOperateCell : UITableViewCell

@property (nonatomic, copy) void (^selectTypeBlock)();

- (void)updateCellWithKindName:(NSString *)kindName;

@end
