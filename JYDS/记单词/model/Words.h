//
//  Words.h
//  JYDS
//
//  Created by liyu on 2016/12/27.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface Words : NSObject

@property (copy,nonatomic) NSString *payType;
@property (copy,nonatomic) NSString *word;
@property (copy,nonatomic) NSString *wordDetail;
@property (copy,nonatomic) NSString *wordID;
@property (copy,nonatomic) NSString *wordPrice;
@property (copy,nonatomic) NSString *wordImgUrl;
@property (copy,nonatomic) NSString *phonogram;//音标
@property (copy,nonatomic) NSString *wordSplit;//拆分
@property (copy,nonatomic) NSString *wordAssociate;//联想

@end
