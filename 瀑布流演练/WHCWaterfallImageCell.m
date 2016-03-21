//
//  WHCWaterfallImageCell.m
//  瀑布流演练
//
//  Created by 王海晨 on 15/12/31.
//  Copyright © 2015年 whc. All rights reserved.
//  自定义Cell

#import "WHCWaterfallImageCell.h"
#import <UIImageView+WebCache.h>
#import "WHCShops.h"

@interface WHCWaterfallImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation WHCWaterfallImageCell

- (void)setShop:(WHCShops *)shop{
    _shop = shop;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:shop.img]];
    self.priceLabel.text = shop.price;
}

@end
