//
//  OtherAmountCell.m
//  JYDS
//
//  Created by liyu on 2017/2/23.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "OtherAmountCell.h"

@implementation OtherAmountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self nightModeConfiguration];
}
- (void)nightModeConfiguration{
    self.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    _amount.delegate = self;
    _amount.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _amount.backgroundColor = [UIColor clearColor];
    _amount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"其他余额" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0f],NSFontAttributeName,[UIColor lightGrayColor],NSForegroundColorAttributeName, nil]];
    _studyBeanLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _money.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
    self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.frame];
    self.selectedBackgroundView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_SELT,N_CELL_SELT,RED);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _money.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    _money.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
}
- (void)textFieldDidBeginEditing:(UITextField *) textField{
    textField.text = @"";
    _amountLabelWidth.constant = 76;
    _money.alpha = 0;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (![textField.text isEqualToString:@""] && [textField.text integerValue] > 0) {
        textField.text = [NSString stringWithFormat:@"%zd",[textField.text integerValue]];
        
        [_delegate getOtherAmount:textField.text];
        
        _amountLabelWidth.constant  = [textField.text boundingRectWithSize:CGSizeMake(1000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15.0f] forKey:NSFontAttributeName] context:nil].size.width+15;
        
        _money.alpha = 1;
        _money.text = [NSString stringWithFormat:@"%@元",textField.text];
        CGFloat width = [_money.text boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:10.0f] forKey:NSFontAttributeName] context:nil].size.width+10;
        _momeyLabelWidth.constant = width<55 ? 55 : width;
    }else{
        textField.text = @"";
        _money.alpha = 0;
    }
}
- (IBAction)amountEditingChanged:(UITextField *)sender {
    if (sender.text.length > 8) {
        sender.text = [sender.text substringToIndex:8];
    }
}
@end
