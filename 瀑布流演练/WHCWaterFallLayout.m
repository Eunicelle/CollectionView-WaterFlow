//
//  WHCWaterFallLayout.m
//  瀑布流演练
//
//  Created by 王海晨 on 15/12/31.
//  Copyright © 2015年 whc. All rights reserved.
//  自定义瀑布流Layout

#import "WHCWaterFallLayout.h"
#import "WHCShops.h"

@interface WHCWaterFallLayout ()

///  自定义的 itme 属性数组
@property (nonatomic,strong) NSArray *attributes;

@property (nonatomic,assign) CGFloat highestHeight;

@end

@implementation WHCWaterFallLayout

///  系统提供的 contentSize 的set方法
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.highestHeight - self.minimumLineSpacing + 50);
}

// 准备布局，当 collectionView 布局发生变化时会被调用
// 通常做布局准备工作
- (void)prepareLayout {
    
    // 打印执行顺序（数据传递、和准备布局）
//    NSLog(@"%s,%@",__FUNCTION__,_dataList);
    
    // 计算item 的宽度
    // 内容的宽度：减去两个边的内边距，该值是在sb中设置的
    CGFloat contentW = self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right;
    
    CGFloat itemW = (contentW - (self.column - 1) * self.minimumInteritemSpacing) / self.column;
    
    // 计算attribute
    [self attributes:itemW];
}

- (void)attributes:(CGFloat)itmeW {
    
    // 定义一个数组，保存每列当前的高度（item高度加行间距）
    CGFloat colHeight[self.column];
    // 定义一个数组，保存每列当前有几个 item
    NSInteger colCount[self.column];
    for (int i = 0; i< self.column; ++i) {
        // 每列的起始高度为上边距
        colHeight[i] = self.sectionInset.top;
        // 每列起始没有item
        colCount[i] = 0;
    }
    
    // 创建一个数组保存自定义的LayoutAttributes
    NSMutableArray *arrayM = [NSMutableArray array];
    
    // 设置模型索引
    NSInteger index = 0;
    // 遍历数据模型
    for (WHCShops *shop in self.dataList) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        
        // 自定义LayoutAttributes
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        // 查找高度最小的列数
        NSInteger col = [self shortestColumn:colHeight];
        
        // 高度最小列 item 数+1
        colCount[col]++;
        
        CGFloat x = self.sectionInset.left + col * (itmeW + self.minimumInteritemSpacing);
        // 列数的最大y
        CGFloat y = colHeight[col];
        // 根据 plist 的宽高等比例缩放 h
        CGFloat h = [self itemHeightWith:CGSizeMake(shop.w, shop.h) itemWidth:itmeW];
        
        attr.frame = CGRectMake(x, y, itmeW, h);
        
        // 数据的索引
        index++;
        
        // 累加该列的高度
        colHeight[col] += (self.minimumLineSpacing + h);
        
        [arrayM addObject:attr];
    }
    
    // 找到高度最大的列
    long highestColIndex = [self highestColumn:colHeight];
    // 记录最大高度
    self.highestHeight = colHeight[highestColIndex];
    
    // 计算最大高度列每个item的高度 （最大高度的列 / 行数 = (item + 行间距)的平均值 - 行间距 = 最高列 item 的平均高度）
//    CGFloat h = colHeight[highestColIndex] / colCount[highestColIndex] - self.minimumLineSpacing;
    // collectionView 的 contentOffset 根据itemSize 动态计算
//    self.itemSize = CGSizeMake(itmeW, h);
    
    
    // 添加页脚属性
    UICollectionViewLayoutAttributes *footerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    // 最大高度列值 - 行间距
    footerAttr.frame = CGRectMake(0, colHeight[highestColIndex] - self.minimumLineSpacing, self.collectionView.bounds.size.width, 50);
    
    [arrayM addObject:footerAttr];
    
    self.attributes = [arrayM copy];
}

///  等比例缩放
- (CGFloat)itemHeightWith:(CGSize)size itemWidth:(CGFloat)itemW
{
    return size.height / size.width * itemW;
}

///  计算最短列
///  @param colHeight 保存每列高度的数组
///  @return 返回最短列的index
- (NSInteger)shortestColumn:(CGFloat *)colHeight {
    NSInteger colIndex = 0;
    CGFloat min = MAXFLOAT;
    
    for (int i = 0; i< self.column; ++i) {
        
        if (colHeight[i] < min) {
            min = colHeight[i];
            colIndex = i;
        }
    }
    return colIndex;
}

///  计算最高列
///  @param colHeight 保存每列高度的数组，C语言的数组名就是数组的首地址
///  @return 返回最大高度列的index
- (NSInteger)highestColumn:(CGFloat *)colHeight {
    CGFloat max = 0;
    NSInteger colIndex = 0;
    
    for (int i = 0; i< self.column; ++i) {
        
        if (colHeight[i] > max) {
            max = colHeight[i];
            colIndex = i;
        }
    }
    return colIndex;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return _attributes;
}

// 返回 collectionView 所有 item 的属性数组
//- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
//    
//    // 打印父类的数组查看内容
//    NSArray *array = [super layoutAttributesForElementsInRect:rect];
//    
//    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:array];
//    
//    [arrayM enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * attr, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        // 修改数组中的 item 属性的frame值
//        attr.frame = CGRectMake(0, 0, 200, 100);
//    }];
//    
//    return arrayM;
//}


@end
