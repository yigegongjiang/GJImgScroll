//
//  GJImgScroll.m
//  ScrollImage
//
//  Created by Adron on 2017/7/11.
//  Copyright © 2017年 Adron. All rights reserved.
//

#import "GJImgScroll.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GJImgScroll () <UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl; ///< 翻页
@property (nonatomic, strong) NSArray *imagesPoolArray;   ///< 图片线程池（3个循环）
@property (nonatomic, strong) UIScrollView *scrollView;   ///< 滚动视图

@property (nonatomic, strong) NSArray *imagesArray;      ///< 需要展示的图片
@property (nonatomic, strong) UIImage *placeholderImage; ///< 加载占位图

@end

@implementation GJImgScroll {
  int8_t _currentIndex;      ///< 当前页码
  NSTimeInterval _cycleTime; ///< 自动滚动的时间
}

#pragma mark - Public Method
- (instancetype)initImageScrollWithFrame:(CGRect)frame
                                  Images:(NSArray *)imagesArray
                        placeholderImage:(nullable UIImage *)placeholder
                               cycleTime:(NSTimeInterval)cycleTime {
  self = [super initWithFrame:frame];
  if (self) {
    _currentIndex = 0;
    _cycleTime = cycleTime;
    self.placeholderImage = placeholder;
    self.imagesArray = [imagesArray copy];
  }
  return self;
}

- (void)updateScrollImages:(NSArray *)imagesArray {
  _currentIndex = 0;
  self.imagesArray = [imagesArray copy];
}

#pragma mark - Private Method

#pragma mark 重新设置Scroll和子Image的位置
- (void)setupImagesPoolPosition {
  UIImageView *poolLeft = [self.imagesPoolArray objectAtIndex:0];
  UIImageView *poolMiddle = [self.imagesPoolArray objectAtIndex:1];
  UIImageView *poolRight = [self.imagesPoolArray objectAtIndex:2];

  float imageWidth = [self imageWidth];
  float imageHeight = [self imageHeight];

  [poolLeft setFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
  [poolMiddle setFrame:CGRectMake(imageWidth, 0, imageWidth, imageHeight)];
  [poolRight setFrame:CGRectMake(imageWidth * 2, 0, imageWidth, imageHeight)];

  { // 各个ImageView开始赋值
    int8_t leftIndex = 0;
    int8_t middleIndex = 0;
    int8_t rightIndex = 0;

    middleIndex = _currentIndex;

    leftIndex = _currentIndex - 1;
    if (leftIndex < 0) {
      leftIndex = [self allImagesNum] - 1;
    }

    rightIndex = _currentIndex + 1;
    if (rightIndex > [self allImagesNum] - 1) {
      rightIndex = 0;
    }

    [poolMiddle sd_setImageWithURL:[self.imagesArray objectAtIndex:middleIndex]
                  placeholderImage:self.placeholderImage];
    [poolRight sd_setImageWithURL:[self.imagesArray objectAtIndex:rightIndex]
                 placeholderImage:self.placeholderImage];
    [poolLeft sd_setImageWithURL:[self.imagesArray objectAtIndex:leftIndex]
                placeholderImage:self.placeholderImage];
  }

  self.pageControl.currentPage = _currentIndex;
  self.pageControl.numberOfPages = [self allImagesNum];

  [self.scrollView setContentOffset:CGPointMake([self imageWidth], 0) animated:NO];

  [self startAutoScroll];
}

- (void)imageHaveClicked:(UITapGestureRecognizer *)sender {
  self.imageBlock ? self.imageBlock(_currentIndex) : nil;
}

#pragma mark 自动滚动 Start
- (void)startAutoScroll {
  [self stopAutoScroll];
  if (_cycleTime < 0) {
    // 如果循环时间过短，则不再循环
    return;
  }
  [self performSelector:@selector(autoScroll) withObject:nil afterDelay:_cycleTime];
}

- (void)stopAutoScroll {
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)autoScroll {
  [self.scrollView setContentOffset:CGPointMake([self imageWidth] * 2, 0) animated:YES];
  [self startAutoScroll];
}

#pragma mark 自动滚动 End

// 当前需要滚动的图片数目
- (int8_t)allImagesNum {
  return self.imagesArray.count;
}

- (float)imageWidth {
  return self.frame.size.width;
}

- (float)imageHeight {
  return self.frame.size.height;
}

#pragma mark - Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [self stopAutoScroll];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  CGPoint point = scrollView.contentOffset;
  NSInteger flag = point.x / [self imageWidth];
  if (flag == 1) {
    // 当前图片没有翻过去，保持原样
  } else if (flag == 0) {
    _currentIndex--;
  } else {
    _currentIndex++;
  }

  if (_currentIndex < 0) {
    _currentIndex = [self allImagesNum] - 1;
  } else if (_currentIndex > [self allImagesNum] - 1) {
    _currentIndex = 0;
  }
  [self setupImagesPoolPosition];
}

#pragma mark - Set/Get

- (NSArray *)imagesPoolArray {
  if (!_imagesPoolArray) {
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:3];
    for (int i = 0; i < 3; i++) {
      UIImageView *imageView = UIImageView.new;
      imageView.layer.masksToBounds = YES;
      [imageView setContentMode:UIViewContentModeScaleAspectFill];
      [self.scrollView addSubview:imageView];
      [temp addObject:imageView];
    }
    _imagesPoolArray = [temp copy];
  }
  return _imagesPoolArray;
}

- (UIScrollView *)scrollView {
  if (!_scrollView) {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_scrollView setPagingEnabled:YES];
    [self addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake([self imageWidth] * 3, [self imageHeight])];

    UITapGestureRecognizer *tapGes =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageHaveClicked:)];
    [_scrollView addGestureRecognizer:tapGes];
  }
  return _scrollView;
}

- (UIPageControl *)pageControl {
  if (!_pageControl) {
    _pageControl = [[UIPageControl alloc]
        initWithFrame:CGRectMake(0, [self imageHeight] - 40, [self imageWidth], 40)];
    [_pageControl setUserInteractionEnabled:NO];
    [self addSubview:_pageControl];
  }
  [self bringSubviewToFront:_pageControl];
  return _pageControl;
}

- (void)setImagesArray:(NSArray *)imagesArray {
  if (imagesArray == nil || imagesArray.count == 0) {
    printf("ADImageScrollView -> 当前需要展示的图片数目为空\n");
    return;
  }
  _imagesArray = imagesArray;
  [self setupImagesPoolPosition];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
  [self setBackgroundColor:backgroundColor ? backgroundColor : [UIColor whiteColor]];
}

- (void)setContentMode:(UIViewContentMode)contentMode {
  for (UIImageView *imageView in self.imagesPoolArray) {
    [imageView setContentMode:contentMode];
  }
}

- (void)setPageTintColor:(UIColor *)pageTintColor {
  [self.pageControl setPageIndicatorTintColor:pageTintColor];
}

- (void)setPageCurrentPageColor:(UIColor *)pageCurrentPageColor {
  [self.pageControl setCurrentPageIndicatorTintColor:pageCurrentPageColor];
}

#pragma mark - Life Cycle

@end
