//
//  WordSearchListVC.h
//  JYDS
//
//  Created by liyu on 2017/4/22.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordSearchListVC : BaseViewController
@property (strong,nonatomic) NSArray *wordSearchResultArray;
@property (copy,nonatomic) NSString *searchContent;
@end
