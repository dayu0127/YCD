//
//  RememberWordItemView.h
//  YCD
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RememberWordItemViewDelegate<NSObject>
- (void)itemClickWithClassifyID:(NSInteger)classifyID title:(NSString *)title;
@end

@interface RememberWordItemView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, weak) id <RememberWordItemViewDelegate> delegate;

- (instancetype)initWithNib;

@end
