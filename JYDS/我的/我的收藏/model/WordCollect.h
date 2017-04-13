//
//  WordCollect.h
//  JYDS
//
//  Created by liyu on 2017/4/13.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordCollect : NSObject
//\"wordId\": \"493abf3c0f7811e7a51c02004c4f4f50\",
//\"associate\": \"爸爸拿了一根~香蕉~，又拿了一根香蕉。\",
//\"phonogram\": \"[bəˈnɑ: nə ]\",
//\"split\": \"ba爸na拼音拿na拼音拿\",
//\"imgUrl\": \"https: //omjbfvi08.qnssl.com/a/9.jpg\",
//\"gradeName\": \"三年级上海牛津版\",
//\"create_time\": \"2017-04-1114: 31: 40\",
//\"word\": \"banana\",
//\"word_explain\": \"n.香蕉\"
@property (copy,nonatomic) NSString *wordId;
@property (copy,nonatomic) NSString *associate;
@property (copy,nonatomic) NSString *phonogram;
@property (copy,nonatomic) NSString *imgUrl;
@property (copy,nonatomic) NSString *gradeName;
@property (copy,nonatomic) NSString *create_time;
@property (copy,nonatomic) NSString *word;
@property (copy,nonatomic) NSString *word_explain;
@property (copy,nonatomic) NSString *split;
@end
