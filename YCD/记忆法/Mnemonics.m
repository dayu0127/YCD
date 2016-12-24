//
//  Mnemonics.m
//  YCD
//
//  Created by liyu on 2016/12/24.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "Mnemonics.h"

@implementation Mnemonics
- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.courseImageUrl = dic[@"courseImageUrl"];
        self.courseInstructions = dic[@"courseInstructions"];
        self.courseName = dic[@"courseName"];
        self.coursePayStatus = [NSString stringWithFormat:@"%@",dic[@"coursePayStatus"]];
        self.coursePrice = [NSString stringWithFormat:@"%@",dic[@"coursePrice"]];
        self.courseTitle = dic[@"courseTitle"];
        self.courseVideo = dic[@"courseVideo"];
    }
    return self;
}
+ (instancetype)modelWithDIc:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}
@end
