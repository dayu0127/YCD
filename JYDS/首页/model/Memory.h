//
//  Memory.h
//  JYDS
//
//  Created by liyu on 2017/4/8.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Memory : NSObject
//{
//    "id": "84eb48401c0911e7bfbe02004c4f4f50",
//    "title": "告诉您：3年级至12年级的学生，如何轻松玩转9大学科！",
//    "content": "   刘健老师的形象记忆法能让学生能够快速提高想象力，连锁记忆法能提升孩子的创造力，空间定位法则能提升综合应用能力。刘健老师的特色和强项在外语、古诗词两门学科，能够极大地调动孩子们的积极性，让孩子在快乐中学习。",
//    "full_price": 300.00,
//    "url": "https://omj0kq04d.qnssl.com/video/zqdn.mp4",
//    "payType": 0
//    "views":1
//    "likes":10,
//    "orders":10,
//    "create_time":"2011-11-11 12:11:11",
//    "imgUrl":"http://www.xxx.com"
//        \"preferentialPrice\": 100.00
//        \"total_lessons\":10
//}
@property (copy,nonatomic) NSString *memoryId;
@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *content;
@property (copy,nonatomic) NSString *full_price;
@property (copy,nonatomic) NSString *url;
@property (copy,nonatomic) NSString *videoUrl;
@property (copy,nonatomic) NSString *payType;
@property (copy,nonatomic) NSString *views;
@property (copy,nonatomic) NSString *likes;
@property (copy,nonatomic) NSString *orders;
@property (copy,nonatomic) NSString *create_time;
@property (copy,nonatomic) NSString *imgUrl;
@property (copy,nonatomic) NSString *preferentialPrice;
@property (copy,nonatomic) NSString *total_lessons;

@end
