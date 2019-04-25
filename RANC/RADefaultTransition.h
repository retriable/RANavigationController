//
//  RADefaultTransition.h
//  RANC
//
//  Created by retriable on 2019/4/19.
//  Copyright © 2019 retriable. All rights reserved.
//

#import "RATransition.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,RADefaultTransitionType) {
    RADefaultTransitionPush,
    RADefaultTransitionPresent
};

@interface RADefaultTransition : RATransition

/**
 transition type.default: RADefaultTransitionPush.
 */
@property (nonatomic,assign  ) RADefaultTransitionType type;

@property (readonly          ) UIPanGestureRecognizer  *panGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
