//
//  WordListVC.h
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordListVC : BaseViewController
@property (copy,nonatomic) NSString *classId;
@property (copy,nonatomic) NSString *unitId;
/**当前单元所在课本订阅状态*/
@property (copy,nonatomic) NSString *payType;
@end
