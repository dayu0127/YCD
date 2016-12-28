//
//  RememberWordVideoCell.m
//  YCD
//
//  Created by dayu on 2016/11/30.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "RememberWordVideoCell.h"
#import "CourseVideo.h"
#import <UIImageView+WebCache.h>
@implementation RememberWordVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _videoName.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _detailLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor darkGrayColor],[UIColor groupTableViewBackgroundColor],RED);
    _videoPrice.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
}
- (void)updateConstraints{
    [super updateConstraints];
    _videoPriceWidth.constant = _videoPriceWidth.constant+10;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)addModel:(CourseVideo *)model{
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:model.videoImageUrl] placeholderImage:[UIImage imageNamed:@"videoImage"]];
    self.videoName.text = model.videoName;
    self.detailLabel.text = [NSString stringWithFormat:@"%@,共%@词",[self getHMSFromS:model.videoTime],model.videoWordNum];
    self.videoPrice.text = [NSString stringWithFormat:@"%@学习豆",model.videoPrice];
}
-(NSString *)getHMSFromS:(NSString *)totalTime{
    NSInteger seconds = [totalTime integerValue];
    NSString *str_hour = [NSString stringWithFormat:@"%02zd",seconds/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02zd",(seconds%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02zd",seconds%60];
    NSString *format_time = @"";
    if ((![str_hour isEqualToString:@"00"])&&(![str_minute isEqualToString:@"00"])) {
        format_time = [NSString stringWithFormat:@"%@时%@分%@秒",str_hour,str_minute,str_second];
    }else if ([str_hour isEqualToString:@"00"]&&(![str_minute isEqualToString:@"00"])){
        format_time = [NSString stringWithFormat:@"%@分%@秒",str_minute,str_second];
    }else if ([str_hour isEqualToString:@"00"]&&[str_minute isEqualToString:@"00"]){
        format_time = [NSString stringWithFormat:@"%@秒",str_second];
    }
    return format_time;
}
@end
