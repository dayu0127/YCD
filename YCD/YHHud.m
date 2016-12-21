//
//  YHHud.m
//  YCD
//
//  Created by liyu on 2016/12/14.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "YHHud.h"

@implementation YHHud

static YHHud * hud = nil;
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
    return self;
}

+ (void)showWithMessage:(NSString *)message{
    //添加背景
    hud = [[YHHud alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    //添加提示框
    CGFloat width =[message boundingRectWithSize:CGSizeMake(1000, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14.0f] forKey:NSFontAttributeName] context:nil].size.width+24;
    UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, width, 40)];
    messageLabel.center = hud.center;
    messageLabel.dk_backgroundColorPicker = DKColorPickerWithColors(D_BG,N_BLUE,RED);
    messageLabel.text = message;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    messageLabel.dk_textColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    [hud addSubview:messageLabel];
    messageLabel.layer.masksToBounds = YES;
    messageLabel.layer.cornerRadius = 8.0f;
    //视图消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud removeFromSuperview];
    });
}


+(void)showWithStatus:(NSString*)text{
    hud = [[YHHud alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    
    UIView * customView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-75, [UIScreen mainScreen].bounds.size.height/2-50, 150, 120)];
    customView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [hud addSubview:customView];
    customView.layer.masksToBounds = YES;
    customView.layer.cornerRadius=10;
    
    UIImageView *heartImageView = [[UIImageView alloc]initWithFrame:CGRectMake(customView.frame.size.width/2-50, 10,100, 80.0)];
    [customView addSubview:heartImageView];
    NSMutableArray *images = [[NSMutableArray alloc]initWithCapacity:7];
    for (int i=1; i<=5; i++){
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"car%d.png",i]]];
    }
    heartImageView.animationImages = images;
    heartImageView.animationDuration = 0.4 ;
    heartImageView.animationRepeatCount = MAXFLOAT;
    [heartImageView startAnimating];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(customView.frame.size.width/2-50, 80, 100, 40)];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    [customView addSubview:label];
}

+(void)showWithSuccess:(NSString*)successString{//成功提示
    hud = [[YHHud alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    
    UIView * customView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH/2-75, HEIGHT/2-50, 150, 100)];
    customView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor colorWithRed:0 green:0 blue:0 alpha:0.5],[UIColor colorWithRed:19/255.0 green:34/255.0 blue:73/255.0 alpha:0.5],RED);
    [hud addSubview:customView];
    customView.layer.masksToBounds = YES;
    customView.layer.cornerRadius=8.0f;
    
    UIImageView *heartImageView = [[UIImageView alloc]initWithFrame:CGRectMake(customView.frame.size.width/2-20, 15,40, 40.0)];
    heartImageView.contentMode=1;
    [customView addSubview:heartImageView];
    heartImageView.image = [UIImage imageNamed:@"success"];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(customView.frame.size.width/2-50, 55, 100, 40)];
    label.text = successString;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    [customView addSubview:label];
    [UIView animateWithDuration:5.0 animations:^{
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud removeFromSuperview];
    });
}
+(void)dismiss{
    [hud removeFromSuperview];
}
@end
