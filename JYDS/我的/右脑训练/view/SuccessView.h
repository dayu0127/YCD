//
//  SuccessView.h
//  JYDS
//
//  Created by liyu on 2017/1/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SuccessViewDelegate<NSObject>
- (void)backToLevelView;
@end
@interface SuccessView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacing1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacing2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacing3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomHeight;
@property (weak,nonatomic) id<SuccessViewDelegate> delegate;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@end
