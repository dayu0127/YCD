//
//  Word.h
//  JYDS
//
//  Created by liyu on 2017/4/8.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Word : NSObject
//associate = "\U4f2f\U4f2f\U8bf4\U8fd9\U672c~\U4e66~ok\U3002";
//"class_id" = 7920306d0f6b11e7a51c02004c4f4f50;
//collectionType = 0;
//imgUrl = "https://omjbfvi08.qnssl.com/a/18.jpg";
//phonogram = "[b\U028ak]";
//split = "bo \U4f2f  ok";
//"unit_id" = c33008960f6d11e7a51c02004c4f4f50;
//word = "book ";
//wordId = 493ac49a0f7811e7a51c02004c4f4f50;
//"word_explain" = "n.\U4e66";
@property (copy,nonatomic) NSString *wordId;
@property (copy,nonatomic) NSString *word;
@property (copy,nonatomic) NSString *imgUrl;
@property (copy,nonatomic) NSString *split;
@property (copy,nonatomic) NSString *phonogram;
@property (copy,nonatomic) NSString *associate;
@property (copy,nonatomic) NSString *word_explain;
@property (copy,nonatomic) NSString *unit_id;
@property (copy,nonatomic) NSString *collectionType;
@property (copy,nonatomic) NSString *class_id;
@end
