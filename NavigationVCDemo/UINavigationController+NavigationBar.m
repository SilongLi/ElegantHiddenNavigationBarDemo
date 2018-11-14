//
//  UINavigationController+NavigationBar.m
//  NavigationVCDemo
//
//  Created by lisilong on 2018/11/13.
//  Copyright © 2018 lisilong. All rights reserved.
//

#import "UINavigationController+NavigationBar.h"
#import <objc/runtime.h>

typedef void(^_LSLViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (HandlerNavigationBarPrivate)

@property(nonatomic, copy) _LSLViewControllerWillAppearInjectBlock lsl_willAppearInjectBlock;

@end

// MARK: - 替换UIViewController的viewWillAppear方法，在此方法中，执行设置导航栏隐藏和显示的代码块。
@implementation UIViewController (HandlerNavigationBarPrivate)

+ (void)load
{
    Method orginalMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(lsl_viewWillAppear:));
    method_exchangeImplementations(orginalMethod, swizzledMethod);
}

- (void)lsl_viewWillAppear:(BOOL)animated
{
    [self lsl_viewWillAppear:animated];

    if (self.lsl_willAppearInjectBlock) {
        self.lsl_willAppearInjectBlock(self, animated);
    }
}

- (_LSLViewControllerWillAppearInjectBlock)lsl_willAppearInjectBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLsl_willAppearInjectBlock:(_LSLViewControllerWillAppearInjectBlock)block
{
    objc_setAssociatedObject(self, @selector(lsl_willAppearInjectBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

// MARK: - 给UIViewController添加lsl_prefersNavigationBarHidden属性

@implementation UIViewController (HandlerNavigationBar)

- (BOOL)lsl_prefersNavigationBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setLsl_prefersNavigationBarHidden:(BOOL)hidden
{
    objc_setAssociatedObject(self, @selector(lsl_prefersNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

// MARK: - 替换UINavigationController的pushViewController:animated:方法，在此方法中去设置导航栏的隐藏和显示
@implementation UINavigationController (NavigationBar)

+ (void)load
{
    Method originMethod = class_getInstanceMethod(self, @selector(pushViewController:animated:));
    Method swizzedMethod = class_getInstanceMethod(self, @selector(lsl_pushViewController:animated:));
    method_exchangeImplementations(originMethod, swizzedMethod);

    Method originSetViewControllersMethod = class_getInstanceMethod(self, @selector(setViewControllers:animated:));
    Method swizzedSetViewControllersMethod = class_getInstanceMethod(self, @selector(lsl_setViewControllers:animated:));
    method_exchangeImplementations(originSetViewControllersMethod, swizzedSetViewControllersMethod);
}

- (void)lsl_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // Handle perferred navigation bar appearance.
    [self lsl_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];

    // Forward to primary implementation.
    [self lsl_pushViewController:viewController animated:animated];
}

- (void)lsl_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated
{
    // Handle perferred navigation bar appearance.
    for (UIViewController *viewController in viewControllers) {
        [self lsl_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];
    }

    // Forward to primary implementation.
    [self lsl_setViewControllers:viewControllers animated:animated];
}

- (void)lsl_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController
{
    if (!self.lsl_viewControllerBasedNavigationBarAppearanceEnabled) {
        return;
    }

    // 即将被调用的代码块
    __weak typeof(self) weakSelf = self;
    _LSLViewControllerWillAppearInjectBlock block = ^(UIViewController *viewController, BOOL animated){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf setNavigationBarHidden:viewController.lsl_prefersNavigationBarHidden animated:animated];
        }
    };

    // 给即将显示的控制器，注入代码块
    appearingViewController.lsl_willAppearInjectBlock = block;

    // 因为不是所有的都是通过push的方式，把控制器压入stack中，也可能是"-setViewControllers:"的方式，所以需要对栈顶控制器做下判断并赋值。
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.lsl_willAppearInjectBlock) {
        disappearingViewController.lsl_willAppearInjectBlock = block;
    }
}

- (BOOL)lsl_viewControllerBasedNavigationBarAppearanceEnabled
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return number.boolValue;
    }
    self.lsl_viewControllerBasedNavigationBarAppearanceEnabled = YES;
    return YES;
}

- (void)setLsl_viewControllerBasedNavigationBarAppearanceEnabled:(BOOL)enabled
{
    SEL key = @selector(lsl_viewControllerBasedNavigationBarAppearanceEnabled);
    objc_setAssociatedObject(self, key, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
