//
//  NiuNiuRuleViewController.m
//  NiuNiu
//
//  Created by fuland539 on 15/12/24.
//  Copyright © 2015年 xiaohuoban. All rights reserved.
//

#import "NiuNiuRuleViewController.h"
#import "SkinManager.h"

@interface NiuNiuRuleViewController ()

@end

@implementation NiuNiuRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_closeBtn setImage:[[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_guanbi"] forState:UIControlStateNormal];
    [_closeBtn setImage:[[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_guanbi_p"] forState:UIControlStateHighlighted];
    
    UIImage *ruleImage = [[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniuguize.jpg"];
    CGFloat height = ruleImage.size.height*screen_W/ruleImage.size.width;
    _scrollView.contentSize = CGSizeMake(0, height);
    _ruleImg.image = ruleImage;
    _ruleImg_H.constant = height;
    
    
    // Do any additional setup after loading the view.
}

- (IBAction)closeBtnDidClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
