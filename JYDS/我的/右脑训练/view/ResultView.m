//
//  ResultView.m
//  JYDS
//
//  Created by liyu on 2017/1/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "ResultView.h"

@implementation ResultView

- (instancetype)initWithFrame:(CGRect)frame imageNameArray:(NSMutableArray *)arr{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
        //title
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, WIDTH, 16)];
        titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        titleLabel.text = @"练习结果";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        //viewArray
        _viewArray  = [NSMutableArray arrayWithCapacity:9];
        CGFloat c = (WIDTH-40)/3.0;
        for (NSInteger i = 0; i<3; i++) {
            CGFloat y = CGRectGetMaxY(titleLabel.frame)+27+(c+5)*i;
            for (NSInteger j = 0; j<3; j++) {
                CGFloat x = 15+(c+5)*j;
                UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(x, y, c, c)];
                itemView.backgroundColor = RGB(238,238,238);
                [self addSubview:itemView];
                [_viewArray addObject:itemView];
            }
        }
        for (NSInteger i = 0; i<arr.count; i++) {
            //image
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, c, c-13)];
            imageView.image = [UIImage imageNamed:arr[i]];
            UIView *itemView = _viewArray[i];
            [itemView addSubview:imageView];
            //text
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, c-13, c, 13)];
            textLabel.text = arr[i];
            textLabel.font = [UIFont systemFontOfSize:13.0f];
            textLabel.textColor = [UIColor blackColor];
            textLabel.backgroundColor = [UIColor whiteColor];
            textLabel.textAlignment = NSTextAlignmentCenter;
            [itemView addSubview:textLabel];
        }
        //button
        //continue
        UIButton *continueButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH-200)*0.5, CGRectGetMaxY(titleLabel.frame)+c*3+70,200, 38)];
        [continueButton setTitle:@"继续" forState:UIControlStateNormal];
        [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        continueButton.layer.masksToBounds = YES;
        continueButton.layer.cornerRadius = 6.0f;
        continueButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
        continueButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [continueButton addTarget:self action:@selector(continueClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:continueButton];
        //back
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH-200)*0.5, CGRectGetMaxY(continueButton.frame)+13,200, 38)];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        backButton.layer.masksToBounds = YES;
        backButton.layer.cornerRadius = 6.0f;
        backButton.backgroundColor = SEPCOLOR;
        backButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
    }
    return self;
}
- (void)continueClick{
    [_delegate backToExerciselView];
}
- (void)backClick{
    [_delegate backToLevelView];
}
@end
