//
//  YHAlertView.m
//  JYDS
//
//  Created by liyu on 2016/12/8.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "YHAlertView.h"

@implementation YHAlertView

- (instancetype)initWithFrame:(CGRect)frame
                        title:(nonnull NSString *)title
                      message:(NSString *)message{
    if (self=[super initWithFrame:frame]) {
        self.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BLUE,RED);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6.0f;
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, width-16, 60)];
        titleLabel.text = title;
        titleLabel.dk_textColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        if (message != nil) {
            UITextView *messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, 60, width-16, 55)];
            messageTextView.text = message;
            messageTextView.editable = NO;
            messageTextView.backgroundColor = [UIColor clearColor];
            messageTextView.dk_textColorPicker = DKColorPickerWithKey(TEXT);
            messageTextView.font = [UIFont systemFontOfSize:12.0f];
            messageTextView.textAlignment = NSTextAlignmentCenter;
            [self addSubview:messageTextView];
        }
        UIView *h_line = [[UIView alloc] initWithFrame:CGRectMake(0, height-37, width, 1)];
        h_line.dk_backgroundColorPicker = DKColorPickerWithColors(D_BTN_BG,[UIColor darkGrayColor],RED);
        [self addSubview:h_line];
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(8, height-36, (width-17)*0.5, 36)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        cancelButton.tag = 0;
        [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        UIView *v_line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelButton.frame), height-36, 1, 36)];
        v_line.dk_backgroundColorPicker = DKColorPickerWithColors(D_BTN_BG,[UIColor darkGrayColor],RED);
        [self addSubview:v_line];
        UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(v_line.frame), height-36, (width-17)*0.5, 36)];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton dk_setTitleColorPicker:DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED) forState:UIControlStateNormal];
        sureButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        sureButton.tag = 1;
        [sureButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureButton];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
                      message:(NSString *)message{
    if (self=[super initWithFrame:frame]) {
        self.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BLUE,RED);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6.0f;
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.font = [UIFont systemFontOfSize:14.0f];
        messageLabel.text = message;
        CGFloat width = [messageLabel.text boundingRectWithSize:CGSizeMake(1000, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:messageLabel.font forKey:NSFontAttributeName] context:nil].size.width+24;
        messageLabel.frame = CGRectMake(0, 0, width, 40);
        messageLabel.dk_textColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:messageLabel];
    }
    return self;
}
- (void)buttonClick:(UIButton *)sender{
    [_delegate buttonClickIndex:sender.tag];
}

@end
