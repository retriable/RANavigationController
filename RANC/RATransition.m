//
//  RATransition.m
//  RANC
//
//  Created by retriable on 2019/4/19.
//  Copyright © 2019 retriable. All rights reserved.
//

#import <objc/runtime.h>

#import "RATransition.h"

@interface RATransition()

@property(readonly        ) BOOL                         cancelled;
@property(readonly        ) BOOL                         interactive;
@property(nonatomic,assign) BOOL                         finished;
@property(nonatomic,weak  ) RANavigationController          *containerViewController;
@property(nonatomic,weak  ) UIViewController             *viewController;
@property(nonatomic,assign) RATransitioningAction action;
@property(nonatomic,assign) RATransitioningState  state;

@property(nonatomic,copy  ) BOOL (^isInteractiveBlock)(void);
@property(nonatomic,copy  ) BOOL (^isCancelledBlock)(void);
@property(nonatomic,copy  ) void (^interactBlock)(void);
@property(nonatomic,copy  ) void (^cancelBlock)(void);
@property(nonatomic,copy  ) void (^completionBlock)(void);

@property(nonatomic,assign) CGRect            initialFrame;
@property(nonatomic,assign) CGAffineTransform initialAffineTransform;
@property(nonatomic,assign) CATransform3D     initialThreeDTransform;

@property(nonatomic,strong) CADisplayLink     *displayLink;

@end

@implementation RATransition

- (instancetype)init{
    self=[super init];
    if (!self) return nil;
    self.style=RATransitioningCurrentContext;
    self.duration=0.25;
    return self;
}

- (void)start{
    RANavigationController *navigationController = self.containerViewController;
    [navigationController popViewController];
    CALayer *layer=navigationController.view.layer;
    layer.speed = 0.0;
    self.interactBlock();
    self.finished=NO;
}

- (void)cancel{
    if (!self.interactive) return;
    if (self.finished) return;
    self.cancelBlock();
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)finish{
    if (!self.interactive) return;
    if (self.finished) return;
    self.finished=YES;
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)complete{
    if (self.cancelled){
        UIView *transitionView=self.viewController.view;
        transitionView.frame=self.initialFrame;
        transitionView.transform=self.initialAffineTransform;
        transitionView.layer.transform=self.initialThreeDTransform;
       
    }
    self.completionBlock();
}

- (void)update:(double)progress{
    if (!self.interactive) return;
    progress=fmax(fmin(progress, 1), 0);
    CALayer *layer=self.containerViewController.view.layer;
    layer.timeOffset=progress*self.duration;
}

- (void)animate{
    UIView *transitionView=self.viewController.view;
    [UIView animateWithDuration:self.duration animations:^{
        switch (self.action) {
            case RATransitioningPush:
                switch (self.state) {
                    case RATransitioningInvisible:
                        transitionView.alpha=0;
                        break;
                    case RATransitioningBackground:
                        transitionView.alpha=1;
                        break;
                    case RATransitioningForeground:
                        transitionView.alpha=1;
                        break;
                }
                break;
            case RATransitioningPop:
                switch (self.state) {
                    case RATransitioningInvisible:
                        transitionView.alpha=0;
                        break;
                    case RATransitioningBackground:
                        transitionView.alpha=1;
                        break;
                    case RATransitioningForeground:
                        transitionView.alpha=1;
                        break;
                }
                break;
        }
    }completion:^(BOOL finished) {
        [self complete];
    }];
}

- (void)_animate{
    UIView *transitionView=self.viewController.view;
    self.initialThreeDTransform=transitionView.layer.transform;
    self.initialAffineTransform=transitionView.transform;
    self.initialFrame=transitionView.frame;
    [self animate];
    if (self.action==RATransitioningPop){
        [self _fixNavigationBarPosition];
    }
}

- (void)_display{
    CALayer *layer= self.containerViewController.view.layer;
    CFTimeInterval timeOffset=layer.timeOffset+(!self.cancelled?self.displayLink.duration:-self.displayLink.duration)*self.speed;
    if (timeOffset < 0 || timeOffset > self.duration) {
        [self.displayLink invalidate];
        self.displayLink=nil;
        layer.timeOffset = 0;
        layer.speed = 1;
        if (self.cancelled){
            UIView *transitionView=self.viewController.view;
            if (transitionView==transitionView.superview.subviews.lastObject){
                UIView *snapshotView=[transitionView snapshotViewAfterScreenUpdates:NO];
                snapshotView.frame=self.initialFrame;
                [transitionView.superview addSubview:snapshotView];
                [self performSelector:@selector(_executeBlock:) withObject:^{
                    [snapshotView removeFromSuperview];
                } afterDelay:0];
            }
        }
    } else {
        layer.timeOffset=timeOffset;
    }
}

- (void)_executeBlock:(void(^)(void))block{
    block();
}

- (void)_fixNavigationBarPosition {
    UINavigationController *navigationController=(UINavigationController*)self.viewController;
    BOOL navigationBarHidden=navigationController.navigationBarHidden;
    navigationController.navigationBarHidden=!navigationBarHidden;
    navigationController.navigationBarHidden=navigationBarHidden;
}

- (BOOL)cancelled{
    return self.isCancelledBlock();
}
- (BOOL)interactive{
    return self.isInteractiveBlock();
}
- (CADisplayLink*)displayLink{
    if (_displayLink) return _displayLink;
    _displayLink=[CADisplayLink displayLinkWithTarget:self selector:@selector(_display)];
    return _displayLink;
}

@end
