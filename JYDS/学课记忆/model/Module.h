//
//  Module.h
//  JYDS
//
//  Created by liyu on 2017/4/8.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Module : NSObject
//\"unitName\": \"Module1\",
//\"id\": \"c33008960f6d11e7a51c02004c4f4f50\",
//\"classId\":\"7920306d0f6b11e7a51c02004c4f4f50\"
@property (copy,nonatomic) NSString *unitName;
@property (copy,nonatomic) NSString *unitId;
@property (copy,nonatomic) NSString *classID;
@end
