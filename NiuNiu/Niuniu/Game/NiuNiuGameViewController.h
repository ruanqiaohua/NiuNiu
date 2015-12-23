//
//  NiuNiuGameViewController.h
//  NiuNiu
//
//  Created by fuland539 on 15/12/21.
//  Copyright © 2015年 xiaohuoban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NiuNiuGameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *background;//背景
@property (weak, nonatomic) IBOutlet UIButton *gameRuleBtn;//游戏规则
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;//最小化
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;//关闭
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *playerViews;//其他玩家
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *niuBiImgs;//其他玩家
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *myCards;//我的卡牌
@property (weak, nonatomic) IBOutlet UIButton *takeChairBtn;//入座
@property (weak, nonatomic) IBOutlet UIView *multipleChooseView;//倍数选择
@property (weak, nonatomic) IBOutlet UIView *niuChooseView;//是否有牛
@property (weak, nonatomic) IBOutlet UIImageView *robotImg;//机器人图片
@property (weak, nonatomic) IBOutlet UIView *calculatorView;//计算是否有牛
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *calculatorNumbers;//显示选择数字
@property (weak, nonatomic) IBOutlet UILabel *totalNums;//计算总算
@property (weak, nonatomic) IBOutlet UIImageView *myNiuSizeImg;//我的牛牛大小
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *otherNiuSizeImgs;//他人牛牛大小

@end
