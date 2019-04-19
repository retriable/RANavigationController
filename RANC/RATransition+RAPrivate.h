//
//  RATransition+RAPrivate.h
//  RANC
//
//  Created by retriable on 2019/4/19.
//  Copyright © 2019 retriable. All rights reserved.
//
#import "RATransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface RATransition (RAPrivate)

@property (nonatomic,weak  ) RANavigationController *containerViewController;
@property (nonatomic,weak  ) UIViewController       *viewController;
@property (nonatomic,assign) RATransitioningAction  action;
@property (nonatomic,assign) RATransitioningState   state;

@property (nonatomic,copy  ) BOOL (^isInteractiveBlock) (void);
@property (nonatomic,copy  ) BOOL (^isCancelledBlock  ) (void);
@property (nonatomic,copy  ) void (^interactBlock     ) (void);
@property (nonatomic,copy  ) void (^cancelBlock       ) (void);
@property (nonatomic,copy  ) void (^completionBlock   ) (void);

- (void)_animate;

@end

NS_ASSUME_NONNULL_END
