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
- (void)showRead:(UIButton *)sender;
- (void)showWrite:(UIButton *)sender;
@end
@interface WordImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpace;
//@property (strong,nonatomic) UIView *line;
//@property (strong,nonatomic) UIButton *showButton;
//@property (strong,nonatomic) UIButton *rwButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBottomSpace;
@property (weak,nonatomic) id<WordImageCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *preImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;
@property (weak, nonatomic) IBOutlet UIButton *preBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (void)setModel:(Word *)word;
@end
