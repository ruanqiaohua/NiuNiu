//
//  NiuNiuGameViewController.m
//  NiuNiu
//
//  Created by fuland539 on 15/12/21.
//  Copyright © 2015年 xiaohuoban. All rights reserved.
//

#import "NiuNiuGameViewController.h"
#import "SkinManager.h"
#import "NiuNiuCard.h"

@interface NiuNiuGameViewController ()

@end

@implementation NiuNiuGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _background.image = [[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_beijing.jpg"];

    [_gameRuleBtn setImage:[[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_youxiguize"] forState:UIControlStateNormal];
    [_gameRuleBtn setImage:[[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_youxiguize_p"] forState:UIControlStateHighlighted];
    
    [_reduceBtn setImage:[[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_jianshao"] forState:UIControlStateNormal];
    [_reduceBtn setImage:[[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_jianshao_p"] forState:UIControlStateHighlighted];
    
    [_closeBtn setImage:[[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_guanbi"] forState:UIControlStateNormal];
    [_closeBtn setImage:[[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_guanbi_p"] forState:UIControlStateHighlighted];
    
    [_takeChairBtn setImage:[[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_ruzuo"] forState:UIControlStateNormal];
    [_takeChairBtn setImage:[[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_ruzuo_p"] forState:UIControlStateHighlighted];
    
    //其他人的牌
    for (UIView *view in _playerViews) {
        for (int i=0; i<5; i++) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(12*i, 0, 22, view.frame.size.height)];
            img.image = [[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_zhengmian"];
            [view addSubview:img];
        }
    }

    //[self loadMultipleChooseView];//倍数
    [self loadNiuChooseView];//有牛or没牛
    [self loadMyCards];
}

- (void)loadMultipleChooseView
{
    [_niuChooseView setHidden:YES];
    [_multipleChooseView setHidden:NO];
    
    CGFloat multipleBtn_W = (screen_W-29*2-5*4)/5;
    NSArray *multipleChooseImgs = @[@"niuniu_anniu_buqiang",@"niuniu_1bei",@"niuniu_2bei",@"niuniu_3bei",@"niuniu_4bei"];
    for (int i=0; i<5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((multipleBtn_W+5)*i, 0, multipleBtn_W, _multipleChooseView.frame.size.height);
        [btn setImage:[[SkinManager inst] getImage:[NSString stringWithFormat:@"Live/Game/NiuNiu/%@",multipleChooseImgs[i]]] forState:UIControlStateNormal];
        [_multipleChooseView addSubview:btn];
    }
}

- (void)loadNiuChooseView
{
    [_multipleChooseView setHidden:YES];
    [_niuChooseView setHidden:NO];
   
    NSArray *niuBtnChooseImgs = @[@"niuniu_youniu",@"niuniu_anniu_meiniu"];
    for (int i=0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((72+6)*i, 0, 72, _niuChooseView.frame.size.height);
        [btn setImage:[[SkinManager inst] getImage:[NSString stringWithFormat:@"Live/Game/NiuNiu/%@",niuBtnChooseImgs[i]]] forState:UIControlStateNormal];
        [_niuChooseView addSubview:btn];
    }
}

- (void)loadMyCards
{
    for (UIButton *cardBtn in _myCards) {
        NSInteger type = arc4random()%4;
        NiuNiuCard *card = [[NiuNiuCard alloc]initWithTypeNum:arc4random()%13+1 cardType:type];
        [cardBtn setImage:[NiuNiuCard imageFromView:card] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeBtnDidClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)takeChairBtnDidClick:(UIButton *)sender
{
    [sender setHidden:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
