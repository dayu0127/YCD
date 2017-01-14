//
//  LevelView.m
//  JYDS
//
//  Created by liyu on 2017/1/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "LevelView.h"

@implementation LevelView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 15)];
        label.text = @"请选择练习题等级";
        label.font = [UIFont systemFontOfSize:17.0f];
        label.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        //等级View
        CGFloat height = frame.size.height;
        CGFloat btnWidth = (WIDTH-120)/3.0;
        CGFloat btnHeight = btnWidth*11/17.0;
        for (NSInteger i = 0; i< 3; i++) {
            CGFloat y = CGRectGetMaxY(label.frame)+0.24*height+(btnHeight+10)*i;
            for (NSInteger j = 0; j<3; j++) {
                CGFloat x = 30+(btnWidth+30)*j;
                UIButton *levelBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, btnWidth, btnHeight)];
                levelBtn.tag = i*3+j;
                [levelBtn setTitle:[NSString stringWithFormat:@"%@秒",LEVELARRAY[i*3+j]]forState:UIControlStateNormal];
                [levelBtn dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
                levelBtn.backgroundColor = D_BTN_BG;
                levelBtn.layer.masksToBounds = YES;
                levelBtn.layer.cornerRadius = 4.0f;
                levelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                [levelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:levelBtn];
            }
        }
    }
    return self;
}
- (void)btnClick:(UIButton *)sender{
    [_delegate levelButtonClick:sender.tag];
}

@end
