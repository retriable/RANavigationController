//
//  UINavigationController+RAPrivate.h
//  RANC
//
//  Created by retriable on 2019/4/19.
//  Copyright © 2019 retriable. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (RAPrivate)

- (void)ra_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
