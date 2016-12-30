//
//  PayVC.m
//  JYDS
//
//  Created by dayu on 2016/11/28.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "PayVC.h"
#import "PaymentVC.h"
@interface PayVC ()

@property (assign,nonatomic) NSInteger money;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIButton *contactServiceButton;
- (IBAction)contactServiceClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *payBean;
@end

@implementation PayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    [YHWebRequest YHWebRequestForPOST:BEANS parameters:@{@"userID":userInfo[@"userID"]} success:^(NSDictionary *json) {
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            _payBean.text = [NSString stringWithFormat:@"%@个",json[@"data"][@"restBean"]];
        }
    }];
    _bgView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
    for (UILabel *item in _labelCollection) {
        item.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    [_contactServiceButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bgView1.frame), WIDTH, (PAY_ROWHEIGHT+1)*PAY_ARRAY.count+1)];
    bgView.backgroundColor = SEPCOLOR;
    [self.view addSubview:bgView];
    for (NSInteger i = 0; i<PAY_ARRAY.count; i++) {
        //itemView
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 1+(PAY_ROWHEIGHT+1)*i, WIDTH, PAY_ROWHEIGHT)];
        itemView.dk_backgroundColorPicker = DKColorPickerWithColors(D_CELL_BG,N_CELL_BG,RED);
        [bgView addSubview:itemView];
        //imageView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (PAY_ROWHEIGHT-19)*0.5, 19, 19)];
        imageView.image = [UIImage imageNamed:@"word"];
        [itemView addSubview:imageView];
        //label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+18, 0, 100, PAY_ROWHEIGHT)];
        label.text = [NSString stringWithFormat:@"%d学习豆",[[PAY_ARRAY objectAtIndex:i] intValue]*PAY_PROPORTION];
        label.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        [itemView addSubview:label];
        //payButton
        UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-72, 12, 60, 23)];
        payButton.layer.masksToBounds = YES;
        payButton.layer.cornerRadius = 3.0f;
        payButton.tag = i;
        [payButton setTitle:[NSString stringWithFormat:@"%@元",[PAY_ARRAY objectAtIndex:i]] forState:UIControlStateNormal];
        [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        payButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_ORANGE,N_ORANGE,RED);
        payButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:payButton];
    }
}
- (void)payButtonClick:(UIButton *)sender{
    _money = [[PAY_ARRAY objectAtIndex:sender.tag] intValue];
    [self performSegueWithIdentifier:@"toPayment" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toPayment"]) {
        PaymentVC *paymentVC = segue.destinationViewController;
        paymentVC.money = _money;
    }
}
- (IBAction)contactServiceClick:(UIButton *)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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
