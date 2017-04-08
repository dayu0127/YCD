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

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalWordLabel;
@property (weak, nonatomic) IBOutlet UILabel *subStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullPriceLabel;
- (void)addModelWithDic:(NSDictionary *)dic;
@end
