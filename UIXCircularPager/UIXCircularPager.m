//
//  UIXCircularPager.m
//  UIXCircularPagerDemo
//
//  Created by Guy Umbright on 5/16/13.
//  Copyright (c) 2013 Umbright Consulting, Inc. All rights reserved.
//

//assumptions:
// pager page is aways the width of the pager

typedef enum
{
    PagePositionLeft = -1,
    PagePositionCenter = 0,
    PagePositionRight = 1
} PagePosition;

#import "UIXCircularPager.h"

@interface UIXCircularPager ()
@property (nonatomic, strong) UIScrollView* scroll;
@property (nonatomic, strong) UIPageControl* pages;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) NSUInteger numberOfPages;
@property (nonatomic, assign) NSUInteger currentPageIndex;
@property (nonatomic, strong) NSMutableArray* currentPages;
@end

@implementation UIXCircularPager

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) commonInit
{
    CGRect r = self.bounds;
    r.origin.y = r.size.height - 36;
    r.size.height = 36;
    self.pages = [[UIPageControl alloc] initWithFrame:r];
    self.pages.numberOfPages = 5;
    [self addSubview:self.pages];
    
    [self.pages addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
    
    r = self.bounds;
    r.size.height -= self.pages.bounds.size.height;
    
    self.pageSize = r.size;
    self.scroll = [[UIScrollView alloc] initWithFrame:r];
    self.scroll.pagingEnabled = YES;
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.bounces = NO;
    self.scroll.delegate = self;
    
    [self addSubview:self.scroll];

    self.currentPageIndex = 0;
    
    self.currentPages = [NSMutableArray arrayWithCapacity:3];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) dealloc
{
    
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) setDataSource:(NSObject<UIXCircularPagerDatasource> *)dataSource
{
    _dataSource = dataSource;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadPages];
    });
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) awakeFromNib
{
    [self commonInit];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (CGRect) frameForPagePosition:(PagePosition) pagePosition
{
    CGRect r;
    
    r.size = self.pageSize;
    r.origin.y = 0;
    r.origin.x = self.pageSize.width + (pagePosition * self.pageSize.width);
    return r;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) clearPages
{
    [self.currentPages makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.currentPages removeAllObjects];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) reloadPages
{
    [self clearPages];
    
    self.numberOfPages = [self.dataSource UIXCircularPagerNumberOfPages:self];
    self.pages.numberOfPages = self.numberOfPages;

    self.scroll.contentSize = CGSizeMake(self.scroll.bounds.size.width * 3, self.scroll.bounds.size.height);
    self.scroll.contentOffset = CGPointMake(self.pageSize.width,0);

    //set center
    UIView* v = [self.dataSource UIXCircularPager:self pageAtIndex:self.currentPageIndex];
    v.frame = [self frameForPagePosition:PagePositionCenter];
    [self.scroll addSubview:v];
    [self.currentPages addObject:v];
    
    NSUInteger pageBeingAdded = 0;
    
    //set left
    if (self.currentPageIndex == 0)
    {
        pageBeingAdded = self.numberOfPages - 1;
    }
    else
    {
        pageBeingAdded = self.currentPageIndex - 1;
    }
    
    v = [self.dataSource UIXCircularPager:self pageAtIndex:pageBeingAdded];
    v.frame = [self frameForPagePosition:PagePositionLeft];
    [self.scroll addSubview:v];
    [self.currentPages addObject:v];
    
    //set right
    if (self.currentPageIndex == self.numberOfPages-1)
    {
        pageBeingAdded = 0;
    }
    else
    {
        pageBeingAdded = self.currentPageIndex + 1;
    }
    
    v = [self.dataSource UIXCircularPager:self pageAtIndex:pageBeingAdded];
    v.frame = [self frameForPagePosition:PagePositionRight];
    [self.scroll addSubview:v];
    [self.currentPages addObject:v];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) pageControlChanged:(UIPageControl*) pageControl
{
    CGPoint offset = self.scroll.contentOffset;
    
    if (self.currentPageIndex > pageControl.currentPage)
    {
        offset.x -= self.pageSize.width;
    }
    else
    {
        offset.x += self.pageSize.width;
        
    }
    [self.scroll setContentOffset:offset animated:YES];
//    self.currentPageIndex = pageControl.currentPage;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger diff = (self.scroll.contentOffset.x/self.pageSize.width) - 1;
    
    if (diff == -1 && self.currentPageIndex == 0)
    {
        self.currentPageIndex = self.numberOfPages -1;
    }
    else if (diff == 1 && self.currentPageIndex == self.numberOfPages-1)
    {
        self.currentPageIndex = 0;
    }
    else
    {
        self.currentPageIndex += diff;
    }    

//    NSLog(@"new page index=%d",self.currentPageIndex);
    self.pages.currentPage = self.currentPageIndex;
    [self reloadPages];
}

@end
