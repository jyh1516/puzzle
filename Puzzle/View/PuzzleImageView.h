//
//  PuzzleImageView.h
//  Puzzle
//
//  Created by 763092 on 2018/2/5.
//  Copyright © 2018年 Jyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PuzzleImageView : UIImageView
/**拼图块所在的行*/
@property (nonatomic, assign) NSInteger row;
/**拼图块所在的列*/
@property (nonatomic, assign) NSInteger col;
/**拼图正确时所在的行*/
@property (nonatomic, assign) NSInteger correctRow;
/**拼图正确时所在的列*/
@property (nonatomic, assign) NSInteger correctCol;

@end
