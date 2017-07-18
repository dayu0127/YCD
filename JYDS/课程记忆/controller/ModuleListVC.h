//
//  ModuleListVC.h
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModuleListVC : BaseViewController
@property (copy,nonatomic) NSString *classId;
/**当前单元所在课本订阅状态*/
@property (copy,nonatomic) NSString *payType;
@property (copy,nonatomic) NSString *gradeName;
@property (copy,nonatomic) NSString *full_price;
@property (copy,nonatomic) NSString *min_price;
@end
