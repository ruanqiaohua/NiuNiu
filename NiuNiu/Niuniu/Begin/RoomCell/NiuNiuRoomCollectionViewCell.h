//
//  NiuNiuRoomCollectionViewCell.h
//  NiuNiu
//
//  Created by ruanqiaohua on 15/12/24.
//  Copyright © 2015年 xiaohuoban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NiuNiuRoomCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *inRoomCoin;
@property (weak, nonatomic) IBOutlet UILabel *inRoomPoint;
@property (weak, nonatomic) IBOutlet UILabel *peopleCount;
@property (weak, nonatomic) IBOutlet UIImageView *peopleImg;

@end
