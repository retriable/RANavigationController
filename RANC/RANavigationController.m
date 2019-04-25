    //
    //  RANavigationController.m
    //  RANC
    //
    //  Created by retriable on 2019/4/19.
    //  Copyright © 2019 retriable. All rights reserved.
    //

#import <objc/message.h>

#import "NSObject+RAPrivate.h"
#import "RANavigationController.h"
#import "RATransition+RAPrivate.h"
#import "UINavigationController+RAPrivate.h"
#import "UIViewController+RAPrivate.h"
#import "UIViewController+RAPublic.h"

@interface RANavigationController ()
{
    NSArray<__kindof UIViewController*> *_viewControllers;
}

@property (nonatomic,assign) BOOL                   busy;
@property (nonatomic,assign) Class                  navigationControllerClass;
@property (nonatomic,weak  ) UIViewController       *activedViewController;
@property (nonatomic,strong) NSMutableArray<__kindof UINavigationController*> *navigationControllers;

@end

@implementation RANavigationController

- (instancetype)initWithNavigationControllerClass:(nullable Class)navigationControllerClass{
    self=[self init];
    if (!self) return nil;
    self.navigationControllerClass=navigationControllerClass;
    return self;
}

- (instancetype)initWithRootViewController:(__kindof UIViewController *)rootViewController{
    self=[self init];
    if (!self) return nil;
    [self pushViewController:rootViewController animated:NO];
    return self;
}

- (instancetype)initWithViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    self=[self init];
    if (!self) return nil;
    [self pushViewControllers:viewControllers animated:NO];
    return self;
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    [self setViewControllers:viewControllers animated:NO];
}

- (void)pushViewController:(__kindof UIViewController *)viewController{
    [self pushViewController:viewController animated:YES];
}

- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    [self pushViewControllers:viewControllers animated:YES];
}

