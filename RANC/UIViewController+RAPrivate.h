//
//  UIViewController+RAPrivate.h
//  RANC
//
//  Created by retriable on 2019/4/19.
//  Copyright © 2019 retriable. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RANavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (RAPrivate)

@property (nonatomic,weak,nullable)RANavigationController *ra_navigationController;

@end

NS_ASSUME_NONNULL_END
