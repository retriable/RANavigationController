//
//  RADefaultTransition.m
//  RANC
//
//  Created by retriable on 2019/4/19.
//  Copyright © 2019 retriable. All rights reserved.
//

#import "RADefaultTransition.h"

@interface RADefaultTransition()

@property(nonatomic,strong) UIPanGestureRecognizer *panGestureRecogniner;
@property(nonatomic,assign) CGPoint                startPoint;

@end

@implementation RADefaultTransition
- (instancetype)init{
    self=[super init];
    if (!self) return nil;
    self.popInteractionEnabled=YES;
    return self;
}
- (void)animate{
    UIView *containerView=self.containerViewController.view;
    UIView *transitionView=self.viewController.view;
    RATransitioningAction action=self.action;
    RATransitioningState state=self.state;
    CATransform3D from=transitionView.layer.transform,to;
    switch (action) {
        case RATransitioningPush:{
            switch (state) {
                case RATransitioningInvisible:
                    to=CATransform3DScale(CATransform3DIdentity, 0.985, 0.985, 1);
                    break;
                case RATransitioningForeground:
                    from=self.type==RADefaultTransitionPush?CATransform3DTranslate(CATransform3DIdentity, CGRectGetWidth(containerView.bounds), 0, 0):CATransform3DTranslate(CATransform3DIdentity,0, CGRectGetHeight(containerView.bounds), 0);
                    to=CATransform3DIdentity;
                {
                    if (self.popInteractionEnabled){
                        if (self.panGestureRecogniner.view!=transitionView){
                            [self.panGestureRecogniner.view removeGestureRecognizer:self.panGestureRecogniner];
                            [transitionView addGestureRecognizer:self.panGestureRecogniner];
                        }
                    }
                }
                    break;
                case RATransitioningBackground:
                    to=CATransform3DScale(CATransform3DIdentity, 0.985, 0.985, 1);
                    break;
            }
        }break;
        case RATransitioningPop:{
            switch (state) {
                case RATransitioningInvisible:
                    to=self.type==RADefaultTransitionPush?CATransform3DTranslate(CATransform3DIdentity, CGRectGetWidth(containerView.bounds), 0, 0):CATransform3DTranslate(CATransform3DIdentity, 0, CGRectGetHeight(containerView.bounds), 0);
                    break;
                case RATransitioningForeground:
                    to=CATransform3DIdentity;
                    break;
                case RATransitioningBackground:
                    to=CATransform3DScale(CATransform3DIdentity, 0.985, 0.985, 1);
                    break;
            }
        }break;
    }
    transitionView.layer.transform=from;
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        transitionView.layer.transform=to;
    } completion:^(BOOL finished) {
        [self complete];
    }];
}

- (void)pan:(UIPanGestureRecognizer*)gesture{
    UIView *superview=gesture.view.superview;
    CGPoint point=[gesture locationInView:superview];
    CGPoint velocity=[gesture velocityInView:superview];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            
            if (self.type==RADefaultTransitionPush){
                if (point.x<CGRectGetWidth(superview.bounds)/2.0){
                    self.startPoint=point;
                    self.speed=1;
                    [self start];
                }
            }else{
                self.startPoint=point;
                self.speed=1;
                [self start];
            }
            break;
        case UIGestureRecognizerStateChanged:
            [self update:(point.x-self.startPoint.x)/CGRectGetWidth(superview.bounds)];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (self.type==RADefaultTransitionPush){
                if (velocity.x>1000){
                    self.speed=velocity.x/CGRectGetWidth(superview.bounds)/2.0;
                    [self finish];
                }else if (point.x-self.startPoint.x>CGRectGetWidth(superview.bounds)/3.0) [self finish];
                else [self cancel];
            }else{
                if (velocity.y>1000){
                    self.speed=velocity.y/CGRectGetHeight(superview.bounds)/2.0;
                    [self finish];
                }else if (point.y-self.startPoint.y>CGRectGetHeight(superview.bounds)/3.0) [self finish];
                else [self cancel];
            }
            break;
        default:
            break;
    }
}

- (UIPanGestureRecognizer*)panGestureRecogniner{
    if (_panGestureRecogniner) return _panGestureRecogniner;
    _panGestureRecogniner=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    return _panGestureRecogniner;
}
@end
