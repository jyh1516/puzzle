//
//  ViewController.m
//  Puzzle
//
//  Created by 763092 on 2018/2/5.
//  Copyright © 2018年 Jyh. All rights reserved.
//

#import "ViewController.h"
#import "ImageTool.h"
#import "PuzzleImageView.h"

#define Row 3
#define Col 3

@interface ViewController ()
/**空白块*/
@property (nonatomic, strong) PuzzleImageView *blankPuzzle;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    UIImage *image = [UIImage imageNamed:@"Minions.jpeg"];
    // 适配各尺寸图片与屏幕尺寸相符
    image = [ImageTool scaleImage:image size:CGSizeMake(self.view.frame.size.width / (Col + 1) * Col - 10, self.view.frame.size.height - 40)];
    // 顺便适配一下iPhoneX
    if (self.view.frame.size.height > 736)
    {
        image = [ImageTool scaleImage:image size:CGSizeMake(self.view.frame.size.width / (Col + 1) * Col - 10, self.view.frame.size.height - 100)];
    }
    // 左上角坐标
    CGPoint position = CGPointMake(5, (self.view.frame.size.height - image.size.height) / 2);
    for (NSInteger row = 0; row < Row; row++)
    {
        for (NSInteger col = 0; col < Col; col++)
        {
            PuzzleImageView *imageView = [[PuzzleImageView alloc] init];
            // 记录初始位置和正确位置
            imageView.row = row;
            imageView.col = col;
            imageView.correctRow = row;
            imageView.correctCol = col;
            [self configPuzzle:imageView image:image point:position];
            [self.view addSubview:imageView];
        }
    }
    
    PuzzleImageView *blankImageView = [[PuzzleImageView alloc] init];
    blankImageView.row = 0;
    blankImageView.col = Col;
    blankImageView.correctRow = 0;
    blankImageView.correctCol = Col;
    [self.view addSubview:blankImageView];
    [self configPuzzle:blankImageView image:image point:position];
    
    [self randomTap];
}

// MARK: - 打乱拼图顺序
- (void)randomTap
{
    for (NSInteger i = 0; i < 1000; i++)
    {
        NSInteger randomRow = arc4random() % Row;
        NSInteger randomCol = arc4random() % Col;
        
        [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[PuzzleImageView class]])
            {
                if ([(PuzzleImageView *)obj row] == randomRow && [(PuzzleImageView *)obj col] == randomCol)
                {
                    [self tapPuzzle:obj];
                }
            }
        }];
    }
}

// MARK: - Tap
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    __block PuzzleImageView *selectedImageView = nil;
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PuzzleImageView class]])
        {
            /*
                position获取被点击块内的坐标, 其他块此时的position是以被点击块的触摸点为原点来计算坐标的
             */
            CGPoint position = [sender locationInView:obj];
            BOOL condition = position.x > 0 && position.y > 0 && position.x < obj.frame.size.width && position.y < obj.frame.size.height;
            if (condition)
            {
                selectedImageView = obj;
                *stop = YES;
            }
        }
    }];
    [self tapPuzzle:selectedImageView];
    // 全部移动回原位
    __block BOOL success = YES;
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PuzzleImageView class]])
        {
            if ([(PuzzleImageView *)obj correctRow] == [(PuzzleImageView *)obj row] &&
                [(PuzzleImageView *)obj correctCol] == [(PuzzleImageView *)obj col]){}
            else // 只要有一块没回到原位, success == NO;
            {
                success = NO;
                *stop = YES;
            }
        }
    }];
    
    if (success)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"社会社会" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"ojbk" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)tapPuzzle:(PuzzleImageView *)selectedImageView
{
    // 判断点击有效性
    if (selectedImageView)
    {
        // 点击的拼图块是否在空白格上或下
        BOOL isTopOrBottom = labs(selectedImageView.row - self.blankPuzzle.row) == 1 && selectedImageView.col == self.blankPuzzle.col;
        // 点击的拼图块是否在空白格的左或右
        BOOL isLeftOrTop = labs(selectedImageView.col - self.blankPuzzle.col) == 1 && selectedImageView.row == self.blankPuzzle.row;
        
        if (isTopOrBottom || isLeftOrTop)
        {
            [UIView animateWithDuration:0.3f animations:^{
                NSInteger tempRow = self.blankPuzzle.row;
                NSInteger tempCol = self.blankPuzzle.col;
                CGRect tempFrame = self.blankPuzzle.frame;
                
                self.blankPuzzle.row = selectedImageView.row;
                self.blankPuzzle.col = selectedImageView.col;
                self.blankPuzzle.frame = selectedImageView.frame;
                
                selectedImageView.row = tempRow;
                selectedImageView.col = tempCol;
                selectedImageView.frame = tempFrame;
            }];
        }
    }
}

// MARK: - 根据row, col, correctRow, correntCol配置拼图块的frame, 图片
- (void)configPuzzle:(PuzzleImageView *)imageView image:(UIImage *)image point:(CGPoint)point
{
    // 从整个图片剪裁下来的每个小图片的frame (相对于原图)
    CGRect imageFrame = CGRectMake(imageView.correctCol * image.size.width / Col, imageView.correctRow * image.size.height / Row, image.size.width / Col, image.size.height / Row);
    // 每块拼图的frame (相对于self.view)
    CGRect puzzleFrame = CGRectMake(point.x + imageView.col * image.size.width / Col, point.y + imageView.row * image.size.height / Row, image.size.width / Col, image.size.height / Row);
    imageView.frame = puzzleFrame;
    
    if (imageView.correctRow == 0 && imageView.correctCol == Col)
    {
        self.blankPuzzle = imageView;
        self.blankPuzzle.backgroundColor = [UIColor darkGrayColor];
    }
    else
    {
        imageView.image = [ImageTool trimImage:image rect:imageFrame];
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

@end
