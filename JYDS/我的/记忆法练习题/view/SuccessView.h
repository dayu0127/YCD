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
@property (weak,nonatomic) id<SuccessViewDelegate> delegate;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@end
