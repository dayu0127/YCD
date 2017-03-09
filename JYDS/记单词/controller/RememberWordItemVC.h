//
//  RememberWordItemVC.h
//  JYDS
//
//  Created by dayu on 2016/11/30.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavViewController.h"
@protocol RememberWordItemVCDelegate<NSObject>
- (void)updateSubBean;
@end
@interface RememberWordItemVC : BaseNavViewController

@property (nonatomic,strong) NSString *classifyID;
@property (nonatomic,strong) NSString *unitID;
@property (nonatomic,weak) id<RememberWordItemVCDelegate> delegate;
@property (nonatomic,assign) BOOL isSub;

@end
