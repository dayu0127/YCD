//
//  MessageCell.h
//  JYDS
//
//  Created by liyu on 2017/3/30.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MessageCellDelegate<NSObject>
- (void)messageDetailClick:(NSInteger)row;
@end
@interface MessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLabelHeight;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) id<MessageCellDelegate> delegate;
- (void)setModel:(NSDictionary *)dic;
@end
