//
//  MessageCenterCell.h
//  JYDS
//
//  Created by liyu on 2017/6/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenterCell : BaseCell
@property (weak, nonatomic) IBOutlet UIImageView *messageImage;
@property (weak, nonatomic) IBOutlet UILabel *msgTitle;
@property (weak, nonatomic) IBOutlet UILabel *msgDetail;
- (void)setModel:(NSDictionary *)dic;
@end
