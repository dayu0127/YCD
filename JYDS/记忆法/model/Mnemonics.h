//
//  Mnemonics.h
//  JYDS
//
//  Created by liyu on 2016/12/24.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mnemonics : NSObject
//courseID = 1;
//courseImageUrl = "wx_fmt=gif&tp=webp&wxfrom=5&wx_lazy=1";
//courseInstructions = "\U8fd9\U662f\U4e00\U90e8\U5f88\U77ed\U7684\U89c6\U9891";
//courseName = "\U8bb0\U5fc6\U6cd5\U8bfe\U7a0b";
//coursePayStatus = 0;
//coursePrice = 20;
//courseTitle = "\U8fd9\U662f\U4e00\U90e8\U5f88\U4e0d\U9519\U7684\U89c6\U9891";
//courseVideo = "http://baobab.wdjcdn.com/14564977406580.mp4";
@property (copy,nonatomic) NSString *courseID;
@property (copy,nonatomic) NSString *courseImageUrl;
@property (copy,nonatomic) NSString *courseInstructions;
@property (copy,nonatomic) NSString *courseName;
@property (copy,nonatomic) NSString *coursePayStatus;
@property (copy,nonatomic) NSString *coursePrice;
@property (copy,nonatomic) NSString *courseTitle;
@property (copy,nonatomic) NSString *courseVideo;
@end
