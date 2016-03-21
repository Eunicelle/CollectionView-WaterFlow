//
//  WHCShops.m
//  瀑布流演练
//
//  Created by 王海晨 on 15/12/31.
//  Copyright © 2015年 whc. All rights reserved.
//  数据模型

#import "WHCShops.h"

@implementation WHCShops

+ (instancetype)shopWithDict:(NSDictionary *)dict{
    id obj = [[self alloc]init];
    
    [obj setValuesForKeysWithDictionary:dict];
    
    return obj;
}

+ (NSArray *)shopsWithIndex:(NSInteger)index{
    
    // 读取plist路径
    NSString *filePaht = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%ld.plist",index%3+1] ofType:nil];
    
    // 读取数组
    NSArray* array = [NSArray arrayWithContentsOfFile:filePaht];
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:array.count];
    
    // 遍历数组，字典转模型
    for (NSDictionary *dict in array) {
        [arrayM addObject:[WHCShops shopWithDict:dict]];
    }
    // 为了安全性，将NSMutableArray赋值成不可变的数组
    return [arrayM copy];
}

@end
