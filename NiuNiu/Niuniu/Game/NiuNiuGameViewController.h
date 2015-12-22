//
//  NiuNiuGameViewController.h
//  NiuNiu
//
//  Created by fuland539 on 15/12/21.
//  Copyright © 2015年 xiaohuoban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NiuNiuGameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIButton *gameRuleBtn;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *playerViews;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *myCards;
@property (weak, nonatomic) IBOutlet UIButton *takeChairBtn;
@property (weak, nonatomic) IBOutlet UIView *multipleChooseView;
@property (weak, nonatomic) IBOutlet UIView *niuChooseView;

@end
