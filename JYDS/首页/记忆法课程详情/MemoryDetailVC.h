//
//  MemoryDetailVC.h
//  JYDS
//
//  Created by liyu on 2017/4/8.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Memory.h"
@protocol MemoryDetailVCDelegate<NSObject>
- (void)reloadMemoryList;
@end
@interface MemoryDetailVC : BaseViewController
@property (copy,nonatomic) NSString *commentId;
@property (strong,nonatomic) Memory *memory;
@property (weak,nonatomic) id<MemoryDetailVCDelegate> delegate;
@property (assign,nonatomic) BOOL isLike;
@end
