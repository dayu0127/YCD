//
//  RememberWordVideoCell.h
//  JYDS
//
//  Created by dayu on 2016/11/30.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import <UIKit/UIKit.h>
@class CourseVideo;
@interface RememberWordVideoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoName;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoPriceWidth;

- (void)addModel:(CourseVideo *)model;

@end
