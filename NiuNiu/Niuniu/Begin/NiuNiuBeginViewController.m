//
//  NiuNiuBeginViewController.m
//  NiuNiu
//
//  Created by fuland539 on 15/12/21.
//  Copyright © 2015年 xiaohuoban. All rights reserved.
//

#import "NiuNiuBeginViewController.h"
#import "SkinManager.h"

@interface NiuNiuBeginViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionViewCell *selectCell;
@end

@implementation NiuNiuBeginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _background.image = [[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_tankuang.jpg"];
    [_closeBtn setImage:[[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_tankuang_guanbi"] forState:UIControlStateNormal];
    [_closeBtn setImage:[[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_tankuang_guanbi_p"] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)closeBtnDidClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectCell) {
        _selectCell.layer.borderColor = nil;
        _selectCell.layer.borderWidth = 0.0;
    }
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:28.0/255.0 alpha:0.8].CGColor;
    cell.layer.borderWidth = 3.0;
    _selectCell = cell;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectCell) {
        _selectCell.layer.borderColor = nil;
        _selectCell.layer.borderWidth = 0.0;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"game" sender:self];
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((collectionView.frame.size.width-4)/2, (collectionView.frame.size.height-4)/2);
    return size;
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
