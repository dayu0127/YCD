//
//  MemoryComment.h
//  JYDS
//
//  Created by liyu on 2017/4/12.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoryComment : NSObject
//\"commentId\": \"1\",
//\"content\": \"good\",
//\"likes\": 1,
//\"create_time\": \"2017-04-1210: 42: 10\",
//\"nick_name\": \"记忆大师\",
//\"head_img\": \"20170408182350.png\"
@property (copy, nonatomic) NSString *commentId;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *likes;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *nick_name;
@property (copy, nonatomic) NSString *head_img;
@end
