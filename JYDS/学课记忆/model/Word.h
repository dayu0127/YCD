//
//  Word.h
//  JYDS
//
//  Created by liyu on 2017/4/8.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Word : NSObject
//\"id\": \"493aba500f7811e7a51c02004c4f4f50\",
//\"word\": \"afternoon\",
//\"img_id\": \"55c5ec060f7111e7a51c02004c4f4f50\",
//\"split\": \"合成词after以后noon午间\",
//\"phonogram\": \"[ɑ: ftəˈnu: n]\",
//\"associate\": \"过了午间以后就是~下午~。\",
//\"word_explain\": \"n.下午\"，
//\"payType\": 1
@property (copy,nonatomic) NSString *wordId;
@property (copy,nonatomic) NSString *word;
@property (copy,nonatomic) NSString *img_id;
@property (copy,nonatomic) NSString *split;
@property (copy,nonatomic) NSString *phonogram;
@property (copy,nonatomic) NSString *associate;
@property (copy,nonatomic) NSString *word_explain;
@property (copy,nonatomic) NSString *unit_id;
@end
