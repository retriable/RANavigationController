//
//  RANavigationController.h
//  RANC
//
//  Created by retriable on 2019/4/19.
//  Copyright © 2019 retriable. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RANavigationController : UIViewController

@property(nullable, nonatomic,readonly,strong) UIViewController *topViewController;

@property(nonatomic,copy) NSArray<__kindof UIViewController *> *viewControllers;

- (instancetype)initWithNavigationControllerClass:(nullable Class)navigationControllerClass NS_SWIFT_NAME(init(navigationControllerClass:));

- (instancetype)initWithRootViewController:(__kindof UIViewController *)rootViewController NS_SWIFT_NAME(init(rootViewController:));
- (instancetype)initWithViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers NS_SWIFT_NAME(init(viewControllers:));

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers NS_SWIFT_NAME(setViewController(_:));
- (void)pushViewController:(__kindof UIViewController *)viewController NS_SWIFT_NAME(pushViewController(_:));
- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers NS_SWIFT_NAME(pushViewControllers(_:));
- (nullable __kindof UIViewController *)popViewController NS_SWIFT_NAME(popViewController());
- (nullable NSArray<__kindof UIViewController *> *)popToRootViewController NS_SWIFT_NAME(popToRootViewController());
- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController NS_SWIFT_NAME(popToViewController(_:));

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated NS_SWIFT_NAME(setViewControllers(_:animated:));
- (void)pushViewController:(__kindof UIViewController *)viewController animated:(BOOL)animated NS_SWIFT_NAME(pushViewController(_:animated:));
- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated NS_SWIFT_NAME(pushViewControllers(_:animated:));
- (nullable __kindof UIViewController *)popViewControllerAnimated:(BOOL)animated NS_SWIFT_NAME(popViewController(animated:));
- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated NS_SWIFT_NAME(popToRootViewController(animated:));
- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated NS_SWIFT_NAME(popToViewController(_:animated:));

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void(^_Nullable)(void))completion NS_SWIFT_NAME(setViewControllers(_:animated:completion:));
- (void)pushViewController:(__kindof UIViewController *)viewController animated:(BOOL)animated completion:(void(^_Nullable)(void))completion NS_SWIFT_NAME(pushViewController(_:animated:completion:));
- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void(^_Nullable)(void))completion NS_SWIFT_NAME(pushViewControllers(_:animated:completion:));
- (nullable __kindof UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void(^_Nullable)(void))completion NS_SWIFT_NAME(popViewController(animated:completion:));
- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated completion:(void(^_Nullable)(void))completion NS_SWIFT_NAME(popToRootViewController(animated:completion:));
- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void(^_Nullable)(void))completion NS_SWIFT_NAME(popToViewController(_:animated:completion:));

@end

NS_ASSUME_NONNULL_END
