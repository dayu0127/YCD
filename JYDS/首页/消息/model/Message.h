//
//  Message.h
//  JYDS
//
//  Created by liyu on 2017/4/17.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
//\"notifyId\": \"55c5e8600f7111e7a51c02004c4f4f50\",
//\"n_title\": \"测试\",
//\"n_content\": \"www.baidu.com\",
//\"create_time\": \"2017-04-1317: 00: 23\",
//\"imgUrl\": \"https: //omjbfvi08.qnssl.com/a/1.jpg\",
//\"type_name\": \"公告\"
@property (copy,nonatomic) NSString *notifyId;
@property (copy,nonatomic) NSString *n_title;
@property (copy,nonatomic) NSString *n_content;
@property (copy,nonatomic) NSString *create_time;
@property (copy,nonatomic) NSString *imgUrl;
@property (copy,nonatomic) NSString *type_name;

@end
