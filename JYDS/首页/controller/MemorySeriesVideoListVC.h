//
//  MemorySeriesVideoListVC.h
//  JYDS
//
//  Created by liyu on 2017/5/2.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "BaseViewController.h"
@interface MemorySeriesVideoListVC : BaseViewController
@property (copy,nonatomic) NSString *lessonId;
@property (copy,nonatomic) NSString *lessonName;
@property (copy,nonatomic) NSString *lessonPayType;
//@property (weak,nonatomic) id<MemorySeriesVideoListVCDelegate> delegate;
@end
