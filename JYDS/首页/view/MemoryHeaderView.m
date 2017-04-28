//
//  MemoryHeaderView.m
//  JYDS
//
//  Created by liyu on 2017/3/23.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MemoryHeaderView.h"

@implementation MemoryHeaderView

+ (instancetype)loadView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}
@end
