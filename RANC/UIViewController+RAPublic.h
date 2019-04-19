//
//  UIViewController+RAPublic.h
//  RANC
//
//  Created by retriable on 2019/4/19.
//  Copyright © 2019 retriable. All rights reserved.
//

#import "RADefaultTransition.h"
#import "RANavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (RAPublic)

@property (readonly,nullable        ) RANavigationController *ra_navigationController;
@property (nonatomic,strong,nullable) RATransition           *ra_transition;
@property (nonatomic,assign         ) BOOL                   ra_defineRotationContext;

@end

NS_ASSUME_NONNULL_END
