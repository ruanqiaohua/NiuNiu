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

#define MyCardsDefaultTag 1000

@interface NiuNiuGameViewController ()
@property (strong, nonatomic) NSMutableArray *chooseCardBtns;
@property (strong, nonatomic) NSMutableArray *myCardsArr;
@property (strong, nonatomic) NSDictionary *myResult;
@property (strong, nonatomic) NSMutableArray *otherCardsArr;
@property (strong, nonatomic) NSMutableArray *otherResults;
@property (strong, nonatomic) NSMutableDictionary *myCardsChooseDic;
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
    
    _robotImg.image = [[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_jiqiren"];

    for (UIImageView *img in _niuBiImgs) {
        img.image = [[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_niubi"];
    }
    
    //[self loadOtherDefaultPlayerCards];//其他人的卡牌
    //[self loadMultipleChooseView];//倍数
    //[self loadNiuChooseView];//有牛or没牛
    //[self loadMyCards];//我的卡片
    
    [_calculatorView setHidden:YES];
    [_robotImg setHidden:YES];
}

- (void)loadOtherDefaultPlayerCards
{
    //其他人的牌（反面）
    for (UIView *view in _playerViews) {
        for (int i=0; i<5; i++) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(12*i, 0, 22, view.frame.size.height)];
            img.image = [[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_zhengmian"];
            [view addSubview:img];
        }
    }
}

- (void)loadOtherPlayerCards
{
    //其他人的牌（正面）
    int a = 0;
    for (UIView *view in _playerViews) {
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NSMutableArray *targetcards = [NSMutableArray array];
        for (int i=0; i<5; i++) {
            NSInteger cardType = arc4random()%4;
            NSInteger typeNum = arc4random()%13+1;
            NiuNiuCard *card = [[NiuNiuCard alloc]initWithTypeNum:typeNum cardType:cardType];
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(12*i, 0, 22, view.frame.size.height)];
            img.image = [NiuNiuCard imageFromView:card];
            [view addSubview:img];
            typeNum = typeNum<10?typeNum:10;
            [targetcards addObject:[NSNumber numberWithInteger:typeNum]];
        }
        [self changeSizeImg:_otherNiuSizeImgs[a] resultDic:[self testNN:targetcards]];
        a += 1;
    }
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
        [btn addTarget:self action:@selector(multipleBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
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
        btn.tag = 200+i;
        [btn addTarget:self action:@selector(niuChooseBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [_niuChooseView addSubview:btn];
    }
}

- (void)loadMyCards
{
    _myCardsArr = [NSMutableArray array];
    int i = 0;
    for (UIButton *cardBtn in _myCards) {
        NSInteger cardType = arc4random()%4;
        NSInteger typeNum = arc4random()%13+1;
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:cardType],@"cardType",[NSNumber numberWithInteger:typeNum],@"typeNum", nil];
        [_myCardsArr addObject:dic];
        NiuNiuCard *card = [[NiuNiuCard alloc]initWithTypeNum:typeNum cardType:cardType];
        [cardBtn setImage:[NiuNiuCard imageFromView:card] forState:UIControlStateNormal];
        cardBtn.tag = i+MyCardsDefaultTag;
        i+=1;
        [cardBtn addTarget:self action:@selector(cardBtnIsClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSMutableArray *targetcards = [NSMutableArray array];
    for (NSDictionary *dic in _myCardsArr) {
        NSInteger typeNum = [dic[@"typeNum"] integerValue];
        typeNum = typeNum<10?typeNum:10;
        [targetcards addObject:[NSNumber numberWithInteger:typeNum]];
    }
    _myResult = [self testNN:targetcards];
}

- (void)cardBtnIsClick:(UIButton *)sender
{
    if (!_chooseCardBtns) {//初始化一个选择数组
        _chooseCardBtns = [NSMutableArray arrayWithCapacity:3];
    }
    for (UIButton *chooseBtn in _chooseCardBtns) {//遍历选择数组
        if (sender == chooseBtn) {//如果点击的是已经选择的
            [_chooseCardBtns removeObject:chooseBtn];
            [UIView animateWithDuration:0.1 animations:^{
                sender.frame = CGRectOffset(sender.frame, 0, 8);
            }];
            for (UIButton *cardBtn in _myCards) {//把超过3个不可点的条件取消
                cardBtn.enabled = YES;
            }
            [self reloadCalculatorNumbers:sender.tag type:@"remove"];
            return;
        }
    }
    [UIView animateWithDuration:0.1 animations:^{
        sender.frame = CGRectOffset(sender.frame, 0, -8);
    }];
    [_chooseCardBtns addObject:sender];
    if (_chooseCardBtns.count >= 3) {//超过3个不可点
        for (UIButton *cardBtn in _myCards) {
            cardBtn.enabled = NO;
            for (UIButton *chooseBtn in _chooseCardBtns) {
                if (cardBtn == chooseBtn) {
                    cardBtn.enabled = YES;
                    break;
                }
            }
        }
    }
    [self reloadCalculatorNumbers:sender.tag type:@"add"];
}

- (void)reloadCalculatorNumbers:(NSInteger)index type:(NSString *)type
{
    if (!_myCardsChooseDic) {
        _myCardsChooseDic = [NSMutableDictionary dictionary];
    }
    if ([type isEqualToString:@"add"]) {
        for (UILabel *label in _calculatorNumbers) {
            if ([label.text isEqualToString:@""]) {
                NSDictionary *dic = _myCardsArr[index-MyCardsDefaultTag];
                [_myCardsChooseDic setObject:dic forKey:[NSNumber numberWithInteger:label.tag]];//添加选择
                NSInteger typeNum = [dic[@"typeNum"] integerValue];
                label.text = [NSString stringWithFormat:@"%zi",typeNum<10?typeNum:10];
                NSInteger total = [_totalNums.text integerValue]+[label.text integerValue];
                _totalNums.text = [NSString stringWithFormat:@"%zi",total];
                break;
            }
        }
    }else {
        for (NSNumber *key in _myCardsChooseDic.allKeys) {
            NSInteger tag = [key integerValue];
            NSDictionary *dic = _myCardsChooseDic[key];
            if (dic == _myCardsArr[index-MyCardsDefaultTag]) {
                for (UILabel *label in _calculatorNumbers) {
                    if (label.tag == tag) {
                        [_myCardsChooseDic removeObjectForKey:key];//移除选择
                        NSInteger total = [_totalNums.text integerValue]-[label.text integerValue];
                        if (total == 0) {
                            _totalNums.text = @"";
                        }else {
                            _totalNums.text = [NSString stringWithFormat:@"%zi",total];
                        }
                        label.text = @"";
                        return;
                    }
                }
            }
        }
    }
}

- (IBAction)closeBtnDidClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)takeChairBtnDidClick:(UIButton *)sender
{
    [sender setHidden:YES];
    [self loadMultipleChooseView];//倍数
}

- (void)multipleBtnDidClick:(UIButton *)sender
{
    [self loadOtherDefaultPlayerCards];//其他人的卡牌
    [self loadNiuChooseView];//有牛or没牛
    [self loadMyCards];//我的卡片
    
    [_calculatorView setHidden:NO];
    [_robotImg setHidden:NO];
}

- (void)niuChooseBtnDidClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 200:
        {
            for (UILabel *label in _calculatorNumbers) {
                if ([label.text integerValue] == 0) {
                    NSLog(@"请选择3张牌！");
                    return;
                }
            }
            if ([_totalNums.text integerValue]%10 != 0) {
                NSLog(@"这个组合没有牛！");
                return;
            }
        }
            break;
        case 201:
        {
            if ([_myResult[@"tmp1"] boolValue]) {
                NSLog(@"仔细看看，应该是有牛的！");
                return;
            }

        }
            break;
        default:
            break;
    }

    [self changeSizeImg:_myNiuSizeImg resultDic:_myResult];
    [self showHiddenSomething];
    [self loadOtherPlayerCards];
}

- (NSDictionary *)testNN:(NSMutableArray *)targetcards
{
    //其中J,Q,K已经转换为10
    BOOL tmp1 = NO;
    BOOL tmp2 = NO;
    NSInteger tmp3 = 0;
    //tmp1记录是否有3张组成10
    //tmp2记录是否是“牛牛”
    //tmp3记录是否是“牛牛大小”
    for(int a=0;a<=2;a++){
        for(int b=a+1;b<=3;b++){
            for(int c=b+1;c<=4;c++){
                if(([targetcards[a] integerValue]+[targetcards[b] integerValue]+[targetcards[c] integerValue])%10 == 0){
                    tmp1 = YES;
                    //tmp3是暂时保存数据用的
                    for(int j=0;j<=4;j++){
                        if(j != a && j != b && j != c){
                            tmp3+= [targetcards[j] integerValue];
                        }
                    }
                    if(tmp3%10 == 0){
                        tmp2 = YES;
                    }
                    goto lalala;
                }
            }
        }
    }
    lalala:NSLog(@"《你开始，顺时针》牛%zi",tmp3);
 
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:tmp1],@"tmp1",[NSNumber numberWithBool:tmp2],@"tmp2",[NSNumber numberWithInteger:tmp3],@"tmp3", nil];
    return dic;
}

- (void)changeSizeImg:(UIImageView *)sizeImg resultDic:(NSDictionary *)resultDic
{
    BOOL tmp1 = [resultDic[@"tmp1"] boolValue];
    BOOL tmp2 = [resultDic[@"tmp2"] boolValue];
    NSInteger tmp3 = [resultDic[@"tmp3"] integerValue];
    if (tmp1) {
        if (tmp2) {
            sizeImg.image = [[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_niuniu"];
        }else {
            sizeImg.image = [[SkinManager inst] getImage:[NSString stringWithFormat:@"Live/Game/NiuNiu/niuniu_niu%zi",tmp3%10]];
        }
    }else {
        sizeImg.image = [[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_meiniu"];
    }
}

- (void)showHiddenSomething
{
    [_calculatorView setHidden:YES];
    [_robotImg setHidden:YES];
    [_niuChooseView setHidden:YES];
    for (UIButton *chooseBtn in _chooseCardBtns) {//遍历选择数组
        [UIView animateWithDuration:0.1 animations:^{
            chooseBtn.frame = CGRectOffset(chooseBtn.frame, 0, 8);
        }];
        [self reloadCalculatorNumbers:chooseBtn.tag type:@"remove"];
    }
    [_chooseCardBtns removeAllObjects];
    for (UIButton *cardBtn in _myCards) {//把超过3个不可点的条件取消
        cardBtn.enabled = YES;
    }
//    [self performSelector:@selector(gameOver) withObject:nil afterDelay:3];
}

- (void)gameOver
{
    for (UIImageView *img in _otherNiuSizeImgs) {
        img.image = nil;
    }
    _myNiuSizeImg.image = nil;
    for (UIButton *card in _myCards) {
        [card setImage:nil forState:UIControlStateNormal];
    }
    for (UIView *view in _playerViews) {
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [_takeChairBtn setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
