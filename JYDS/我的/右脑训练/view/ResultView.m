//
//  ResultView.m
//  JYDS
//
//  Created by liyu on 2017/1/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "ResultView.h"

@implementation ResultView

- (instancetype)initWithFrame:(CGRect)frame imageNameArray:(NSArray *)arr{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [YHHud showWithStatus];
        _wkWebView = [[WKWebView alloc] initWithFrame:self.bounds];
        _wkWebView.navigationDelegate = self;
        _wkWebView.scrollView.bounces = NO;
        NSMutableString *arrStr = [[NSMutableString alloc] initWithString:@"["];
        for (int i = 0; i<arr.count; i++) {
            if (i!=arr.count-1) {
                [arrStr appendString:[NSString stringWithFormat:@"%@,",[arr objectAtIndex:i]]];
            }else{
                [arrStr appendString:[arr objectAtIndex:i]];
            }
        }
        [arrStr appendString:@"]"];
        NSString *url = [NSString stringWithFormat:@"%@%@",kExerciseResult,arrStr];
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [_wkWebView loadRequest:request];
        [self insertSubview:_wkWebView atIndex:0];
//        self.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BG,RED);
//        //title
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, WIDTH, 16)];
//        titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
//        titleLabel.text = @"练习结果";
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:titleLabel];
//        
//        //viewArray
//        _viewArray  = [NSMutableArray arrayWithCapacity:9];
//        CGFloat c = (WIDTH-40)/3.0;
//        for (NSInteger i = 0; i<3; i++) {
//            CGFloat y = CGRectGetMaxY(titleLabel.frame)+27+(c+5)*i;
//            for (NSInteger j = 0; j<3; j++) {
//                CGFloat x = 15+(c+5)*j;
//                UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(x, y, c, c)];
//                itemView.backgroundColor = RGB(238,238,238);
//                [self addSubview:itemView];
//                [_viewArray addObject:itemView];
//            }
//        }
//        for (NSInteger i = 0; i<arr.count; i++) {
//            //image
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, c, c-13)];
//            imageView.image = [UIImage imageNamed:arr[i]];
//            UIView *itemView = _viewArray[i];
//            [itemView addSubview:imageView];
//            //text
//            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, c-13, c, 13)];
//            textLabel.text = arr[i];
//            textLabel.font = [UIFont systemFontOfSize:13.0f];
//            textLabel.textColor = [UIColor blackColor];
//            textLabel.backgroundColor = [UIColor whiteColor];
//            textLabel.textAlignment = NSTextAlignmentCenter;
//            [itemView addSubview:textLabel];
//        }
        
        //button
        //继续当前难度训练
        _continueButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_continueButton setTitle:@"继续" forState:UIControlStateNormal];
        [_continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _continueButton.layer.masksToBounds = YES;
        _continueButton.layer.cornerRadius = 6.0f;
        _continueButton.backgroundColor = ORANGERED;
        _continueButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_continueButton addTarget:self action:@selector(continueClick) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:_continueButton atIndex:1];
        [_continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-(self.frame.size.height*39/603.0+38));
            make.centerX.equalTo(self);
            make.width.mas_equalTo(@200);
            make.height.mas_equalTo(@38);
        }];
        _continueButton.alpha = 0;
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backButton.layer.masksToBounds = YES;
        _backButton.layer.cornerRadius = 6.0f;
        _backButton.backgroundColor = LIGHTGRAYCOLOR;
        _backButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:_backButton atIndex:1];
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-(self.frame.size.height*25/603.0));
            make.centerX.equalTo(self);
            make.width.mas_equalTo(@200);
            make.height.mas_equalTo(@38);
        }];
        _backButton.alpha = 0;
    }
    return self;
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    _continueButton.alpha = 1;
    _backButton.alpha = 1;
    [YHHud dismiss];
}
- (void)continueClick{
    [_delegate backToExerciselView];
}
- (void)backClick{
    [_delegate backToLevelView];
}
@end
