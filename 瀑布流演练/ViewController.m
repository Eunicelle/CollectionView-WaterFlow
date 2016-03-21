//
//  ViewController.m
//  瀑布流演练
//
//  Created by 王海晨 on 15/12/31.
//  Copyright © 2015年 whc. All rights reserved.
//

#import "ViewController.h"
#import "WHCShops.h"
#import "WHCWaterFallLayout.h"
#import "WHCWaterfallImageCell.h"
#import "WHCWaterfallFooterView.h"

@interface ViewController ()

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) NSMutableArray *shops;

@property (weak, nonatomic) IBOutlet WHCWaterFallLayout *layout;

// 记录指示器状态
@property (nonatomic,assign,getter = isLoading) BOOL loading;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载数据
    [self loadData];
    
    self.loading = NO;
}

#pragma mark - 加载数据
- (void)loadData {
    [self.shops addObjectsFromArray:[WHCShops shopsWithIndex:_index]];
    
    _index++;
    
    // 定义waterFallLayout相关属性
    self.layout.column = 3;
    
    self.layout.dataList = self.shops;
    
    // 刷新 collectionView 的数据源方法
    [self.collectionView reloadData];
}

#pragma mark - 懒加载
- (NSMutableArray *)shops{
    if (_shops == nil) {
        _shops = [[NSMutableArray alloc]init];
    }
    return _shops;
}

#pragma mark - 数据源方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _shops.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WHCWaterfallImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    // 设置随机颜色
    cell.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    
    cell.shop = self.shops[indexPath.item];
    
    return cell;
}

///  设值reusableView的方法 设置collectionView的页头、页脚
///  @param kind           类型： 页头、页脚
///  SupplementaryView 追加视图
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    // 判断是否是页脚
    if (kind == UICollectionElementKindSectionFooter) {
        // 追加视图
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        
        return footerView;
    }
    return nil;
}

///  即将显示追加视图是调用 处理activityIndicator 和加载数据
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    // 判断追加是页尾 判断字符串相等，比较地址
    if (elementKind == UICollectionElementKindSectionFooter) {
//        [self.activityIndicator startAnimating];
        
        WHCWaterfallFooterView *footerView = (WHCWaterfallFooterView *)view;
        
        // 避免重复加载
        if (!self.isLoading) {
            
            self.loading = YES;
            // 开始动画
            [footerView.indicator startAnimating];
            
            // 模拟网络延迟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 加载数据
                [self loadData];
                
                self.loading = NO;
                [footerView.indicator stopAnimating];
            });
        }
    }
}
@end
