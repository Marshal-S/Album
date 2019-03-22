//
//  QYLDetailKindData.m
//  Album
//
//  Created by Marshal on 2017/10/13.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLDetailKindData.h"
#import "QYLBaseKindModel.h"
#import <UIKit/UIColor.h>
#import "QYLEnum.h"


@implementation QYLDetailKindData

+ (NSArray *)textArray:(QYLOperateType)type {
    NSMutableArray *typeList = [NSMutableArray array];
    NSDictionary *typeDic = nil;
    switch (type) {
        case QYLOperateTypeTextType:
            typeDic = [self getTextTypeData];
            break;
        case QYLOperateTypeColor:
            typeDic = [self getTextColorData];
            break;
        case QYLOperateTypeFont:
            typeDic = [self getTextFontData];
            break;
        case QYLOperateTypeSize:
            break;
    }
    for (NSString *key in typeDic) {
        QYLBaseKindModel *kind = [[QYLBaseKindModel alloc] init];
        kind.kindName = key;
        kind.kindValue = typeDic[key];
        [typeList addObject:kind];
    };
    return typeList;
}


+ (NSDictionary *)getTextTypeData {
    return @{kQYLHorizontalText:@(QYLTextKindTypeHorizontal),
             kQYLVerticalText:@(QYLTextKindTypeVertical)};
}

+ (NSDictionary *)getTextColorData {
    return @{kQYLWhite:[UIColor whiteColor],
             kQYLRed:[UIColor redColor],
             kQYLBlack:[UIColor blackColor],
             kQYLOrange:[UIColor orangeColor],
             kQYLGray:[UIColor grayColor]};
}

+ (NSDictionary *)getTextFontData {
    return @{
             @"北方行书":@"beifang",
             @"方正吕建德":@"FZZJ-LJDFONT",
             @"方正启笛简体":@"FZQiDiS-R-GB",
             @"方正清刻本悦宋简":@"FZQingKeBenYueSongS-R-GB",
             @"汉仪行楷繁":@"HYXingkaiF",
             @"汉仪行楷简":@"HYXingKaiJ",
             @"汉仪颜楷繁":@"HYYanKaiF"};
}


+ (NSArray *)getFamilyName {
    NSString *familyName = @"赵 钱 孙 李 周 吴 郑 王 冯 陈 褚 卫 蒋 沈 韩 杨 朱 秦 尤 许 何 吕 施 张 孔 曹 严 华 金 魏 陶 姜 戚 谢 邹 喻 柏 水 窦 章 云 苏 潘 葛 奚 范 彭 郎 鲁 韦 昌 马 苗 凤 花 方 俞 任 袁 柳 酆 鲍 史 唐 费 廉 岑 薛 雷 贺 倪 汤 滕 殷 罗 毕 郝 安 常 乐 于 时 傅 皮 卞 齐 康 伍 余 元 卜 顾 孟 平 黄 和 穆 萧 尹 姚";
    return [familyName componentsSeparatedByString:@" "];
}

+ (NSArray *)getName {
    NSString *nameStr = @"邢佳栋 李学庆 高昊 潘粤明 戴军 薛之谦 贾宏声 于波 李连杰 王斑 蓝雨 刘恩佑 任泉 李光洁 姜文 黑龙 张殿菲 邓超 张杰 杨坤 沙溢 李茂 黄磊 于小伟 黄志忠 李晨 后弦 王挺 何炅 朱亚文 胡军 许亚军 张涵予 贾乃亮 陆虎 印小天 于和伟 田亮 夏雨 李亚鹏 胡兵 王睿 保剑锋 于震 苏醒 胡夏 张丰毅 刘翔 李玉刚 林依轮 袁弘 朱雨辰 丁志诚 黄征 张子健 许嵩 向鼎 陆毅 乔振宇 闫肃 李健 王啸坤 胡歌 吉杰 吴俊余 韩寒 黄海冰 魏晨 郭敬明 何晟铭 巫迪文 谢苗 郑源 欢子 文章 陈翔 井柏然 含笑 李咏 徐誉滕 段奕宏 李炜 罗中旭 张远 李立 释小龙 大左 毛宁 樊凡 周一围于荣光 汤潮 张晓晨 吴京 山野 陈龙 侯勇 张国强 玉米提 周觅 张丹峰 俞思远 姚明 冯绍峰 陈玉建 吴建飞 郑钧 胡彦斌 李智楠 钱枫 高曙光 谢和弦 陈道明 柳云龙 汪峰 陈楚生 陈思成 魏晨 马雪阳 袁成杰 崔健 杜淳 林申 刘洲成 黄晓明 刘烨 张翰 杨洋 宋晓波 解小东 窦唯 姜武 陈泽宇 彭坦 张一山 李易峰 严宽 张国立 王志文 佟大为 柏栩栩 蒲巴甲 凌潇肃 李行亮 毛方圆 张嘉译 大张伟 师洋 李幼斌 张磊 朱梓骁 武艺 杨俊毅 耿乐 钱泳辰 撒贝宁 徐峥 谭杰希 黄晟晟 海鸣威 汪涵 王学兵 贾一平 孙红雷 袁文康 蔡国庆 吴秀波 王栎鑫 安琥 刘心 俞灏明 张超 于小彤 张峻宁 乔任梁朴树 赵帆 张译 聂远 张敬轩 付辛博 黄明 杜海涛";
    return [nameStr componentsSeparatedByString:@" "];
}

@end
