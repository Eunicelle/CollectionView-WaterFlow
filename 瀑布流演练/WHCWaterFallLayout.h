//
//  WHCWaterFallLayout.h
//  瀑布流演练
//
//  Created by 王海晨 on 15/12/31.
//  Copyright © 2015年 whc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHCWaterFallLayout : UICollectionViewFlowLayout

///  列数
@property (nonatomic,assign) NSInteger column;
///  模型数组
@property (nonatomic,strong) NSArray *dataList;

@end
