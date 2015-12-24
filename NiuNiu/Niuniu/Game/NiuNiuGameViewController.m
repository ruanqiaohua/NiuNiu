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
#import "MBProgressHUD.h"

#define MyCardsDefaultTag 1000

typedef enum : NSUInteger {
    beginType,
    bossType,
    multipleType,
    openType,
} CountDownType;

@interface NiuNiuGameViewController ()
@property (strong, nonatomic) NSMutableArray *chooseCardBtns;
@property (strong, nonatomic) NSMutableArray *myCardsArr;
@property (strong, nonatomic) NSDictionary *myResult;
@property (strong, nonatomic) NSMutableArray *otherCardsArr;
@property (strong, nonatomic) NSMutableArray *otherResults;
@property (strong, nonatomic) NSMutableDictionary *myCardsChooseDic;
@property (strong, nonatomic) NSMutableArray *bossChooseBtns;//抢庄
@property (strong, nonatomic) NSMutableArray *multipleBtns;//倍数选择
@property (assign, nonatomic) NSInteger timeCount;//倒计时从几开始
@property (weak, nonatomic) NSTimer *countDownTimer;//倒计时
@property (assign, nonatomic) CountDownType countDownType;//倒计时类型
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
    
    [_getUpBtn setImage:[[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_qishen"] forState:UIControlStateNormal];
    [_getUpBtn setImage:[[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_qishen_p"] forState:UIControlStateHighlighted];
    
    _robotImg.image = [[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_jiqiren"];
    
    [_timeCountDownImg setImage:[[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_daojishikuang"]];

    for (UIImageView *img in _niuBiImgs) {
        img.image = [[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_niubi"];
    }
    
    [_calculatorView setHidden:YES];
    [_robotImg setHidden:YES];
    
    //满足某些条件自动入座
    [self takeChairBtnDidClick:_takeChairBtn];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark 开始倒计时

- (void)timeCountDown:(NSInteger)count countDownType:(CountDownType)type
{
    [_timeCountDownImg setHidden:NO];
    [_timeCountDownLab setHidden:NO];
    _timeCount = count;
    _countDownType = type;
    [self setTimeCountDownLabText];
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCountDownTimer:) userInfo:nil repeats:YES];
}

- (void)timeCountDownTimer:(NSTimer *)timer
{
    _timeCount -= 1;
    if (_timeCount == 0) {
        [self closeCountDownTimer];
        switch (_countDownType) {
            case beginType:
                [self gameBeginning];
                break;
            case bossType:
                [self bossBtnDidClick:_bossChooseBtns.firstObject];
                break;
            case multipleType:
                [self multipleBtnDidClick:_multipleBtns.firstObject];
                break;
            case openType:
                [self openResult];
                break;
            default:
                break;
        }
    }else {
        [self setTimeCountDownLabText];
    }
}

- (void)setTimeCountDownLabText
{
    switch (_countDownType) {
        case beginType:
            _timeCountDownLab.text = [NSString stringWithFormat:@"牛牛即将开始:%zi",_timeCount];
            break;
        case bossType:
            _timeCountDownLab.text = [NSString stringWithFormat:@"抢庄倒计时:%zi",_timeCount];
            break;
        case multipleType:
            _timeCountDownLab.text = [NSString stringWithFormat:@"倍数选择倒计时:%zi",_timeCount];
            break;
        case openType:
            _timeCountDownLab.text = [NSString stringWithFormat:@"倒计时:%zi",_timeCount];
            break;
        default:
            break;
    }
}

- (void)closeCountDownTimer
{
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    [_timeCountDownImg setHidden:YES];
    _timeCountDownLab.text = nil;
    [_timeCountDownLab setHidden:YES];
}

#pragma mark 游戏开始

- (void)gameBeginning
{
    //游戏开始不能起身
    [_getUpBtn setHidden:YES];
    //显示我的4张牌
    [self loadMyCards];
    //其他人的卡牌
    [self loadOtherDefaultPlayerCards];
    //抢庄
    [self loadBossChooseView];
    //抢庄倒计时
    [self timeCountDown:5 countDownType:bossType];
}

#pragma mark 其他人的卡牌

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

#pragma mark 选择庄家

- (void)loadBossChooseView
{
    [_niuChooseView setHidden:YES];
    [_multipleChooseView setHidden:NO];
    [_multipleChooseView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    CGFloat multipleBtn_W = (screen_W-29*2-5*3)/5;
    NSArray *multipleChooseImgs = @[@"niuniu_anniu_buqiang",@"niuniu_1bei",@"niuniu_2bei",@"niuniu_3bei",@"niuniu_4bei"];
    _bossChooseBtns = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((multipleBtn_W+5)*i, 0, multipleBtn_W, _multipleChooseView.frame.size.height);
        [btn setImage:[[SkinManager inst] getImage:[NSString stringWithFormat:@"Live/Game/NiuNiu/%@",multipleChooseImgs[i]]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(bossBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [_multipleChooseView addSubview:btn];
        [_bossChooseBtns addObject:btn];
    }
}

#pragma mark 选择倍数

- (void)loadMultipleChooseView
{
    [_niuChooseView setHidden:YES];
    [_multipleChooseView setHidden:NO];
    [_multipleChooseView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    CGFloat multipleBtn_W = (screen_W-29*2-5*4)/5;
    NSArray *multipleChooseImgs = @[@"niuniu_anniu_5bei",@"niuniu_anniu_10bei",@"niuniu_anniu_15bei",@"niuniu_anniu_20bei"];
    _multipleBtns = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((multipleBtn_W+5)*i+multipleBtn_W/2, 0, multipleBtn_W, _multipleChooseView.frame.size.height);
        [btn setImage:[[SkinManager inst] getImage:[NSString stringWithFormat:@"Live/Game/NiuNiu/%@",multipleChooseImgs[i]]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(multipleBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [_multipleChooseView addSubview:btn];
        [_multipleBtns addObject:btn];
    }
}

#pragma mark 有牛or没牛

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

#pragma mark 我的卡片

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
    UIButton *lastBtn = _myCards.lastObject;
    [lastBtn setHidden:YES];
    //计算结果并储存
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
    [self closeCountDownTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 入座

- (IBAction)takeChairBtnDidClick:(UIButton *)sender
{
    [_getUpBtn setHidden:NO];
    [sender setHidden:YES];
    //倒计时（如果人数5人3秒，少于5人5秒）
    [self timeCountDown:3 countDownType:beginType];
}

#pragma mark 起身

- (IBAction)getUpBtnDidClick:(UIButton *)sender
{
    [_takeChairBtn setHidden:NO];
    [sender setHidden:YES];
    //关闭倒计时
    [self closeCountDownTimer];
}

#pragma mark 抢庄

- (void)bossBtnDidClick:(UIButton *)sender
{
    //todo庄家选择
    //如果不是boss
    [self loadMultipleChooseView];
    //关闭倒计时
    [self closeCountDownTimer];
    //倍数倒计时
    [self timeCountDown:5 countDownType:multipleType];
}

#pragma mark 倍数

- (void)multipleBtnDidClick:(UIButton *)sender
{
    //todo选庄
    [self loadNiuChooseView];//有牛or没牛
    //显示我的最后一张卡片
    UIButton *lastBtn = _myCards.lastObject;
    [lastBtn setHidden:NO];
    [_calculatorView setHidden:NO];
    [_robotImg setHidden:NO];
    //开启结果倒计时
    [self timeCountDown:10 countDownType:openType];
    //关闭倒计时
    //[self closeCountDownTimer];
}

#pragma mark 有牛和没牛的点击

- (void)niuChooseBtnDidClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 200:
        {
            for (UILabel *label in _calculatorNumbers) {
                if ([label.text integerValue] == 0) {
                    [self showTextOnly:@"配牌好像不对哦，再仔细看看吧！"];
                    return;
                }
            }
            if ([_totalNums.text integerValue]%10 != 0) {
                [self showTextOnly:@"配牌好像不对哦，再仔细看看吧！"];
                return;
            }
        }
            break;
        case 201:
        {
            if ([_myResult[@"tmp1"] boolValue]) {
                [self showTextOnly:@"好像有牛哦，再仔细看看吧！"];
                return;
            }

        }
            break;
        default:
            break;
    }
    [self openResult];
}

#pragma mark 结果

- (void)openResult
{
    [self changeSizeImg:_myNiuSizeImg resultDic:_myResult];
    [self showHiddenSomething];
    [self loadOtherPlayerCards];
    //关闭倒计时
    [self closeCountDownTimer];
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
    lalala:;
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
    [self performSelector:@selector(gameOver) withObject:nil afterDelay:3];
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
    
    [self takeChairBtnDidClick:_takeChairBtn];
}

#pragma mark Tool

- (void)showTextOnly:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.creatView animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
