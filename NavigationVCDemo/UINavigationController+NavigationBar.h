//
//  UINavigationController+NavigationBar.h
//  NavigationVCDemo
//
//  Created by lisilong on 2018/11/13.
//  Copyright © 2018 lisilong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (NavigationBar)
    
/// A view controller is able to control navigation bar's appearance by itself,
/// rather than a global way, checking "lsl_prefersNavigationBarHidden" property.
/// Default to YES, disable it if you don't want so.
@property (nonatomic, assign) BOOL lsl_viewControllerBasedNavigationBarAppearanceEnabled;

@end
    
@interface UIViewController (HandlerNavigationBar)
    
/// Indicate this view controller prefers its navigation bar hidden or not,
/// checked when view controller based navigation bar's appearance is enabled.
/// Default to NO, bars are more likely to show.
@property (nonatomic, assign) BOOL lsl_prefersNavigationBarHidden;

@end

NS_ASSUME_NONNULL_END
