//
//  WordSearchListVC.m
//  JYDS
//
//  Created by liyu on 2017/4/22.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "WordSearchListVC.h"
#import "SubedCell.h"
#import "Word.h"
#import "WordDetailVC.h"
@interface WordSearchListVC ()<UITableViewDelegate,UITableViewDataSource,WordDetailVCDelegate>
@property(strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) Word *word;
@end

@implementation WordSearchListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_wordSearchResultArray.count == 0) {
        [self loadNoInviteView:@"该单词未订阅或者没有结果"];
    }else{
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView registerClass:[SubedCell class] forCellReuseIdentifier:@"SubedCell"];
        [_tableView reloadData];
    }
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _wordSearchResultArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _word = [Word yy_modelWithJSON:_wordSearchResultArray[indexPath.row]];
    [self performSegueWithIdentifier:@"wordSearchToWordDetail" sender:self];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubedCell" forIndexPath:indexPath];
    [cell addModelWithDic:_wordSearchResultArray[indexPath.row]];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"wordSearchToWordDetail"]) {
        WordDetailVC *wordDetail = segue.destinationViewController;
        wordDetail.word = _word;
        wordDetail.showCollectButton = YES;
        wordDetail.delegate = self;
        wordDetail.vcName = UIViewControllerNameWordSearchList;
    }
}
- (void)updateWordSearchList{
    NSDictionary *jsonDic = @{
        @"userPhone":self.phoneNum,   //     #用户手机号
        @"token":self.token,            //      #用户登陆凭证
        @"selContent":_searchContent       //      #查询内容
    };
    [YHWebRequest YHWebRequestForPOST:kSelectWord parameters:jsonDic success:^(NSDictionary *json) {
        if ([json[@"code"] integerValue] == 200) {
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _wordSearchResultArray = resultDic[@"selWordList"];
            [_tableView reloadData];
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
@end
