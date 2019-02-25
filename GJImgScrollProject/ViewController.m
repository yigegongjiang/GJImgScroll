//
//  ViewController.m
//  GJImgScrollProject
//
//  Created by 一个工匠 on 2019/2/25.
//  Copyright © 2019 one.gongjiang. All rights reserved.
//

#import "ViewController.h"
#import "GJImgScroll/GJImgScroll.h"

#ifndef ADScreenHeight
#define ADScreenHeight [UIScreen mainScreen].bounds.size.height
#endif
#ifndef ADScreenWidth
#define ADScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

@interface ViewController ()

@end

@implementation ViewController {
    GJImgScroll *v;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *imageArray = @[
                            [NSURL URLWithString:@"https://img1.doubanio.com/view/photo/large/public/p2464977809.jpg"],
                            [NSURL URLWithString:@"https://img3.doubanio.com/view/photo/lphoto/public/p2477199663.jpg"],
                            [NSURL URLWithString:@"https://img1.doubanio.com/view/photo/lphoto/public/p2477199679.jpg"],
                            [NSURL URLWithString:@"https://img3.doubanio.com/view/photo/lphoto/public/p2469764440.jpg"],
                            [NSURL URLWithString:@"https://img3.doubanio.com/view/photo/lphoto/public/p2469761712.jpg"],
                            [NSURL URLWithString:@"https://img3.doubanio.com/view/photo/lphoto/public/p2469727100.jpg"]
                            ];
    v = [[GJImgScroll alloc] initImageScrollWithFrame:CGRectMake(0, 100, ADScreenWidth, 200)
                                                     Images:imageArray
                                           placeholderImage:nil
                                                  cycleTime:2.0];
    [v setContentMode:UIViewContentModeScaleAspectFill];
    [v setImageBlock:^(int8_t index) {
        NSLog(@"点击了 %d 图片", index);
    }];
    [self.view addSubview:v];
}

- (IBAction)changeImage:(id)sender {
    NSArray *imageArray = @[
                            [NSURL URLWithString:@"https://img3.doubanio.com/view/photo/lphoto/public/p2469764440.jpg"],
                            [NSURL URLWithString:@"https://img3.doubanio.com/view/photo/lphoto/public/p2469761712.jpg"],
                            [NSURL URLWithString:@"https://img3.doubanio.com/view/photo/lphoto/public/p2469727100.jpg"]
                            ];
    [v updateScrollImages:imageArray];
    
    [v setPageTintColor:[UIColor redColor]];
    [v setPageCurrentPageColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
