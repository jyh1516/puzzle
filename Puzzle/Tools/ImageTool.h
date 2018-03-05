//
//  ImageTool.h
//  Puzzle
//
//  Created by 763092 on 2018/2/5.
//  Copyright © 2018年 Jyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageTool : NSObject

/**
 剪裁图片

 @param image 图片
 @param rect 剪裁区域
 @return 裁好的图片
 */
+ (UIImage *)trimImage:(UIImage *)image rect:(CGRect)rect;

/**
 压缩图片

 @param image 准备压缩的图片
 @param size 压缩的尺寸大小
 @return 压缩好的图片
 */
+ (UIImage *)scaleImage:(UIImage *)image size:(CGSize)size;


@end
