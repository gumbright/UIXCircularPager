//
//  UIXCircularPager.h
//  UIXCircularPagerDemo
//
//  Created by Guy Umbright on 5/16/13.
//  Copyright (c) 2013 Umbright Consulting, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIXCircularPager;

@protocol UIXCircularPagerDatasource <NSObject>

- (NSUInteger) UIXCircularPagerNumberOfPages:(UIXCircularPager*) pager;
- (UIView*) UIXCircularPager:(UIXCircularPager*) pager pageAtIndex:(NSUInteger) index;

@end

@interface UIXCircularPager : UIView

@property (nonatomic, weak) NSObject<UIXCircularPagerDatasource>* dataSource;

- (void) reloadPages;
@end
