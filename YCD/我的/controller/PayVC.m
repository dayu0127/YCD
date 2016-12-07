//
//  PayVC.m
//  YCD
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "PayVC.h"
#import "PaymentVC.h"
@interface PayVC ()
@property (assign,nonatomic)NSInteger money;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *detailButton;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;
- (IBAction)contactServiceClick:(UIButton *)sender;
@end

@implementation PayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _bgView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor blackColor],[UIColor redColor]);
    _detailButton.dk_tintColorPicker = DKColorPickerWithKey(TEXT);
    for (UILabel *item in _labelCollection) {
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 161, WIDTH, (PAY_ROWHEIGHT+1)*6)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bgView];
    for (NSInteger i = 0; i<6; i++) {
        //itemView
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, (PAY_ROWHEIGHT+1)*i, WIDTH, PAY_ROWHEIGHT)];
        itemView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor blackColor],[UIColor redColor]);
        [bgView addSubview:itemView];
        //imageView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
        imageView.image = [UIImage imageNamed:@"banner01"];
        [itemView addSubview:imageView];
        //label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 100, PAY_ROWHEIGHT)];
        label.text = [NSString stringWithFormat:@"%d学习豆",[[PAY_ARRAY objectAtIndex:i] intValue]*PAY_PROPORTION];
        label.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        [itemView addSubview:label];
        //payButton
        UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-90, 15, 75, 30)];
        payButton.layer.masksToBounds = YES;
        payButton.layer.cornerRadius = 8.0f;
        payButton.layer.borderWidth = 2;
        payButton.tag = i;
        payButton.layer.borderColor = [UIColor orangeColor].CGColor;
        [payButton setTitle:[NSString stringWithFormat:@"%@元",[PAY_ARRAY objectAtIndex:i]] forState:UIControlStateNormal];
        [payButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        payButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:payButton];
    }
}
- (void)payButtonClick:(UIButton *)sender{
    _money = [[PAY_ARRAY objectAtIndex:sender.tag] integerValue];
    [self performSegueWithIdentifier:@"toPayment" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toPayment"]) {
        PaymentVC *paymentVC = segue.destinationViewController;
        paymentVC.money = _money;
    }
}
- (IBAction)contactServiceClick:(UIButton *)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"客服电话" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *telephone = [UIAlertAction actionWithTitle:@"400-021-008" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-021-008"];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:telephone];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}
@end
