//
//  UINavigationController+RAPublic.h
//  RANC
//
//  Created by retriable on 2019/4/19.
//  Copyright © 2019 retriable. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (RAPublic)

@property (nullable,nonatomic,copy)void(^ra_backItemDidClick)(UINavigationController *navigationController);

@end

NS_ASSUME_NONNULL_END
