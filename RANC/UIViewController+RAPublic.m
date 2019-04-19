//
//  UIViewController+RANC.m
//  RANC
//
//  Created by retriable on 2019/4/19.
//  Copyright © 2019 retriable. All rights reserved.
//

#import <objc/runtime.h>

#import "UIViewController+RAPublic.h"

@implementation UIViewController (RAPublic)

- (void)setRa_transition:(RATransition*)ra_transition{
    objc_setAssociatedObject(self, @selector(ra_transition), ra_transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RATransition*)ra_transition{
    RATransition* transition = objc_getAssociatedObject(self, @selector(ra_transition));
    if (transition) return transition;
    if ([self isKindOfClass:UINavigationController.class]){
        transition=[(UINavigationController*)self topViewController].ra_transition;
    }
    if (transition) return transition;
    transition=[[RADefaultTransition alloc]init];
    self.ra_transition=transition;
    return transition;
}

- (void)setRa_defineRotationContext:(BOOL)ra_defineRotationContext{
    objc_setAssociatedObject(self, @selector(ra_defineRotationContext), @(ra_defineRotationContext), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ra_defineRotationContext{
    id v=objc_getAssociatedObject(self, @selector(ra_defineRotationContext));
    if (!v) return YES;
    return [v boolValue];
}

- (RANavigationController *)ra_navigationController {
    if ([self isKindOfClass:UINavigationController.class]) {
        return [objc_getAssociatedObject(self, @selector(ra_navigationController)) anyObject];
    }
    return [self.navigationController ra_navigationController];
}

- (void)setRa_navigationController:(RANavigationController * _Nullable)ra_navigationController {
    objc_setAssociatedObject(self, @selector(ra_navigationController), ra_navigationController ? ({
        NSHashTable *v = [NSHashTable weakObjectsHashTable];
        [v addObject:ra_navigationController];
        v;
    }): nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
