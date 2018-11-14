//
//  ViewController.m
//  NavigationVCDemo
//
//  Created by lisilong on 2018/11/13.
//  Copyright © 2018 lisilong. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationController+NavigationBar.h"

@interface ViewController ()

@end

@implementation ViewController
  
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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


@end
