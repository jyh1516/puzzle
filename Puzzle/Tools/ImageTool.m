//
//  ImageTool.m
//  Puzzle
//
//  Created by 763092 on 2018/2/5.
//  Copyright © 2018年 Jyh. All rights reserved.
//

#import "ImageTool.h"

@implementation ImageTool

+ (UIImage *)trimImage:(UIImage *)image rect:(CGRect)rect
{
    CGImageRef imageRef = image.CGImage;
    CGImageRef resultImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, resultImageRef);
    UIImage *result = [UIImage imageWithCGImage:resultImageRef];
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIImage *)scaleImage:(UIImage *)image size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
