//
//  NiuNiuCard.m
//  NiuNiu
//
//  Created by fuland539 on 15/12/22.
//  Copyright © 2015年 xiaohuoban. All rights reserved.
//

#import "NiuNiuCard.h"
#import "SkinManager.h"

@implementation NiuNiuCard

- (instancetype)initWithTypeNum:(NSInteger)num cardType:(CardType)type
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 50, 70);
        UIImageView *background = [[UIImageView alloc]initWithFrame:self.bounds];
        background.image = [[SkinManager inst] getImage:@"Live/Game/NiuNiu/niuniu_paimian"];
        [self addSubview:background];
        
        NSString *numColor = @"";
        NSMutableString *photoImgName = [NSMutableString stringWithString:@""];
        switch (type) {
            case meihua:
                numColor = @"hei";
                photoImgName = [NSMutableString stringWithString:@"niuniu_meihua"];
                break;
            case fangkuai:
                numColor = @"hong";
                photoImgName = [NSMutableString stringWithString:@"niuniu_fangkuai"];
                break;
            case heitao:
                numColor = @"hei";
                photoImgName = [NSMutableString stringWithString:@"niuniu_heitao"];
                break;
            case hongtao:
                numColor = @"hong";
                photoImgName = [NSMutableString stringWithString:@"niuniu_hongtao"];
                break;
            default:
                break;
        }
        
        if (num>10) {
            [photoImgName insertString:[NSString stringWithFormat:@"%zi",num] atIndex:photoImgName.length];
        }
        
        NSString *imageName = [NSString stringWithFormat:@"niuniu_%@%zi",numColor,num];;
        UIImageView *numImg = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 15, 20)];
        numImg.image = [[SkinManager inst] getImage:[NSString stringWithFormat:@"Live/Game/NiuNiu/%@",imageName]];
        [self addSubview:numImg];
        
        UIImageView *photoImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 25, 40, 40)];
        photoImg.image = [[SkinManager inst] getImage:[NSString stringWithFormat:@"Live/Game/NiuNiu/%@",photoImgName]];
        [self addSubview:photoImg];
        
    }
    return self;
}

+ (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContextWithOptions(theView.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
