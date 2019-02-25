//
//  GJImgScroll.h
//  ScrollImage
//
//  Created by Adron on 2017/7/11.
//  Copyright © 2017年 Adron. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ADImageScrollViewBlock)(int8_t index);

@interface GJImgScroll : UIView

@property (nonatomic, copy) ADImageScrollViewBlock imageBlock;

@property (nonatomic, strong) UIColor *backgroundColor;    ///< 背景色
@property (nonatomic) UIViewContentMode contentMode;       ///< 图片显示模式
@property (nonatomic, copy) UIColor *pageTintColor;        ///< 翻页主题色
@property (nonatomic, copy) UIColor *pageCurrentPageColor; ///< 当前页码颜色

/**
 初始化

 @param frame 循环滚动尺寸
 @param imagesArray 需要循环滚动的图片（运行过程中需要更新，可以调用下面的'updateScrollImages'方法）
 @param placeholder 加载占位图
 @param cycleTime 自动滚动的时间（如不需要自动滚动，可设置为0）
 @return 当前对象
 */
- (instancetype)initImageScrollWithFrame:(CGRect)frame
                                  Images:(NSArray *)imagesArray
                        placeholderImage:(nullable UIImage *)placeholder
                               cycleTime:(NSTimeInterval)cycleTime;

- (void)updateScrollImages:(NSArray *)imagesArray;

@end

NS_ASSUME_NONNULL_END
