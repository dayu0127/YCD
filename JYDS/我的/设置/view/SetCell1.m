//
//  SetCell1.m
//  JYDS
//
//  Created by liyu on 2017/6/20.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "SetCell1.h"
#import <UserNotifications/UserNotifications.h>
@implementation SetCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateSwitchState];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSwitchState) name:@"updateSwitchState" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)switchChange:(UISwitch *)sender {
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}
- (void)updateSwitchState{
    UIUserNotificationSettings *type10 = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (type10.types != UIUserNotificationTypeNone) {
        _notificationSwitch.on = YES;
    }else{
        _notificationSwitch.on = NO;
    }
}
@end
