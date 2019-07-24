//
//  UINavigationController+RANC.m
//  RANC
//
//  Created by retriable on 2019/4/19.
//  Copyright © 2019 retriable. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+RAPrivate.h"
#import "UINavigationController+RAPublic.h"
#import "UIViewController+RAPrivate.h"

@implementation UINavigationController (RAPublic)

- (void)setRa_backItemDidClick:(void (^)(UINavigationController * _Nonnull))ra_backItemDidClick{
    objc_setAssociatedObject(self, @selector(ra_backItemDidClick), ra_backItemDidClick, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void(^)(UINavigationController *))ra_backItemDidClick{
    return objc_getAssociatedObject(self, @selector(ra_backItemDidClick));
}

- (void)ra_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated{
    if (!self.ra_navigationController){
        [self ra_setViewControllers:viewControllers animated:animated];
        return;
    }
    NSAssert(0, @"disabled call");
    [self ra_setViewControllers:viewControllers animated:animated];
}

- (BOOL)ra_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    if (self.ra_backItemDidClick){
        self.ra_backItemDidClick(self);
        return NO;
    }
    if (!self.ra_navigationController){
        return [self ra_navigationBar:navigationBar shouldPopItem:item];
    }
    if (self.viewControllers.count==2){
        [self.ra_navigationController popViewControllerAnimated:YES];
        return NO;
    }
    NSAssert(0, @"unexpected error");
    return [self ra_navigationBar:navigationBar shouldPopItem:item];
}

- (UIViewController*)ra_popViewControllerAnimated:(BOOL)animated{
    if (!self.ra_navigationController){
        return [self ra_popViewControllerAnimated:animated];
    }
    NSAssert(0, @"disabled call");
    if (self.viewControllers.count<=2){
        return nil;
    }
    return [self ra_popViewControllerAnimated:animated];
}

- (nullable NSArray<__kindof UIViewController *> *)ra_popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (!self.ra_navigationController){
        return [self ra_popToViewController:viewController animated:animated];
    }
    NSAssert(0, @"disabled call");
    NSUInteger index=[self.viewControllers indexOfObject:viewController];
    if (index==NSNotFound) {
        return nil;
    }
    if (index<2){
        return nil;
    }
    return [self ra_popToViewController:viewController animated:animated];
}

- (nullable NSArray<__kindof UIViewController *> *)ra_popToRootViewControllerAnimated:(BOOL)animated{
    if (!self.ra_navigationController){
        return [self ra_popToRootViewControllerAnimated:animated];
    }
    NSAssert(0, @"disabled call");
    return self.viewControllers.count>2?[self popToViewController:self.viewControllers[1] animated:animated]:nil;
}

- (BOOL)ra_prefersStatusBarHidden{
    if (!self.ra_navigationController){
        return [self ra_prefersStatusBarHidden];
    }
    if (!self.topViewController){
        return [self ra_prefersStatusBarHidden];
    }
    return [self.topViewController prefersStatusBarHidden];
}

- (UIStatusBarStyle)ra_preferredStatusBarStyle{
    if (!self.ra_navigationController){
        return [self ra_preferredStatusBarStyle];
    }
    if (!self.topViewController){
        return [self ra_preferredStatusBarStyle];
    }
    return [self.topViewController preferredStatusBarStyle];
}

- (UIStatusBarAnimation)ra_preferredStatusBarUpdateAnimation{
    if (!self.ra_navigationController){
        return [self ra_preferredStatusBarUpdateAnimation];
    }
    if (!self.topViewController){
        return [self ra_preferredStatusBarUpdateAnimation];
    }
    return [self.topViewController preferredStatusBarUpdateAnimation];
}

- (BOOL)ra_shouldAutorotate{
    if (!self.ra_navigationController){
        return [self ra_shouldAutorotate];
    }
    if (!self.topViewController){
        return [self ra_shouldAutorotate];
    }
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)ra_supportedInterfaceOrientations{
    if (!self.ra_navigationController){
        return [self ra_supportedInterfaceOrientations];
    }
    if (!self.topViewController){
        return [self ra_supportedInterfaceOrientations];
    }
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)ra_preferredInterfaceOrientationForPresentation{
    if (!self.ra_navigationController){
        return [self ra_preferredInterfaceOrientationForPresentation];
    }
    if (!self.topViewController){
        return [self ra_preferredInterfaceOrientationForPresentation];
    }
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (void)ra_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (!self.ra_navigationController){
        [self ra_pushViewController:viewController animated:animated];
        return;
    }
    NSAssert(0, @"disabled call");
    [self ra_pushViewController:viewController animated:animated];
}

+ (void)load{
    [self ra_swizzleinstanceWithOrignalMethod:@selector(navigationBar:shouldPopItem:) alteredMethod:@selector(ra_navigationBar:shouldPopItem:)];
    [self ra_swizzleinstanceWithOrignalMethod:@selector(setViewControllers:animated:) alteredMethod:@selector(ra_setViewControllers:animated:)];
    [self ra_swizzleinstanceWithOrignalMethod:@selector(pushViewController:animated:) alteredMethod:@selector(ra_pushViewController:animated:)];
    [self ra_swizzleinstanceWithOrignalMethod:@selector(popViewControllerAnimated:) alteredMethod:@selector(ra_popViewControllerAnimated:)];
    [self ra_swizzleinstanceWithOrignalMethod:@selector(popToRootViewControllerAnimated:) alteredMethod:@selector(ra_popToRootViewControllerAnimated:)];
    [self ra_swizzleinstanceWithOrignalMethod:@selector(popToViewController:animated:) alteredMethod:@selector(ra_popToViewController:animated:)];
    [self ra_swizzleinstanceWithOrignalMethod:@selector(prefersStatusBarHidden) alteredMethod:@selector(ra_prefersStatusBarHidden)];
    [self ra_swizzleinstanceWithOrignalMethod:@selector(preferredStatusBarStyle) alteredMethod:@selector(ra_preferredStatusBarStyle)];
    [self ra_swizzleinstanceWithOrignalMethod:@selector(preferredStatusBarUpdateAnimation) alteredMethod:@selector(ra_preferredStatusBarUpdateAnimation)];
    [self ra_swizzleinstanceWithOrignalMethod:@selector(shouldAutorotate) alteredMethod:@selector(ra_shouldAutorotate)];
    [self ra_swizzleinstanceWithOrignalMethod:@selector(supportedInterfaceOrientations) alteredMethod:@selector(ra_supportedInterfaceOrientations)];
    [self ra_swizzleinstanceWithOrignalMethod:@selector(preferredInterfaceOrientationForPresentation) alteredMethod:@selector(ra_preferredInterfaceOrientationForPresentation)];
}


@end
