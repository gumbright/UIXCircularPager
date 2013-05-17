//
//  ViewController.m
//  UIXCircularPagerDemo
//
//  Created by Guy Umbright on 5/16/13.
//  Copyright (c) 2013 Umbright Consulting, Inc. All rights reserved.
//

#import "ViewController.h"
#import "UIXCircularPager.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIXCircularPager* pager;
@property (nonatomic, strong) IBOutlet UIView* red;
@property (nonatomic, strong) IBOutlet UIView* blue;
@property (nonatomic, strong) IBOutlet UIView* yellow;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.pager.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger) UIXCircularPagerNumberOfPages:(UIXCircularPager*) pager
{
    return 3;
}

- (UIView*) UIXCircularPager:(UIXCircularPager*) pager pageAtIndex:(NSUInteger) index
{
    UIView* v = nil;
    switch (index)
    {
        case 0:
        {
            v = self.blue;
        }
            break;
            
        case 1:
        {
            v = self.red;
        }
            break;
            
        case 2:
        {
            v = self.yellow;
        }
            break;
    }
    return v;
}

@end
