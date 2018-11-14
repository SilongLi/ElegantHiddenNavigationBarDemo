//
//  ViewControllerFirst.m
//  NavigationVCDemo
//
//  Created by lisilong on 2018/11/13.
//  Copyright © 2018 lisilong. All rights reserved.
//

#import "ViewControllerFirst.h"
#import "UINavigationController+NavigationBar.h"

@interface ViewControllerFirst ()

@end

@implementation ViewControllerFirst

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lsl_prefersNavigationBarHidden = YES;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    [self.navigationController setNavigationBarHidden:true animated:animated];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:false animated:animated];
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)pushToNewViwe:(id)sender {
    
    NSArray *childs = self.navigationController.childViewControllers;
    NSMutableArray *newChilds = [@[] mutableCopy];
    for (UIViewController *VC in childs) {
        if ([VC isKindOfClass:ViewControllerFirst.class]) {
            break;
        } else {
            [newChilds addObject:VC];
        }
    }
    
    UIViewController *newVC = [[UIViewController alloc] init];
    [newVC view].backgroundColor = UIColor.yellowColor;
    [newChilds addObject:newVC];
    [self.navigationController setViewControllers:[newChilds copy] animated:true];
}


@end
