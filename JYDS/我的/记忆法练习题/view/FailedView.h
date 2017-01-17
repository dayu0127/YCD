//
//  FailedView.h
//  JYDS
//
//  Created by liyu on 2017/1/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FailedViewDelegate<NSObject>
- (void)backToExerciselView;
- (void)backToLevelView;
@end
@interface FailedView : UIView
@property (weak,nonatomic) id<FailedViewDelegate> delegate;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@end
