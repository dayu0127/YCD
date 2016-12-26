//
//  RememberWordVideoCell.h
//  YCD
//
//  Created by dayu on 2016/11/30.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RememberWordVideoCell : UITableViewCell
//@property (copy,nonatomic) NSString *productType;
//@property (copy,nonatomic) NSString *videoDetail;
//@property (copy,nonatomic) NSString *videoID;
//@property (copy,nonatomic) NSString *videoImageUrl;
//@property (copy,nonatomic) NSString *videoName;
//@property (copy,nonatomic) NSString *videoPrice;
//@property (copy,nonatomic) NSString *videoTime;
//@property (copy,nonatomic) NSString *videoUrl;
//@property (copy,nonatomic) NSString *videoWordNum;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoName;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoPriceWidth;

@end
