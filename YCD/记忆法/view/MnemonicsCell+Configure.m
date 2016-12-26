//
//  MnemonicsCell+Configure.m
//  YCD
//
//  Created by liyu on 2016/12/24.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "MnemonicsCell+Configure.h"
#import "Mnemonics.h"
#import <UIImageView+WebCache.h>
@implementation MnemonicsCell (Configure)
-(void)configureCellWithModel:(Mnemonics *)model {
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:model.courseImageUrl] placeholderImage:[UIImage imageNamed:@"videoImage"]];
//    @property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
//    @property (weak, nonatomic) IBOutlet UILabel *courseTitle;
//    @property (weak, nonatomic) IBOutlet UILabel *courseDetail;
//    @property (weak, nonatomic) IBOutlet UILabel *studyDouLabel;
    self.courseName.text = model.courseName;
    self.courseTitle.text = model.courseTitle;
//    @property (copy,nonatomic) NSString *coursePayStatus;
//    @property (copy,nonatomic) NSString *coursePrice;
    NSString *coursePrice = @"";
    if ([model.coursePayStatus isEqualToString:@"0"]) {
        if ([model.coursePrice isEqualToString:@"0"]) {
            coursePrice = @"免费";
        }else{
            coursePrice = [NSString stringWithFormat:@"%@学习豆",model.coursePrice];
        }
    }else{
        coursePrice = @"已订阅";
    }
    self.coursePrice.text = coursePrice;
}
@end
