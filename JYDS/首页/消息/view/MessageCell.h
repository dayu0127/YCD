//
//  MessageCell.h
//  JYDS
//
//  Created by liyu on 2017/3/30.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MessageCellDelegate<NSObject>
- (void)messageDetail;
@end
@interface MessageCell : UITableViewCell
@property (weak,nonatomic) id<MessageCellDelegate> delegate;
@end
