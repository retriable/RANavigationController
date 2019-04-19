//
//  ViewController.m
//  RANC iOS Example
//
//  Created by retriable on 2019/4/19.
//  Copyright © 2019 retriable. All rights reserved.
//

@import RANC;

#import <objc/message.h>

#import "ViewController.h"

@interface Model : NSObject

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)void(^block)(void);

@end

@implementation Model : NSObject

@end

@interface Cell : UICollectionViewCell

@property (nonatomic,strong)UILabel *label;

@end

@implementation Cell

- (instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (!self) return nil;
    [self.contentView addSubview:self.label];
    return self;
}

- (UILabel*)label{
    if (_label) return _label;
    _label=[[UILabel alloc]init];
    return _label;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.label.frame=self.contentView.bounds;
}
@end

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,assign)UIInterfaceOrientation orientation;
@property (nonatomic,strong)NSArray *Models;
@property (nonatomic,strong)UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%@，viewWillAppear：%@",self.title,@(animated));
    if (!self.ra_defineRotationContext) [self.navigationController setNavigationBarHidden:YES animated:NO];
    ((void (*)(id, SEL, UIInterfaceOrientation))(void *) objc_msgSend)([UIDevice currentDevice], NSSelectorFromString(@"setOrientation:"), UIInterfaceOrientationLandscapeRight);
    [UIViewController attemptRotationToDeviceOrientation];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%@，viewDidAppear：%@",self.title,@(animated));
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"%@，viewWillDisappear：%@",self.title,@(animated));
    ((void (*)(id, SEL, UIInterfaceOrientation))(void *) objc_msgSend)([UIDevice currentDevice], NSSelectorFromString(@"setOrientation:"), UIInterfaceOrientationPortrait);
    [UIViewController attemptRotationToDeviceOrientation];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"%@，viewDidDisappear：%@",self.title,@(animated));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.title){
        self.title=@"0";
    }
    self.navigationController.view.backgroundColor=!self.ra_defineRotationContext?[UIColor colorWithWhite:0 alpha:0.5]:[UIColor whiteColor];
    __weak typeof(self) weakSelf=self;
    self.Models=@[
                        ({
                            Model *v=[[Model alloc]init];
                            v.title=@"pop 1";
                            v.block = ^{
                                [weakSelf.ra_navigationController popViewController];
                            };
                            v;
                        }),
                        ({
                            Model *v=[[Model alloc]init];
                            v.title=@"pop 2";
                            v.block=^{
                                NSInteger i=weakSelf.ra_navigationController.viewControllers.count-3;
                                if (i>0){
                                    [weakSelf.ra_navigationController popToViewController:weakSelf.ra_navigationController.viewControllers[i]];
                                }
                            };
                            v;
                        }),
                        ({
                            Model *v=[[Model alloc]init];
                            v.title=@"ppush 1";
                            v.block=^{
                                [weakSelf.ra_navigationController pushViewController:({
                                    ViewController *v= [[ViewController alloc]init];
                                    v.title=[@(weakSelf.title.integerValue+1) description];
                                    v.ra_transition=[[RADefaultTransition alloc]init];
                                    v;
                                }) animated:YES];
                            };
                            v;
                        }),
                        ({
                            Model *v=[[Model alloc]init];
                            v.title=@"lpush 1";
                            v.block=^{
                                [weakSelf.ra_navigationController pushViewController:({
                                    ViewController *v= [[ViewController alloc]init];
                                    v.title=[@(weakSelf.title.integerValue+1) description];
                                    v.ra_transition=[[RADefaultTransition alloc]init];
                                    v.orientation=UIInterfaceOrientationLandscapeRight;
                                    v;
                                }) animated:YES];
                            };
                            v;
                        }),
                        ({
                            Model *v=[[Model alloc]init];
                            v.title=@"ppush 2";
                            v.block=^{
                                [weakSelf.ra_navigationController pushViewControllers:@[({
                                    ViewController *v= [[ViewController alloc]init];
                                    v.title=[@(weakSelf.title.integerValue+1) description];
                                    v.ra_transition=[[RADefaultTransition alloc]init];
                                    v;
                                }),({
                                    ViewController *v= [[ViewController alloc]init];
                                    v.title=[@(weakSelf.title.integerValue+2) description];
                                    v.ra_transition=[[RADefaultTransition alloc]init];
                                    v;
                                })] animated:YES];
                            };
                            v;
                        }),
                        ({
                            Model *v=[[Model alloc]init];
                            v.title=@"lpush 2";
                            v.block=^{
                                [weakSelf.ra_navigationController pushViewControllers:@[({
                                    ViewController *v= [[ViewController alloc]init];
                                    v.title=[@(weakSelf.title.integerValue+1) description];
                                    v.ra_transition=[[RADefaultTransition alloc]init];
                                    v.orientation=UIInterfaceOrientationLandscapeRight;
                                    v;
                                }),({
                                    ViewController *v= [[ViewController alloc]init];
                                    v.title=[@(weakSelf.title.integerValue+2) description];
                                    v.ra_transition=[[RADefaultTransition alloc]init];
                                    v.orientation=UIInterfaceOrientationLandscapeRight;
                                    v;
                                })] animated:YES];
                            };
                            v;
                        }),
                        ({
                            Model *v=[[Model alloc]init];
                            v.title=@"plpush 2";
                            v.block=^{
                                [weakSelf.ra_navigationController pushViewControllers:@[({
                                    ViewController *v= [[ViewController alloc]init];
                                    v.title=[@(weakSelf.title.integerValue+1) description];
                                    v.ra_transition=[[RADefaultTransition alloc]init];
                                    v;
                                }),({
                                    ViewController *v= [[ViewController alloc]init];
                                    v.title=[@(weakSelf.title.integerValue+2) description];
                                    v.ra_transition=[[RADefaultTransition alloc]init];
                                    v.orientation=UIInterfaceOrientationLandscapeRight;
                                    v;
                                })] animated:YES];
                            };
                            v;
                        }),
                        ({
                            Model *v=[[Model alloc]init];
                            v.title=@"lppush 2";
                            v.block=^{
                                [weakSelf.ra_navigationController pushViewControllers:@[({
                                    ViewController *v= [[ViewController alloc]init];
                                    v.title=[@(weakSelf.title.integerValue+1) description];
                                    v.ra_transition=[[RADefaultTransition alloc]init];
                                    v.orientation=UIInterfaceOrientationLandscapeRight;
                                    v;
                                }),({
                                    ViewController *v= [[ViewController alloc]init];
                                    v.title=[@(weakSelf.title.integerValue+2) description];
                                    v.ra_transition=[[RADefaultTransition alloc]init];
                                    v;
                                })] animated:YES];
                            };
                            v;
                        }),
                        /*({
                         Model *v=[[Model alloc]init];
                         v.title=@"sheet";
                         v.block=^{
                         [weakSelf.ra_navigationController pushViewControllers:@[({
                         ViewController *v= [[ViewController alloc]init];
                         v.title=[@(weakSelf.title.integerValue+1) description];
                         v.ra_transition=({
                         RASheetTransition *v=[[RASheetTransition alloc]init];
                         v;
                         });
                         v.ra_defineRotationContext=NO;
                         v;
                         })] animated:YES];
                         };
                         v;
                         }),*/
                        ];
    UICollectionView  *collectionView=({
        UICollectionViewFlowLayout *layout=({
            UICollectionViewFlowLayout *v=[[UICollectionViewFlowLayout alloc]init];
            v.itemSize=CGSizeMake(200, 44);
            v;
        });
        UICollectionView *v=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [v registerClass:Cell.class forCellWithReuseIdentifier:@"cell"];
        v.dataSource=self;
        v.delegate=self;
        v.backgroundColor=[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
        v;
    });
    [self.view addSubview:collectionView];
    collectionView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraints:@[
                                !self.ra_defineRotationContext?[NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:88]:[NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                                 [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                                 [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
                                 [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]
                                 ]];
    self.collectionView=collectionView;
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (!self.ra_defineRotationContext) self.collectionView.layer.mask=({
        CAShapeLayer *v=[CAShapeLayer layer];
        v.frame=self.collectionView.bounds;
        v.path=[UIBezierPath bezierPathWithRoundedRect:self.collectionView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)].CGPath;
        v;
    });
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.Models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    cell.label.text=[self.Models[indexPath.item] title];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    Model *model=self.Models[indexPath.item];
    model.block();
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return self.orientation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return 1<<self.orientation;
    //    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)orientation{
    if (_orientation==UIInterfaceOrientationUnknown) _orientation=UIInterfaceOrientationPortrait;
    return _orientation;
}
@end