- (nullable __kindof UIViewController *)popViewController{
    return [self popViewControllerAnimated:YES];
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewController{
    return [self popToRootViewControllerAnimated:YES];
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController{
    return [self popToViewController:viewController animated:YES];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated{
    [self setViewControllers:viewControllers animated:animated completion:nil];
}

- (void)pushViewController:(__kindof UIViewController *)viewController animated:(BOOL)animated{
    [self pushViewController:viewController animated:animated completion:nil];
}

- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated{
    [self pushViewControllers:viewControllers animated:animated completion:nil];
}

- (nullable __kindof UIViewController *)popViewControllerAnimated:(BOOL)animated{
    return [self popViewControllerAnimated:animated completion:nil];
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    return [self popToRootViewControllerAnimated:animated completion:nil];
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    return [self popToViewController:viewController animated:animated completion:nil];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void(^_Nullable)(void))completion{
    if (self.busy) {
        if (completion) completion();
        return;
    }
    self.busy=YES;
    if (viewControllers.count==0){
        self.busy=NO;
        if (completion) completion();
        return;
    }
    __weak typeof(self) weakSelf=self;
    [self _pushViewControllers:viewControllers increasing:NO animated:animated completion:^{
        weakSelf.busy=NO;
        if (completion) completion();
    }];
}

- (void)pushViewController:(__kindof UIViewController *)viewController animated:(BOOL)animated completion:(void(^_Nullable)(void))completion{
    if (self.busy) {
        if (completion) completion();
        return;
    }
    self.busy=YES;
    __weak typeof(self) weakSelf=self;
    [self _pushViewControllers:@[viewController] increasing:YES animated:animated completion:^{
        weakSelf.busy=NO;
        if (completion) completion();
    }];
}

- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void(^_Nullable)(void))completion{
    if (self.busy) {
        if (completion) completion();
        return;
    }
    self.busy=YES;
    if (viewControllers.count==0){
        self.busy=NO;
        if (completion) completion();
        return;
    }
    __weak typeof(self) weakSelf=self;
    [self _pushViewControllers:viewControllers increasing:YES animated:animated completion:^{
        weakSelf.busy=NO;
        if (completion) completion();
    }];
}

- (nullable __kindof UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void(^_Nullable)(void))completion{
    if (self.busy) {
        if (completion) completion();
        return nil;
    }
    self.busy=YES;
    if (self.viewControllers.count<2){
        self.busy=NO;
        if (completion) completion();
        return nil;
    }
    __weak typeof(self) weakSelf=self;
    return [self _popToViewController:self.viewControllers[self.viewControllers.count-2] animated:animated completion:^{
        weakSelf.busy=NO;
        if (completion) completion();
    }].lastObject;
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated completion:(void(^_Nullable)(void))completion{
    if (self.busy) {
        if (completion) completion();
        return nil;
    }
    self.busy=YES;
    if (self.viewControllers.count<2){
        self.busy=NO;
        if (completion) completion();
        return nil;
    }
    __weak typeof(self) weakSelf=self;
    return [self _popToViewController:self.viewControllers.firstObject animated:animated completion:^{
        weakSelf.busy=NO;
        if (completion) completion();
    }];
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void(^_Nullable)(void))completion{
    if (self.busy) {
        if (completion) completion();
        return nil;
    }
    self.busy=YES;
    NSUInteger index=[self.viewControllers indexOfObject:viewController];
    if (index==NSNotFound){
        self.busy=NO;
        if (completion) completion();
        return nil;
    }
    if (index==self.viewControllers.count-1){
        self.busy=NO;
        if (completion) completion();
        return nil;
    }
    __weak typeof(self) weakSelf=self;
    return [self _popToViewController:viewController animated:animated completion:^{
        weakSelf.busy=NO;
        if (completion) completion();
    }];
}

- (void)_pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers increasing:(BOOL)increasing animated:(BOOL)animated completion:(void(^_Nullable)(void))completion{
    __weak typeof(self) weakSelf=self;
    NSMutableArray<void(^)(void)> *completions=[NSMutableArray array];
    NSMutableArray<void(^)(void)> *cancels=[NSMutableArray array];
    dispatch_group_t group=dispatch_group_create();
    void (^completionBlock)(void)=^{
        dispatch_group_leave(group);
    };
    __block BOOL interactive=NO;
    BOOL (^isInteractiveBlock)(void)=^{
        return interactive;
    };
    void (^interactBlock)(void)=^{
        if (interactive) return;
        interactive=YES;
    };
    __block BOOL cancelled=NO;
    BOOL (^isCancelledBlock)(void)=^{
        return cancelled;
    };
    void (^cancelBlock)(void)=^{
        if (cancelled) return;
        cancelled=YES;
        [cancels enumerateObjectsUsingBlock:^(void (^ _Nonnull obj)(void), NSUInteger idx, BOOL * _Nonnull stop) {
            obj();
        }];
    };
    
    NSMutableArray<__kindof UIViewController*> *navigationControllers=[self.navigationControllers mutableCopy];
    NSUInteger index=navigationControllers.count-1;
    NSArray *pushedNavigationControllers=({
        NSMutableArray *v=[NSMutableArray array];
        for (NSInteger i=0,count=viewControllers.count;i<count;i++){
            BOOL backItemVisable = !increasing?(i!=0):i+navigationControllers.count>0;
            [v addObject:[self createNavigationControllerForViewController:viewControllers[i] backItemVisable:backItemVisable]];
        }
        v;
    });
    [navigationControllers addObjectsFromArray:pushedNavigationControllers];
    BOOL appear=self.view.superview?YES:NO;
    BOOL visableFlags[navigationControllers.count];
    for (NSInteger count=navigationControllers.count-1,i=count;i>=0;i--){
        if (i==count) visableFlags[i]=YES;
        else if (i>index) {
            UIViewController *nextViewController=navigationControllers[i+1];
            visableFlags[i]=visableFlags[i+1]?nextViewController.ra_transition.style==RATransitioningOverCurrentContext:NO;
        }else {
            UIViewController *nextViewController=navigationControllers[i+1];
            visableFlags[i]=increasing?(visableFlags[i+1]?nextViewController.ra_transition.style==RATransitioningOverCurrentContext:NO):NO;
        }
    }
    for (NSInteger i=viewControllers.count-1;i>=0;i--){
        UIViewController *viewController=viewControllers[i];
        if (viewController.ra_defineRotationContext){
            UIViewController *activedViewController=self.activedViewController;
            self.activedViewController=viewController;
            [completions addObject:^{
                if (cancelled){
                    weakSelf.activedViewController=activedViewController;
                }
            }];
            break;
        }
    }
    for (NSInteger i=0,count=navigationControllers.count;i<count;i++){
        __weak UINavigationController *navigationController=navigationControllers[i];
        if (visableFlags[i]) {
            if (!navigationController.parentViewController){
                [self ra_addChildViewController:navigationController];
                if(appear) [navigationController beginAppearanceTransition:YES animated:animated];
                [self.view addSubview:navigationController.view];
                navigationController.view.translatesAutoresizingMaskIntoConstraints=NO;
                [self.view addConstraints:@[
                                            [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                            [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
                                            [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
                                            [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:0]]
                 ];
                [completions addObject:^{
                    [navigationController didMoveToParentViewController:self];
                    if (cancelled){
                        [navigationController willMoveToParentViewController:nil];
                        [navigationController.view removeFromSuperview];
                        [navigationController removeFromParentViewController];
                    }
                    if(appear) [navigationController endAppearanceTransition];
                    navigationController.interactivePopGestureRecognizer.enabled=NO;
                }];
                [cancels addObject:^{
                    if(appear) [navigationController beginAppearanceTransition:NO animated:animated];
                }];
            }
            if (animated){
                dispatch_group_enter(group);
                RATransition *transition=navigationController.ra_transition;
                transition.containerViewController=self;
                transition.viewController=navigationController;
                transition.action=RATransitioningPush;
                transition.state=i==count-1?RATransitioningForeground:RATransitioningBackground;
                transition.isInteractiveBlock = isInteractiveBlock;
                transition.interactBlock = interactBlock;
                transition.isCancelledBlock = isCancelledBlock;
                transition.cancelBlock = cancelBlock;
                transition.completionBlock = completionBlock;
                [transition _animate];
            }
        }else{
            if (navigationController.parentViewController){
                [self.view sendSubviewToBack:navigationController.view];
                [navigationController willMoveToParentViewController:nil];
                if(appear) [navigationController beginAppearanceTransition:NO animated:animated];
                [completions addObject:^{
                    if(appear) [navigationController endAppearanceTransition];
                    if (!cancelled){
                        [navigationController.view removeFromSuperview];
                        [navigationController removeFromParentViewController];
                    }else{
                        [navigationController removeFromParentViewController];
                        [weakSelf addChildViewController:navigationController];
                        [navigationController didMoveToParentViewController:weakSelf];
                    }
                }];
                [cancels addObject:^{
                    if(appear) [navigationController beginAppearanceTransition:YES animated:animated];
                }];
                if (animated){
                    dispatch_group_enter(group);
                    RATransition *transition=navigationController.ra_transition;
                    transition.containerViewController=self;
                    transition.viewController=navigationController;
                    transition.action=RATransitioningPush;
                    transition.state=RATransitioningInvisible;
                    transition.isInteractiveBlock = isInteractiveBlock;
                    transition.interactBlock = interactBlock;
                    transition.isCancelledBlock = isCancelledBlock;
                    transition.cancelBlock = cancelBlock;
                    transition.completionBlock = completionBlock;
                    [transition _animate];
                }
            }
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSInteger i=completions.count-1;i>=0;i--){
                completions[i]();
            }
            if (cancelled){
                if (completion) completion();
                return;
            }
            if (!increasing){
                [(NSMutableArray*)weakSelf.viewControllers removeAllObjects];
                [weakSelf.navigationControllers removeAllObjects];
            }
            [(NSMutableArray*)weakSelf.viewControllers addObjectsFromArray:viewControllers];
            [weakSelf.navigationControllers addObjectsFromArray:pushedNavigationControllers];
            if (completion) completion();
        });
    });
}

- (nullable NSArray<__kindof UIViewController *> *)_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void(^_Nullable)(void))completion{
    __weak typeof(self) weakSelf=self;
    NSMutableArray<void(^)(void)> *completions=[NSMutableArray array];
    NSMutableArray<void(^)(void)> *cancels=[NSMutableArray array];
    dispatch_group_t group=dispatch_group_create();
    void (^completionBlock)(void)=^{
        dispatch_group_leave(group);
    };
    __block BOOL interactive=NO;
    BOOL (^isInteractiveBlock)(void)=^{
        return interactive;
    };
    void (^interactBlock)(void)=^{
        if (interactive) return;
        interactive=YES;
    };
    __block BOOL cancelled=NO;
    BOOL (^isCancelledBlock)(void)=^{
        return cancelled;
    };
    void (^cancelBlock)(void)=^{
        if (cancelled) return;
        cancelled=YES;
        [cancels enumerateObjectsUsingBlock:^(void (^ _Nonnull obj)(void), NSUInteger idx, BOOL * _Nonnull stop) {
            obj();
        }];
    };
    NSArray *navigationControllers=[self.navigationControllers copy];
    BOOL visableFlags[navigationControllers.count];
    BOOL appeared=self.view.superview?YES:NO;
    NSUInteger index=[self.viewControllers indexOfObject:viewController];
    NSArray *popedViewControllers=[self.viewControllers subarrayWithRange:NSMakeRange(index+1, self.viewControllers.count-index-1)];
    for (NSInteger i=index;i>=0;i--){
        UIViewController *viewController=self.viewControllers[i];
        if (viewController.ra_defineRotationContext){
            UIViewController *activedViewController=self.activedViewController;
            self.activedViewController=viewController;
            [completions addObject:^{
                if (cancelled){
                    weakSelf.activedViewController=activedViewController;
                }
            }];
            break;
        }
    }
    for (NSInteger count=navigationControllers.count-1,i=count;i>=0;i--){
        visableFlags[i]=NO;
        if (i==index) visableFlags[i]=YES;
        else if (i>index) visableFlags[i]=NO;
        else{
            UIViewController *nextViewController=self.navigationControllers[i+1];
            visableFlags[i]=visableFlags[i+1]?nextViewController.ra_transition.style==RATransitioningOverCurrentContext:NO;
        }
        __weak UINavigationController *navigationController=navigationControllers[i];
        if (visableFlags[i]) {
            if (!navigationController.parentViewController){
                [self ra_addChildViewController:navigationController];
                if(appeared) [navigationController beginAppearanceTransition:YES animated:animated];
                [self.view insertSubview:navigationController.view atIndex:0];
                navigationController.view.translatesAutoresizingMaskIntoConstraints=NO;
                [self.view addConstraints:@[
                                            [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                            [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
                                            [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
                                            [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:0]]
                 ];
                [completions addObject:^{
                    [navigationController didMoveToParentViewController:weakSelf];
                    if (cancelled){
                        [navigationController willMoveToParentViewController:nil];
                        [navigationController.view removeFromSuperview];
                        [navigationController removeFromParentViewController];
                    }
                    if(appeared) [navigationController endAppearanceTransition];
                }];
                [cancels addObject:^{
                    if(appeared) [navigationController beginAppearanceTransition:NO animated:animated];
                }];
            }
            if (animated){
                dispatch_group_enter(group);
                RATransition *transition=navigationController.ra_transition;
                transition.containerViewController=self;
                transition.viewController=navigationController;
                transition.action=RATransitioningPop;
                transition.state=i==index?RATransitioningForeground:RATransitioningBackground;
                transition.isInteractiveBlock = isInteractiveBlock;
                transition.interactBlock = interactBlock;
                transition.isCancelledBlock = isCancelledBlock;
                transition.cancelBlock = cancelBlock;
                transition.completionBlock = completionBlock;
                [transition _animate];
            }
        }else{
            if (navigationController.parentViewController){
                [navigationController willMoveToParentViewController:nil];
                [navigationController beginAppearanceTransition:NO animated:animated];
                [completions addObject:^{
                    if (!cancelled){
                        [navigationController.view removeFromSuperview];
                        [navigationController removeFromParentViewController];
                    }else{
                        [navigationController removeFromParentViewController];
                        [weakSelf ra_addChildViewController:navigationController];
                        [navigationController didMoveToParentViewController:weakSelf];
                    }
                    [navigationController endAppearanceTransition];
                }];
                [cancels addObject:^{
                    if(appeared) [navigationController beginAppearanceTransition:YES animated:animated];
                }];
                if (animated){
                    dispatch_group_enter(group);
                    RATransition *transition=navigationController.ra_transition;
                    transition.containerViewController=self;
                    transition.viewController=navigationController;
                    transition.action=RATransitioningPop;
                    transition.state=RATransitioningInvisible;
                    transition.isInteractiveBlock = isInteractiveBlock;
                    transition.interactBlock = interactBlock;
                    transition.isCancelledBlock = isCancelledBlock;
                    transition.cancelBlock = cancelBlock;
                    transition.completionBlock = completionBlock;
                    [transition _animate];
                }
            }
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSInteger i=completions.count-1;i>=0;i--){
                completions[i]();
            }
            if (cancelled) {
                if (completion) completion();
                return;
            }
            NSIndexSet *set=[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index+1, weakSelf.viewControllers.count-index-1)];
            [(NSMutableArray*)weakSelf.viewControllers removeObjectsAtIndexes:set];
            [weakSelf.navigationControllers removeObjectsAtIndexes:set];
            if (completion) completion();
        });
    });
    return popedViewControllers;
}

#pragma mark --
#pragma mark -- create new navigationController from navigationController class

- (__kindof UINavigationController*)createNavigationControllerForViewController:(UIViewController*)viewController backItemVisable:(BOOL)backItemVisable{
    UINavigationController *navigationController = [[self.navigationControllerClass alloc]init];
    [navigationController ra_setViewControllers:backItemVisable?@[[[UIViewController alloc]init],viewController]:@[viewController] animated:NO];
    navigationController.ra_navigationController=self;
    return navigationController;
}

#pragma mark --
#pragma mark -- getter

- (Class)navigationControllerClass{
    if (_navigationControllerClass) return _navigationControllerClass;
    return UINavigationController.class;
}

- (NSArray<__kindof UIViewController*>*)viewControllers{
    if(_viewControllers) return _viewControllers;
    _viewControllers=[NSMutableArray array];
    return _viewControllers;
}

#pragma mark --
#pragma mark -- override

- (BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for (UIViewController *viewController in self.childViewControllers){
        [viewController beginAppearanceTransition:YES animated:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    for (UIViewController *viewController in self.childViewControllers){
        [viewController endAppearanceTransition];
    }
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    for (UIViewController *viewController in self.childViewControllers){
        [viewController beginAppearanceTransition:NO animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    for (UIViewController *viewController in self.childViewControllers){
        [viewController endAppearanceTransition];
    }
    [super viewDidDisappear:animated];
}


- (void)ra_addChildViewController:(UIViewController *)childController{
    NSAssert(0, @"Do not call this method directly");
    return;
}

- (void)setActivedViewController:(UIViewController *)activedViewController{
    if (_activedViewController==activedViewController) return;
    _activedViewController=activedViewController;
    [self setNeedsStatusBarAppearanceUpdate];
    [UIViewController attemptRotationToDeviceOrientation];
}

- (BOOL)shouldAutorotate{
    if (!self.activedViewController) return [super shouldAutorotate];
    return [self.activedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if (!self.activedViewController) return [super supportedInterfaceOrientations];
    return [self.activedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if (!self.activedViewController) return [super preferredInterfaceOrientationForPresentation];
    return [self.activedViewController preferredInterfaceOrientationForPresentation];
}

- (BOOL)prefersStatusBarHidden{
    if (!self.activedViewController) return [super prefersStatusBarHidden];
    return [self.activedViewController prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    if (!self.activedViewController) return [super preferredStatusBarStyle];
    return [self.activedViewController preferredStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    if (!self.activedViewController) return [super preferredStatusBarUpdateAnimation];
    return [self.activedViewController preferredStatusBarUpdateAnimation];
}

- (UIViewController*)topViewController{
    return self.viewControllers.lastObject;
}

- (NSMutableArray*)navigationControllers{
    if (_navigationControllers) return _navigationControllers;
    _navigationControllers=[NSMutableArray array];
    return _navigationControllers;
}

+ (void)load{
    [self ra_swizzleinstanceWithOrignalMethod:@selector(addChildViewController:) alteredMethod:@selector(ra_addChildViewController:)];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
