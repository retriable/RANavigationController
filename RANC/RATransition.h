//
//  RATransition.h
//  RANC
//
//  Created by retriable on 2019/4/19.
//  Copyright © 2019 retriable. All rights reserved.
//

#import "RANavigationController.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, RATransitioningStyle) {
    RATransitioningCurrentContext,
    RATransitioningOverCurrentContext
};

typedef NS_ENUM(NSInteger, RATransitioningAction) {
    RATransitioningPush,
    RATransitioningPop
};

typedef NS_ENUM(NSInteger, RATransitioningState) {
    RATransitioningInvisible,
    RATransitioningForeground,
    RATransitioningBackground
};

@interface RATransition : NSObject

/**
 transition style,default: RATransitioningCurrentContext.
 */
@property (nonatomic,assign) RATransitioningStyle          style;

/**
 transition duration,default: 0.25.
 */
@property (nonatomic,assign) NSTimeInterval                duration;

/**
 current navigation controller.
 */
@property (readonly ,weak  ) RANavigationController        *containerViewController;

/**
 current transition view controller.
 */
@property (readonly ,weak  ) UIViewController              *viewController;

/**
 current transition action.
 */
@property (readonly,assign ) RATransitioningAction         action;

/**
 current transition state.
 */
@property (readonly,assign ) RATransitioningState          state;

/**
 call at transitioning finished.
 */
- (void)complete;

/**
 override this method for implementation of custom transition animation.
 */
- (void)animate;

#pragma mark --
#pragma mark -- percent driven interactive transition

/**
 interactive completion speed.default: 1.
 */
@property (nonatomic,assign) CGFloat                       speed;

/**
 interactive completion curve.unimplemented.
 */
@property (nonatomic,assign) UIViewAnimationCurve          curve;

/*
following is the call chain of interactive transition
*/
/**
                           finish()
                           ↑
 start()->update(progress)-
                           ↓
                           cancel()
**/

/**
 start interactive transition,will call navigationController.popViewController automatically.
 
 */
- (void)start;

/**
 update dynamic progress.0-1

 @param progress percent progress of interactive transition
 */
- (void)update:(double)progress;

/**
 fnish interactive transition.
 */
- (void)finish;

/**
 cancel interactive transition.
 */
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
