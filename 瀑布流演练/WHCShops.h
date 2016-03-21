//
//  WHCShops.h
//  瀑布流演练
//
//  Created by 王海晨 on 15/12/31.
//  Copyright © 2015年 whc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHCShops : NSObject

///  高度
@property (nonatomic,assign) float h;
///  宽度
@property (nonatomic,assign) float w;
///  图片地址
@property (nonatomic,copy) NSString *img;
///  单价
@property (nonatomic,copy) NSString *price;

///  模型构造方法
+ (instancetype)shopWithDict:(NSDictionary *)dict;

///  数据访问方法
+ (NSArray *)shopsWithIndex:(NSInteger)index;

@end
