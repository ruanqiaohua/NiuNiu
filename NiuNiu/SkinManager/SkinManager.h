//
//  SkinManager.h
//  LiveDemo
//
//  Created by fuland539 on 15-1-26.
//  Copyright (c) 2015年 pengbin. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBWithAlpha(rgbValue,alp) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alp]
#define screen_W [UIScreen mainScreen].bounds.size.width
#define screen_H [UIScreen mainScreen].bounds.size.height

#import <UIKit/UIKit.h>

@interface SkinManager : NSObject

+ (SkinManager *)inst;
+ (UIColor *) skinColor;

-(void) setCurrentSkin:(NSString *)skinName;
-(UIImage*)getImage:(NSString *)imageName;

@end
