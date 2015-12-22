//
//  NiuNiuCard.h
//  NiuNiu
//
//  Created by fuland539 on 15/12/22.
//  Copyright © 2015年 xiaohuoban. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    meihua,
    fangkuai,
    heitao,
    hongtao,
} CardType;

@interface NiuNiuCard : UIView

- (instancetype)initWithTypeNum:(NSInteger)num cardType:(CardType)type;
+ (UIImage *)imageFromView:(UIView *)theView;

@end
