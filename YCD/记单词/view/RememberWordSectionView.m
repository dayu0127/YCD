//
//  RememberWordSectionView.m
//  YCD
//
//  Created by dayu on 2016/11/26.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "RememberWordSectionView.h"
@implementation RememberWordSectionView

- (instancetype)initWithFrame:(CGRect)frame detailDic:(NSDictionary *)dic{
    if (self = [super initWithFrame:frame]) {
        CGFloat width = frame.size.width;
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width-10, TITLE_HEIGHT)];
        titleLabel.text = dic[@"name"];
        [self addSubview:titleLabel];
        //详情
        NSArray *detailArr = dic[@"detail"];
        NSInteger item_row = detailArr.count%2==0 ? detailArr.count/2 : detailArr.count/2+1;
        for (NSInteger row=0; row<item_row; row++) {
            CGFloat y=TITLE_HEIGHT+row*(ITEM_HEIGHT+5),item_width=(width-20)*0.5;
            for (NSInteger col=0; col<2; col++) {
                NSInteger index = row*2+col;
                if (row == item_row-1&& col == 1 && index %2!=0) {
                    break;
                }
                CGFloat x = col == 0 ? 10 : 15+item_width;
                UILabel *item_label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, item_width, ITEM_HEIGHT)];
                item_label.backgroundColor = [UIColor orangeColor];
                item_label.text = [detailArr objectAtIndex:index];
                item_label.font = [UIFont systemFontOfSize:15.5f];
                [self addSubview:item_label];
            }
        }
//        if (item_row%2==1) {
//            <#statements#>
//        }else{
//            
//        }
    }
    return self;
}
@end
