//
//  GradeCell.h
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradeCell : UITableViewCell
//@property (copy,nonatomic) NSString *version_id;
//@property (copy,nonatomic) NSString *class_name;
//@property (copy,nonatomic) NSString *total_words;
//@property (copy,nonatomic) NSString *full_price;
//@property (copy,nonatomic) NSString *imgurl;
//@property (copy,nonatomic) NSString *payType;
//\"classId\": \"7920306d0f6b11e7a51c02004c4f4f50\",
//\"class_name\": \"牛津上海版\",
//\"total_words\": 172,
//\"full_price\": 3600.00,
//\"imgurl\": \"0\",
//\"payType\": \"0\",
//\"orders\": 1,
//\"grade_name\": \"小学五年级上学期\",
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *totalWordLabel;
@property (weak, nonatomic) IBOutlet UILabel *subStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ordersLabel;
- (void)addModelWithDic:(NSDictionary *)dic;
@end
