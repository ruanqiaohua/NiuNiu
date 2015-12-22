//
//  SkinManager.m
//  LiveDemo
//
//  Created by fuland539 on 15-1-26.
//  Copyright (c) 2015年 pengbin. All rights reserved.
//

#import "SkinManager.h"

#define parentPath @"resource"
#define resPath @"Skins"

@interface SkinManager()
@property (nonatomic,strong) NSString * curSkinName;
@property (nonatomic,strong) NSString * resdirectory;
@end

@implementation SkinManager

+ (SkinManager *)inst {
    static SkinManager *sSkinManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sSkinManager = [[SkinManager alloc] init];

        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        sSkinManager.resdirectory = [doc stringByAppendingPathComponent:parentPath];
        
    });
    
    return sSkinManager;
}
+ (UIColor *) skinColor
{
    return UIColorFromRGB(0xe92d6f);
}

-(void) setCurrentSkin:(NSString *)skinName
{
    _curSkinName = skinName;
}

-(UIImage*)getImage:(NSString *)imageName
{
    NSString * fullImageName = [NSString stringWithFormat:@"Skins/%@/%@",_curSkinName,imageName];
    NSString * localImageName = [NSString stringWithFormat:@"%@/%@",_resdirectory,fullImageName];
    UIImage * image1 = [UIImage imageWithContentsOfFile:localImageName];//to do 没有缓存
    if (!image1) {
        UIImage * image = [UIImage imageNamed:fullImageName];
        if (!image) {
            NSString * error = [NSString stringWithFormat:@"皮肤图片 %@ 丢失！",fullImageName];
            NSLog(@"%@",error);
        }
        return image;
    }
    return image1;
    
}

@end
