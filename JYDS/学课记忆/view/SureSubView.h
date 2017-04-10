//
//  SureSubView.h
//  testDemo
//
//  Created by 大雨 on 2017/4/9.
//  Copyright © 2017年 大雨. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SureSubViewDelegate<NSObject>
- (void)cancelClick;
- (void)sureClick;
@end
@interface SureSubView : UIView
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak,nonatomic) id<SureSubViewDelegate> delegate;
- (instancetype)initWithNib;
@end
