//
//  Version.h
//  JYDS
//
//  Created by liyu on 2017/4/7.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Version : NSObject
//\"id\": \"7920306d0f6b11e7a51c02004c4f4f50\",
//\"class_name\": \"牛津上海版\",
//\"total_words\": 172,
//\"full_price\": 3600.00,
//\"imgurl\": \"0\",
//\"payType\": \"0\"
@property (copy,nonatomic) NSString *version_id;
@property (copy,nonatomic) NSString *class_name;
@property (copy,nonatomic) NSString *grade_name;
@property (copy,nonatomic) NSString *total_words;
@property (copy,nonatomic) NSString *full_price;
@property (copy,nonatomic) NSString *imgurl;
@property (copy,nonatomic) NSString *payType;

@end
