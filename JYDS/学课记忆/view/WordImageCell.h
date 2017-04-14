//
//  WordImageCell.h
//  JYDS
//
//  Created by liyu on 2017/4/5.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Word;
@protocol WordImageCellDelegate<NSObject>
- (void)showRead;
- (void)showWrite;
@end
@interface WordImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpace;
@property (weak, nonatomic) IBOutlet UIButton *readButton;
@property (weak, nonatomic) IBOutlet UIButton *writeButton;
@property (strong,nonatomic) UIView *line;
@property (strong,nonatomic) UIButton *showButton;
@property (strong,nonatomic) UIButton *rwButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBottomSpace;
@property (weak,nonatomic) id<WordImageCellDelegate> delegate;
- (void)setModel:(Word *)word;
@end
