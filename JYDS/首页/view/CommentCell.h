//
//  CommentCell.h
//  JYDS
//
//  Created by liyu on 2017/4/12.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CommentCellDelegate<NSObject>
- (void)replyButtonClick;
@end
@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commemtLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *sepLine;
@property (weak, nonatomic) id<CommentCellDelegate> delegate;
- (void)addModelWithDic:(NSDictionary *)dic;
@end
